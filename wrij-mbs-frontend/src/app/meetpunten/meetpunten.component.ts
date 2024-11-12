import { Component, EventEmitter, Input, Output, ViewChild } from '@angular/core';
import { NgbAccordionModule } from '@ng-bootstrap/ng-bootstrap';

import { MeetpuntService } from '../meetpunt.service';
import { Meetpunt } from '../meetpunt';
import { Meetpakket } from '../meetpakket';
//import { Order } from '../order';

@Component({
  selector: 'app-meetpunten',
  templateUrl: './meetpunten.component.html',
  styleUrls: ['./meetpunten.component.css']
})
export class MeetpuntenComponent {
  @ViewChild('closebutton') closebutton: any; //om modal te kunnen sluiten vanuit opslaan
  @ViewChild('closebutton2') closebutton2: any; //om modal te kunnen sluiten vanuit opslaan

  @Input() meetplanId?: Number;
  @Input() meetpakketten: Meetpakket[] = [];

  @Output() meetpuntenChangedEvent = new EventEmitter<number>(); // event emitter voor parent component, doorgeven dat meetpunten zijn gewijzigd

  meetpunten: Meetpunt[] = [];
  meetpuntenSelectie: Meetpunt[] = [];

  nrOfMeetpuntenCreated = 0;
  nrOfMeetpuntChanges = 0;

  constructor(
    private meetpuntService: MeetpuntService,
  ){
  }

  ngOnInit(): void {
     this.getMeetpunten(this.meetplanId);
  }

  getMeetpunten(meetplanId?:Number): void{    
      this.meetpuntService.getMeetpunten(meetplanId)
        .subscribe(meetpunten => {this.meetpunten = meetpunten});
  }


  // per meegegeven meetlocatie, voeg een lege record to aan order
  addMeetpuntenSelectie(): void{
    console.log(`meetpunten.addMeetpuntenSelectie aangeroepen`);

    for(let meetpunt of this.meetpuntenSelectie){
      this.meetpunten.push(meetpunt);
    }

    this.meetpuntenSelectie = [];
    this.closebutton2.nativeElement.click();
  }

  // Meetpunten toevoegen aan UI, wordt aangeroepen vanuit child component Meetpunt
  addNewMeetpunt(meetpunt: Meetpunt): void{

    // Toevoegen in UI 
    this.meetpunten.push(meetpunt);

    // Verhoog variabele zodat child component weet dat het meetpunt is toegevoegd
    this.nrOfMeetpuntenCreated++;

    // Sluit modal
    this.closebutton2.nativeElement.click();
    this.closebutton.nativeElement.click(); 
  }

  cancelNewMeetpunt(): void{
    this.closebutton2.nativeElement.click();
    this.closebutton.nativeElement.click(); 
  }

  setMeetpuntenSelectie(meetpunten: Meetpunt[]): void{
    this.meetpuntenSelectie = meetpunten;
  }

  // verhoog nrOfMeetpuntChanges en emit event naar parent component (=meetplan), zodat deze de kostentabel kan bijwerken
  ordersChanged(): void{
    this.nrOfMeetpuntChanges++;
    //console.log(`Meetpunten.ordersChanged: ${this.nrOfMeetpuntChanges}`);
    this.meetpuntenChangedEvent.emit(this.nrOfMeetpuntChanges);

  }

}


