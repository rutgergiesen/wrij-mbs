import { Component, Input, Output, EventEmitter} from '@angular/core';

import { Order } from '../order';
import { OrderService } from '../order.service';
import { MeetpakketService } from '../meetpakket.service';
import { Meetpakket } from '../meetpakket';
import { LoggingService } from '../message.service';


@Component({
  selector: 'app-orders',
  templateUrl: './orders.component.html',
  styleUrls: ['./orders.component.css']
})
export class OrdersComponent {
  @Input() meetpuntId: Number = 0;
  @Input() meetplanId: Number | undefined = 0;
  @Input() retrieveOrders: boolean = true; // default bestaande orders ophalen
  @Input() meetpakketten: Meetpakket[] = [];

  @Output() ordersChangedEvent = new EventEmitter<void>(); // event emitter voor parent component, doorgeven dat orders zijn gewijzigd

  orders: Order[] = [];
  newOrder!: Order; //= new Order(0, this.meetplanId!, this.meetpuntId);

  nrOfSaves: number = 0; // variabele om bij te houden hoe vaak er wordt opgeslagen, bij elke keer dat wijziging wordt opgeslagen, wordt deze variabele met 1 verhoogd en aan parent doorgegeven t.b.v. update van de meetplan kostentabel
  isButtonDisabled: boolean = true;

  alternatieOpties = [1, 2, 3, 4, 15];
  jaarOpties = [2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025, 2026, 2027, 2028, 2029, 2030, 2031, 2032, 2033, 2034, 2035, 2036, 2037, 2038, 2039, 2040];

  constructor(
    private orderService: OrderService, 
    private loggingService: LoggingService,
    private meetpakketService: MeetpakketService){
  }

  ngOnInit(): void {
    
    // haal nieuwe orders op, als vlag retrieveOrders op true staat (=default)
    if (this.retrieveOrders)
     this.getOrders(this.meetpuntId, this.meetplanId);

    this.getMeetpakketten();

    this.initializeNewOrder();
  }

  initializeNewOrder():void{
    this.newOrder = new Order(0, this.meetplanId!, this.meetpuntId, 0, 1, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,'','',0,0,true, false);
  }

  toggleButtonState() {
    this.isButtonDisabled = !this.isButtonDisabled;
  }

  getOrders(meetpuntId?:Number, meetplanId?:Number): void{
      this.orderService.getOrders(meetpuntId, meetplanId)
        .subscribe(orders => {this.orders = orders});
  }

  getMeetpakketten(){
    if(this.meetpakketten.length === 0)
    this.meetpakketService.getMeetpakketten()
        .subscribe(meetpakketten => {
          this.meetpakketten = meetpakketten;
        });
  }

  cancelNewOrder(): void{
    this.initializeNewOrder();
  }

  cancelOrders(): void{
    this.ngOnInit();
  }

  async deleteOrder(index:number){
    const id = this.orders[index].id;
    await this.orderService.deleteOrder(id).toPromise();
    this.orders.splice(index,1);

    this.ordersChangedEvent.emit()
    
  }

  async saveOrders(newOrder: Order) : Promise<void>{
    try{
      //console.log('saveOrders');
      let nrOfChanges = 0; //  aantal gewijzigde orders bijhouden

      // Als gebruiker de lege nieuwer order heeft gewijzigd, wijzigingen opslaan op de server, 
      // de nieuwe order pushen naar de order stack en nieuwe order resetten/opnieuw initializeren
      if(newOrder.hasChanged){
        nrOfChanges++; // aantal gewijzigde orders met 1 ophogen

        const savedOrder = await this.orderService.addOrder(newOrder).toPromise();
       // .subscribe(savedOrder => (
        this.orders.push(savedOrder!);
        savedOrder!.hasChanged = false;
        savedOrder!.isNew = false;
        this.initializeNewOrder();
      }    

      let orderIndex: number = 0;
      // Alle orders nalopen, wijzigingen opslaan op de server en de order stack resetten
      for(var order of this.orders){      
 
        // alleen als de order is gewijzigd opslaan
        if(order.hasChanged){
          nrOfChanges++;

          await this.orderService.updateOrder(order).toPromise();
          this.modelChangeReset(order); // Vlag 'order is gewijzigd' resetten
        }
        orderIndex++;
      }
      this.ngOnInit();
      this.ordersChangedEvent.emit();
    }

    catch(e: any){
      //log error
      this.loggingService.handleError(e);
    }

  }

  // Vlag voor het bijhouden of er wijzigingen zijn in de order resetten
  modelChangeReset(order: Order): void{
    order.hasChanged = false;
  }

  // Bij wijziging van de order, vlag 'order is gewijzigd' op true zetten en button 'opslaan' activeren
  modelChange(order: Order){
      order.hasChanged = true;

      this.isButtonDisabled = false;
  }

  // orderprijs van de order berekenen
  updateTotaalprijs(order: Order): void{

    //if(!isNewOrder){
      order.orderprijs = 
        (
          order.  jan! +
          order.feb! + 
          order.mrt! + 
          order.apr! + 
          order.mei! + 
          order.jun! + 
          order.jul! + 
          order.aug! + 
          order.sep! + 
          order.okt! + 
          order.nov! + 
          order.dec!
        ) * order.stukprijs!;

  }

  // als het meetpakket bij een order wordt gewijzigd, dan de kosten en valuta bijwerken
  meetpakketChange(order: Order){

    // vind het meetpakket object bij voor het geselecteerde meetpakket
    const meetpakketId = parseInt(order.meetpakket.toString());
    const foundMeetpakket = this.meetpakketten.find(meetpakket => meetpakket.id === meetpakketId);//meetpakket.stukprijs;
    
    // update het order object met de valuta en stukprijs gegevens van het gevonden meetpakket
    order.stukprijs = foundMeetpakket!.stukprijs;
    order.valuta = foundMeetpakket!.valuta;
     
    // update de totaal prijs
    this.updateTotaalprijs(order);
  }

}
