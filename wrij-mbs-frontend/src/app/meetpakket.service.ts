import { Injectable } from '@angular/core';
import { Observable, of } from 'rxjs';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { catchError, map, tap } from 'rxjs';

import { LoggingService } from './message.service';
import { Meetpakket } from './meetpakket';

@Injectable({
  providedIn: 'root'
})

export class MeetpakketService {

  constructor(private http: HttpClient, private loggingService: LoggingService) { }
  private meetpakketUrl = 'http://localhost:6868/meetpakketten'; // URL to web api

  httpOptions = {
    headers: new HttpHeaders({ 'Content-Type': 'application/json' })
  };

  meetpakketten : Meetpakket[] = [];

  searchMeetpakketten(term: string): Observable<Meetpakket[]> {
    // if (!term.trim()) {
    //   // if not search term, return empty hero array.
    //   return of([]);
    // }
    return this.http.get<Meetpakket[]>(`${this.meetpakketUrl}/?search=${term}`).pipe(
      tap(x => x.length ?
         this.log(`Meetpakketten gevonden met "${term}"`) :
         this.log(`Geen meetpakketten gevonden  met "${term}"`)),
      catchError(this.loggingService.handleError<Meetpakket[]>('searchMeetpakketten', []))
    );
  }

  getMeetpakketten() : Observable<Meetpakket[]>{
    return this.http.get<Meetpakket[]>(this.meetpakketUrl)
    .pipe(
      tap(_ => this.log('Meetpakketten opgehaald')),
      catchError(this.loggingService.handleError<Meetpakket[]>('getMeetpakketten', []))
    );
  }

  getMeetpakket(id: number): Observable<Meetpakket> {
    const url = `${this.meetpakketUrl}/${id}`;
    return this.http.get<Meetpakket>(url).pipe(
      tap(_ => this.log(`Meetpakket opgehaald id=${id}`)),
      catchError(this.loggingService.handleError<Meetpakket>(`getMeetpakket id=${id}`))
    );
  }
  
  updateMeetpakket(meetpakket: Meetpakket): Observable<any> {
    const url = `${this.meetpakketUrl}/${meetpakket.id}`;
    return this.http.put(url, meetpakket, this.httpOptions).pipe(
      tap(_ => this.log(`Meetpakket geupdate id=${meetpakket.id}`)),
      catchError(this.loggingService.handleError<any>('updateMeetpakket'))
    );
  }

  addMeetpakket(meetpakket: Meetpakket): Observable<Meetpakket> {
    return this.http.post<Meetpakket>(this.meetpakketUrl, meetpakket, this.httpOptions).pipe(
      tap((newMeetpakket: Meetpakket) => this.log(`Meetpakket toegevoegd id=${newMeetpakket.id}`)),
      catchError(this.loggingService.handleError<Meetpakket>('addMeetpakket'))
    );
  }

  deleteMeetpakket(meetpakket: Meetpakket): Observable<Meetpakket> {
    const url = `${this.meetpakketUrl}/${meetpakket.id}`;
    return this.http.delete<Meetpakket>(url, this.httpOptions).pipe(
      tap(() => this.log(`Meetpakket verwijderd id=${meetpakket.id}`)),
      catchError(this.loggingService.handleError<Meetpakket>('deleteMeetpakket'))
    );
  }

  private log(message: string) {
    this.loggingService.add(`MeetpakketService: ${message}`);
  }

}

