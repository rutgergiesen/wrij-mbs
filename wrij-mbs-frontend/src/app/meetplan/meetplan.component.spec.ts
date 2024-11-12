import { ComponentFixture, TestBed } from '@angular/core/testing';

import { MeetplanComponent } from './meetplan.component';


describe('MeetplanComponent', () => {
  let component: MeetplanComponent;
  let fixture: ComponentFixture<MeetplanComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [MeetplanComponent]
    });
    fixture = TestBed.createComponent(MeetplanComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
