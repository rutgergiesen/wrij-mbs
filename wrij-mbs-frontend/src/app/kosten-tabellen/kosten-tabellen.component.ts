import { Component, Input, OnInit, } from '@angular/core';

import { Alternatie } from '../alternatie';
import { AlternatieService } from '../alternatie.service';

@Component({
  selector: 'app-kosten-tabellen',
  templateUrl: './kosten-tabellen.component.html',
  styleUrl: './kosten-tabellen.component.css'
})
export class KostenTabellenComponent implements OnInit {
  
  @Input() meetplanId: number = 0;
  @Input() startjaar: number | undefined;
  @Input() eindjaar: number | undefined;
  @Input() status: string | undefined;
  @Input() nrOfKostenUpdates: number = 0;

  //alternaties: Alternatie[] = [];

  constructor(private alternatieService: AlternatieService){
  }

  ngOnInit(){
    // Als meetplanId > 0, alternatie ophalen
    //if (this.meetplanId > 0){
      // this.getAlternaties();
      // console.log('Alternaties: ', JSON.stringify(this.alternaties));
      
      // if (this.checkForAlternatie('tweejaarlijks')){
      //   console.log('Tweejaarlijks: true');
      // }
    //}
    //this.getKostenRegels();


   //console.log('Kosten: ' + JSON.stringify(this.kosten));
    //console.log('Alternaties: ' + JSON.stringify(this.alternaties));
  }

  // getAlternaties(): void{
  //   this.alternatieService.getAlternaties(this.meetplanId)
  //       .subscribe(alternaties => {this.alternaties = alternaties, console.log('Alternaties: ', JSON.stringify(alternaties))});
  // }

  // checkForAlternatie(alternatie: number): boolean{
  //   return this.alternaties.some(
  //     a => a.alternatie === alternatie,
  //   );
  //}
}
