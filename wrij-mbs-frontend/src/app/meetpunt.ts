export class Meetpunt {
    constructor(
        public id: number,
        public code: string,
        public naam: string,
        //bestaand: boolean;
        public x: string,
        public y: string,
        public toelichting?: string,
        public isSelected?: boolean
        /*meetpakket: string;
        prijstype: string;
        stukprijs: number; 
        meetjaren: number;
        maanden: number; //TODO maanden[]*/
    ){}

}