import Client from './database';
import dotenv from 'dotenv';
import bcrypt from 'bcrypt';
import Logger from "./utilities/logger";   
import { User, UserStore } from "./models/user";

dotenv.config();

const {
    INIT_APPUSER,
    INIT_APPUSER_PASSWORD
} = process.env;

async function init() {
    try {
        Logger.info('Init wrij-mbs gestart');

        const user : User = {
            username: process.env.INIT_APPUSER, 
            password: process.env.INIT_APPUSER_PASSWORD
        };

        const conn = await Client.connect();

        Logger.info('Check of initial user bestaat');
        const sqlCheck = 'SELECT * FROM tblUsers';
        const resultCheck = await conn.query(sqlCheck);

        if(resultCheck.rows.length){
            Logger.info('Initial user bestaat al');
            conn.release();
            return;
        }
        else{
            Logger.info('Initial user bestaat nog niet');

            const sqlInsert = 'INSERT INTO tblUsers (username, password) VALUES ($1, $2) RETURNING *';
            const hash = bcrypt.hashSync(
                user.password + pepper, 
                parseInt(saltRounds!)
            );
    
            Logger.info('Initial user aanmaken');
            const result = await conn.query(sqlInsert, [user.username, hash]);
            Logger.info('Initial user aangemaakt');
            //console.log(JSON.stringify(result.rows[0]));
            const newUser = result.rows[0];
            conn.release();

            Logger.info('Init wrij-mbs afgerond');
            return;
        }

        //var token = jwt.sign({ user: newUser }, process.env.TOKEN_SECRET!);

    } catch (err) {
        Logger.error('Error init-wrij-mbs', err);
    }
}


try{
    Logger.info('Create in Users handler file = try block');
    
    const user : User = {
        username: _req.body.username,
        password: _req.body.password,
    };

    Logger.info('Create in Users handler file = try block 2');
    const newUser = await store.create(user);
    var token = jwt.sign({ user: newUser }, process.env.TOKEN_SECRET!);
    res.json(token);
}
catch(err){
    Logger.error('Create in Users handler file = catch block', err);
    res.status(400)
    res.json(err)
}

init();

