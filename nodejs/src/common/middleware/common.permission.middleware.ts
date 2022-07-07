import express from 'express';
import { PermissionLevel } from './common.permissionlevel.enum';
import debug from 'debug';
import { makeErrorMessage } from '../utils/error';

const log: debug.IDebugger = debug('app:common-permission-middleware');

class CommonPermissionMiddleware {
    minimumPermissionLevelRequired(requiredPermissionLevel: PermissionLevel) {
        return (
            req: express.Request,
            res: express.Response,
            next: express.NextFunction
        ) => {
            try {
                const userPermissionLevel = res.locals.jwt.roleLevel;
                if (userPermissionLevel >= requiredPermissionLevel) {
                    next();
                } else {
                    res.status(403).send(makeErrorMessage(null, [
                        'Error: minimumPermissionLevelRequired',
                        `Yours: ${userPermissionLevel || res.locals.jwt.permissionLevel} & required: ${requiredPermissionLevel}`
                    ]));
                }
            } catch (e) {
                log(e);
            }
        };
    }

    async onlySameUserOrAdminCanDoThisAction(
        req: express.Request,
        res: express.Response,
        next: express.NextFunction
    ) {
        const userPermissionLevel = res.locals.jwt.roleLevel;
        if (
            req.params &&
            req.params.userId &&
            req.params.userId == res.locals.jwt.userId
        ) {
            return next();
        } else {
            if (userPermissionLevel >= PermissionLevel.admin) {
                return next();
            } else {
                return res.status(403).send(makeErrorMessage(null, ['Error: onlySameUserOrAdminCanDoThisAction']));
            }
        }
    }

    async onlyAdminCanDoThisAction(
        req: express.Request,
        res: express.Response,
        next: express.NextFunction
    ) {
        const userPermissionLevel = res.locals.jwt.roleLevel;
        if (userPermissionLevel >= PermissionLevel.admin) {
            return next();
        } else {
            return res.status(403).send(makeErrorMessage(null, [
                'Error: onlyAdminCanDoThisAction',
                `Your permission level: ${userPermissionLevel} but required ${PermissionLevel.admin}`
            ]));
        }
    }
}

export default new CommonPermissionMiddleware();
