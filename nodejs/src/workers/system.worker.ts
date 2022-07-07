import Timeout = NodeJS.Timeout;

import { WorkerApi } from './worker.api';
import { systemWorkerConfig, SystemWorkerConfig } from '../config/system-worker.config';
import { Observable, of, Subject } from 'rxjs';
import debug from 'debug';
import { SystemWorkerDelegate } from './system';

const log: debug.IDebugger = debug('app:system-worker');

class SystemWorker implements WorkerApi {
    private config: SystemWorkerConfig = systemWorkerConfig;

    private stopped = true;
    private interval?: Timeout;
    private delegate?: SystemWorkerDelegate;
    private subject?: Subject<string>;

    stop(): Observable<string> {
        this.stopped = true;
        log('*** Stopping system worker');

        if (this.interval) {
            clearInterval(this.interval);
        }

        if (this.subject) {
            this.subject.complete();
        }

        return this.subject || of();
    }

    start(): Observable<string> {
        if (this.subject) {
            return this.subject;
        }

        this.stopped = false;

        this.subject = new Subject<string>();

        this.delegate = new SystemWorkerDelegate(this.config);

        log(`Worker will run every ${this.config.runSystemInterval} ms`);

        this.interval = setInterval(() => {
            if (!this.subject) {
                return null;
            }
            this.subject.next(this.nudgeDelegate());
            return null;
        }, this.config.runSystemInterval);

        return this.subject;
    }

    nudgeDelegate(): string {
        const message = '**** System worker running';
        console.log(message);

        const log: debug.IDebugger = debug('app:system-worker:delegate');
        log(message);

        const value = this.delegate?.work();
        log(`Delegate status: ${value}`);

        return message;
    }
}

export const systemWorker: WorkerApi = new SystemWorker();
