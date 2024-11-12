import Client from '../database';
import Logger from '../utilities/logger';

export type Meetpakket = {
    id: number;
    naam: string;
    omschrijving: string;
    valuta: string; // Euro/ILOW
    type: string;
    stukprijs: number; 
}

export class MeetpakketStore {
    async index(search?: String): Promise<Meetpakket[]> {
        try{
            //console.log('Meetpakketten index aangeroepen')
            const conn = await Client.connect();
            let sql = 'SELECT * FROM tblMeetpakketten ';
            let sql_where = '';

            if(search !== undefined)
                sql_where = `WHERE LOWER(naam) LIKE LOWER('%${search}%') OR LOWER(omschrijving) LIKE LOWER('%${search}%') `;
            
            sql = sql + sql_where + 'ORDER BY naam';
            const result = await conn.query(sql);
            //console.log(sql);
            conn.release();
            return result.rows;            
        }
        catch(err) {
            Logger.error('Error in meetpakket index', err);
            throw new Error(`Cannot get meetpakketten. Error: ${err}`)        
        }
    }

    async show(id: number): Promise<Meetpakket>{
        try{
            const conn = await Client.connect();
            const sql = 'SELECT * FROM tblMeetpakketten WHERE id=($1)';
            //console.log(sql);
            const result = await conn.query(sql, [id]);
            conn.release();
            return result.rows[0];   
        }
        catch(err){
            Logger.error('Error in meetpakket show', err);
            throw new Error(`Cannot get meetpakket ${id}. Error: ${err}`) 
        }
    }

    async create(meetpakket: Meetpakket): Promise<Meetpakket> {
        try{
            const conn = await Client.connect();
            const sql = `INSERT INTO tblMeetpakketten (
                naam,
                omschrijving,
                type,
                valuta, 
                stukprijs
                ) VALUES ($1, $2, $3, $4, $5) RETURNING *`;
            console.log(sql);
            const result = await conn.query(sql, [meetpakket.naam, meetpakket.omschrijving, meetpakket.type, meetpakket.valuta, meetpakket.stukprijs]);
            console.log(`Result: ${JSON.stringify(result.rows[0])}`);
            conn.release();
            return result.rows[0];   
        }
        catch(err){
            Logger.error('Error in meetpakket create', err);
            throw new Error(`Cannot add new meetpakket ${meetpakket.naam}. Error: ${err}`) 
        }
    }

    async edit(meetpakket: Meetpakket): Promise<Meetpakket> {
        try{
            const conn = await Client.connect();
            const sql = `UPDATE tblMeetpakketten SET 
                naam = $2,
                omschrijving = $3,
                type = $4,
                valuta = $5, 
                stukprijs = $6
                WHERE ID=$1 RETURNING *`
            //UPDATE tblMeetpakketten (naam, behoefte, code, contactpersoon, opdrachtgever, startjaar, eindjaar, type, projectnr, versie, aqlcode, status) VALUES ($2, $3, $4, $5, $6, $7, $8, $9, $10. $11, $12) WHERE ID=$1 RETURNING *';
            console.log(sql);
            //const result = await conn.query(sql, [meetpakket.id, meetpakket.naam, meetpakket.behoefte, meetpakket.code, meetpakket.contactpersoon, meetpakket.opdrachtgever, meetpakket.startjaar, meetpakket.eindjaar, meetpakket.type, meetpakket.projectnr, meetpakket.versie, meetpakket.aqlcode, meetpakket.status]);
            const result = await conn.query(sql, [meetpakket.id, meetpakket.naam, meetpakket.omschrijving, meetpakket.type, meetpakket.valuta, meetpakket.stukprijs]);
            console.log(`Result: ${JSON.stringify(result.rows[0])}`);
            conn.release();
            return result.rows[0];   
        }
        catch(err){
            Logger.error('Error in meetpakket edit', err);
            throw new Error(`Cannot change meetpakket ${meetpakket.id}. Error: ${err}`) 
        }
    }

    async delete(id: number): Promise<Meetpakket> {
        try{
            const sql = 'DELETE FROM tblMeetpakketten WHERE id=($1)';
            const conn = await Client.connect();
            const result = await conn.query(sql, [id]);
            //const meetpakket = result;
            conn.release();
            return result;   
        }
        catch(err){
            Logger.error('Error in meetpakket delete', err);
            throw new Error(`Cannot delete meetpakket ${id}. Error: ${err}`) 
        }
    }

}

