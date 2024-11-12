import { Component, Input, OnInit, OnChanges, SimpleChanges } from '@angular/core';

import { KostenRecord } from '../kosten';
import { KostenService } from '../kosten.service';
import { Alternatie } from '../alternatie';

@Component({
  selector: 'app-kosten-tabel',
  templateUrl: './kosten-tabel.component.html',
  styleUrls: ['./kosten-tabel.component.css']
})
export class KostenTabelComponent implements OnInit, OnChanges {

  @Input() meetplanId: number = 0;
  @Input() startjaar: number | undefined;
  @Input() eindjaar: number | undefined;
  @Input() status: string | undefined;
  @Input() alternatie: Alternatie = {alternatie: 0, jaren: []};

  @Input() nrOfKostenUpdates: number = 0;

  kosten: KostenRecord[] = [];

  constructor(private kostenService: KostenService){
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
    //this.getAlternaties();
    this.getKosten();

   //console.log('Kosten: ' + JSON.stringify(this.kosten));
    //console.log('Alternaties: ' + JSON.stringify(this.alternaties));
  }

  // als een input parameter verandert, opnieuw kosten ophalen
  ngOnChanges(changes: SimpleChanges) {
    // for (const propName in changes) {
    //   const chng = changes[propName];
    //   const cur  = JSON.stringify(chng.currentValue);
    //   const prev = JSON.stringify(chng.previousValue);
    //   console.log(`${propName}: currentValue = ${cur}, previousValue = ${prev}`);
    // }
    //this.getAlternaties(this.alternatie);
    this.getKosten();
  }

  getKosten(): void{
    this.kostenService.getKosten(this.meetplanId, this.startjaar, this.eindjaar, this.status)
        .subscribe(kosten => {this.kosten = kosten});
  }

}
