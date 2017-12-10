import {Injectable} from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {Observable} from 'rxjs/Observable';

@Injectable()
export class UserService {
  constructor(
    private httpClient: HttpClient,
  ) { }

  public createUser(user: any): Observable<any> {
    console.log('user', user);
    return this.httpClient
      // .post(`${window['ENV'].USERS_URL}/`, user);
      .post(`http://localhost:3000/api/users`, user);
  }

  public getUsers(): Observable<any> {
    return this.httpClient
    // .post(`${window['ENV'].USERS_URL}/`, user);
      .get(`http://localhost:3000/api/users`);
  }
}
