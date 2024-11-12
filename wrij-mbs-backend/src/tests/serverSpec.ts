// import supertest from 'supertest';
// import app from '../server';
// import { Order } from '../models/order';

// const request = supertest(app);
// describe('Test endpoint responses', () => {
//     it('gets the orders endpoint', async () => {
//         const response = await request.get('/orders');
//         expect(response.status).toBe(200);
//         //done();
//     }),
//     it('creates an order', async () =>{
//         const tempOrder : Order = {"id":0,"meetplan":1,"meetpunt":1,"meetpakket":4,"alternatie":"tweejaarlijks","jan":1,"feb":0,"mrt":0,"apr":0,"mei":0,"jun":0,"jul":0,"aug":0,"sep":0,"okt":0,"nov":0,"dec":0,"toelichting":"was created by UnitTest","valuta":"","stukprijs":0,"totaalprijs":0,"isNew":true,"hasChanged":true};
//         const response = await request.post('/orders')
//         .send('')
//         .set('Accept', 'application/json')
//         .expect(200)
//     })
// });

// describe ('Test create order', () => {
//     it
// })