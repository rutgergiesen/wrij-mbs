import { ComponentFixture, TestBed } from '@angular/core/testing';

import { KostenComponent } from './kosten.component';

describe('KostenComponent', () => {
  let component: KostenComponent;
  let fixture: ComponentFixture<KostenComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [KostenComponent]
    });
    fixture = TestBed.createComponent(KostenComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
