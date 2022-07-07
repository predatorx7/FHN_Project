import debug from "debug";
import { WorkerApi } from "./worker.api";
import { workers } from "./workers";
import { forkJoin, Observable, lastValueFrom, EmptyError } from 'rxjs';
import { isInstance } from "class-validator";

export abstract class WorkerManager {
    static get isEnabled() { return process.env.is_worker_disabled != 'true'; };

    abstract registerWorker(worker: WorkerApi): WorkerApi;
    abstract start(): Promise<any>;
    abstract stop(): Promise<any>;
    abstract workerCount(): number;
}

const log: debug.IDebugger = debug('app:worker-manager-impl');

class WorkerManagerImpl implements WorkerManager {

    private workers: WorkerApi[] = [];

    registerWorker(worker: WorkerApi) {
        if (worker) {
            this.workers.push(worker);
        }

        return worker;
    }

    workerCount(): number {
        return this.workers.length;
    }

    isRegistered = false;
    register(): void {
        if (this.isRegistered) return;
        log('Registering workers');
        for (const worker of workers) {
            workerManager.registerWorker(worker);
        }
        log(`Registered ${workerManager.workerCount()} workers`)
        this.isRegistered = true;
    }

    async start(): Promise<any> {
        if (!WorkerManager.isEnabled) return;
        this.register();
        log(`starting ${this.workerCount()} workers`);
        const observables: Observable<any>[] = this.workers.map(worker => worker.start());
        const observable = forkJoin(observables);
        try {
            await lastValueFrom(observable);
        } catch (e) {
            if (!isInstance(e, EmptyError)) {
                log(e);
            }
        }
        return 'done';
    }

    async stop(): Promise<any> {
        if (!WorkerManager.isEnabled) return;
        log(`stopping ${this.workerCount()} workers`);
        const observables: Observable<any>[] = this.workers.map(worker => worker.stop());
        const observable = forkJoin(observables);
        try {
            await lastValueFrom(observable);
        } catch (e) {
            if (!isInstance(e, EmptyError)) {
                log(e);
            }
        }
        return 'stopped';
    }
}

export const workerManager: WorkerManager = new WorkerManagerImpl();
