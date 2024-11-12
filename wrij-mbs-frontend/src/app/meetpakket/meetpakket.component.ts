import { Component, Input, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { Location } from '@angular/common';
import { NgForm } from '@angular/forms';

import { Meetpakket } from '../meetpakket';
import { MeetpakketService } from '../meetpakket.service';


//import { Order } from '../order';

@Component({
  selector: 'app-meetpakket',
  templateUrl: './meetpakket.component.html',
  styleUrls: ['./meetpakket.component.css']
})
export class MeetpakketComponent implements OnInit {

  @Input() meetpakket: Meetpakket = {
    id: 0,
    naam: '',
    omschrijving: '',
    type: 'Individueel',
    valuta: 'ILOW',
    stukprijs: 0
  };

  isEditMode = false; // Toggle between POST and PUT based on this flag

  constructor(
    private meetpakketService: MeetpakketService,
    private route: ActivatedRoute,
  ) {}

  ngOnInit(): void {
    // Optionally, you can load an item to edit by setting this.item and this.isEditMode = true
    // For example, fetching item by id and setting its values in the form.

    // get id from URL
    const id = Number(this.route.snapshot.paramMap.get('id'));

    // als meetpakket niet is meegegeven, maar er is wel een id
    if (id > 0){
      this.getMeetpakket(id); 
      this.isEditMode = true;
    }
  }

  // meetpakket ophalen en als huidig meetpakket object zetten
  getMeetpakket(id:number): void {
    this.meetpakketService.getMeetpakket(id)
      .subscribe(meetpakket => this.meetpakket = meetpakket);
}

  onSubmit(form: NgForm): void {
    if (this.isEditMode) {
      // If in edit mode, perform PUT request
      this.meetpakketService.updateMeetpakket(this.meetpakket).subscribe();
    } 
    else {
      // If in create mode, perform POST request
      this.meetpakketService.addMeetpakket(this.meetpakket).subscribe();
    } 
  }
}