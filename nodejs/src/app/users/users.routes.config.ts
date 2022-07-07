import { CommonRoutesConfig } from '../../common/common.routes.config';
import UsersController from './controllers/users.controller';
import UsersMiddleware from './middleware/users.middleware';
import jwtMiddleware from '../auth/middleware/jwt.middleware';
import permissionMiddleware from '../../common/middleware/common.permission.middleware';
import { PermissionLevel } from '../../common/middleware/common.permissionlevel.enum';
import BodyValidationMiddleware from '../../common/middleware/body.validation.middleware';
import { body, query } from 'express-validator';

import express from 'express';

export class UsersRoutes extends CommonRoutesConfig {
    constructor(app: express.Application) {
        super(app, 'UsersRoutes');
    }

    configureRoutes(): express.Application {
        this.app
            .route(`/users`)
            .get(
                jwtMiddleware.validJWTNeeded,
                permissionMiddleware.onlyAdminCanDoThisAction,
                UsersController.listUsers
            )
            .post(
                jwtMiddleware.validJWTNeeded,
                permissionMiddleware.onlyAdminCanDoThisAction,
                UsersMiddleware.validateRequiredUserBodyFields,
                UsersMiddleware.validateSameUsernameDoesntExist,
                jwtMiddleware.addUserConnectionIn('_user'),
                UsersController.createUser
            );

        this.app
            .route(`/roles`)
            .get(
                jwtMiddleware.validJWTNeeded,
                permissionMiddleware.minimumPermissionLevelRequired(
                    PermissionLevel.data_entry,
                ),
                query('limit').isInt().default(100),
                query('page').isInt().default(0),
                BodyValidationMiddleware.setLimitAndPage,
                UsersController.listRoles,
            );

        this.app.param(`userId`, UsersMiddleware.extractUserId);
        this.app
            .route(`/users/:userId`)
            .all(
                UsersMiddleware.validateUserExists,
                jwtMiddleware.validJWTNeeded,
                permissionMiddleware.onlySameUserOrAdminCanDoThisAction
            )
            .get(UsersController.getUserById)
            .delete(UsersController.removeUser);

        this.app.put(`/users/:userId`, [
            jwtMiddleware.validJWTNeeded,
            body('email').optional({ checkFalsy: true }).isEmail(),
            body('password')
                .isLength({ min: 5 })
                .withMessage('Must include password (5+ characters)'),
            body('firstName').optional({ checkFalsy: true }).isString(),
            body('lastName').optional({ checkFalsy: true }).isString(),
            BodyValidationMiddleware.verifyBodyFieldsErrors,
            UsersMiddleware.validateSameUsernameBelongToSameUser,
            permissionMiddleware.onlySameUserOrAdminCanDoThisAction,
            jwtMiddleware.addUserConnectionIn('_user'),
            UsersController.put,
        ]);

        this.app.patch(`/users/:userId`, [
            jwtMiddleware.validJWTNeeded,
            body('username').isString(),
            body('email').isEmail().optional(),
            body('password')
                .isLength({ min: 5 })
                .withMessage('Password must be 5+ characters')
                .optional(),
            body('firstName').isString().optional(),
            body('lastName').isString().optional(),
            BodyValidationMiddleware.verifyBodyFieldsErrors,
            UsersMiddleware.validatePatchUsername,
            permissionMiddleware.onlySameUserOrAdminCanDoThisAction,
            jwtMiddleware.addUserConnectionIn('_user'),
            UsersController.patch,
        ]);

        this.app.put(`/users/:userId/permissions/:roleType`, [
            jwtMiddleware.validJWTNeeded,
            permissionMiddleware.onlySameUserOrAdminCanDoThisAction,
            jwtMiddleware.addUserConnectionIn('_user'),
            UsersController.updatePermissionLevel,
        ]);

        return this.app;
    }
}
