import { Component, OnInit } from '@angular/core';
import { AuthenticationService } from "../../services/auth.service";
import { Router } from '@angular/router';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent implements OnInit {
  public loginForm: any;
  public user: any;
  public error: string = '';
  public loading: boolean = false;
  constructor(
    private router: Router,
    private authenticationServer: AuthenticationService
  ) { }

  ngOnInit() {
    this.user = {};
  }

  onSubmit() {
    this.loading = true;
    console.log('x', this.user);
    this.authenticationServer.login(this.user.email, this.user.password)
      .subscribe((result) => {
        if (result) {
          this.router.navigate(['/home']);
        } else {
          this.error = 'Your credentials are invalid';
          this.loading = false;
        }
      });
  }
}
