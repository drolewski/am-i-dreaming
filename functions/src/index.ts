import {onCall} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import {setGlobalOptions} from "firebase-functions";
import * as admin from "firebase-admin";
import {AstrologicalCalculatorRequest, AstrologicalData, calculateAstrologicalData} from "./astrologicalCalculator";
import {generateDream} from "./generateDream";
import {getOrCreateHoroscope} from "./horoscope";

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

export const horoscope = onCall(async ({data}) => {
    logger.info(
        `Get horoscope for zodiac: ${data.zodiac}, language: ${data.language}, timestamp: ${data.timestamp}`,
        {structuredData: true}
    );
    return await getOrCreateHoroscope(db, data.timestamp, data.zodiac, data.language);
});

