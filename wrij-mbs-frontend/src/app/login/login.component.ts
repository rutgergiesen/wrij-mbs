import { Component, Input } from '@angular/core';
import { Router } from "@angular/router";

import { AuthService } from '../auth.service';
import { User } from '../user';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrl: './login.component.css'
})
export class LoginComponent {

  user: User = new User(0, '','');

  constructor(
    private authService: AuthService, private router: Router
  ) {}


  login(): void {
    const token = this.authService.login(this.user).subscribe(result => {this.router.navigate(['']);});
  }

}
