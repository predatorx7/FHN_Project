import debug from 'debug';
import express from 'express';
import { makeErrorMessage } from '../utils/error';

const log: debug.IDebugger = debug('app:safe-controller-request');

export const safelyRequest = (controller: (req: express.Request, res: express.Response) => Promise<any>) => {
    return async (req: express.Request, res: express.Response) => {
        try {
            return await controller(req, res);
        } catch (error) {
            log('Something went wrong with a controller');
            log(error);
            res.status(500).send(makeErrorMessage(error, [ 'Something went wrong' ]));
        } 
    }
}
