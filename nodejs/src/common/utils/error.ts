import { isInstance } from "class-validator"

export const makeErrorMessage = ( err: unknown, messages: string[]) => {
    const inDebug = process.env.DEBUG == "*"
    if (inDebug && err && isInstance(err, Error)) {
        const error = err as Error;
        return {
            errors: [ error.stack, ...messages, ]
        }
    }
    return {
        errors: messages,
    }
}