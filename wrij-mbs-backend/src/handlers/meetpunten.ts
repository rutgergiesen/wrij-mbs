import express, { Request, Response } from "express";
import Logger from "../utilities/logger";
import { Meetpunt, MeetpuntStore } from "../models/meetpunt";

const store = new MeetpuntStore();

const index = async (req: Request, res: Response) => {
    try{
        let meetplanId: number | undefined;
        let search: String | undefined;
        let notInMeetplanId: number | undefined;

        // bepaal de waarden van variabelen, als ze in de querystring zijn meegegeven
        if(req.query.meetplan !== undefined){
            meetplanId = parseInt(req.query.meetplan.toString());
        }
        if(req.query.search !== undefined){
            search = req.query.search.toString();
        }
        if(req.query.notInMeetplan !== undefined){
            // zet om van string naar boolean
            notInMeetplanId = parseInt(req.query.notInMeetplan.toString());
        }

        //console.log('Search: ' + search);

        const meetpunten = await store.index(meetplanId, search, notInMeetplanId);
        res.json(meetpunten);
    }
    catch(err){
        Logger.error('Error in meetpunten index', err);
        res.status(400)
        res.json(err)
    }
}

const show = async (req: Request, res: Response) => {
    try{
        const meetpunt = await store.show(parseInt(req.params.id));
        res.json(meetpunt);
    }
    catch(err){
        Logger.error('Error in meetpunten show', err);
        res.status(400)
        res.json(err)
    }
}

const create = async (req: Request, res: Response) => {
    try{
        const meetpunt : Meetpunt = req.body;
        const newMeetpunt = await store.create(meetpunt);
        res.json(newMeetpunt);
    }
    catch(err){
        Logger.error('Error in meetpunten create', err);
        res.status(400)
        res.json(err)
    }
}

const edit = async (req: Request, res: Response) => {
    try{
        const meetpunt : Meetpunt = req.body;
        const newMeetpunt = await store.edit(meetpunt); // TODO: number from url
        res.json(newMeetpunt);
    }
    catch(err){
        Logger.error('Error in meetpunten edit', err);
        res.status(400)
        res.json(err)
    }
}

const destroy = async (req: Request, res: Response) => {
    const deleted = await store.delete(parseInt(req.params.id));
    res.json(deleted);
}

const meetpunten_routes = (app: express.Application) => {
    app.get('/meetpunten/', index);      
    app.get('/meetpunten/:id', show);
    app.post('/meetpunten/', create);
    app.put('/meetpunten/:id', edit);
    app.delete('/meetpunten/:id', destroy);
}

export default meetpunten_routes;