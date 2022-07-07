import express from 'express';
import { validationResult } from 'express-validator';

class BodyValidationMiddleware {
    verifyBodyFieldsErrors(
        req: express.Request,
        res: express.Response,
        next: express.NextFunction
    ) {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).send({ errors: errors.array() });
        }
        next();
    }

    setLimitAndPage(
        req: express.Request,
        res: express.Response,
        next: express.NextFunction
    ) {
        let limit = req.query.limit || 100;
        let page = req.query.page || 0;

        if (typeof limit === 'string') {
            limit = Number.parseInt(limit)
        }
        if (typeof page === 'string') {
            page = Number.parseInt(page)
        }

        res.locals.limit = limit;
        res.locals.page = page;
        next();
    }
}

export default new BodyValidationMiddleware();
