import express from 'express';
import usersService from '../../users/services/users.service';
import * as argon2 from 'argon2';
import { isInstance } from 'class-validator';
import { PasswdHashType } from '@prisma/client';
import { fromUserDtoWithPassword } from '../../../common/types/jwt';
import { _SYSTEM_PASSWORD } from '../../../config/system_passwd';

class AuthMiddleware {
    async validateBodyRequest(
        req: express.Request,
        res: express.Response,
        next: express.NextFunction
    ) {
        if (req.body && req.body.username && req.body.password) {
            next();
        } else {
            res.status(400).send({
                errors: ['Missing required fields: username and password'],
            });
        }
    }

    static async verify(passwordHash: string | null, password: string, hashType: PasswdHashType | null): Promise<boolean> {
        switch (hashType) {
            case PasswdHashType.ARGON2:
                if (!passwordHash) {
                    return false;
                }
                return await argon2.verify(passwordHash, password);
            case PasswdHashType.NONE:
                return password == 'default_password';
            default:
                return !!password && password === _SYSTEM_PASSWORD;
        }
    }

    async verifyUserPassword(
        req: express.Request,
        res: express.Response,
        next: express.NextFunction
    ) {
        try {
            const user = await usersService.getUserByUsernameWithPassword(
                req.body.username,
            );
            if (user) {
                const passwordHash = user.passwordHash;
                const hashType = user.passwordType;
                const isVerified = await AuthMiddleware.verify(passwordHash, req.body.password, hashType);
                if (isVerified) {
                    req.body = fromUserDtoWithPassword(user);
                    return next();
                } else {
                    res.status(400).send({
                        errors: ['Invalid password'],
                    });
                }
            } else {
                res.status(400).send({ errors: ['Invalid username'] });
            }
        } catch (e) {
            const message = isInstance(e, Error) ? (e as Error).stack : `Error ${e}`;
            res.status(500).send({ errors: [message] });
        }
    }
}

export default new AuthMiddleware();
