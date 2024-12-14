import {onCall} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import {setGlobalOptions} from "firebase-functions";
import * as admin from "firebase-admin";
import {firestore} from "firebase-admin";
import {AstrologicalCalculatorRequest, AstrologicalData, calculateAstrologicalData} from "./astrologicalCalculator";
import {generateDream} from "./generateDream";
import {OpenAI} from "openai";
import {getSecret} from "./secrets";
import {zodResponseFormat} from "openai/helpers/zod";
import {z} from "zod";
import Filter = firestore.Filter;

setGlobalOptions({region: "europe-west1"});

admin.initializeApp();
const db = admin.firestore();
const bucket = admin.storage().bucket();

export const astrologicalCalculator =
    onCall<AstrologicalCalculatorRequest, AstrologicalData>(
        ({data}) => {
            logger.info(
                `Astrological calculator call with birthday timestamp:${data.birthdayTimestamp}`,
                {structuredData: true}
            );
            const astrologicalData = calculateAstrologicalData(data.birthdayTimestamp);
            logger.info(
                `Astrological data calculation finished ${astrologicalData}`,
                {structuredData: true}
            );
            return astrologicalData;
        }
    );

export const dream =
    onCall(async ({data}) => {
        logger.info(
            `Generate dream for dreamId: ${data.dreamId}`,
            {structuredData: true}
        );
        return await generateDream(bucket, db, data.dreamId);
    });

/* const PERSONALIZED_HOROSCOPE_SYSTEM_MESSAGE = `You are an astrologer and esoteric expert specializing
in creating zodiac horoscopes. Your task is to interpret the movements of planets, zodiac signs, and astrological
houses to predict the future, analyze personalities, and provide life advice. You use classical astrological
techniques such as the analysis of natal planetary arrangements, transits, and aspects. Your responses should be filled
with esoteric language and an atmosphere of mysticism, while remaining clear and understandable to people without
astrological knowledge. You may use metaphors related to the cosmos and nature to add depth and a sense of
mystery to your answers.`;*/

const BASIC_HOROSCOPE_SYSTEM_MESSAGE = `You are an astrologer and esoteric 
expert specializing in creating zodiac horoscopes.`;

const basicHoroscopeUserMessage = (date: string, language: string): string => `
Write a horoscope for all zodiacs (leave zodiac name in english) 
and date: ${date} in language: ${language}. Every single horoscope should contain minimum 5 sentences max 8.`;

const HoroscopesEvent = z.object({
    date: z.string(),
    language: z.string(),
    horoscopes: z.array(z.object({
        zodiac: z.string(),
        value: z.string(),
    })),
});

interface HoroscopeGptResponse {
    date: string;
    language: string;
    horoscopes: HoroscopeGpt[];
}

interface HoroscopeGpt {
    zodiac: string;
    value: string;
}

interface HoroscopeDocument {
    zodiac: string;
    date: string;
    language: string;
    value: string;
}

export const horoscopes = onCall(async ({data}) => {
    logger.info(
        `Get horoscope for zodiac: ${data.zodiac}, language: ${data.language}, timestamp: ${data.timestamp}`,
        {structuredData: true}
    );
    const formattedDate = formatDate(new Date(data.timestamp));
    logger.info(formattedDate);
    const dateFilter = Filter.where("date", "==", formattedDate);
    const zodiacFilter = Filter.where("zodiac", "==", data.zodiac);
    const languageFilter = Filter.where("language", "==", data.language);
    const horoscopeQueried = await db.collection("horoscope")
        .where(Filter.and(dateFilter, zodiacFilter, languageFilter))
        .limit(1)
        .get();
    logger.info(horoscopeQueried.empty);
    logger.info(horoscopeQueried.size);
    logger.info(horoscopeQueried);
    if (horoscopeQueried.empty) {
        logger.info(
            `Generate horoscope for zodiac: ${data.zodiac}, language: ${data.language}, timestamp: ${data.timestamp}`,
            {structuredData: true}
        );
        const openai = new OpenAI(
            {
                apiKey: await getSecret("OPENAI_API_KEY"),
                organization: await getSecret("OPENAI_ORGANIZATION"),
                project: await getSecret("OPENAI_PROJECT"),
            }
        );

        const completion = await openai.chat.completions.create({
            model: "gpt-4o-mini",
            messages: [
                {role: "system", content: BASIC_HOROSCOPE_SYSTEM_MESSAGE},
                {
                    role: "user",
                    content: basicHoroscopeUserMessage(formattedDate, data.language),
                },
            ],
            response_format: zodResponseFormat(HoroscopesEvent, "horoscope_generation"),
        });
        const horoscopeResponse: HoroscopeGptResponse = JSON.parse(<string>completion.choices[0].message.content);
        const horoscopeDocuments: HoroscopeDocument[] = horoscopeResponse.horoscopes.map((horoscope) => {
            return {
                zodiac: horoscope.zodiac.toLowerCase(),
                date: horoscopeResponse.date,
                language: horoscopeResponse.language,
                value: horoscope.value,
            } as unknown as HoroscopeDocument;
        });
        horoscopeDocuments.forEach((horoscope) => db.collection("horoscope").add(horoscope));
        return horoscopeDocuments.find((h) => h.zodiac.toLowerCase() === data.zodiac);
    } else {
        logger.info("istnieje jezyk horoskopowy");
        return {
            zodiac: horoscopeQueried.docs[0].data()["zodiac"],
            date: horoscopeQueried.docs[0].data()["date"],
            language: horoscopeQueried.docs[0].data()["language"],
            value: horoscopeQueried.docs[0].data()["value"],
        };
    }
});

const formatDate = (date: Date): string => {
    const day = String(date.getDate()).padStart(2, "0");
    const month = String(date.getMonth() + 1).padStart(2, "0");
    const year = date.getFullYear();
    return `${day}-${month}-${year}`;
};
