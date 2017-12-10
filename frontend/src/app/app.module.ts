import {BrowserModule} from '@angular/platform-browser';
import {NgModule} from '@angular/core';
import {NgbModule} from '@ng-bootstrap/ng-bootstrap';
import {RouterModule} from '@angular/router';
import {FormsModule} from '@angular/forms';
import {HttpClientModule, HTTP_INTERCEPTORS} from '@angular/common/http';
import {AuthModule} from './auth/auth.module';

import {AppComponent} from './app.component';
import {NavbarComponent} from './components/navbar/navbar.component';

import {appRoutes} from './routes';
import {ProjectsComponent} from './components/projects/projects.component';
import {HomeComponent} from './components/home/home.component';
import {CardComponent} from './components/card/card.component';
import {LoginComponent} from './components/login/login.component';
import {UserProfileComponent} from './components/userProfile/userProfile.component';
import {UserService} from './components/userProfile/user.service';

import {AuthGuard} from './guards/auth.guard';
import {AuthenticationService} from './services/auth.service';


// 3rd party
import {SelectModule} from 'ng2-select';
import {ColabAppHttpInterceptor} from "./http.interceptor";

@NgModule({
  declarations: [
    AppComponent,
    NavbarComponent,
    ProjectsComponent,
    HomeComponent,
    CardComponent,
    LoginComponent,
    UserProfileComponent,
  ],
  imports: [
    BrowserModule,
    NgbModule.forRoot(),
    FormsModule,
    RouterModule.forRoot(appRoutes),
    HttpClientModule,
    SelectModule,
    AuthModule,
  ],
  providers: [
    AuthGuard,
    AuthenticationService,
    UserService,
    {
      provide: HTTP_INTERCEPTORS,
      useClass: ColabAppHttpInterceptor,
      multi: true,
    },
  ],
  bootstrap: [AppComponent]
})
export class AppModule {
}
