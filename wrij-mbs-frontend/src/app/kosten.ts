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
// export class Kosten {
//     constructor(
//         public meetplan: number,
//         public valuta: string,
//         public totaal: number,
//         public jan: number,
//         public feb: number,
//         public mrt: number,
//         public apr: number,
//         public mei: number,
//         public jun: number,
//         public jul: number,
//         public aug: number,
//         public sep: number,
//         public okt: number,
//         public nov: number,
//         public dec: number, 
//         public jaar?: number
//     ){}
// }