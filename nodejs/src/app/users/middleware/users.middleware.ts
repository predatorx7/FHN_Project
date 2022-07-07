import express from 'express';
import userService from '../services/users.service';

class UsersMiddleware {
    async validateRequiredUserBodyFields(
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

    async validateSameUsernameDoesntExist(
        req: express.Request,
        res: express.Response,
        next: express.NextFunction
    ) {
        const user = await userService.getUserByUsername(req.body.username);
        if (user) {
            res.status(400).send({ errors: ['User username already exists'] });
        } else {
            next();
        }
    }

    async validateSameUsernameBelongToSameUser(
        req: express.Request,
        res: express.Response,
        next: express.NextFunction
    ) {
        const user = await userService.getUserByUsername(req.body.username);
        if (user && user.id.toString() == req.params.userId) {
            res.locals.user = user;
            next();
        } else {
            res.status(400).send({ errors: ['Invalid username'] });
        }
    }

    async userCantChangePermission(
        req: express.Request,
        res: express.Response,
        next: express.NextFunction
    ) {
        if (res.locals.user.roleLevel !== req.body.roleLevel) {
            res.status(400).send({
                errors: ['User cannot change permission level'],
            });
        } else {
            next();
        }
    }

    validatePatchUsername = async (
        req: express.Request,
        res: express.Response,
        next: express.NextFunction
    ) => {
        if (req.body.username) {
            this.validateSameUsernameBelongToSameUser(req, res, next);
        } else {
            next();
        }
    };

    async validateUserExists(
        req: express.Request,
        res: express.Response,
        next: express.NextFunction
    ) {
        const user = await userService.readById(Number.parseInt(req.params.userId));
        if (user) {
            next();
        } else {
            res.status(404).send({
                errors: [`User ${req.params.userId} not found`],
            });
        }
    }

    async extractUserId(
        req: express.Request,
        res: express.Response,
        next: express.NextFunction
    ) {
        req.body.id = req.params.userId;
        next();
    }
}

export default new UsersMiddleware();
