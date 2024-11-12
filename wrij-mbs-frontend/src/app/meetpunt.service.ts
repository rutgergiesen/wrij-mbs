import { Injectable } from '@angular/core';
import { Observable, of } from 'rxjs';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { catchError, map, tap } from 'rxjs';

import { LoggingService } from './message.service';
import { Meetpunt } from './meetpunt';
//import { MEETPUNTEN } from './MOCK-meetpunten';

@Injectable({
  providedIn: 'root'
})
export class MeetpuntService {

  constructor(private http: HttpClient, private loggingService: LoggingService) { }

  private meetpuntUrl = 'http://localhost:6868/meetpunten'; // URL to web api
  //private meetplanMeetpuntUrl = 'http://localhost:6868/meetplanmeetpunten'; // URL to web api

  httpOptions = {
    headers: new HttpHeaders({ 'Content-Type': 'application/json' })
  };
  meetpuntList: Meetpunt[] = [];//MEETPUNTEN;

  getMeetpunten(meetplanId?:Number) : Observable<Meetpunt[]> {
    let params = new HttpParams();
    
    if (meetplanId) {
      params = params.set('meetplan', meetplanId.toString());
    }

    return this.http.get<Meetpunt[]>(this.meetpuntUrl, { params })
    .pipe(
      tap(_ => this.log(`Meetpunten opgehaald, meetplanId: ${meetplanId}`)),
      catchError(this.loggingService.handleError<Meetpunt[]>('getMeetpunten', []))
    );
  }

  addMeetpunt(meetpunt: Meetpunt): Observable<Meetpunt> {
    return this.http.post<Meetpunt>(this.meetpuntUrl, meetpunt, this.httpOptions).pipe(
      tap((newMeetpunt: Meetpunt) => this.log(`Meetpunt toegevoegd id=${newMeetpunt.id}`)),
      catchError(this.loggingService.handleError<Meetpunt>('addMeetpunt'))
    );
  }
  
  updateMeetpunt(meetpunt: Meetpunt): Observable<Meetpunt> {
    const url = `${this.meetpuntUrl}/${meetpunt.id}`;
    return this.http.put<Meetpunt>(url, meetpunt, this.httpOptions).pipe(
      tap((newMeetpunt: Meetpunt) => this.log(`Meetpunt gewijzigd id=${newMeetpunt.id}`)),
      catchError(this.loggingService.handleError<Meetpunt>('addMeetpunt'))
    );
  }

  searchMeetpunten(term: string, notInMeetplanId?: Number): Observable<Meetpunt[]>{
    // if (!term.trim()) {
    //   // if not search term, return empty array.
    //   return of([]);
    // }

    return this.http.get<Meetpunt[]>(`${this.meetpuntUrl}/?notInMeetplan=${notInMeetplanId}&search=${term}`).pipe(
      tap(x => x.length ?
         this.log(`Meetpunten gevonden met "${term}"`) :
         this.log(`Geen meetpunten gevonden met "${term}"`)),
      catchError(this.loggingService.handleError<Meetpunt[]>('searchMeetpunten', []))
    );
  }
  
  /*

  getMeetpuntenByMeetplan(meetplanId?:Number) : Observable<Meetpunt[]> {
    const url = `${this.meetplanMeetpuntUrl}/${meetplanId}`;
    //var meetplanmeetpunt = this.http.get<Meetpuntmeetplan[]>(url).pipe(
    return this.http.get<Meetpunt[]>(url).pipe(
      tap(_ => this.log(`Meetpunten opgehaald voor dit meetplan, meetplanId: ${meetplanId}`)),
      catchError(this.handleError<Meetpunt[]>('getMeetpunten', []))
    );
  }

  */

  private log(message: string) {
    this.loggingService.add(`MeetpuntService: ${message}`);
  }

}