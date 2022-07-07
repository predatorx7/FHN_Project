import { PrismaClient } from '@prisma/client';
import debug from 'debug';

const log: debug.IDebugger = debug('app:prisma-service');

interface PrismaService {
    get prisma(): PrismaClient;
    disconnect(): Promise<void>;
}

class PrismaServiceImpl implements PrismaService {
    constructor() {
        this.connect();
    }

    _prisma: PrismaClient | null = null;

    protected connect() {
        log('Attempting MySQL-Prisma connection (will retry if needed)');
        this._prisma = new PrismaClient({ log: ['query'] });
        
    }

    public async disconnect(): Promise<void> {
        await this._prisma?.$disconnect();
        this._prisma = null;
        log('Disconnected MySQL-Prisma connection');
    }

    get prisma(): PrismaClient {
        return this._prisma as PrismaClient;
    }
}

const prismaService: PrismaService = new PrismaServiceImpl();

export default prismaService;
