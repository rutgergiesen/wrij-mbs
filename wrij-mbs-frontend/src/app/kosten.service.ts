import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { catchError, tap } from 'rxjs';

import { LoggingService } from './message.service';
import { KostenRecord } from './kosten';
// import { Alternatie } from './alternatie';

@Injectable({
  providedIn: 'root'
})
export class KostenService {

  constructor(private http: HttpClient, private loggingService: LoggingService) { }

  private kostenUrl = 'http://localhost:6868/kosten'; // URL to web api

  httpOptions = {
    headers: new HttpHeaders({ 'Content-Type': 'application/json' })
  };


  kostenList: KostenRecord[] = [];

  getKosten(meetplanId?: number, startjaar?: number, eindjaar?:number, status?: string) : Observable<KostenRecord[]> {
    //const headers = new HttpHeaders().set('Content-Type', 'application/json');
   // headers = headers.set('Authorization', 'Bearer ' + localStorage.getItem('token'));

    let params = new HttpParams();
    
    if (meetplanId) {
      params = params.set('meetplan', meetplanId);
    }
    if (startjaar) {
      params = params.set('startjaar', startjaar);
    }
    if (eindjaar) {
      params = params.set('eindjaar', eindjaar);
    }
    if (status) {
      params = params.set('status', status.toString());
    }

    return this.http.get<KostenRecord[]>(this.kostenUrl, {params})
    .pipe(
      tap(result => this.log(`Kosten opgehaald voor meetplan: ${meetplanId}`)),
      catchError(this.loggingService.handleError<KostenRecord[]>('getKosten', [], 'Kosten niet opgehaald'))
    );
  }

  private log(message: string) {
    this.loggingService.add(`KostenService: ${message}`);
  }
}
