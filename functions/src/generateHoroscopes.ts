import {OpenAI} from "openai";
import {getSecret} from "./secrets";
import {zodResponseFormat} from "openai/helpers/zod";
import {z} from "zod";

const BASIC_HOROSCOPE_SYSTEM_MESSAGE = `You are an astrologer and esoteric 
expert specializing in creating zodiac horoscopes.`;

const PERSONALIZED_HOROSCOPE_SYSTEM_MESSAGE = `You are an astrologer and esoteric
expert specializing in creating zodiac horoscopes based on birthdate and birthplace.
You have to take care of astrological houses, moon phases, planets positions and generate high quality horoscope.`;

const basicHoroscopeUserMessage = (date: string, language: string): string => `
Write a horoscope for all zodiacs (leave zodiac name in english and don't use zodiac name in generated text)
and date: ${date} in language: ${language}. Every single horoscope should contain minimum 5 sentences max 8.`;

const personalizedHoroscopeUserMessage = (
    date: string, birthdate: string, birthplace: string, language: string): string => `
Write a horoscope for person born at ${birthdate} in this place of: ${birthplace}.
Write horoscope for the date of ${date}. Generate minimum of 8 sentences max 14 in language ${language}`;

const HoroscopesEvent = z.object({
    date: z.string(),
    horoscopes: z.array(z.object({
        zodiac: z.string(),
        value: z.string(),
    })),
});

const PersonalizedHoroscopeEvent = z.object({
    date: z.string(),
    horoscope: z.string(),
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

export const generatePersonalizedHoroscope = async (
    formattedDate: string, language: string, birthdate: string, birthplace: string) => {
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
            {role: "system", content: PERSONALIZED_HOROSCOPE_SYSTEM_MESSAGE},
            {
                role: "user",
                content: personalizedHoroscopeUserMessage(formattedDate, birthdate, birthplace, language),
            },
        ],
        response_format: zodResponseFormat(PersonalizedHoroscopeEvent, "personalized_horoscope_generation"),
    });
};
