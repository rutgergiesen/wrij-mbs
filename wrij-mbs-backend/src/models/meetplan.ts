import Client from '../database';
import Logger from '../utilities/logger';

export type Meetplan = {
    id: number,
    naam: string,
    behoefte?: string,
    code?: string,
    contactpersoon?: string,
    opdrachtgever?: string,
    startjaar?: number,
    eindjaar?: number,
    type?: string, // project/routine
    projectnr?: number,
    versie?: number,
    aqlcode?: string,
    status?: string
}

export class MeetplanStore {
    async index(search?: String, status?: String, startjaar?: Number, eindjaar?: Number): Promise<Meetplan[]> {
        try{
            Logger.info('Meetplan index was called');
            Logger.info(`Client: ${JSON.stringify(Client)}`);

            const conn = await Client.connect();
            let sql = 'SELECT * FROM tblMeetplannen';
            let sql_where = '';

            if(search !== undefined){
                 sql_where = `LOWER(naam) LIKE LOWER('%${search}%') OR LOWER(code) LIKE LOWER('%${search}%') OR LOWER(opdrachtgever) LIKE LOWER('%${search}%') `;
            }
            if(status !== undefined){
                if(sql_where !== '')
                    sql_where = sql_where + ' AND '
                sql_where =  sql_where + `LOWER(status) = LOWER('${status}')`;
            }

            if(startjaar !== undefined && eindjaar !== undefined){
                if(sql_where !== '')
                    sql_where = sql_where + ' AND '
                sql_where = sql_where + `(${startjaar} BETWEEN startjaar AND eindjaar OR ${eindjaar} BETWEEN startjaar AND eindjaar)`
            }
            else if(startjaar !== undefined){
                if(sql_where !== '')
                    sql_where = sql_where + ' AND '
                sql_where = sql_where + `${startjaar} BETWEEN startjaar AND eindjaar`
            }

            if(sql_where !== '')
                sql_where = ' WHERE ' + sql_where;
            sql = sql + sql_where + ` ORDER BY naam ASC`


            const result = await conn.query(sql);
            //console.log(sql);
            conn.release();
            return result.rows;            
        }
        catch(err) {
            Logger.error('Error in meetplan index', err);
            throw new Error(`Cannot get meetplannen. Error: ${err}`)        
        }
    }

    async show(id: number): Promise<Meetplan>{
        try{
            const conn = await Client.connect();
            const sql = 'SELECT * FROM tblMeetplannen WHERE id=($1)';
            //console.log(sql);
            const result = await conn.query(sql, [id]);
            conn.release();
            return result.rows[0];   
        }
        catch(err){
            Logger.error('Error in meetplan show', err);
            throw new Error(`Cannot get meetplan ${id}. Error: ${err}`) 
        }
    }

    async create(meetplan: Meetplan): Promise<Meetplan> {
        try{
            const conn = await Client.connect();
            const sql = `INSERT INTO tblMeetplannen (
                naam, 
                behoefte, 
                code, 
                contactpersoon, 
                opdrachtgever, 
                startjaar, 
                eindjaar, 
                type, 
                projectnr, 
                versie, 
                aqlcode, 
                status) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12) RETURNING *`;
            console.log(sql);
            const result = await conn.query(sql, [meetplan.naam, meetplan.behoefte, meetplan.code, meetplan.contactpersoon, meetplan.opdrachtgever, meetplan.startjaar, meetplan.eindjaar, meetplan.type, meetplan.projectnr, meetplan.versie, meetplan.aqlcode, meetplan.status]);// , 1234, 1, meetplan.aqlcode, meetplan.status]);
            //console.log(`Result: ${JSON.stringify(result.rows[0])}`); 
            conn.release();
            return result.rows[0];   
        }
        catch(err){
            Logger.error('Error in meetplan create', err);
            throw new Error(`Cannot add new meetplan ${meetplan.naam}. Error: ${err}`) 
        }
    }

    async edit(meetplan: Meetplan): Promise<Meetplan> {
        try{
            const conn = await Client.connect();
            const sql = `UPDATE tblMeetplannen SET 
                naam = $2, 
                behoefte = $3, 
                code = $4, 
                contactpersoon = $5, 
                opdrachtgever= $6, 
                startjaar = $7, 
                eindjaar = $8, 
                projectnr = $9,
                type = $10, 
                versie = $11, 
                aqlcode = $12, 
                status = $13
                WHERE ID=$1 RETURNING *`
            //UPDATE tblMeetplannen (naam, behoefte, code, contactpersoon, opdrachtgever, startjaar, eindjaar, type, projectnr, versie, aqlcode, status) VALUES ($2, $3, $4, $5, $6, $7, $8, $9, $10. $11, $12) WHERE ID=$1 RETURNING *';
            console.log(sql);
            //const result = await conn.query(sql, [meetplan.id, meetplan.naam, meetplan.behoefte, meetplan.code, meetplan.contactpersoon, meetplan.opdrachtgever, meetplan.startjaar, meetplan.eindjaar, meetplan.type, meetplan.projectnr, meetplan.versie, meetplan.aqlcode, meetplan.status]);
            const result = await conn.query(sql, [meetplan.id, meetplan.naam, meetplan.behoefte, meetplan.code, meetplan.contactpersoon, meetplan.opdrachtgever, meetplan.startjaar, meetplan.eindjaar, meetplan.projectnr, meetplan.type, meetplan.versie, meetplan.aqlcode, meetplan.status]);
            console.log(`Result: ${JSON.stringify(result.rows[0])}`);
            conn.release();
            return result.rows[0];   
        }
        catch(err){
            Logger.error('Error in meetplan edit', err);
            throw new Error(`Cannot change meetplan ${meetplan.id}. Error: ${err}`) 
        }
    }

    async delete(id: number): Promise<Meetplan>
     {
        try{
            const sql = 'DELETE FROM tblMeetplannen WHERE id=($1)';
            const conn = await Client.connect();
            const result = await conn.query(sql, [id]);
            //const meetplan = result;
            conn.release();
            return result;   
        }
        catch(err){
            // TODO: add loggin mechanism
            Logger.error('Error in meetplan delete', err);

            // Return a default Meetplan object to maintain type consistency
            return {
                id: -1,
                naam: 'Unknown'
            } as Meetplan;
        }
    }

}

