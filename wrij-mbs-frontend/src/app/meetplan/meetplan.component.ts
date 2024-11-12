import { Component, Input, /*Output, EventEmitter*/ } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { Location } from '@angular/common';
import { NgForm } from '@angular/forms';

import { Meetplan } from '../meetplan';
import { MeetplanService } from '../meetplan.service';

import { Meetpakket } from '../meetpakket';
import { MeetpakketService } from '../meetpakket.service';

@Component({
  selector: 'app-meetplan',
  templateUrl: './meetplan.component.html',
  styleUrls: ['./meetplan.component.css'],
})
export class MeetplanComponent {

  @Input() meetplan?: Meetplan;

  jaarOpties = [undefined, '2016', '2017', '2018', '2019', '2020', '2021', '2022', '2023', '2024', '2025', '2026', '2027', '2028', '2029', '2030', '2031', '2032', '2033', '2034', '2035', '2036', '2037'];
  typeOpties = [undefined, 'Project', 'Routine'];
  statusOpties = ['Concept', 'Definitief'];
  meetpakketten : Meetpakket[] = [];

  nrOfMeetpuntenChanges = 0;
  isNewMeetplan = false;
  submitted = false;

  onSubmit(form: NgForm) { 
    this.submitted = true; 
  }

  constructor(
    private route: ActivatedRoute,
    private meetplanService: MeetplanService,
    private meetpakketService: MeetpakketService,
    private location: Location,
    private router: Router
  ) {}

  ngOnInit(): void {
    const id = Number(this.route.snapshot.paramMap.get('id'));

    if (id){
      this.getMeetplan(id);
    }
    else{
      this.isNewMeetplan = true;
      this.meetplan = new Meetplan(0,'','','','','',undefined, undefined,'',undefined, undefined, undefined, 'Concept');
    }

    this.getMeetpakketten();
  }

  getMeetplan(id:number): void {
      this.meetplanService.getMeetplan(id)
        .subscribe(meetplan => this.meetplan = meetplan);
  }

  getMeetpakketten(): void {
    this.meetpakketService.getMeetpakketten()
      .subscribe(meetpakketten => this.meetpakketten = meetpakketten);
}

  cancel(): void {
    this.ngOnInit();
  }

  goBack(): void {
    this.location.back();
  }

  save(): void{
    if(this.meetplan) {
      this.meetplanService.updateMeetplan(this.meetplan)
        .subscribe();
        //.subscribe(() => this.goBack());
    }
  }

  add(): void {
    if (!this.meetplan) { return; }
    this.meetplanService.addMeetplan(this.meetplan)
      .subscribe(addedMeetplan => this.router.navigate(['/meetplan', addedMeetplan.id])); 
  }

  delete(): void{
    if(!this.meetplan){return; }
    this.meetplanService.deleteMeetplan(this.meetplan)
      .subscribe(() => this.goBack());
  }

  // aantal meetpuntenwijzigingen met 1 ophogen, zodat kostentabel wordt bijgewerkt
  updateKosten(nrOfChanges: number): void{
    //console.log(`updateKosten aangeroepen met nrOfChanges=${nrOfChanges}`);
    this.nrOfMeetpuntenChanges++;
  }
}
