export class Meetplan {

    constructor(
        public id: number,
        public naam: string,
        public behoefte?: string,
        public code?: string,
        public contactpersoon?: string,
        public opdrachtgever?: string,
        public startjaar?: number,
        public eindjaar?: number,
        public type?: string, // project/routine
        public projectnr?: number,
        public versie?: number,
        public aqlcode?: string,
        public status?: string
    ){}
}
