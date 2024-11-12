import { Component, OnInit } from '@angular/core';
import { Observable, Subject } from 'rxjs';
import { debounceTime, distinctUntilChanged, switchMap } from 'rxjs/operators';

import { Meetplan } from '../meetplan';
import { MeetplanService } from '../meetplan.service';

@Component({
  selector: 'app-meetplannen',
  templateUrl: './meetplannen.component.html',
  styleUrls: ['./meetplannen.component.css']
})
export class MeetplannenComponent implements OnInit {
  
  meetplannen$!: Observable<Meetplan[]>;
  private searchTerms = new Subject<string>();

  constructor(private meetplanService: MeetplanService) {
  };

  ngOnInit() : void {

    this.meetplannen$ = this.searchTerms.pipe(  
      // wait 300ms after each keystroke before considering the term
      debounceTime(300),

      // ignore new term if same as previous term
      distinctUntilChanged(),

      // switch to new search observable each time the term changes
      switchMap((term: string) => this.meetplanService.searchMeetplannen(term)),
    )
  }

  // na initialisatie van de component, zoek alle meetplannen
  ngAfterViewInit() {
    this.search('');
  }

  search(term: string): void{
    this.searchTerms.next(term);
  }
}