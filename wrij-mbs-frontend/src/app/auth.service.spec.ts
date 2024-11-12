import { TestBed } from '@angular/core/testing';

import { KostenService } from './kosten.service';

describe('KostenService', () => {
  let service: KostenService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(KostenService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
