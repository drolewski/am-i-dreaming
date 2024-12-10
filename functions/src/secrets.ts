import {SecretManagerServiceClient} from "@google-cloud/secret-manager";

const secretClient = new SecretManagerServiceClient();

export const getSecret = async (secretName: string): Promise<string> => {
    const [version] = await secretClient.accessSecretVersion({
        name: `projects/${process.env.GCLOUD_PROJECT}/secrets/${secretName}/versions/latest`,
    });

    const secret = version.payload?.data?.toString();
    if (!secret) {
        throw new Error(`Secret ${secretName} is empty or not accessible.`);
    }

    return secret;
};
