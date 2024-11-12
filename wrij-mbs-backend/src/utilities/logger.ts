import express from "express";
import winston from "winston";


const levels = {
    error: 0,
    warn: 1,
    info: 2,
    http: 3,
    debug: 4,
}

const level = () => {
    const env = process.env.ENV || 'dev'
    const isDevelopment = env === 'dev'
    return isDevelopment ? 'debug' : 'warn'
}

const colors = {
    error: 'red',
    warn: 'yellow',
    info: 'green',
    http: 'magenta',
    debug: 'white',
}

winston.addColors(colors);

const format = winston.format.combine(
    winston.format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss:ms' }),
    winston.format.colorize({ all: true }),
    winston.format.printf(
      (info) => `${info.timestamp} ${info.level}: ${info.message}`,
    ),
)

const transports = [
    new winston.transports.Console(),
    new winston.transports.File({
      filename: 'logs/error.log',
      level: 'error',
    }),
    new winston.transports.File({ filename: 'logs/all.log' }),
  ]

//const Logger = (req: express.Request, res: express.Response, next: Function): void => {
const Logger = 
    winston.createLogger({
        level: level(),
        levels,
        format,
        transports,
    });
// };

// const logger = (req: express.Request, res: express.Response, next: Function): void => {
//     let url = req.url;
//     console.log(`${url} was visited`);
//     console.log(`Request method: ${req.method}`);
//     console.log(`Request headers: ${JSON.stringify(req.headers)}`);
//     console.log(`Request query: ${JSON.stringify(req.query)}`);
//     console.log(`Request params: ${JSON.stringify(req.params)}`);
//     console.log(`Request body: ${JSON.stringify(req.body)}`);
//     next();
// }

export default Logger;