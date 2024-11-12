import dotenv from 'dotenv';
import { Pool } from 'pg';
import Logger from './utilities/logger';

dotenv.config();

// const {
//     POSTGRES_HOST,
//     POSTGRES_DB,
//     POSTGRES_USER,
//     POSTGRES_PASSWORD,
//     POSTGRES_TEST_DB,
//     POSTGRES_PORT,
//     ENV
// } = process.env;
const {
    DB_HOST,
    DB_USER,
    DB_PASSWORD,
    POSTGRESDB_USER,
    POSTGRESDB_ROOT_PASSWORD,
    DB_NAME,
    DB_PORT,
    TEST_DB_NAME,
    ENV
} = process.env;

const port = parseInt(DB_PORT as string);

let client: Pool | any;
console.log(ENV)

if (ENV === 'test'){
    client = new Pool ({
        host: DB_HOST,
        database: TEST_DB_NAME,
        user: DB_USER,
        password: DB_PASSWORD
    });
}
if (ENV === 'dev'){
    client = new Pool ({
        host: DB_HOST,
        database: DB_NAME,
        user: POSTGRESDB_USER,
        password: POSTGRESDB_ROOT_PASSWORD
    });
};

export default client;