import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ZoekMeetpuntenComponent } from './zoek-meetpunten.component';

describe('ZoekMeetpuntenComponent', () => {
  let component: ZoekMeetpuntenComponent;
  let fixture: ComponentFixture<ZoekMeetpuntenComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [ZoekMeetpuntenComponent]
    });
    fixture = TestBed.createComponent(ZoekMeetpuntenComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
