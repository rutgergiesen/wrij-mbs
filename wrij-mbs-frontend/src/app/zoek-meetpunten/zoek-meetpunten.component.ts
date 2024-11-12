import { Component, OnInit, Output, EventEmitter, Input  } from '@angular/core';

import { Observable, Subject } from 'rxjs';

import {
  debounceTime, distinctUntilChanged, switchMap
} from 'rxjs/operators';

import { Meetpunt } from '../meetpunt';
import { MeetpuntService } from '../meetpunt.service';

@Component({
  selector: 'app-zoek-meetpunten',
  templateUrl: './zoek-meetpunten.component.html',
  styleUrls: ['./zoek-meetpunten.component.css']
})

export class ZoekMeetpuntenComponent implements OnInit {
  meetpunten$!: Observable<Meetpunt[]>;
  meetpuntenSelectie: Meetpunt[] = [];
  private searchTerms = new Subject<string>();

  @Input() meetplanId?: Number = 0;
  @Output() selectedMeetpuntenEvent = new EventEmitter<Meetpunt[]>();

  //meetpunten: Meetpunt[] = [];

  constructor(
    private meetpuntService: MeetpuntService,
  ){
  }

  // Push a search term into the observable stream.
  search(term: string): void {
    this.searchTerms.next(term);
  }

  ngOnInit(): void {
    this.meetpunten$ = this.searchTerms.pipe(
      // wait 300ms after each keystroke before considering the term
      debounceTime(300),

      // ignore new term if same as previous term
      distinctUntilChanged(),

      // switch to new search observable each time the term changes
      switchMap((term: string) => this.meetpuntService.searchMeetpunten(term, this.meetplanId)),
    );
  }

  // Na initialisatie van de component, zoek alle meetpunten
  ngAfterViewInit() {
    this.search('');
  }

  /* 
  Als het meetpunt nog niet is geselecteerd, dan selecteren en toevoegen aan geselecteerde meetpunten. 
  Als het meetpunt al is geselecteerd, dan deselecteren en verwijderen uit array met geslecteerde meetpunten. 
  */
  selectMeetpunt(meetpunt: Meetpunt){

//    console.log(`selectedMeetpunt ${JSON.stringify(meetpunt)}`);
    // TODO meetpunt doorgeven aan parent component en daar toevoegen aan meetplan 
    if (meetpunt.isSelected === false || meetpunt.isSelected === undefined){
      meetpunt.isSelected = true;
      this.meetpuntenSelectie.push(meetpunt);
    }
    else {
      meetpunt.isSelected = false;
      const removeIndex = this.meetpuntenSelectie.findIndex( item => item.id === meetpunt.id );
      this.meetpuntenSelectie.splice(removeIndex, 1)
    }

    //console.log('Meetpuntenselectie: '+JSON.stringify(this.meetpuntenSelectie));
    this.setSelectedMeetpunten();
  }

  // Deel de geslecteerde meetpunten (array) met parent object
  setSelectedMeetpunten(){
    this.selectedMeetpuntenEvent.emit(this.meetpuntenSelectie);
  }



  // getMeetpunten(searchString: string): void{    
  //   this.meetpuntService.getMeetpunten()
  //     .subscribe(meetpunten => {this.meetpunten = meetpunten});
  // }
}
