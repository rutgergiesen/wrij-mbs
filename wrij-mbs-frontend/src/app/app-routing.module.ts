import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AuthGuard } from './utils/AuthGuard';
import { MeetplannenComponent } from './meetplannen/meetplannen.component';
import { MeetplanComponent } from './meetplan/meetplan.component';
import { MeetpuntenComponent } from './meetpunten/meetpunten.component';
import { KostenComponent } from './kosten/kosten.component';
import { MeetpakketComponent } from './meetpakket/meetpakket.component';
import { MeetpakkettenComponent } from './meetpakketten/meetpakketten.component';
import { LoginComponent } from './login/login.component';
import { LogoutComponent } from './logout/logout.component';

const routes: Routes = [
  { path: '', redirectTo: '/meetplannen', pathMatch: 'full' },
  { path: 'login', component: LoginComponent},
  { path: 'logout', component: LogoutComponent},
  { path: 'meetplannen', component: MeetplannenComponent,
    canActivate: [AuthGuard] },
  { path: 'meetlocaties', component: MeetpuntenComponent,
    canActivate: [AuthGuard] },
  { path: 'meetplan/:id', component: MeetplanComponent,
    canActivate: [AuthGuard] },
  { path: 'meetplan', component: MeetplanComponent,
    canActivate: [AuthGuard] },
  { path: 'kosten', component: KostenComponent,
    canActivate: [AuthGuard] },
  { path: 'meetpakketten', component: MeetpakkettenComponent,
    canActivate: [AuthGuard]},
  { path: 'meetpakket/:id', component: MeetpakketComponent,
    canActivate: [AuthGuard]},
  { path: 'meetpakket', component: MeetpakketComponent,
    canActivate: [AuthGuard]}
];

@NgModule({
  imports: [
    RouterModule.forRoot(routes)
  ],
  exports: [RouterModule]
})
export class AppRoutingModule { }
