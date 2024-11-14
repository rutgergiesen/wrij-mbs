import express, { Request, Response } from "express";
import jwt from 'jsonwebtoken';
import dotenv from 'dotenv';

import Logger from "../utilities/logger";   
import { User, UserStore } from "../models/user";

dotenv.config();

const {
    TOKEN_SECRET
} = process.env;

const store = new UserStore();

const create = async (_req: Request, res: Response) => {
    Logger.info('Create in Users handler file was called');

    try{
        //Logger.info('Create in Users handler file = try block');
        
        const user : User = {
            username: _req.body.username,
            password: _req.body.password,
        };

        //Logger.info('Create in Users handler file = try block 2');
        const newUser = await store.create(user);
        Logger.info('User aangemaakt: ' + JSON.stringify(newUser));
        var token = jwt.sign({ user: newUser }, process.env.TOKEN_SECRET!);
        res.json(token);
    }
    catch(err){
        Logger.error('Create in Users handler file = catch block', err);
        res.status(400)
        res.json(err)
    }
}

const login = async (req: Request, res: Response) => {
    const user: User = {
        username: req.body.username,
        password: req.body.password,
    };
    try {
        const u = await store.login(user.username, user.password)
        if (!u) {
            throw new Error('User not found');
        }
        else{
            var newToken = jwt.sign({ user: u }, process.env.TOKEN_SECRET!, {expiresIn: '14h'});
            res.json({
                token: newToken,
                expiresIn: 50400
            });
        }
    } catch(error) {
        res.status(401)
        res.json('Gebruiker bestaat niet, of verkeer wachtwoord');
    }
    // try{
    //     console.log('Authenticate in Users handler file was called');
    //     //console.log(JSON.stringify(req.body));

    //     const user : User = req.body;
    //     const newUser = await store.authenticate(user.username, user.password);
    //     res.json(newUser);
    // }
    // catch(err){
    //     res.status(400)
    //     res.json(err)
    // }
}

const users_routes = (app: express.Application) => {
    app.post('/user/', create);
    app.post('/login/', login);
}

export default users_routes;