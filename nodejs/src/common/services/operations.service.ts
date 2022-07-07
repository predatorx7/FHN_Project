import debug from "debug";

export class OperationStartupShutdown {
    log: debug.IDebugger = debug('app:operation-info');

    private startup!: Date;
    
    get startupDateTime() {
        return this.startup;
    }

    get elapsedDurationMs() {
        return new Date().getTime() - this.startup.getTime();
    }

    private stopped!: Date;

    async start() {
        this.startup = new Date();
        this.log(`Server started at ${this.startup.toLocaleString()}`);
        (BigInt.prototype as any).toJSON = function () {
            return Number(this)
        };
        return this;
    }

    async stop() {
        this.stopped = new Date();
        this.log(`Server stopped at ${this.stopped.toLocaleString()}`);
        const elapsedMs = this.stopped.getTime() - this.startup.getTime();
        this.log(`Server operated for duration: ${elapsedMs} milliseconds`);
        return this;
    }
}
