import prismaService from "./common/services/prisma.service";
import { ApiServer } from "./server";
import { workerManager } from './workers';
import dotenv from 'dotenv';
import { OperationStartupShutdown } from "./common/services/operations.service";

export const start = async (): Promise<void> => {
    dotenv.config();

    return new Promise<void>((resolve, reject) => {
        const operation = new OperationStartupShutdown();
        const apiServer = new ApiServer(operation);

        Promise.all([
            operation.start(),
            apiServer.start(),
            workerManager.start(),
        ]).then(() => resolve())
            .catch(reject);


        const graceful = () => {
            Promise.all([
                apiServer.stop(),
                workerManager.stop(),
                prismaService.disconnect(),
                operation.stop(),
            ]).then(() => process.exit(0));
        };

        // Stop graceful
        process.on('SIGTERM', graceful);
        process.on('SIGINT', graceful);
    });
};

