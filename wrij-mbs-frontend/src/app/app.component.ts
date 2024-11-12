import { Component, OnInit } from '@angular/core';
import { Observable } from 'rxjs';

import { AuthService } from './auth.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent implements OnInit{
  title = 'WRIJ Meetplan beheersysteem';

  //meetplannen$!: Observable<Meetplan[]>;
  userLoggedIn!: Observable<boolean>;

  constructor(
    private authService: AuthService){
  }

  ngOnInit(): void {
    //this.userLoggedIn$ = this.authService.isLoggedIn();
    //this.meetplannen$ = this.searchTerms.pipe(  
  }

  /*private meetpakketten: Meetpakket[] = []; 

  constructor(
    private meetpakketService: MeetpakketService){
  }

  ngOnInit(): void {
    this.setMeetpakketten();
  }

  public setMeetpakketten(){
    this.meetpakketService.getMeetpakketten()
        .subscribe(meetpakketten => {
          this.meetpakketten = meetpakketten;
        });

  }

  public getMeetpakketten() : Meetpakket[]{
    return this.meetpakketten;
  }*/
}
