import cors from 'cors';
import debug from 'debug';
import express from 'express';
import { AddressInfo } from 'net';
import * as winston from 'winston';
import * as http from 'http';
import * as bodyparser from 'body-parser';
import * as expressWinston from 'express-winston';
import { CommonRoutesConfig } from './common/common.routes.config';
import helmet from 'helmet';
import { registerRoutes } from './routes';
import { parseCsvString } from './common/utils/strings';
import { systemWorkerConfig } from './config/system-worker.config';
import packageJson from '../package.json';
import { OperationStartupShutdown } from './common/services/operations.service';
import { WorkerManager } from './workers/worker-manager';
import { getRevision } from './config/revision';

const ServerDefaultConfig = {
    PORT: 3000
}

const loggerOptions: expressWinston.LoggerOptions = {
    transports: [new winston.transports.Console(),],
    format: winston.format.combine(
        winston.format.json(),
        winston.format.prettyPrint(),
        winston.format.colorize({ all: true })
    ),
};


export class ApiServer {
    // private readonly app: express.Application;
    public PORT: number = +(process.env.PORT || ServerDefaultConfig.PORT);
    public server!: http.Server;
    public routes: Array<CommonRoutesConfig> = []
    private debugLog: debug.IDebugger = debug('app');

    constructor(private readonly operations: OperationStartupShutdown, private readonly app: express.Application = express()) {
        this.server = http.createServer(app);
        this.app.use(bodyparser.json({ limit: "500kb" }));
        this.app.use(cors());
        this.app.use(helmet());

        if (!process.env.DEBUG) {
            loggerOptions.meta = false; // when not debugging, make terse
            if (typeof global.it === 'function') {
                loggerOptions.level = 'http'; // for non-debug test runs, squelch entirely
            }
        }

        app.use(expressWinston.logger(loggerOptions));
    }

    protected async onStart() {
        const _routes = registerRoutes(this.app);
        for (const route of _routes) {
            this.routes.push(route);
        }

        this.app.get('/health', (req: express.Request, res: express.Response) => {
            res.status(200).send({
                status: true,
                version: packageJson.version,
                revision: getRevision(),
                author: packageJson.author,
                startup_time: this.operations.startupDateTime,
                elapsed_duration: this.operations.elapsedDurationMs,
                is_worker_enabled: WorkerManager.isEnabled,
                message: `Server running at ${this.serverUrl()}`,
            });
        });

        this.app.get('/ping', (req: express.Request, res: express.Response) => {
            res.status(200).send('pong');
        });

        return null;
    }

    /**
     * Start the server
     * @returns {Promise<any>}
     */
    public async start(): Promise<ApiServer> {
        await this.onStart();
        return new Promise<ApiServer>((resolve, reject) => {
            this.server?.listen(this.PORT, () => {
                this.debugLog(`Server running at ${this.serverUrl()}`);

                this.routes.forEach((route: CommonRoutesConfig) => {
                    this.debugLog(`Routes configured for ${route.getName()}`);
                });
                return resolve(this);
            });
        });
    }

    public serverUrl(): string {
        const addressInfo = this.server.address() as AddressInfo;
        const address = addressInfo.address === '::' ? 'localhost' : addressInfo.address;
        const url = `http://${address}:${addressInfo.port}`;
        systemWorkerConfig.systemServerUrl = url;
        return url;
    }

    /**
     * Stop the server (if running).
     * @returns {Promise<boolean>}
     */
    public async stop(): Promise<boolean> {
        return new Promise<boolean>(resolve => {
            if (this.server) {
                this.server.close(() => {
                    return resolve(true);
                });
            } else {
                return resolve(false);
            }
        });
    }

    public getApp(): express.Application {
        return this.app;
    }

    get swaggerProtocols(): string[] {
        return parseCsvString(process.env.PROTOCOLS || '', '');
    }

    get swaggerHost(): string {
        return process.env.INGRESS_HOST || '';
    }
}
