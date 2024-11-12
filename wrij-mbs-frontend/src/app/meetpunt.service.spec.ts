import { TestBed } from '@angular/core/testing';

import { MeetpuntService } from './meetpunt.service';

describe('MeetpuntService', () => {
  let service: MeetpuntService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(MeetpuntService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
