import { Component } from '@angular/core';

import { Meetplan } from '../meetplan';
import { MeetplanService } from '../meetplan.service';

@Component({
  selector: 'app-kosten',
  templateUrl: './kosten.component.html',
  styleUrls: ['./kosten.component.css']
})
export class KostenComponent {
  meetplannen: Meetplan[] = [];

  currentDate = new Date();//
  currentYear = this.currentDate.getFullYear();
  startjaar: number | undefined = this.currentYear;
  eindjaar: number | undefined;
  status: string | undefined = 'Definitief';

  jaarOpties = ['2016', '2017', '2018', '2019', '2020', '2021', '2022', '2023', '2024', '2025', '2026', '2027', '2028', '2029', '2030', '2031', '2032', '2033', '2034', '2035', '2036', '2037'];
  typeOpties = ['', 'Project', 'Routine'];
  statusOpties = ['Concept', 'Definitief'];

  constructor(
    private meetplanService: MeetplanService){
  }

  // Meetplannen ophalen bij initialisatie van de component
  ngOnInit(){
    this.getMeetplannen();
    //this.getKosten();
  }

  // Meetplannen ophalen van de server via MeetplanService
  getMeetplannen(): void{
    this.meetplanService.getMeetplannen(this.status, this.startjaar, this.eindjaar)
      .subscribe(meetplannen => this.meetplannen = meetplannen);
  }

  // Verwijder filter Startjaar
  resetStartjaar(){
    this.startjaar = undefined;
    this.getMeetplannen();
  }

  // Verwijder filter Eindjaar
  resetEindjaar(){
    this.eindjaar = undefined;
    this.getMeetplannen();
  }

  // Verwijder filter Status
  resetStatus(){
    this.status = undefined;
    this.getMeetplannen();
  }

}
