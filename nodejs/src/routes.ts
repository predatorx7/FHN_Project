import express from 'express';

import { CommonRoutesConfig } from "./common/common.routes.config";

import { UsersRoutes } from "./app/users/users.routes.config";
import { AuthRoutes } from "./app/auth/auth.routes.config";
// import { PublicRoutes } from './app/public/public.routes.config';

export const registerRoutes = (
    app: express.Application,
): CommonRoutesConfig[] => {
    return [
        new UsersRoutes(app),
        new AuthRoutes(app),
        // new PublicRoutes(app),
    ]
}
