import { ComponentFixture, TestBed } from '@angular/core/testing';

import { MeetpakketComponent } from './meetpakket.component';

describe('MeetpakketComponent', () => {
  let component: MeetpakketComponent;
  let fixture: ComponentFixture<MeetpakketComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [MeetpakketComponent]
    });
    fixture = TestBed.createComponent(MeetpakketComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
