import { Injectable } from '@angular/core';
import { Observable, of } from 'rxjs';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { catchError, map, tap } from 'rxjs';

import { LoggingService } from './message.service';
import { Order } from './order';

//import { ORDERS } from './MOCK-orders';

@Injectable({
  providedIn: 'root'
})
export class OrderService {

  constructor(private http: HttpClient, private loggingService: LoggingService) { 
  }
  private orderUrl = 'http://localhost:6868/orders'; // URL to web api

  httpOptions = {
    headers: new HttpHeaders({ 'Content-Type': 'application/json' })
  };

  orderList: Order[] = [];
  
  // retourneert alle orders, of orders bij een meetpunt en/of meetplan
  getOrders(meetpuntId?:Number, meetplanId?:Number): Observable<Order[]>{ 
    let params = new HttpParams();
    
    if (meetpuntId) {
      params = params.set('meetpunt', meetpuntId.toString());
    }

    if (meetplanId) {
      params = params.set('meetplan', meetplanId.toString());
    }

    const url = `${this.orderUrl}`;

    return this.http.get<Order[]>(url, { params })
      .pipe(
        tap(_ => this.log(`Orders opgehaald, meetpunt: ${meetpuntId}, meetplan: ${meetplanId}`)),
        catchError(this.loggingService.handleError<Order[]>('getOrders', []))
      );
  }

  // saveOrders(orders: Order[], meetpuntId: Number, meetplanId: Number){
  //   /*
  //   return this.http.post<Meetplan>(this.meetplanUrl, meetplan, this.httpOptions).pipe(
  //     tap((newMeetplan: Meetplan) => this.log(`Meetplan toegevoegd id=${newMeetplan.id}`)),
  //     catchError(this.handleError<Meetplan>('addMeetplan'))
  //   );
  //   */
  //  this.log(`Orders opslaan, meetpunt: ${meetpuntId}, meetplan: ${meetplanId}, ${ JSON.stringify(orders)}`);
  //   return this.http.put(this.orderUrl, JSON.stringify(orders), this.httpOptions)
  //     .pipe(
  //       tap(_ => this.log(`Orders opgeslagen, meetpunt: ${meetpuntId}, meetplan: ${meetplanId}, ${orders}`)),
  //       catchError(this.handleError<any>('saveOrders'))
  //   );

  // }
  // updateMeetplan(meetplan: Meetplan): Observable<any> {
  //   const url = `${this.meetplanUrl}/${meetplan.id}`;
  //   return this.http.put(url, meetplan, this.httpOptions).pipe(
  //     tap(_ => this.log(`Meetplan geupdate id=${meetplan.id}`)),
  //     catchError(this.handleError<any>('updateMeetplan'))
  //   );
  // }

  updateOrder(order: Order): Observable<any> {
    const url = `${this.orderUrl}/${order.id}`;
    
    return this.http.put<Order>(url, order, this.httpOptions)
      .pipe(
        tap(_ => this.log(`Order geupdate id=${order.id}`)),
        catchError(this.loggingService.handleError<any>('updateOrder'))
    );
  }

  addOrder(order: Order): Observable<Order> {
    return this.http.post<Order>(this.orderUrl, order, this.httpOptions)
      .pipe(
        tap((newOrder: Order) => this.log(`Order toegevoegd. Id=${newOrder.id} `)),
        catchError(this.loggingService.handleError('postOrder', order))
      );
  }

  deleteOrder(id: number): Observable<unknown>{
    const url = `${this.orderUrl}/${id}`;
    return this.http.delete(url, this.httpOptions)
      .pipe(
        tap(_ => this.log(`Order verwijderd. Id=${id} `)),
        catchError(this.loggingService.handleError('deleteOrder'))
      );
  }

  // addOrder(order: Order): Observable<Order> {
  //   // console.log('addOrder: ' + JSON.stringify(order));
  //   console.log('addOrder: ' + this.orderUrl);

  //   const tempOrder : Order = {"id":0,"meetplan":1,"meetpunt":1,"meetpakket":4,"alternatie":"driejaarlijks","jan":1,"feb":0,"mrt":0,"apr":0,"mei":0,"jun":0,"jul":0,"aug":0,"sep":0,"okt":0,"nov":0,"dec":0,"toelichting":"efwewef","valuta":"","stukprijs":0,"orderprijs":0,"isNew":true,"hasChanged":true};
  //   console.log('addOrder: ' + JSON.stringify(tempOrder));
  //   return this.http.post<Order>(this.orderUrl, tempOrder, this.httpOptions).pipe(
  //     tap((newOrder: Order) => this.log(`Order toegevoegd id=${newOrder.id}`)),
  //     catchError(this.handleError<Order>('addMeetplan'))
  //   );
  // }

  private log(message: string) {
    this.loggingService.add(`OrderService: ${message}`);
  }
  
}
