import { Injectable } from '@angular/core';
import { Observable, of } from 'rxjs';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { catchError, map, tap } from 'rxjs';

import { Alternatie } from './alternatie';
import { LoggingService } from './message.service';

@Injectable({
  providedIn: 'root'
})
export class AlternatieService {

  constructor(private http: HttpClient, private loggingService: LoggingService) { }
  private alternatieUrl = 'http://localhost:6868/alternaties'; // URL to web api

  httpOptions = {
    headers: new HttpHeaders({ 'Content-Type': 'application/json' })
  };

  alternaties : Alternatie[] = [];

  getAlternaties(meetplanId:number) : Observable<Alternatie[]>{
    let params = new HttpParams();

    params = params.set('meetplan', meetplanId.toString());

    return this.http.get<Alternatie[]>(this.alternatieUrl, { params })
      .pipe(
        tap(_ => this.log(`Alternaties opgehaald, meetplan: ${meetplanId}`)),
        catchError(this.loggingService.handleError<Alternatie[]>('getAlternaties', []))
      );
  }

  private log(message: string) {
    this.loggingService.add(`AlternatietService: ${message}`);
  }

}
