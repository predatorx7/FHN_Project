import express from 'express';
import usersService from '../services/users.service';
import argon2 from 'argon2';
import debug from 'debug';
import { PatchUserDto } from '../dto/patch.user.dto';
import { makeErrorMessage } from '../../../common/utils/error';

const log: debug.IDebugger = debug('app:users-controller');

class UsersController {
    async listUsers(req: express.Request, res: express.Response) {
        log('Fetching users');
        const users = await usersService.list(100, 0);
        log(`Fetched users: ${users.length}`);
        res.status(200).send(users || []);
    }

    async listRoles(req: express.Request, res: express.Response) {
        try {
            log('Fetching roles');
            const limit = res.locals.limit || 100;
            const page = res.locals.page || 0;
            const users = await usersService.listRoles(limit as number, page as number);
            log(`Fetched roles: ${users.length}`);
            res.status(200).send(users || []);
        } catch (e) {
            res.status(500).send(makeErrorMessage(e, ['Something went wrong']));
        }
    }

    async getUserById(req: express.Request, res: express.Response) {
        try {
            const user = await usersService.readById(Number.parseInt(req.params.userId));
            res.status(200).send(user);
        } catch (error) {
            log(`An error ocurred: ${error}`);
            res.status(500).send(makeErrorMessage(error, []));
        }
    }

    async createUser(req: express.Request, res: express.Response) {
        try {
            req.body.password = await argon2.hash(req.body.password || 'default_password');
            const userId = await usersService.create(req.body);
            res.status(201).send({ id: userId });
        } catch (error) {
            log(`An error ocurred: ${error}`);
            res.status(500).send(makeErrorMessage(error, []));
        }
    }

    async patch(req: express.Request, res: express.Response) {
        if (req.body.password) {
            req.body.password = await argon2.hash(req.body.password);
        }
        req.body.roleType = undefined;
        log(await usersService.patchById(Number.parseInt(req.params.userId), req.body));
        res.status(204).send();
    }

    async put(req: express.Request, res: express.Response) {
        req.body.password = await argon2.hash(req.body.password);
        req.body.roleType = undefined;
        log(await usersService.putById(Number.parseInt(req.params.userId), req.body));
        res.status(204).send();
    }

    async removeUser(req: express.Request, res: express.Response) {
        log(await usersService.deleteById(Number.parseInt(req.params.userId)));
        res.status(204).send();
    }

    async updatePermissionLevel(req: express.Request, res: express.Response) {
        if (req.params.roleType == 'sys_admin') {
            return res.status(400).send({ errors: ['Cannot upgrade someone to sys_admin'] });
        }
        const patchUserDto: PatchUserDto = {
            roleType: req.params.roleType,
        };
        log(await usersService.patchById(Number.parseInt(req.params.userId), patchUserDto));
        res.status(204).send();
    }
}

export default new UsersController();
