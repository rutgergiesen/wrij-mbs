import { ComponentFixture, TestBed } from '@angular/core/testing';

import { MeetplannenComponent } from './meetplannen.component';

describe('MeetplannenComponent', () => {
  let component: MeetplannenComponent;
  let fixture: ComponentFixture<MeetplannenComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [MeetplannenComponent]
    });
    fixture = TestBed.createComponent(MeetplannenComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
