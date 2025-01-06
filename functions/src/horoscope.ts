import {firestore} from "firebase-admin";
import * as logger from "firebase-functions/logger";
import {
    findHoroscope,
    saveHoroscope,
    findPersonalizedHoroscope,
    savePersonalizedHoroscope,
} from "./horoscopeRepository";
import {generateBasicHoroscopes, generatePersonalizedHoroscope} from "./generateHoroscopes";
import Firestore = firestore.Firestore;

/* const PERSONALIZED_HOROSCOPE_SYSTEM_MESSAGE = `You are an astrologer and esoteric expert specializing
in creating zodiac horoscopes. Your task is to interpret the movements of planets, zodiac signs, and astrological
houses to predict the future, analyze personalities, and provide life advice. You use classical astrological
techniques such as the analysis of natal planetary arrangements, transits, and aspects. Your responses should be filled
with esoteric language and an atmosphere of mysticism, while remaining clear and understandable to people without
astrological knowledge. You may use metaphors related to the cosmos and nature to add depth and a sense of
mystery to your answers.`;*/


export interface HoroscopeGptResponse {
    date: string;
    language: string;
    horoscopes: HoroscopeGpt[];
}

export interface PersonalizedHoroscopeGptResponse {
    date: string;
    language: string;
    horoscope: string;
}

interface HoroscopeGpt {
    zodiac: string;
    value: string;
}

export interface HoroscopeDocument {
    zodiac: string;
    date: string;
    language: string;
    value: string;
}

export interface PersonalizedHoroscopeDocument {
    userId: string;
    date: string;
    language: string;
    horoscope: string;
}

// TODO there is place to optimize this function
export const getOrCreateHoroscope = async (db: Firestore, timestamp: number, zodiac: string, language: string) => {
    const formattedDate = formatDate(new Date(timestamp));
    const horoscope = await findHoroscope(db, formattedDate, zodiac, language);
    if (horoscope.empty) {
        logger.info(
            `Generate horoscope for zodiac: ${zodiac}, language: ${language}, date: ${formattedDate}`,
            {structuredData: true}
        );
        return await createHoroscope(formattedDate, language, db, zodiac);
    } else {
        logger.info(`Return existing horoscope document: ${zodiac}, language: ${language}, date: ${formattedDate}`);
        return {
            zodiac: horoscope.docs[0].data()["zodiac"],
            date: horoscope.docs[0].data()["date"],
            language: horoscope.docs[0].data()["language"],
            value: horoscope.docs[0].data()["value"],
        };
    }
};

export const getOrCreatePersonalizedHoroscope = async (
    db: Firestore, userId: string, timestamp: number, birthdate: number, birthplace: string, language: string) => {
    const formattedDate = formatDate(new Date(timestamp));
    const formattedBirthdate = formatDate(new Date(birthdate));
    const personalizedHoroscope = await findPersonalizedHoroscope(db, userId, formattedDate, language);
    if (personalizedHoroscope.empty) {
        logger.info(
            `Generate personalized horoscope for userId=${userId}, language=${language}, date=${formattedDate}`,
            {structuredData: true}
        );
        return await createPersonalizedHoroscope(userId, formattedDate, language, db, formattedBirthdate, birthplace);
    } else {
        logger.info(
            `Return existing personalized horoscope document:
            userId=${userId}, language=${language}, date=${formattedDate}`);
        return {
            userId: userId,
            date: personalizedHoroscope.docs[0].data()["date"],
            language: personalizedHoroscope.docs[0].data()["language"],
            horoscope: personalizedHoroscope.docs[0].data()["horoscope"],
        };
    }
};

const createHoroscope = async (
    formattedDate: string, language: string, db: FirebaseFirestore.Firestore, zodiac: string) => {
    const completion = await generateBasicHoroscopes(formattedDate, language);
    const horoscopeResponse: HoroscopeGptResponse = JSON.parse(<string>completion.choices[0].message.content);
    const horoscopeDocuments = await saveHoroscope(db, horoscopeResponse);
    return horoscopeDocuments.find((h) => h.zodiac.toLowerCase() === zodiac);
};

const createPersonalizedHoroscope = async (
    userId: string, formattedDate: string, language: string,
    db: FirebaseFirestore.Firestore, birthdate: string, birthplace: string) => {
    const completion = await generatePersonalizedHoroscope(formattedDate, language, birthdate, birthplace);
    const horoscopeResponse: PersonalizedHoroscopeGptResponse = JSON.parse(
        <string>completion.choices[0].message.content);
    return await savePersonalizedHoroscope(db, horoscopeResponse, userId);
};

const formatDate = (date: Date): string => {
    const day = String(date.getDate()).padStart(2, "0");
    const month = String(date.getMonth() + 1).padStart(2, "0");
    const year = date.getFullYear();
    return `${day}-${month}-${year}`;
};


