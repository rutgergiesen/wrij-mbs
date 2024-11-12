import { TestBed } from '@angular/core/testing';

import { MeetpakketService } from './meetpakket.service';

describe('MeetpakketService', () => {
  let service: MeetpakketService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(MeetpakketService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
