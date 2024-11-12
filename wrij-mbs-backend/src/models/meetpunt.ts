import Client from '../database';
import Logger from '../utilities/logger';

export type Meetpunt = {
        id: number,
        code: string,
        naam: string,
        x: string,
        y: string,
        toelichting?: string
}

export class MeetpuntStore {
    // Geed meetpunten terug, als meetplanId is opgegeven dan alleen die meetpunten die in dat meetplan voorkomen
    // Als search is opgegeven dan alleen die meetpunten die voldoen aan de zoekterm
    // Als notInMeetplanId is opgegeven dan alleen die meetpunten die niet in het meetplan voorkomen met opgegeven Id
    async index(meetplanId?: number, search?: String, notInMeetplanId?: number): Promise<Meetpunt[]> {
        try{
            const conn = await Client.connect();
            let sql = '';

            // Als meetplanId is opgegeven  
            if(meetplanId !== undefined){
                sql = `SELECT DISTINCT M.id, M.code, M.naam, M.x, M.y, M.toelichting
                        FROM tblMeetpunten as M
                            INNER JOIN tblOrders as O ON M.id = O.meetpunt `
                
                            
                if(notInMeetplanId === undefined || notInMeetplanId <= 0 ){
                    sql = sql + `WHERE meetplan = ${meetplanId}`;
                }
                else{
                    // Alleen meetpunten selecteren die (via tblOrders) niet gekoppeld zijn aan het meetplan 
                    sql = sql + `WHERE meetplan NOT IN (
                        SELECT DISTINCT(meetpunt)
                        FROM tblOrders
                        WHERE meetplan = ${meetplanId}
                        )`;
                }
            }
            // else if(meetplanId !== undefined && notInMeetplanId === true){
            //     sql = `SELECT DISTINCT M.id, M.code, M.naam, M.x, M.y, M.toelichting
            //             FROM tblMeetpunten as M
            //                 INNER JOIN tblOrders as O ON M.id = O.meetpunt

                
            //     // `SELECT DISTINCT M.id, M.code, M.naam, M.x, M.y, M.toelichting
            //     //         FROM tblMeetpunten as M
            //     //             LEFT JOIN tblOrders as O ON M.id = O.meetpunt
            //     //         WHERE meetplan <> ${meetplanId} OR meetplan IS NULL`;
            // }
            else{
                sql = 'SELECT * FROM tblMeetpunten ';
                let sql_where = '';

                // Als notInMeetplanId is opgegeven, dan alleen die meetpunten selecteren die niet in het meetplan voorkomen
                if(notInMeetplanId !== undefined && notInMeetplanId > 0){
                    // vervang de sql door een nieuwe query, om meetpunten met orders te koppelen
                   
                    // Alleen meetpunten selecteren die (via tblOrders) niet gekoppeld zijn aan het meetplan 
                    sql_where =  `WHERE id NOT IN(
		                SELECT DISTINCT M.id
                        FROM tblMeetpunten as M
        	                INNER JOIN tblOrders as O ON M.id = O.meetpunt
                            WHERE meetplan = ${notInMeetplanId}) `;
                }

                if(search !== undefined){
                    if (sql_where === '')
                        sql_where = 'WHERE ';
                    else
                        sql_where = sql_where + 'AND ';

                    sql_where = sql_where + `(LOWER(naam) LIKE LOWER('%${search}%') OR LOWER(code) LIKE LOWER('%${search}%') OR LOWER(toelichting) LIKE LOWER('%${search}%'))`;
                }
                sql = sql + sql_where;
            }

            //console.log(sql);
            const result = await conn.query(sql);
            conn.release();
            return result.rows;            
        }
        catch(err) {
            Logger.error('Error in meetpunt index', err);
            throw new Error(`Cannot get MEETPUNT(EN). Error: ${err}`)        
        }
    }

    async show(id: number): Promise<Meetpunt>{
        try{
            const conn = await Client.connect();
            const sql = 'SELECT * FROM tblMeetpunten WHERE id=($1)';
            //console.log(sql);
            const result = await conn.query(sql, [id]);
            conn.release();
            return result.rows[0];   
        }
        catch(err){
            Logger.error('Error in meetpunt show', err);
            throw new Error(`Cannot get MEETPUNT ${id}. Error: ${err}`) 
        }
    }

    async create(meetpunt: Meetpunt): Promise<Meetpunt> {
        try{
            const conn = await Client.connect();
            const sql = `INSERT INTO tblMeetpunten (
                code,
                naam,
                x,
                y,
                toelichting 
                ) VALUES ($1, $2, $3, $4, $5) RETURNING *`;
            //console.log(sql);
            const result = await conn.query(sql, [meetpunt.code, meetpunt.naam, meetpunt.x, meetpunt.y, meetpunt.toelichting]);
            //console.log(`Result: ${JSON.stringify(result.rows[0])}`);
            conn.release();
            return result.rows[0];   
        }
        catch(err){
            Logger.error('Error in meetpunt create', err);
            throw new Error(`Cannot add new MEETPUNT ${meetpunt.naam}. Error: ${err}`) 
        }
    }

    async edit(meetpunt: Meetpunt): Promise<Meetpunt> {
        try{
            const conn = await Client.connect();
            const sql = `UPDATE tblMeetpunten SET
                code = $2,
                naam = $3,
                x = $4,
                y = $5,
                toelichting = $6 
                WHERE ID=$1 RETURNING *`
            //UPDATE tblMeetpunten (naam, behoefte, code, contactpersoon, opdrachtgever, startjaar, eindjaar, type, projectnr, versie, aqlcode, status) VALUES ($2, $3, $4, $5, $6, $7, $8, $9, $10. $11, $12) WHERE ID=$1 RETURNING *';
            console.log(sql);
            //const result = await conn.query(sql, [meetpunt.id, meetpunt.naam, meetpunt.behoefte, meetpunt.code, meetpunt.contactpersoon, meetpunt.opdrachtgever, meetpunt.startjaar, meetpunt.eindjaar, meetpunt.type, meetpunt.projectnr, meetpunt.versie, meetpunt.aqlcode, meetpunt.status]);
            const result = await conn.query(sql, [meetpunt.id, meetpunt.code, meetpunt.naam, meetpunt.x, meetpunt.y, meetpunt.toelichting]);
            console.log(`Result: ${JSON.stringify(result.rows[0])}`);
            conn.release();
            return result.rows[0];   
        }
        catch(err){
            Logger.error('Error in meetpunt edit', err);
            throw new Error(`Cannot change MEETPUNT ${meetpunt.id}. Error: ${err}`) 
        }
    }

    async delete(id: number): Promise<Meetpunt> {
        try{
            const sql = 'DELETE FROM tblMeetpunten WHERE id=($1)';
            const conn = await Client.connect();
            const result = await conn.query(sql, [id]);
            //const Meetpunt= result;
            conn.release();
            return result;   
        }
        catch(err){
            Logger.error('Error in meetpunt delete', err);
            throw new Error(`Cannot delete MEETPUNT ${id}. Error: ${err}`) 
        }
    }

}
