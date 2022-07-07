import debug from "debug";
import jwt from "jsonwebtoken";
import prismaService from "../../common/services/prisma.service";
import { isJwtExpired } from "../../common/utils/jwt";
import { SystemWorkerConfig } from "../../config/system-worker.config";
import { SystemService, Token } from "./service";
import crypto from 'crypto';

const log: debug.IDebugger = debug('app:system-worker-delegate');

export class SystemWorkerDelegate {
    private system: SystemService;

    _prisma = prismaService.prisma;

    constructor(config: SystemWorkerConfig) {
        this.system = new SystemService(config);
    }

    public work(): boolean {
        if (this.working) {
            return true;
        }
        this.startWork();
        return true;
    }

    working = false;

    private token?: Token

    private async authenticate() {
        if (this.token?.accessToken) {
            const decodedJson = jwt.decode(this.token?.accessToken) as jwt.JwtPayload;
            if (!isJwtExpired(decodedJson)) {
                return true;
            }
        }
        try {
            const data = await this.system.getAuthentication();
            if (data) {
                this.token = data;
                const decodedJson = jwt.decode(this.token?.accessToken) as jwt.JwtPayload;
                return !isJwtExpired(decodedJson);
            }
        } catch (error) {
            log(error);
        }
        log('Failed to authenticate');
        return false;
    }

    private async startWork() {
        this.working = true;

        const now = new AbsoluteDateTime(new Date());

        const yesterday = now.msToYesterday();
        const tomorrow = now.msToTomorrow();

        const hour = 3.6e+6;

        if (yesterday <= hour) {
            log('Cannot work within an hour after yesterday');
            this.working = false;
            return;
        }
        if (tomorrow <= hour) {
            log('Cannot work within an hour before tomorrow');
            this.working = false;
            return;
        }

        try {
            const isAuthenticated = await this.authenticate();
            if (isAuthenticated) {
                log(`Using token: ${this.token}`);
                const didComplete = await this.doSomething();
                if (didComplete) {
                    log(`Service completed`);
                }
            } else {
                log(`I am not authenticated`);
            }
        } catch (error) {
            log(error);
        }
        log('Stopping work');
        this.working = false;
    }

    private async doSomething(): Promise<boolean> {
        try {
            // do something
            return true;
        } catch (error) {
            log(error);
        }
        log('Failed to get today');
        return false;
    }

    private cryptoRandomNumber(minimum: number, maximum: number): number | null {
        const distance = maximum - minimum;

        if (minimum >= maximum) {
            log('Minimum number should be less than maximum');
            return null;
        } else if (distance > 281474976710655) {
            log('You can not get all possible random numbers if range is greater than 256^6-1');
            return null;
        } else if (maximum > Number.MAX_SAFE_INTEGER) {
            log('Maximum number should be safe integer limit');
            return null;
        } else {
            const maxBytes = 6;
            const maxDec = 281474976710656;

            const randbytes = parseInt(crypto.randomBytes(maxBytes).toString('hex'), 16);
            let result = Math.floor(randbytes / maxDec * (maximum - minimum + 1) + minimum);

            if (result > maximum) {
                result = maximum;
            }

            return result;
        }
    }
}

class AbsoluteDateTime {
    year: number;
    month: number;
    day: number;
    hours: number;
    minutes: number;

    constructor(date: Date) {
        this.year = date.getFullYear();
        this.month = date.getMonth();
        this.day = date.getDate();
        this.hours = 0;
        this.minutes = 0;
    }

    tomorrow(): Date {
        return new Date(this.year, this.month, this.day + 1, this.hours, this.minutes);
    }

    yesterday(): Date {
        return new Date(this.year, this.month, this.day - 1, this.hours, this.minutes);
    }

    msToYesterday(): number {
        return Math.abs(this.yesterday().getTime() - new Date().getTime());
    }

    msToTomorrow(): number {
        return Math.abs(this.tomorrow().getTime() - new Date().getTime());
    }
}