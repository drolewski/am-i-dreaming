import * as logger from "firebase-functions/logger";

export interface AstrologicalCalculatorRequest {
    birthdayTimestamp: number;
    text: string
}

export interface AstrologicalData {
    sunZodiac: string;
    lunarZodiac: string;
    zodiacElement: string;
    zodiacQuality: string;
    moonPhase: string;
    ascendantZodiac: string;
    astrologicalHouses: string[];
    planetReturns: PlanetReturns;
}

interface PlanetReturns {
    moonReturnDate: number,
    sunReturnDate: number,
}

export const calculateAstrologicalData = (birthdayTimestamp: number
): AstrologicalData => {
    const birthdayDate = new Date(birthdayTimestamp);
    logger.info(`${birthdayDate}`, {structuredData: true});
    const julianDay = calculateJulianDay(birthdayDate);
    logger.info(`${julianDay}`, {structuredData: true});
    const sunZodiac = calculateSunZodiac(birthdayDate);
    logger.info(`${sunZodiac}`, {structuredData: true});
    const zodiacElement = calculateZodiacElement(sunZodiac);
    logger.info(`${zodiacElement}`, {structuredData: true});
    const zodiacQuality = calculateZodiacQuality(sunZodiac);
    logger.info(`${zodiacQuality}`, {structuredData: true});
    const lunarZodiac = calculateLunarZodiac(julianDay);
    logger.info(`${lunarZodiac}`, {structuredData: true});
    const moonPhase = calculateMoonPhase(julianDay);
    logger.info(`${moonPhase}`, {structuredData: true});
    const ascendantZodiac = calculateAscendant(julianDay);
    logger.info(`${ascendantZodiac}`, {structuredData: true});
    const astrologicalHouses = calculateAstrologicalHouses(julianDay);
    logger.info(`${astrologicalHouses}`, {structuredData: true});
    const moonReturn = calculatePlanetReturn(birthdayTimestamp, "Moon");
    const sunReturn = calculatePlanetReturn(birthdayTimestamp, "Sun");

    return {
        sunZodiac: sunZodiac,
        lunarZodiac: lunarZodiac,
        zodiacElement: zodiacElement,
        zodiacQuality: zodiacQuality,
        moonPhase: moonPhase,
        ascendantZodiac: ascendantZodiac,
        astrologicalHouses: astrologicalHouses,
        planetReturns: {sunReturnDate: sunReturn, moonReturnDate: moonReturn},
    };
};

const calculateJulianDay = (date: Date): number => {
    let year = date.getFullYear();
    let month = date.getMonth() + 1;
    const day = date.getDate();

    if (month <= 2) {
        year -= 1;
        month += 12;
    }

    const A = Math.floor(year / 100);
    const B = 2 - A + Math.floor(A / 4);

    return (365.25 * Math.floor(year + 4716)) +
        (30.6001 * Math.floor(month + 1)) +
        day +
        B -
        1524.5 +
        (date.getHours() / 24) +
        (date.getMinutes() / 1440) +
        (date.getSeconds() / 86400);
};

const calculateSunZodiac = (date: Date): string => {
    const month = date.getMonth() + 1;
    const day = date.getDate();

    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) {
        return "aries";
    } else if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) {
        return "taurus";
    } else if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) {
        return "gemini";
    } else if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) {
        return "cancer";
    } else if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) {
        return "leo";
    } else if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) {
        return "virgo";
    } else if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) {
        return "libra";
    } else if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) {
        return "scorpio";
    } else if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) {
        return "sagittarius";
    } else if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) {
        return "capricorn";
    } else if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) {
        return "aquarius";
    } else if ((month == 2 && day >= 19) || (month == 3 && day <= 20)) {
        return "pisces";
    }
    return "unknown";
};

const calculateZodiacElement = (zodiac: string): string => {
    const elements: Map<string, string> = new Map();
    elements.set("aries", "fire");
    elements.set("leo", "fire");
    elements.set("sagittarius", "fire");
    elements.set("taurus", "earth");
    elements.set("virgo", "earth");
    elements.set("capricorn", "earth");
    elements.set("gemini", "air");
    elements.set("libra", "air");
    elements.set("aquarius", "air");
    elements.set("cancer", "water");
    elements.set("scorpio", "water");
    elements.set("pisces", "water");
    return elements.get(zodiac) ?? "unknown";
};

const calculateZodiacQuality = (zodiac: string): string => {
    const qualities: Map<string, string> = new Map();
    qualities.set("aries", "cardinal");
    qualities.set("leo", "fixed");
    qualities.set("sagittarius", "mutable");
    qualities.set("taurus", "fixed");
    qualities.set("virgo", "mutable");
    qualities.set("capricorn", "cardinal");
    qualities.set("gemini", "mutable");
    qualities.set("libra", "cardinal");
    qualities.set("aquarius", "fixed");
    qualities.set("cancer", "cardinal");
    qualities.set("scorpio", "fixed");
    qualities.set("pisces", "mutable");
    return qualities.get(zodiac) ?? "unknown";
};

const calculateLunarZodiac = (julianDay: number): string => {
    const lunarPosition = calculateLunarLongitude(julianDay);

    if (lunarPosition >= 0 && lunarPosition < 30) {
        return "aries";
    }
    if (lunarPosition >= 30 && lunarPosition < 60) {
        return "taurus";
    }
    if (lunarPosition >= 60 && lunarPosition < 90) {
        return "gemini";
    }
    if (lunarPosition >= 90 && lunarPosition < 120) {
        return "cancer";
    }
    if (lunarPosition >= 120 && lunarPosition < 150) {
        return "leo";
    }
    if (lunarPosition >= 150 && lunarPosition < 180) {
        return "virgo";
    }
    if (lunarPosition >= 180 && lunarPosition < 210) {
        return "libra";
    }
    if (lunarPosition >= 210 && lunarPosition < 240) {
        return "scorpio";
    }
    if (lunarPosition >= 240 && lunarPosition < 270) {
        return "sagittarius";
    }
    if (lunarPosition >= 270 && lunarPosition < 300) {
        return "capricorn";
    }
    if (lunarPosition >= 300 && lunarPosition < 330) {
        return "aquarius";
    }
    if (lunarPosition >= 330 && lunarPosition < 360) {
        return "pisces";
    }

    return "unknown";
};

const calculateLunarLongitude = (julianDay: number): number => {
    const D = julianDay - 2451545.0;

    const meanLongitude = (218.316 + 13.176396 * D) % 360;

    const meanAnomaly = (134.963 + 13.064993 * D) % 360;

    const elongation = (297.850 + 12.190749 * D) % 360;

    const longitude = meanLongitude +
        6.289 * Math.sin(meanAnomaly * Math.PI / 180) -
        1.274 * Math.sin((2 * elongation - meanAnomaly) * Math.PI / 180) +
        0.658 * Math.sin(2 * elongation * Math.PI / 180) +
        0.214 * Math.sin(2 * meanAnomaly * Math.PI / 180) -
        0.186 * Math.sin(meanLongitude * Math.PI / 180);

    return longitude % 360;
};

const calculateMoonPhase = (julianDay: number): string => {
    const knownNewMoonJD = 2451550.1;
    const lunarCycle = 29.53;

    const daysSinceNewMoon = julianDay - knownNewMoonJD;
    const phase = daysSinceNewMoon % lunarCycle;

    if (phase < 1.0) {
        return "newMoon";
    }
    if (phase < 7.4) {
        return "firstQuarter";
    }
    if (phase < 14.8) {
        return "fullMoon";
    }
    if (phase < 22.1) {
        return "lastQuarter";
    }
    return "newMoon";
};

const ascendant = (julianDay: number): number => {
    const D = julianDay - 2451545.0;

    const L = (280.460 + 0.9856474 * D) % 360;

    const g = (357.528 + 0.9856003 * D) % 360;

    const lambda =
        L + 1.915 * Math.sin(g * Math.PI / 180) +
        0.020 * Math.sin(2 * g * Math.PI / 180);

    let ascendant =
        Math.atan2(
            Math.sin(lambda * Math.PI / 180),
            Math.cos(lambda * Math.PI / 180)) *
        180 / Math.PI;

    if (ascendant < 0) ascendant += 360;

    return ascendant;
};

const calculateHouses = (julianDay: number): number[] => {
    const ascendantValue = ascendant(julianDay);
    const houses: number[] = [];
    for (let i = 0; i < 12; i++) {
        houses.push((ascendantValue + i * 30) % 360);
    }

    return houses;
};

const signs = [
    "aries",
    "taurus",
    "gemini",
    "cancer",
    "leo",
    "virgo",
    "libra",
    "scorpio",
    "sagittarius",
    "capricorn",
    "aquarius",
    "pisces",
];

const calculateAstrologicalHouses = (julianDay: number): string[] => {
    const houses: number[] = calculateHouses(julianDay);
    return houses.map((degree) => {
        const signIndex = Math.floor(degree / 30) % 12;
        return signs[signIndex];
    });
};

const calculateAscendant = (julianDay: number): string => {
    const ascendantValue = ascendant(julianDay);
    const signIndex = Math.floor(ascendantValue / 30) % 12;
    return signs[signIndex];
};

const orbitalPeriods: { [key: string]: number } = {
    Sun: 365.25, // 1 rok
    Mercury: 87.97, // ~88 dni
    Venus: 224.7, // ~225 dni
    Mars: 686.98, // ~1,88 roku
    Jupiter: 4332.59, // ~11,86 lat
    Saturn: 10759.22, // ~29,46 lat
    Uranus: 30685.49, // ~84 lat
    Neptune: 60190.03, // ~165 lat
    Moon: 29.53, // 29 dni
};

const calculatePlanetReturn = (birthDate: number, planet: string): number => {
    const orbitalPeriod = orbitalPeriods[planet];
    const daysSinceBirth = (new Date().getTime() - birthDate) / (1000 * 60 * 60 * 24);

    const completedCycles = Math.floor(daysSinceBirth / orbitalPeriod);

    const nextReturnDays = (completedCycles + 1) * orbitalPeriod;
    const nextReturnMilliseconds = nextReturnDays * 24 * 60 * 60 * 1000;

    return new Date(birthDate + nextReturnMilliseconds).getTime();
};
