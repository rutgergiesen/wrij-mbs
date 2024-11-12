import { Component, OnInit } from '@angular/core';
import { Observable, Subject } from 'rxjs';
import { debounceTime, distinctUntilChanged, switchMap } from 'rxjs/operators';
//import { Component, Input, ViewChild } from '@angular/core';

import { Meetpakket } from '../meetpakket';
import { MeetpakketService } from '../meetpakket.service';

@Component({
  selector: 'app-meetpakketten',
  templateUrl: './meetpakketten.component.html',
  styleUrl: './meetpakketten.component.css'
})
export class MeetpakkettenComponent {

  meetpakketten$!: Observable<Meetpakket[]>;
  private searchTerms = new Subject<string>();

  constructor(private meetpakketService: MeetpakketService,
  ){
  }

  ngOnInit() : void {

    this.meetpakketten$ = this.searchTerms.pipe(  
      // wait 300ms after each keystroke before considering the term
      debounceTime(300),

      // ignore new term if same as previous term
      distinctUntilChanged(),

      // switch to new search observable each time the term changes
      switchMap((term: string) => this.meetpakketService.searchMeetpakketten(term)),
    )
  }

  ngAfterViewInit() {
    this.search('');
  }

  search(term: string): void{
    this.searchTerms.next(term);
  }

  getMeetpakketten(meetpakketId?:Number): void{    
    //this.meetpakketService.getMeetpakketten().subscribe(meetpakketten => this.meetpakketten$ = meetpakketten);
  }

}
