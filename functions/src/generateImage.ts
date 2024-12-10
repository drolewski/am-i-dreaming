import {OpenAI} from "openai";
import {getSecret} from "./secrets";
import * as path from "node:path";
import * as fs from "node:fs";
import * as os from "node:os";
import {Bucket} from "@google-cloud/storage";
import * as logger from "firebase-functions/logger";

export const generateImage = async (bucket: Bucket, prompt: string,): Promise<string> => {
    const openai = new OpenAI(
        {
            apiKey: await getSecret("OPENAI_API_KEY"),
            organization: await getSecret("OPENAI_ORGANIZATION"),
            project: await getSecret("OPENAI_PROJECT"),
        }
    );
    logger.info("openai configured");
    const response = await openai.images.generate({
        model: "dall-e-3", // 0.04$;  "dall-e-2"-0.02$
        prompt: prompt, // Wrap this url with some story text about dream.
        size: "1024x1024",
        quality: "standard",
        response_format: "url",
        n: 1,
    });
    const imageUrl = response.data[0].url as string;
    logger.info(`image url: ${imageUrl}`);

    const imgFetch = await fetch(imageUrl);
    if (!imgFetch.ok) {
        throw new Error(`Failed to fetch image from URL: ${imageUrl}`);
    }
    const buffer = Buffer.from(await imgFetch.arrayBuffer());
    const fileExtension = path.extname(imageUrl) || ".jpg";
    const tempFilename = path.join(os.tmpdir(), `tmp-image-${new Date().getTime()}${fileExtension}`);
    const destFilename = `${new Date().getTime()}${fileExtension}`;
    logger.info(`tempFilename: ${tempFilename}`);
    logger.info(`destFilename: ${tempFilename}`);
    logger.info(`fileExtension: ${tempFilename}`);
    fs.writeFileSync(tempFilename, buffer);

    await bucket.upload(tempFilename, {
        destination: destFilename,
    });

    fs.unlinkSync(tempFilename);

    logger.info("open ai generation and storage finished");
    return destFilename;
};
