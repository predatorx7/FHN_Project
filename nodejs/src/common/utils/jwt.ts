import jwt from 'jsonwebtoken';

export const isJwtExpired = (payload: jwt.JwtPayload | null): boolean => {
    try {
        const exp = payload?.exp;

        if (!exp) {
            return false;
        }

        const expiry = exp * 1000;

        return Date.now() >= expiry;
    } catch {
        return true;
    }
};
