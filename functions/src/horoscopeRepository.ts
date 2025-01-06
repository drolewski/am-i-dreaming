import {firestore} from "firebase-admin";
import {
    HoroscopeDocument,
    HoroscopeGptResponse,
    PersonalizedHoroscopeDocument,
    PersonalizedHoroscopeGptResponse,
} from "./horoscope";
import Filter = firestore.Filter;
import Firestore = firestore.Firestore;

export const findHoroscope = async (db: Firestore, formattedDate: string, zodiac: string, language: string) => {
    const dateFilter = Filter.where("date", "==", formattedDate);
    const zodiacFilter = Filter.where("zodiac", "==", zodiac);
    const languageFilter = Filter.where("language", "==", language);
    return await db.collection("horoscope")
        .where(Filter.and(dateFilter, zodiacFilter, languageFilter))
        .limit(1)
        .get();
};

export const saveHoroscope = async (db: FirebaseFirestore.Firestore, horoscopeResponse: HoroscopeGptResponse) => {
    const horoscopeDocuments: HoroscopeDocument[] = horoscopeResponse.horoscopes.map((horoscope) => {
        return {
            zodiac: horoscope.zodiac.toLowerCase(),
            date: horoscopeResponse.date,
            language: horoscopeResponse.language,
            value: horoscope.value,
        } as unknown as HoroscopeDocument;
    });
    horoscopeDocuments.forEach((horoscope) => db.collection("horoscope").add(horoscope));
    return horoscopeDocuments;
};

export const findPersonalizedHoroscope = async (
    db: Firestore, userId: string, formattedDate: string, language: string) => {
    const dateFilter = Filter.where("date", "==", formattedDate);
    const userIdFilter = Filter.where("userId", "==", userId);
    const languageFilter = Filter.where("language", "==", language);
    return await db.collection("personalizedHoroscope")
        .where(Filter.and(dateFilter, userIdFilter, languageFilter))
        .limit(1)
        .get();
};

export const savePersonalizedHoroscope = async (
    db: FirebaseFirestore.Firestore, horoscopeResponse: PersonalizedHoroscopeGptResponse, userId: string) => {
    const horoscopeDocument: PersonalizedHoroscopeDocument = {
        userId: userId,
        date: horoscopeResponse.date,
        language: horoscopeResponse.language,
        horoscope: horoscopeResponse.horoscope,
    } as unknown as PersonalizedHoroscopeDocument;
    db.collection("personalizedHoroscope").add(horoscopeDocument);
    return horoscopeDocument;
};
