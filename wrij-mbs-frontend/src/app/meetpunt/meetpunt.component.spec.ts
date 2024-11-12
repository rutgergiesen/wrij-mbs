import { ComponentFixture, TestBed } from '@angular/core/testing';

import { MeetpuntComponent } from './meetpunt.component';


describe('MeetpuntComponent', () => {
  let component: MeetpuntComponent;
  let fixture: ComponentFixture<MeetpuntComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [MeetpuntComponent]
    });
    fixture = TestBed.createComponent(MeetpuntComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
