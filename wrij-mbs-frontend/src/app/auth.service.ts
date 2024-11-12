import { Injectable } from '@angular/core';
import { Observable, of } from 'rxjs';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { catchError, tap, shareReplay } from 'rxjs';

import { LoggingService } from './message.service';
import { User } from './user';

@Injectable({
  providedIn: 'root'
})
export class AuthService {

  constructor(private http: HttpClient, private loggingService: LoggingService) { }
  private loginUrl = 'http://localhost:6868/login'; // URL to web api

  httpOptions = {
    headers: new HttpHeaders({ 'Content-Type': 'application/json' })
  };

  login(user: User): Observable<string> {
    return this.http.post<string>(this.loginUrl, user, this.httpOptions)
    .pipe(
      tap((result) => (this.setSession(result), this.loggingService.add(`Gebruiker ingelogd met gebruikersnaam=${user.username}`))),
      catchError(this.loggingService.handleError<string>('authenticateUser', '', 'Gebruiker niet ingelogd. Ongeldige login.')),
      shareReplay()
    );
  }

  private setSession(authResult: any) {

    const currentMoment = new Date();
    const expiresAt = new Date(currentMoment);
    expiresAt.setSeconds(currentMoment.getSeconds() + authResult.expiresIn);

    localStorage.setItem('id_token', authResult.token);
    localStorage.setItem("expires_at", JSON.stringify(expiresAt.valueOf()) );
  } 

  logout() {
    localStorage.removeItem("id_token");
    localStorage.removeItem("expires_at");
  }

  public isLoggedIn() {
    const currentMoment = new Date();
    const isLoggedIn = currentMoment < this.getExpiration();
    return isLoggedIn;
  }

  isLoggedOut() {
      return !this.isLoggedIn();
  }

  getExpiration() {
      const expiration = localStorage.getItem("expires_at");
      const expiresAt = new Date(JSON.parse(expiration!));
      return expiresAt;
  }
}
