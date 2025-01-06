import {OpenAI} from "openai";
import {getSecret} from "./secrets";
import {zodResponseFormat} from "openai/helpers/zod";
import {z} from "zod";

const BASIC_HOROSCOPE_SYSTEM_MESSAGE = `You are an astrologer and esoteric 
expert specializing in creating zodiac horoscopes.`;

const basicHoroscopeUserMessage = (date: string, language: string): string => `
Write a horoscope for all zodiacs (leave zodiac name in english and don't use zodiac name in generated text)
and date: ${date} in language: ${language}. Every single horoscope should contain minimum 5 sentences max 8.`;

const HoroscopesEvent = z.object({
    date: z.string(),
    language: z.string(),
    horoscopes: z.array(z.object({
        zodiac: z.string(),
        value: z.string(),
    })),
});

export const generateBasicHoroscopes = async (formattedDate: string, language: string) => {
    return generateHoroscopes(formattedDate, language, BASIC_HOROSCOPE_SYSTEM_MESSAGE);
};

const generateHoroscopes = async (formattedDate: string, language: string, systemMessage: string) => {
    const openai = new OpenAI(
        {
            apiKey: await getSecret("OPENAI_API_KEY"),
            organization: await getSecret("OPENAI_ORGANIZATION"),
            project: await getSecret("OPENAI_PROJECT"),
        }
    );

    // TODO openAI Generation metrics
    return openai.chat.completions.create({
        model: "gpt-4o-mini",
        messages: [
            {role: "system", content: systemMessage},
            {
                role: "user",
                content: basicHoroscopeUserMessage(formattedDate, language),
            },
        ],
        response_format: zodResponseFormat(HoroscopesEvent, "horoscope_generation"),
    });
};
