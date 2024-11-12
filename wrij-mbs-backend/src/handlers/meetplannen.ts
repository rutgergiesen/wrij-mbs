import express, { Request, Response } from "express";
import { Meetplan, MeetplanStore } from "../models/meetplan";
import Logger from "../utilities/logger";

const store = new MeetplanStore();

const index = async (req: Request, res: Response) => {
    try{
        let search: String | undefined;
        let status: String | undefined;
        let startjaar: Number | undefined;
        let eindjaar: Number | undefined;


        if(req.query.search !== undefined){
            search = req.query.search.toString();
        }

        if(req.query.status !== undefined)
            status = req.query.status.toString();

        if(req.query.startjaar !== undefined){
            startjaar = parseInt(req.query.startjaar.toString());
        }

        if(req.query.eindjaar !== undefined){
            eindjaar = parseInt(req.query.eindjaar.toString());
        }

        const meetplannen = await store.index(search, status, startjaar, eindjaar);
        Logger.info('Meetplannen index was called');
        //console.log('index in Meetplannen handler file was called')
        res.json(meetplannen);
    }
    catch(err){
        Logger.error('Error in meetplannen index', err);
        res.status(400)
        res.json(err)
    }
}

const show = async (req: Request, res: Response) => {
    try{
        //console.log('show in Meetplannen handler file was called');
        //console.log(JSON.stringify(req.params.id));
        const meetplan = await store.show(parseInt(req.params.id));
        res.json(meetplan);
    }
    catch(err){
        Logger.error('Error in meetplannen show', err);
        res.status(400)
        res.json(err)
    }
}

const create = async (req: Request, res: Response) => {
    try{
        //console.log('Create in Meetplannen handler file was called');
        //console.log(JSON.stringify(req.body));

        const meetplan : Meetplan = req.body;
        const newMeetplan = await store.create(meetplan); 
        res.json(newMeetplan);
    }
    catch(err){
        Logger.error('Error in meetplannen create', err);
        res.status(400)
        res.json(err)
    }
}

const edit = async (req: Request, res: Response) => {
    try{
        //console.log('edit in Meetplannen handler file was called');
        //console.log(req.query);
        //console.log(JSON.stringify(req.body));
        const meetplan : Meetplan = req.body;
        //console.log(JSON.stringify(meetplan));
        const newMeetplan = await store.edit(meetplan); // TODO: number from url
        res.json(newMeetplan);
    }
    catch(err){
        Logger.error('Error in meetplannen edit', err);
        res.status(400)
        res.json(err)
    }
}

const destroy = async (req: Request, res: Response) => {
    try{
        const deleted = await store.delete(parseInt(req.params.id));
        res.json(deleted);
    }
    catch(err){ 
        Logger.error('Error in meetplannen destroy', err);
        res.status(400)
        res.json(err)
    }
}

const meetplannen_routes = (app: express.Application) => {
    // app.get('/meetplannen/', logger, index);       
    // app.get('/meetplannen/:id', show);
    // app.post('/meetplannen/', logger, create);
    // app.put('/meetplannen/:id', edit);
    // app.delete('/meetplannen/:id', destroy);
    app.get('/meetplannen/', index);       
    app.get('/meetplannen/:id', show);
    app.post('/meetplannen/', create);
    app.put('/meetplannen/:id', edit);
    app.delete('/meetplannen/:id', destroy);
}

export default meetplannen_routes;