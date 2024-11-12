import { ComponentFixture, TestBed } from '@angular/core/testing';

import { MeetpakkettenComponent } from './meetpakketten.component';

describe('MeetpakkettenComponent', () => {
  let component: MeetpakkettenComponent;
  let fixture: ComponentFixture<MeetpakkettenComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [MeetpakkettenComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(MeetpakkettenComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
