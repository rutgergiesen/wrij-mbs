import { TestBed } from '@angular/core/testing';

import { AlternatieService } from './alternatie.service';

describe('AlternatieService', () => {
  let service: AlternatieService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(AlternatieService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
