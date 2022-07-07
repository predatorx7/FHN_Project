import express from 'express';
import swaggerUi from 'swagger-ui-express';
import swaggerJsdoc from 'swagger-jsdoc';
import swaggerDocument from './swagger.json';

export const setupSwagger = (app: express.Application) => {
    const options = {
        explorer: true
    };
    app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument, options));
}
