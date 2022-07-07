import { systemWorker } from "./system.worker";
import { WorkerApi } from "./worker.api";

export const workers: WorkerApi[] = [
    systemWorker,
];
