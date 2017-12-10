import {Injectable} from '@angular/core';
import {HttpInterceptor, HttpRequest, HttpEvent, HttpHandler} from '@angular/common/http';
import {Observable} from 'rxjs/Observable';

@Injectable()
export class ColabAppHttpInterceptor implements HttpInterceptor {

  constructor(
  ) {
  }

  intercept(req: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
    const user = JSON.parse(localStorage.getItem('currentUser'));
    const authHeader = user && user['token'];
    if (authHeader) {
      const authReq = req.clone({
        headers: req.headers.set('Authorization', `JWT ${authHeader}`)
      });
      return next.handle(authReq);
    } else {
      return next.handle(req);
    }
  }
}
