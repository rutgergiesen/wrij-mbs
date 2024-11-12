import Client from '../database';
import Logger from '../utilities/logger';

export type KostenRecord = {
    id: number; // SERIAL PRIMARY KEY
    order: number; // INT NOT NULL
    meetplan: number; // integer references tblMeetplannen(id)
    meetpunt: number; // integer references tblMeetpunten(id)
    meetpakket: number; // integer references tblMeetpakketten(id)
    prioriteit: number; // integer references tblPrioriteiten(id)
    jaar: number; // numeric(4)
    valuta: string; // VARCHAR(10)
    stukprijs: number; // smallint
    kostenregel: number; // integer references tblKostenregels
  
    // Per maand: aantal metingen (bruto-ontdubbeling=netto)
    aantal_jan_bruto: number; // smallint
    aantal_jan_ontdubbeling: number; // smallint
    aantal_jan_netto: number; // smallint
    jan_bruto: number; // NUMERIC(4)
    jan_ontdubbeling: number; // NUMERIC(4)
    jan_netto: number; // NUMERIC(4)
  
    aantal_feb_bruto: number; // smallint
    aantal_feb_ontdubbeling: number; // smallint
    aantal_feb_netto: number; // smallint
    feb_bruto: number; // NUMERIC(4)
    feb_ontdubbeling: number; // NUMERIC(4)
    feb_netto: number; // NUMERIC(4)
  
    aantal_mrt_bruto: number; // smallint
    aantal_mrt_ontdubbeling: number; // smallint
    aantal_mrt_netto: number; // smallint
    mrt_bruto: number; // NUMERIC(4)
    mrt_ontdubbeling: number; // NUMERIC(4)
    mrt_netto: number; // NUMERIC(4)
  
    aantal_apr_bruto: number; // smallint
    aantal_apr_ontdubbeling: number; // smallint
    aantal_apr_netto: number; // smallint
    apr_bruto: number; // NUMERIC(4)
    apr_ontdubbeling: number; // NUMERIC(4)
    apr_netto: number; // NUMERIC(4)
  
    aantal_mei_bruto: number; // smallint
    aantal_mei_ontdubbeling: number; // smallint
    aantal_mei_netto: number; // smallint
    mei_bruto: number; // NUMERIC(4)
    mei_ontdubbeling: number; // NUMERIC(4)
    mei_netto: number; // NUMERIC(4)
  
    aantal_jun_bruto: number; // smallint
    aantal_jun_ontdubbeling: number; // smallint
    aantal_jun_netto: number; // smallint
    jun_bruto: number; // NUMERIC(4)
    jun_ontdubbeling: number; // NUMERIC(4)
    jun_netto: number; // NUMERIC(4)
  
    aantal_jul_bruto: number; // smallint
    aantal_jul_ontdubbeling: number; // smallint
    aantal_jul_netto: number; // smallint
    jul_bruto: number; // NUMERIC(4)
    jul_ontdubbeling: number; // NUMERIC(4)
    jul_netto: number; // NUMERIC(4)
  
    aantal_aug_bruto: number; // smallint
    aantal_aug_ontdubbeling: number; // smallint
    aantal_aug_netto: number; // smallint
    aug_bruto: number; // NUMERIC(4)
    aug_ontdubbeling: number; // NUMERIC(4)
    aug_netto: number; // NUMERIC(4)
  
    aantal_sep_bruto: number; // smallint
    aantal_sep_ontdubbeling: number; // smallint
    aantal_sep_netto: number; // smallint
    sep_bruto: number; // NUMERIC(4)
    sep_ontdubbeling: number; // NUMERIC(4)
    sep_netto: number; // NUMERIC(4)
  
    aantal_okt_bruto: number; // smallint
    aantal_okt_ontdubbeling: number; // smallint
    aantal_okt_netto: number; // smallint
    okt_bruto: number; // NUMERIC(4)
    okt_ontdubbeling: number; // NUMERIC(4)
    okt_netto: number; // NUMERIC(4)
  
    aantal_nov_bruto: number; // smallint
    aantal_nov_ontdubbeling: number; // smallint
    aantal_nov_netto: number; // smallint
    nov_bruto: number; // NUMERIC(4)
    nov_ontdubbeling: number; // NUMERIC(4)
    nov_netto: number; // NUMERIC(4)
  
    aantal_dec_bruto: number; // smallint
    aantal_dec_ontdubbeling: number; // smallint
    aantal_dec_netto: number; // smallint
    dec_bruto: number; // NUMERIC(4)
    dec_ontdubbeling: number; // NUMERIC(4)
    dec_netto: number; // NUMERIC(4)
  
    aantal_jaar_bruto: number; // smallint
    aantal_jaar_ontdubbeling: number; // smallint
    aantal_jaar_netto: number; // smallint
    jaar_bruto: number; // NUMERIC(4)
    jaar_ontdubbeling: number; // NUMERIC(4)
    jaar_netto: number; // NUMERIC(4)
  
    redenen_ontdubbeling: string; // TEXT
};

export class KostenStore {
    async index(meetplanId?: number, startjaar?: number, eindjaar? : number, status?: string): Promise<KostenRecord[]> {
        try{
            const conn = await Client.connect();

            // let sql = `SELECT jaar, 
            //                 valuta, 
            //                 SUM(orderprijs) AS Totaal, 
            //                 SUM(jan) AS jan, 
            //                 SUM(feb) AS feb, 
            //                 SUM(mrt) AS mrt, 
            //                 SUM(apr) AS apr, 
            //                 SUM(mei) AS mei, 
            //                 SUM(jun) AS jun, 
            //                 SUM(jul) AS jul, 
            //                 SUM(aug) AS aug, 
            //                 SUM(sep) AS sep, 
            //                 SUM(okt) AS okt, 
            //                 SUM(nov) AS nov, 
            //                 SUM(dec) AS dec
            //             FROM tblKosten AS K
            //                 INNER JOIN tblMeetplannen AS M ON K.meetplan = M.id `;
            let sql = `SELECT 
                jaar,
                valuta,
                SUM(aantal_jan_bruto) AS aantal_jan_bruto,
                SUM(aantal_jan_ontdubbeling) AS aantal_jan_ontdubbeling,
                SUM(aantal_jan_netto) AS aantal_jan_netto,
                SUM(jan_bruto) AS jan_bruto,
                SUM(jan_ontdubbeling) AS jan_ontdubbeling,
                SUM(jan_netto) AS jan_netto,
                
                SUM(aantal_feb_bruto) AS aantal_feb_bruto,
                SUM(aantal_feb_ontdubbeling) AS aantal_feb_ontdubbeling,
                SUM(aantal_feb_netto) AS aantal_feb_netto,
                SUM(feb_bruto) AS feb_bruto,
                SUM(feb_ontdubbeling) AS feb_ontdubbeling,
                SUM(feb_netto) AS feb_netto,
                
                SUM(aantal_mrt_bruto) AS aantal_mrt_bruto,
                SUM(aantal_mrt_ontdubbeling) AS aantal_mrt_ontdubbeling,
                SUM(aantal_mrt_netto) AS aantal_mrt_netto,
                SUM(mrt_bruto) AS mrt_bruto,
                SUM(mrt_ontdubbeling) AS mrt_ontdubbeling,
                SUM(mrt_netto) AS mrt_netto,
                
                SUM(aantal_apr_bruto) AS aantal_apr_bruto,
                SUM(aantal_apr_ontdubbeling) AS aantal_apr_ontdubbeling,
                SUM(aantal_apr_netto) AS aantal_apr_netto,
                SUM(apr_bruto) AS apr_bruto,
                SUM(apr_ontdubbeling) AS apr_ontdubbeling,
                SUM(apr_netto) AS apr_netto,
                
                SUM(aantal_mei_bruto) AS aantal_mei_bruto,
                SUM(aantal_mei_ontdubbeling) AS aantal_mei_ontdubbeling,
                SUM(aantal_mei_netto) AS aantal_mei_netto,
                SUM(mei_bruto) AS mei_bruto,
                SUM(mei_ontdubbeling) AS mei_ontdubbeling,
                SUM(mei_netto) AS mei_netto,
                
                SUM(aantal_jun_bruto) AS aantal_jun_bruto,
                SUM(aantal_jun_ontdubbeling) AS aantal_jun_ontdubbeling,
                SUM(aantal_jun_netto) AS aantal_jun_netto,
                SUM(jun_bruto) AS jun_bruto,
                SUM(jun_ontdubbeling) AS jun_ontdubbeling,
                SUM(jun_netto) AS jun_netto,
                
                SUM(aantal_jul_bruto) AS aantal_jul_bruto,
                SUM(aantal_jul_ontdubbeling) AS aantal_jul_ontdubbeling,
                SUM(aantal_jul_netto) AS aantal_jul_netto,
                SUM(jul_bruto) AS jul_bruto,
                SUM(jul_ontdubbeling) AS jul_ontdubbeling,
                SUM(jul_netto) AS jul_netto,
                
                SUM(aantal_aug_bruto) AS aantal_aug_bruto,
                SUM(aantal_aug_ontdubbeling) AS aantal_aug_ontdubbeling,
                SUM(aantal_aug_netto) AS aantal_aug_netto,
                SUM(aug_bruto) AS aug_bruto,
                SUM(aug_ontdubbeling) AS aug_ontdubbeling,
                SUM(aug_netto) AS aug_netto,
                
                SUM(aantal_sep_bruto) AS aantal_sep_bruto,
                SUM(aantal_sep_ontdubbeling) AS aantal_sep_ontdubbeling,
                SUM(aantal_sep_netto) AS aantal_sep_netto,
                SUM(sep_bruto) AS sep_bruto,
                SUM(sep_ontdubbeling) AS sep_ontdubbeling,
                SUM(sep_netto) AS sep_netto,
                
                SUM(aantal_okt_bruto) AS aantal_okt_bruto,
                SUM(aantal_okt_ontdubbeling) AS aantal_okt_ontdubbeling,
                SUM(aantal_okt_netto) AS aantal_okt_netto,
                SUM(okt_bruto) AS okt_bruto,
                SUM(okt_ontdubbeling) AS okt_ontdubbeling,
                SUM(okt_netto) AS okt_netto,
                
                SUM(aantal_nov_bruto) AS aantal_nov_bruto,
                SUM(aantal_nov_ontdubbeling) AS aantal_nov_ontdubbeling,
                SUM(aantal_nov_netto) AS aantal_nov_netto,
                SUM(nov_bruto) AS nov_bruto,
                SUM(nov_ontdubbeling) AS nov_ontdubbeling,
                SUM(nov_netto) AS nov_netto,
                
                SUM(aantal_dec_bruto) AS aantal_dec_bruto,
                SUM(aantal_dec_ontdubbeling) AS aantal_dec_ontdubbeling,
                SUM(aantal_dec_netto) AS aantal_dec_netto,
                SUM(dec_bruto) AS dec_bruto,
                SUM(dec_ontdubbeling) AS dec_ontdubbeling,
                SUM(dec_netto) AS dec_netto,
                
                SUM(aantal_jaar_bruto) AS aantal_jaar_bruto,
                SUM(aantal_jaar_ontdubbeling) AS aantal_jaar_ontdubbeling,
                SUM(aantal_jaar_netto) AS aantal_jaar_netto,
                SUM(jaar_bruto) AS jaar_bruto,
                SUM(jaar_ontdubbeling) AS jaar_ontdubbeling,
                SUM(jaar_netto) AS jaar_netto
            FROM 
                tblKosten AS K INNER JOIN tblMeetplannen AS M ON K.meetplan = M.id `;
            
            let where_counter = 0;
            let sql_where = ''
            if(meetplanId !== undefined){
                sql_where = `meetplan = ${meetplanId} `;
                where_counter++;   
            }
            if(startjaar !== undefined && startjaar > 0){
                if(where_counter > 0)
                    sql_where = sql_where + 'AND '
                //sql_where = sql_where + `${jaar} BETWEEN startjaar AND eindjaar `;
                sql_where = sql_where + `jaar >= ${startjaar} `;
                where_counter++; 
            }
            if(eindjaar !== undefined && eindjaar > 0){
                if(where_counter > 0)
                    sql_where = sql_where + 'AND '
                sql_where = sql_where + `jaar <= ${eindjaar} `;
                where_counter++;
            }
            if(status !== undefined){
                if(where_counter > 0)
                    sql_where = sql_where + 'AND '
                sql_where = sql_where + `LOWER(status) = LOWER('${status}') `;
                where_counter++; 
            }
            // Als alternatie jaarlijks is meegegeven, kosten voor orders uitgezonderd 'tweejaarlijks' bepalen
            // if(alternatie !== undefined && alternatie.alternatie === 'jaarlijks'){
            //     if(where_counter > 0)
            //         sql_where = sql_where + 'AND '
            //     sql_where = sql_where + `NOT alternatie = 'tweejaarlijks' `;
            //     where_counter++; 

            // }

            if (where_counter > 0)
                sql = sql + 'WHERE ' + sql_where;
            
            sql = sql + `GROUP BY jaar, valuta
             ORDER BY jaar ASC, valuta DESC`;    
            // let sql_where: string = '';
            
            // if (meetplanId && meetpuntId)
            //     sql_where = ` WHERE meetplan = ${meetplanId} AND meetpunt = ${meetpuntId}`;
            // else if (meetplanId)
            //     sql_where = ` WHERE meetplan = ${meetplanId}`;
            // else if (meetpuntId)
            //     sql_where = ` WHERE meetpunt = ${meetpuntId}`;

            // sql = sql.concat(sql_where);
            //console.log(sql);
            const result = await conn.query(sql);

            conn.release();
            return result.rows;            
        }
        catch(err) {
            Logger.error('Error in kosten index: ', err);
            throw new Error(`Cannot get KOSTEN. Error: ${err}`)        
        }
    }
}