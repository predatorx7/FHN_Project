import express from 'express';
import jwt from 'jsonwebtoken';
import crypto from 'crypto';
import { fromUserDtoWithPassword, Jwt, JwtId } from '../../../common/types/jwt';
import usersService from '../../users/services/users.service';
import debug from 'debug';
import { makeErrorMessage } from '../../../common/utils/error';

// @ts-expect-error
const jwtSecret: string = process.env.JWT_SECRET;

const log: debug.IDebugger = debug('auth:middleware:jwt');

class JwtMiddleware {
    verifyRefreshBodyField(
        req: express.Request,
        res: express.Response,
        next: express.NextFunction
    ) {
        if (req.body && req.body.refreshToken) {
            return next();
        } else {
            return res
                .status(400)
                .send({ errors: ['Missing required field: refreshToken'] });
        }
    }

    async validRefreshNeeded(
        req: express.Request,
        res: express.Response,
        next: express.NextFunction
    ) {
        const user = await usersService.getUserByUsernameWithPassword(
            res.locals.jwt.username,
        );
        if (user == null) {
            return res.status(400).send({ errors: [`No user found by name: ${res.locals.jwt.username}`] })
        }
        const salt = crypto.createSecretKey(
            Buffer.from(res.locals.jwt.refreshKey.data)
        );
        const hash = crypto
            .createHmac('sha512', salt)
            .update(res.locals.jwt.userId + jwtSecret)
            .digest('base64');

        if (hash === req.body.refreshToken) {
            req.body = fromUserDtoWithPassword(user);
            return next();
        } else {
            return res.status(400).send({ errors: ['Invalid refresh token'] });
        }
    }

    validJWTNeeded(
        req: express.Request,
        res: express.Response,
        next: express.NextFunction
    ) {
        if (req.headers['authorization']) {
            try {
                const authorization = req.headers['authorization'].split(' ');
                if (authorization[0] !== 'Bearer') {
                    return res.status(401).send();
                } else {
                    log('Verifying JWT');
                    res.locals.jwt = jwt.verify(
                        authorization[1],
                        jwtSecret
                    ) as Jwt;
                    next();
                }
            } catch (err) {
                return res.status(403).send(makeErrorMessage(err, ['Error authentication']));
            }
        } else {
            return res.status(401).send();
        }
    }

    addUserConnectionIn(key: string) {
        return (
            req: express.Request,
            res: express.Response,
            next: express.NextFunction
        ) => {
            if (!res.locals.jwt) {
                return res.status(403).send({ errors: ["Error adding user as an updator for this request"] });
            }

            const jwtUser = res.locals.jwt as Jwt;

            const user: JwtId = {
                id: jwtUser.userId,
            }

            req.body[key] = user;

            next();
        }
    }
}

export default new JwtMiddleware();
