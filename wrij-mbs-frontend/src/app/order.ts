export class Order {
    constructor(
        public id: number,
        public meetplan: Number,
        public meetpunt: Number,
        public meetpakket: Number,
        public alternatie: number,
        public startjaar: number,
        public eindjaar: number,
        public jan: number,
        public feb: number,
        public mrt: number,
        public apr: number,
        public mei: number,
        public jun: number,
        public jul: number,
        public aug: number,
        public sep: number,
        public okt: number,
        public nov: number,
        public dec: number, 
        public toelichting: string,
        public valuta: string,
        public stukprijs: number,
        public orderprijs: number,
        public isNew?: boolean,
        public hasChanged?: boolean
    ){}
}