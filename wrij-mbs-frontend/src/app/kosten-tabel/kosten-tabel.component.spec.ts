import { ComponentFixture, TestBed } from '@angular/core/testing';

import { KostenTabelComponent } from './kosten-tabel.component';

describe('KostenTabelComponent', () => {
  let component: KostenTabelComponent;
  let fixture: ComponentFixture<KostenTabelComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [KostenTabelComponent]
    });
    fixture = TestBed.createComponent(KostenTabelComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
