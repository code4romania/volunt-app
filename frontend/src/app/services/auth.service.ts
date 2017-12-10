import {Injectable, OnInit} from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {Observable, Subject} from 'rxjs';
import 'rxjs/add/operator/map';

@Injectable()
export class AuthenticationService implements OnInit {
  public token: string;
  private currentUser = new Subject<any>();

  constructor(private http: HttpClient) {
    // set token if saved in local storage
    const currentUser = JSON.parse(localStorage.getItem('currentUser'));
    this.token = currentUser && currentUser.token;
  }

  ngOnInit() {
    this.currentUser.next(JSON.parse(localStorage.getItem('currentUser')));
  }

  getCurrentUser() {
    return this.currentUser.asObservable();
  }

  login(email: string, password: string): Observable<any> {
    return this.http.post('http://localhost:3000/api/login', {
      email: email,
      password: password
    })
      .map((response: any) => {
        // login successful if there's a jwt token in the response
        let token = response && response.token;
        if (token) {
          // set token property
          this.token = token;

          // store username and jwt token in local storage to keep user logged in between page refreshes
          localStorage.setItem('currentUser', JSON.stringify({email: email, token: token}));
          this.currentUser.next({email: email, token: token});

          // return true to indicate successful login
          return true;
        } else {
          // return false to indicate failed login
          return false;
        }
      });
  }

  logout(): void {
    // clear token remove user from local storage to log user out
    this.token = null;
    localStorage.removeItem('currentUser');
    this.currentUser.next(null);
  }
}
