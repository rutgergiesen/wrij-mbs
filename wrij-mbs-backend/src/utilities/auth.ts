import jwt from 'jsonwebtoken';
import { Request, Response } from "express";
import dotenv from 'dotenv';

dotenv.config();

const {
    TOKEN_SECRET
} = process.env;


const verifyAuthToken = (req: Request, res: Response, next: Function) => {
    try {
        const authorizationHeader = req.headers.authorization;
        const token = authorizationHeader!.split(' ')[1];
        const decoded = jwt.verify(token, process.env.TOKEN_SECRET!);

        next();
    } catch (error) {
        res.status(401).json('Access denied, invalid token');
    }
}

export default verifyAuthToken;