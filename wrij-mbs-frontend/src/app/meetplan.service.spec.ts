import { TestBed } from '@angular/core/testing';

import { MeetplanService } from './meetplan.service';

describe('MeetplanService', () => {
  let service: MeetplanService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(MeetplanService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
