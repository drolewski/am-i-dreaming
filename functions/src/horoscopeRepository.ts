import {firestore} from "firebase-admin";
import {HoroscopeDocument, HoroscopeGptResponse} from "./horoscope";
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
