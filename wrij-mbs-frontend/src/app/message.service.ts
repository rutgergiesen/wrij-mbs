import { Injectable } from '@angular/core';
import { Observable, of } from 'rxjs';

import { ToastService } from './toast.service';

@Injectable({
  providedIn: 'root'
})

export class LoggingService {
  logMessages: string[] = [];

  constructor(private toastService: ToastService){
  }

  add(logMessage: string, userMessage = '', isError = false){

    this.logMessages.push(logMessage);

    // weergave voor eindgebruiker
    if(isError && userMessage !== '')
      this.toastService.showError(userMessage);
    else if(isError)
      this.toastService.showError(logMessage);
    else if(userMessage !== '')
      this.toastService.show(userMessage);
  }

  clear(){
    this.logMessages = [];
  }

    /**
   * Handle Http operation that failed.
   * Let the app continue.
   *
   * @param operation - name of the operation that failed
   * @param result - optional value to return as the observable result
   */
    public handleError<T>(operation = 'operation', result?: T, userMessage = '') {
      return (error: any): Observable<T> => {

        // TODO: send the error to remote logging infrastructure
        console.error(error); // log to console instead

        // TODO: better job of transforming error for user consumption
        this.add(`${operation} failed: ${error.message}`, `FOUT: ${userMessage}`, true);

        // Let the app keep running by returning an empty result.
        return of(result as T);
      };
    }
}
