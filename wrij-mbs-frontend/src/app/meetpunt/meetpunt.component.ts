import { Component, Input, OnChanges, inject, AfterViewInit, ViewChild } from '@angular/core';
import { Output, EventEmitter } from '@angular/core';

import { Meetpunt } from '../meetpunt';
import { MeetpuntService } from '../meetpunt.service';
import { FormControl, NgModel, NgForm } from '@angular/forms';

interface PrijsType {
  value: string;
  viewValue: string;
}

@Component({
  selector: 'app-meetpunt',
  templateUrl: './meetpunt.component.html',
  styleUrls: ['./meetpunt.component.css']
})
export class MeetpuntComponent {
//implements AfterViewInit {

  @Input() meetpunt: Meetpunt = new Meetpunt(0,'','','','','');
  @Input() nrOfMeetpuntenCreated = 0;
  @Output() newMeetpuntEvent = new EventEmitter<Meetpunt>();
  @Output() meetpuntCancelledEvent = new EventEmitter<void>();

  isEditMode = false; // Toggle between POST and PUT based on this flag

  constructor(private meetpuntService: MeetpuntService) {
  }

  ngOnInit(): void {
    // Als het niet om een nieuw meetpunt gaat, zet vlag isEditMode
    if (this.meetpunt.id > 0){
      this.isEditMode = true;
    }  
  }

  // Als het formulier wordt geannuleerd, trigger meetpuntCancelledEvent bij parent component (=meetpunten)
  onCancel(){
    this.meetpuntCancelledEvent.emit();
  }

  // als het formulier valide is, trigger newMeetpuntEvent bij parent component (=meetpunten)
  onSubmit(form: NgForm){  
    // if (meetpuntform.checkValidity())
    //   this.newMeetpuntEvent.emit(this.meetpunt);
    if (this.isEditMode) {
      // If in edit mode, perform PUT request
      this.meetpuntService.updateMeetpunt(this.meetpunt).subscribe();
    } 
    else {
      // If in create mode, perform POST request, daarna nieuwe meetpunt doorgeven (emit) naar parent object 
      this.meetpuntService.addMeetpunt(this.meetpunt).subscribe((addedMeetpunt) => this.newMeetpuntEvent.emit(addedMeetpunt));
    } 
  }
}
