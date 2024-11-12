import Client from '../database';
import Logger from '../utilities/logger';

export type Order = {
    id: number,
    meetplan: Number,
    meetpunt: Number,
    meetpakket: Number,
    alternatie: number,
    startjaar: number,
    eindjaar: number,
    jan: number,
    feb: number,
    mrt: number,
    apr: number,
    mei: number,
    jun: number,
    jul: number,
    aug: number,
    sep: number,
    okt: number,
    nov: number,
    dec: number, 
    toelichting: string,
    valuta: string,
    stukprijs: number,
    orderprijs: number,
    isNew?: boolean,
    hasChanged?: boolean
}

export class OrderStore {
    async index(meetpuntId?: Number, meetplanId?: Number): Promise<Order[]> {
        try{
            const conn = await Client.connect();
            let sql = 'SELECT * FROM tblOrders';
            let sql_where: string = '';
            
            if (meetplanId && meetpuntId)
                sql_where = ` WHERE meetplan = ${meetplanId} AND meetpunt = ${meetpuntId}`;
            else if (meetplanId)
                sql_where = ` WHERE meetplan = ${meetplanId}`;
            else if (meetpuntId)
                sql_where = ` WHERE meetpunt = ${meetpuntId}`;

            sql = sql.concat(sql_where) + ' ORDER BY id';
            const result = await conn.query(sql);
            //console.log(sql);
            conn.release();
            return result.rows;            
        }
        catch(err) {
            Logger.error('Error in order index', err);
            throw new Error(`Cannot get ORDER(S). Error: ${err}`)        
        }
    }

    async show(id: number): Promise<Order>{
        try{
            const conn = await Client.connect();
            const sql = 'SELECT * FROM tblOrders WHERE id=($1)';
            //console.log(sql);
            const result = await conn.query(sql, [id]);
            conn.release();
            return result.rows[0];   
        }
        catch(err){
            Logger.error('Error in order show', err);
            throw new Error(`Cannot get ORDER ${id}. Error: ${err}`) 
        }
    }

    async create(order: Order): Promise<Order> {
        //console.log('Order.create was called')
        try{
            const conn = await Client.connect();
            const sql = `INSERT INTO tblOrders (
                meetplan,
                meetpunt,
                meetpakket,
                alternatie,
                startjaar,
                eindjaar,
                jan,
                feb,
                mrt,
                apr,
                mei,
                jun,
                jul,
                aug,
                sep,
                okt,
                nov,
                dec, 
                toelichting,
                valuta,
                stukprijs,
                orderprijs
                ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22) RETURNING *`;
            console.log(sql);
            const result = await conn.query(sql, [order.meetplan, order.meetpunt, order.meetpakket, order.alternatie, order.startjaar, order.eindjaar, 
                order.jan, order.feb, order.mrt, order.apr, order.mei, order.jun, order.jul, order.aug, order.sep, order.okt, order.nov, order.dec, 
                order.toelichting, order.valuta, order.stukprijs, order.orderprijs]);
            //console.log(`Result: ${JSON.stringify(result.rows[0])}`);
            conn.release();
            return result.rows[0];   
        }
        catch(err){
            Logger.error('Error in order create', err);
            throw new Error(`Cannot add new ORDER voor MEETPLAN ${order.meetplan} en MEETPUNT ${order.meetpunt} en MEETPAKKET ${order.meetpakket}. Error: ${err}`) 
        }
    }

    async edit(order: Order): Promise<Order> {
        try{
            const conn = await Client.connect();
            const sql = `UPDATE tblOrders SET
                meetplan = $2,
                meetpunt = $3,
                meetpakket = $4,
                alternatie = $5,
                startjaar = $6,
                eindjaar = $7,
                jan = $8,
                feb = $9,
                mrt = $10,
                apr = $11,
                mei = $12,
                jun = $13,
                jul = $14,
                aug = $15,
                sep = $16,
                okt = $17,
                nov = $18,
                dec = $19, 
                toelichting = $20,
                valuta = $21,
                stukprijs = $22,
                orderprijs = $23
                WHERE ID=$1 RETURNING *`
            //UPDATE tblOrders (naam, behoefte, code, contactpersoon, opdrachtgever, startjaar, eindjaar, type, projectnr, versie, aqlcode, status) VALUES ($2, $3, $4, $5, $6, $7, $8, $9, $10. $11, $12) WHERE ID=$1 RETURNING *';
            //console.log(sql);
            //const result = await conn.query(sql, [order.id, order.naam, order.behoefte, order.code, order.contactpersoon, order.opdrachtgever, order.startjaar, order.eindjaar, order.type, order.projectnr, order.versie, order.aqlcode, order.status]);
            // const result = await conn.query(sql, [order.id, order.meetplan, order.meetpunt, order.meetpakket, 1, 2020, 2024, 
            //     order.jan, order.feb, order.mrt, order.apr, order.mei, order.jun, order.jul, order.aug, order.sep, order.okt, order.nov, order.dec, 
            //     order.toelichting, order.valuta, order.stukprijs, order.orderprijs]);
            const result = await conn.query(sql, [order.id, order.meetplan, order.meetpunt, order.meetpakket, order.alternatie, order.startjaar, order.eindjaar, 
                order.jan, order.feb, order.mrt, order.apr, order.mei, order.jun, order.jul, order.aug, order.sep, order.okt, order.nov, order.dec, 
                order.toelichting, order.valuta, order.stukprijs, order.orderprijs]);
            //console.log(`Result: ${JSON.stringify(result.rows[0])}`);
            conn.release();
            return result.rows[0];   
        }
        catch(err){
            Logger.error('Error in order edit', err);
            throw new Error(`Cannot change ORDER voor MEETPLAN ${order.meetplan} en MEETPUNT ${order.meetpunt} en MEETPAKKET ${order.meetpakket}. Error: ${err}`) 
        }
    }

    async delete(id: number): Promise<Order> {
        try{
            const sql = 'DELETE FROM tblOrders WHERE id=($1)';
            const conn = await Client.connect();
            const result = await conn.query(sql, [id]);
            //const Order= result;
            conn.release();
            return result;   
        }
        catch(err){
            Logger.error('Error in order delete', err);
            throw new Error(`Cannot delete ORDER ${id}. Error: ${err}`) 
        }
    }

}
