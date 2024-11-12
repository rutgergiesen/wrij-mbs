import { ComponentFixture, TestBed } from '@angular/core/testing';

import { MeetpuntenComponent } from './meetpunten.component';

describe('MeetpuntenComponent', () => {
  let component: MeetpuntenComponent;
  let fixture: ComponentFixture<MeetpuntenComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [MeetpuntenComponent]
    });
    fixture = TestBed.createComponent(MeetpuntenComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
