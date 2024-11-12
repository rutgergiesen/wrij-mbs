import express, { Request, Response } from "express";
import { Order, OrderStore } from "../models/order";
import Logger from "../utilities/logger";

const store = new OrderStore();

const index = async (req: Request, res: Response, next: Function) => {
    try{
        //console.log('orders index was called');
        let meetpuntId: Number | undefined;
        let meetplanId: Number | undefined;

        if(req.query.meetpunt !== undefined){
            meetpuntId = parseInt(req.query.meetpunt.toString());
        }
        if(req.query.meetplan !== undefined){
            meetplanId = parseInt(req.query.meetplan.toString());
        }

        const orders = await store.index(meetpuntId, meetplanId);
        res.json(orders);
    }
    catch(err){
        Logger.error('Error in orders index', err);
        res.status(400)
        res.json(err)
    }
}

const show = async (req: Request, res: Response) => {
    try{
        const order = await store.show(parseInt(req.params.id));
        res.json(order);
    }
    catch(err){
        Logger.error('Error in orders show', err);
        res.status(400)
        res.json(err)
    }
}

const create = async (req: Request, res: Response, next: Function) => {
    try{
        const order : Order = req.body;
        const newOrder = await store.create(order);
        res.json(newOrder);
    }
    catch(err){
        Logger.error('Error in orders create', err);
        res.status(400);
        res.json(err)
    }
}

const edit = async (req: Request, res: Response) => {
    try{
        const order : Order = req.body;
        const newOrder = await store.edit(order); // TODO: number from url
        res.json(newOrder);
    }
    catch(err){
        Logger.error('Error in orders edit', err);
        res.status(400)
        res.json(err)
    }
}

const destroy = async (req: Request, res: Response) => {
    const deleted = await store.delete(parseInt(req.params.id));
    res.json(deleted);
}

const orders_routes = (app: express.Application) => {
    // app.get('/orders/', logger, index);       
    // app.post('/orders/', logger, create);
    // app.put('/orders/:id', logger, edit);
    // app.delete('/orders/:id', logger, destroy);
    app.get('/orders/', index);       
    app.post('/orders/', create);
    app.put('/orders/:id', edit);
    app.delete('/orders/:id', destroy);
}

export default orders_routes;