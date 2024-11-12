import { Component, inject, Input } from '@angular/core';
import { CommonModule } from '@angular/common';

import { Order } from '../order';
//import { OrderService } from '../order.service';

interface PrijsType {
  value: string;
  viewValue: string;
}
@Component({
  selector: 'app-order',
  templateUrl: './order.component.html',
  styleUrls: ['./order.component.css'],
})

export class OrderComponent {

  @Input() meetplanId : Number | undefined;
  @Input() meetpuntId : Number = 0;
  @Input() order?: Order;
  @Input() even: boolean = false;
  @Input() odd: boolean  = false;
  @Input() counter?: Number = 0;
  
  isNewOrder = false;

  prijsTypes: PrijsType[] =  [
    {value: 'euro', viewValue: 'Euro'},
    {value: 'ilow', viewValue: 'ILOW'}, 
  ];

  //orderList: Order[] = [];
  //orderService: OrderService = inject(OrderService);
  //displayedColumns: string[] = ['meetpakket', 'toelichting', 'valuta', 'stukprijs', 'alternatie', 'jan', 'feb', 'mrt', 'apr', 'mei', 'jun', 'jul', 'aug', 'sep', 'okt', 'nov', 'dec', 'orderprijs'];
  //<option *ngFor="let meetpakket of meetpakketOpties" [value]="meetpakket">{{meetpakket}}</option>
  meetpakketOpties = ["yow", "yveld-chemie", "licpow", "licpow_nf", "monbeh"]; // TODO -> ophalen via API
  alternatieOpties = ["jaarlijks", "tweejaarlijks", "driejaarlijks"];

  constructor() {

  }

  ngOnInit(): void {
    if(!this.meetplanId)
      this.meetplanId = 0;

    if(!this.order){
      //console.log(`onInit order id: ${this.order.id}`);
      this.isNewOrder = true;
      this.order = new Order(0, this.meetplanId!, this.meetpuntId, 0, 0, 0,0, 0,0,0,0,0,0,0,0,0,0,0,0,'','',0,0);
    }


  }

  /*
  getOrders(): void {
    this.orderService.getOrders()
      .subscribe(orders => this.orderList = orders);
  }
  */
}
