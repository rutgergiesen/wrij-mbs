import Client from '../database';
import dotenv from 'dotenv';
import bcrypt from 'bcrypt';
import Logger from '../utilities/logger';

dotenv.config();

const {
    BCRYPT_PASSWORD,
    SALT_ROUNDS
} = process.env;

export type User = {
    username: string,
    password: string
}
const pepper: string | undefined = process.env.BCRYPT_PASSWORD;
const saltRounds: string | undefined = process.env.SALT_ROUNDS;

export class UserStore {


    async create (u: User): Promise<User> {
        try{
            //console.log('models.create' + JSON.stringify(u));
            Logger.info('User aanmaken. ');

            const conn = await Client.connect();
            let sql = 'INSERT INTO tblUsers (username, password) VALUES ($1, $2) RETURNING *';
            const hash = bcrypt.hashSync(
                u.password + pepper, 
                parseInt(saltRounds!)
            );
            //console.log(hash);
            const result = await conn.query(sql, [u.username, hash]);
            //console.log(JSON.stringify(result.rows[0]));
            const user = result.rows[0];
    
            conn.release();
            return user;
        }
        catch(err){
            Logger.error('Error in user create. Error: ', err);
            throw new Error(`Cannot add new user ${u.username}. Error: ${err}`) 
        }
    }

    async login (username: string, password: string): Promise<User | null> {
        try{
            const conn = await Client.connect();
            const sql = 'SELECT * FROM tblUsers WHERE username=($1)';
    
            const result = await conn.query(sql, [username]);
    
            //console.log(password+pepper);
    
            if(result.rows.length){
    
                const user = result.rows[0];
    
                if(bcrypt.compareSync(password + pepper, user.password)){
                    return user;
                }
            }
    
            return null;
        }
        catch(err){
            Logger.error('Error in user login: ', err);
        };
        return null;
    }

    // check of er een gebruiker bestaat. Retourneer true als er een gebruiker bestaat, anders false.
    async checkFirstUserExists () : Promise<boolean | null> {
        try{
            const conn = await Client.connect();
            const sqlCheck = 'SELECT * FROM tblUsers';
            const result = await conn.query(sqlCheck);
            const user = result.rows[0];
            conn.release();
            if (user){
                return true;
            }
            else{
                return false;
            }
        }
        catch(err){
            Logger.error('Error in user show: ', err);
            throw new Error(`Fout bij het checken of er een gebruiker bestaat. Error: ${err}`)
        }


    }

}
