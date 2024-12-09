import {onCall} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import {setGlobalOptions} from "firebase-functions";
import {AstrologicalCalculatorRequest, AstrologicalData, calculateAstrologicalData} from "./astrologicalCalculator";

setGlobalOptions({region: "europe-west1"});

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
