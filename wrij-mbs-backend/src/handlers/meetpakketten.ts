import express, { Request, Response } from "express";
import Logger from "../utilities/logger";
import { Meetpakket, MeetpakketStore } from "../models/meetpakket";

const store = new MeetpakketStore();

const index = async (req: Request, res: Response) => {
    try{
        let search: String | undefined;

        if(req.query.search !== undefined){
            search = req.query.search.toString();
        }

        const meetpakketten = await store.index(search);
        //console.log('index in Meetpakketten handler file was called')
        res.json(meetpakketten);
    }
    catch(err){
        Logger.error('Error in meetpakketten index', err);
        res.status(400)
        res.json(err)
    }
}

const show = async (req: Request, res: Response) => {
    try{
        //console.log('show in Meetpakketten handler file was called');
        //console.log(JSON.stringify(req.params.id));
        const meetpakket = await store.show(parseInt(req.params.id));
        res.json(meetpakket);
    }
    catch(err){
        Logger.error('Error in meetpakketten show', err);
        res.status(400)
        res.json(err)
    }
}

const create = async (req: Request, res: Response) => {
    try{
        //console.log('Create in Meetpakketten handler file was called');
        //console.log(JSON.stringify(req.body));

        const meetpakket : Meetpakket = req.body;
        const newMeetpakket = await store.create(meetpakket);
        res.json(newMeetpakket);
    }
    catch(err){
        Logger.error('Error in meetpakketten create', err);
        res.status(400)
        res.json(err)
    }
}

const edit = async (req: Request, res: Response) => {
    try{
        //console.log('edit in Meetpakketten handler file was called');
        //console.log(req.query);
        //console.log(JSON.stringify(req.body));
        const meetpakket : Meetpakket = req.body;
        //console.log(JSON.stringify(meetpakket));
        const newMeetpakket = await store.edit(meetpakket); // TODO: number from url
        res.json(newMeetpakket);
    }
    catch(err){
        Logger.error('Error in meetpakketten edit', err);
        res.status(400)
        res.json(err)
    }
}

const destroy = async (req: Request, res: Response) => {
    const deleted = await store.delete(parseInt(req.params.id));
    res.json(deleted);
}

const meetpakketten_routes = (app: express.Application) => {
    app.get('/meetpakketten/', index);       
    app.get('/meetpakketten/:id', show);
    app.post('/meetpakketten/', create);
    app.put('/meetpakketten/:id', edit);
    app.delete('/meetpakketten/:id', destroy);
}

export default meetpakketten_routes;