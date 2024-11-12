import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { FormsModule } from '@angular/forms';
import { HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http';

import { LoginComponent } from './login/login.component';
import { LogoutComponent } from './logout/logout.component';
import { MeetplannenComponent } from './meetplannen/meetplannen.component';
import { MeetplanComponent } from './meetplan/meetplan.component';
import { MeetpuntenComponent } from './meetpunten/meetpunten.component';
import { MeetpuntComponent } from './meetpunt/meetpunt.component';
import { MeetpakkettenComponent } from './meetpakketten/meetpakketten.component';
import { MeetpakketComponent } from './meetpakket/meetpakket.component';
import { OrdersComponent } from './orders/orders.component';
import { OrderComponent } from './order/order.component';
import { MessagesComponent } from './messages/messages.component';
import { ZoekMeetpuntenComponent } from './zoek-meetpunten/zoek-meetpunten.component';
import { KostenComponent } from './kosten/kosten.component';
import { KostenTabelComponent } from './kosten-tabel/kosten-tabel.component';
import { KostenTabellenComponent } from './kosten-tabellen/kosten-tabellen.component';
import { NgbModule, NgbToast } from '@ng-bootstrap/ng-bootstrap';
import { ToastContainerComponent } from './toast-container/toast-container.component';
import { JWSInterceptor } from './utils/httpinterceptor';

@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    LogoutComponent,
    MeetplanComponent,
    MeetpuntComponent,
    MeetpakkettenComponent,
    MeetpakketComponent,
    OrderComponent,
    MeetplannenComponent,
    MessagesComponent,
    MeetpuntenComponent,
    OrdersComponent,
    ZoekMeetpuntenComponent,
    KostenComponent,
    KostenTabelComponent,
    KostenTabellenComponent,
    ToastContainerComponent,
  ],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    AppRoutingModule,
    FormsModule,
    HttpClientModule,
    NgbModule,
    NgbToast
  ],
  providers: [
    {
      provide: HTTP_INTERCEPTORS,
      useClass: JWSInterceptor,
      multi: true
    }
  ],
  bootstrap: [ AppComponent ]
})
export class AppModule { }
