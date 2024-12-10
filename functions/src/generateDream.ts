import {generateImage} from "./generateImage";
import {Bucket} from "@google-cloud/storage";
import {firestore} from "firebase-admin";
import * as logger from "firebase-functions/logger";
import Firestore = firestore.Firestore;

const DEFAULT_FILE = "obraz_2024-12-10_151203115.png";

export const generateDream = async (bucket: Bucket, db: Firestore, dreamId: string) => {
    const dream = await db.collection("dream").doc(dreamId).get();

    if (dream.exists) {
        const dreamData = dream.data();
        logger.info(`Dream text: ${dreamData?.text}`);
        const filename = await generateImage(bucket, dreamData?.text as string);
        logger.info(`File name: ${filename}`);
        const signedUrl = await getSignedUrl(bucket, filename);
        await db.collection("dream").doc(dreamId).set({url: signedUrl.url}, {merge: true});
        return signedUrl;
    }

    logger.info("Default file");
    return await getSignedUrl(bucket, DEFAULT_FILE);
};

const getSignedUrl = async (bucket: Bucket, filename: string) => {
    const file = bucket.file(filename);
    const [url] = await file.getSignedUrl({
        action: "read",
        expires: new Date(new Date().getTime() + 365 * 24 * 60 * 60 * 1000).getTime(),
    });
    logger.info(`Signed url: ${url.toString()}`);
    return {url: url};
};
