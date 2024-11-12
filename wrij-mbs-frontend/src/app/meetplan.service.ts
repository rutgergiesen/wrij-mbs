import { Injectable } from '@angular/core';
import { Observable, of } from 'rxjs';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { catchError, map, tap } from 'rxjs';

import { LoggingService } from './message.service';
import { Meetplan } from './meetplan';

@Injectable({
  providedIn: 'root'
})
export class MeetplanService {

  constructor(private http: HttpClient, private loggingService: LoggingService) { 
  }
  private meetplanUrl = 'http://localhost:6868/meetplannen'; // URL to web api

  httpOptions = {
    headers: new HttpHeaders({ 'Content-Type': 'application/json' })
  };

  meetplannen : Meetplan[] = [];//MEETPLANNEN;

  getMeetplannen(status?: string, startjaar? : number, eindjaar? : number) : Observable<Meetplan[]>{ 
    let params = new HttpParams();

    if(status !== undefined)
      params = params.set('status', 'definitief');
    if(startjaar !== undefined)
      params = params.set('startjaar', startjaar);
    if(eindjaar !== undefined)
      params = params.set('eindjaar', eindjaar);

    return this.http.get<Meetplan[]>(this.meetplanUrl, { params })
    .pipe(
      tap(_ => this.log('Meetplannen opgehaald')),
      catchError(this.loggingService.handleError<Meetplan[]>('getMeetplannen', [], 'Fout bij het ophalen van meetplannen'))
    );
  }

  // getMeetplannenDefinitief(){
  //   let params = new HttpParams();
  //   params = params.set('status', 'definitief');

  //   return this.http.get<Meetplan[]>(this.meetplanUrl, { params })
  //   .pipe(
  //     tap(_ => this.log('Definitieve meetplannen opgehaald')),
  //     catchError(this.handleError<Meetplan[]>('getMeetplannenDefinitief', []))
  //   );
  // }

  getMeetplan(id: number): Observable<Meetplan> {
    const url = `${this.meetplanUrl}/${id}`;
    return this.http.get<Meetplan>(url).pipe(
      tap(_ => this.log(`Meetplan opgehaald id=${id}`)),
      catchError(this.loggingService.handleError<Meetplan>(`getMeetplan id=${id}`, undefined, 'Fout bij openen van het meetplan'))
    );
  }
  
  updateMeetplan(meetplan: Meetplan): Observable<any> {
    const url = `${this.meetplanUrl}/${meetplan.id}`;
    return this.http.put(url, meetplan, this.httpOptions).pipe(
      tap(_ => this.log(`Meetplan geupdate id=${meetplan.id}`, 'Meetplan opgeslagen')),
      catchError(this.loggingService.handleError<any>('updateMeetplan', undefined, 'Fout bij opslaan van het meetplan'))
    );
  }

  addMeetplan(meetplan: Meetplan): Observable<Meetplan> {
    return this.http.post<Meetplan>(this.meetplanUrl, meetplan, this.httpOptions).pipe(
      tap((newMeetplan: Meetplan) => this.log(`Meetplan toegevoegd id=${newMeetplan.id}`, 'Meetplan opgeslagen')),
      catchError(this.loggingService.handleError<Meetplan>('addMeetplan', undefined, 'Fout bij opslaan van het meetplan'))
    );
  }

  deleteMeetplan(meetplan: Meetplan): Observable<Meetplan> {
    const url = `${this.meetplanUrl}/${meetplan.id}`;
    return this.http.delete<Meetplan>(url, this.httpOptions).pipe(
      tap((deletedMeetplan: Meetplan) => {
        if(deletedMeetplan.id === -1)
          this.log(`FOUT: Meetplan niet verwijderd, meetplan id=${meetplan.id}`, `FOUT: Meetplan niet verwijderd, meetplan id=${meetplan.id}`, true);
        else
          this.log(`Meetplan verwijderd id=${meetplan.id}`, 'Meetplan verwijderd')
      }),
      catchError(this.loggingService.handleError<Meetplan>('deleteMeetplan', undefined, 'Fout bij verwijderen van het meetplan'))
    );
  }

  searchMeetplannen(term: string): Observable<Meetplan[]> {
    // if (!term.trim()) {
    //   // if not search term, return empty array.
    //   return of([]);
    // }
    return this.http.get<Meetplan[]>(`${this.meetplanUrl}/?search=${term}`).pipe(
      tap(x => x.length ?
         this.log(`Meetplannen gevonden met "${term}"`) :
         this.log(`Geen meetplannen gevonden  met "${term}"`)),
      catchError(this.loggingService.handleError<Meetplan[]>('searchMeetplannen', [], 'Fout bij zoeken van meetplannen'))
    );
  }

  private log(logMessage: string, userMessage?: string, isError?: boolean) {
    this.loggingService.add(`MeetplanService: ${logMessage}`, userMessage, isError);
  }


}
