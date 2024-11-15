import { Component } from '@angular/core';

import { LoggingService } from '../message.service';
import { ToastService } from '../toast.service';

@Component({
  selector: 'app-messages',
  templateUrl: './messages.component.html',
  styleUrls: ['./messages.component.css']
})
export class MessagesComponent {

  constructor(public loggingService: LoggingService) {}
}
