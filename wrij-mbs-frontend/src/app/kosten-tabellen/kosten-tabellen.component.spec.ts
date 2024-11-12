import { ComponentFixture, TestBed } from '@angular/core/testing';

import { KostenTabellenComponent } from './kosten-tabellen.component';

describe('KostenTabellenComponent', () => {
  let component: KostenTabellenComponent;
  let fixture: ComponentFixture<KostenTabellenComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [KostenTabellenComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(KostenTabellenComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
