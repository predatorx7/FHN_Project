import winston, { Logger } from 'winston';
import DailyRotateFile from 'winston-daily-rotate-file';

const logger: Logger = winston.createLogger({
    level: 'info',
    format: winston.format.json(),
    defaultMeta: { service: 'user-service' },
});

//
// If we're not in production then log to the `console` with the format:
// `${info.level}: ${info.message} JSON.stringify({ ...rest }) `
//
if (process.env.NODE_ENV !== 'production') {
    logger.add(new winston.transports.Console({
        format: winston.format.simple(),
    }));
}

logger.configure({
    level: 'verbose',
    transports: [
        new DailyRotateFile({
            dirname: 'logs',
        })
    ]
});

export default logger;
