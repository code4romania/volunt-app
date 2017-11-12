import {Routes} from '@angular/router';
import {ProjectsComponent} from "./components/projects/projects.component";
import {HomeComponent} from "./components/home/home.component";
import {LoginComponent} from "./components/login/login.component";
import {SignupComponent} from "./components/signup/signup.component";
import {AuthGuard} from "./guards/auth.guard";

export const appRoutes: Routes = [
  {path: 'projects', component: ProjectsComponent, canActivate: [AuthGuard]},
  {path: 'home', component: HomeComponent},
  {path: 'login', component: LoginComponent},
  {path: 'signup', component: SignupComponent},
  {path : '**', redirectTo: 'home'}
];
