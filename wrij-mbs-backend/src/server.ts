import express, { Request, Response } from 'express';
var cors = require('cors');
import bodyParser from 'body-parser';
import dotenv from 'dotenv';

import Logger from './utilities/logger';
import meetplannen_routes from './handlers/meetplannen';
import meetpunten_routes from './handlers/meetpunten';
import orders_routes from './handlers/orders';
import meetpakketten_routes from './handlers/meetpakketten';
import kosten_routes from './handlers/kosten';
import users_routes from './handlers/users';
import init_route from './handlers/init';
import morganMiddleware from './utilities/morganMiddleware';

dotenv.config();

const {
    EXPRESS_URL,
    EXPRESS_PORT
} = process.env;

//app.use(logErrors)

// Custom error handling middleware
const errorHandler = (err: Error, req: Request, res: Response, next: Function) => {
    console.error(err.stack);
    res.status(500).send('Something went wrong!');
};

const app: express.Application = express();
app.use(cors());
app.use(morganMiddleware);
app.use(bodyParser.json());
//app.get('/', Logger, async function (req: Request, res: Response) {
app.get('/', async function (req: Request, res: Response) {
    res.send('WRIJ-MBS-Backend index route');
});

app.get("/logger", (_, res) => {
    Logger.error("This is an error log");
    Logger.warn("This is a warn log");
    Logger.info("This is a info log");
    Logger.http("This is a http log");
    Logger.debug("This is a debug log");
  
    res.send("Hello world");
  });

orders_routes(app);
meetplannen_routes(app);
meetpunten_routes(app);
meetpakketten_routes(app);
kosten_routes(app);
users_routes(app);
init_route(app);

app.use(errorHandler);

app.listen(EXPRESS_PORT, function () {
    console.log(`starting app on: ${EXPRESS_URL}:${EXPRESS_PORT}`)
});

// app.use(function(err: any, req: any, res: any, next: Function) {
//     console.log('Error: '+ err);
//     res.status(500).send('Something wrong!');
// });
//const myFunc = (num: number): number => { return num * num; };

export default app;
