import express, { Request, Response } from "express";

import verifyAuthToken from "../utilities/auth";
import { KostenStore } from "../models/kosten";
import Logger from "../utilities/logger";

const store = new KostenStore();

const index = async (req: Request, res: Response, next: Function) => {
    try{
        // //console.log('orders index was called');
        let meetplanId: number | undefined;
        let startjaar: number | undefined;
        let eindjaar: number | undefined;
        let status: string | undefined;

        if(req.query.meetplan !== undefined){
            meetplanId = parseInt(req.query.meetplan.toString());
        }
        if(req.query.startjaar !== undefined){
            startjaar = parseInt(req.query.startjaar.toString());
        }
        if(req.query.eindjaar !== undefined){
            eindjaar = parseInt(req.query.eindjaar.toString());
        }
        if(req.query.status !== undefined){
            status = req.query.status.toString();
        }

        const kosten = await store.index(meetplanId, startjaar, eindjaar, status);
        res.json(kosten);
    }
    catch(err){
        Logger.error('Error in kosten index', err);
        res.status(400)
        res.json(err)
    }
}

const kosten_routes = (app: express.Application) => {
    app.get('/kosten/', verifyAuthToken, index);       
}

export default kosten_routes;