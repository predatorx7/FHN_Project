import axios from "axios";
import debug from "debug";
import { SystemWorkerConfig } from "../../config/system-worker.config";
import { _SYSTEM_PASSWORD } from "../../config/system_passwd";


const log: debug.IDebugger = debug('app:system-worker-delegate:service');


export type Token = {
    accessToken: string;
    refreshToken: string;
}

export class SystemService {
    config: SystemWorkerConfig;

    get serverUrl(): string {
        return this.config.systemServerUrl;
    }

    private getBearerToken(token: Token): string {
        return 'Bearer '.concat(token.accessToken);
    }

    constructor(config: SystemWorkerConfig) {
        this.config = config;
        log(`Using server URL: ${this.serverUrl}`);
    }

    _log(value: string) {
        log(`Sending request at ${value}`);
        return value;
    }

    async getAuthentication(): Promise<Token | null> {
        const response = await axios.post(this._log(`${this.serverUrl}/auth`), {
            username: 'system',
            password: _SYSTEM_PASSWORD,
        });

        return response.data;
    }

    async doSomething(token: Token, data: any) {
        try {
            const response = await axios.post(this._log(`${this.serverUrl}/do_something`),
                data,
                {
                    headers: {
                        Authorization: this.getBearerToken(token),
                    }
                }
            );

            return response;
        } catch (err) {
            log('Failed to do something');
            log(err);
        }
        return null;
    }
}
