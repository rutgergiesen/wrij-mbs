import express, { Request, Response } from "express";
//import jwt from 'jsonwebtoken';
import dotenv from 'dotenv';

import Logger from "../utilities/logger";   
import { User, UserStore } from "../models/user";

dotenv.config();

const store = new UserStore();

// Initialiseer applicatie door eerste user aan te maken op basis van .env file
const init = async() =>{
    try {
        Logger.info('Init gestart');

        Logger.info('Check of initial user bestaat');


        const firstUserExists = await store.checkFirstUserExists();

        if(firstUserExists){
            Logger.info('Initial user bestaat al');
            return;
        }
        else{
            Logger.info('Initial user bestaat nog niet. Get INIT_APPUSER uit .env file');    

            const {
                INIT_APPUSER,
                INIT_APPUSER_PASSWORD
            } = process.env;
            
            const user : User = {
                username: process.env.INIT_APPUSER!, 
                password: process.env.INIT_APPUSER_PASSWORD!
            };

            Logger.info('Initial user aanmaken. ');
            const newUser = await store.create(user);
    
            //const result = await conn.query(sqlInsert, [user.username, hash]);
            Logger.info(`Initial user aangemaakt: ${newUser.username}`);
            //var token = jwt.sign({ user: newUser }, process.env.TOKEN_SECRET!);

            Logger.info('Init wrij-mbs afgerond');
            //console.log('Init wrij-mbs afgerond');
            return;
        }



    } catch (err) {
        Logger.error('Error initizalize app bij aanmaken eerste user: ', err);
    }
}

const init_route = (app: express.Application) => {
    app.get('/init/', init);
}

export default init_route;

