import {Component, OnInit} from '@angular/core';
import {AuthenticationService} from '../../services/auth.service';
import {Observable} from "rxjs/Observable";

@Component({
  selector: 'navbar',
  templateUrl: './navbar.component.html',
  styleUrls: ['./navbar.component.scss']
})
export class NavbarComponent implements OnInit {
  public $currentUser: Observable<any>;

  constructor(
    private authenticationService: AuthenticationService,
  ) {
  }

  ngOnInit() {
    this.$currentUser = this.authenticationService.getCurrentUser();
    this.$currentUser.subscribe((x) => console.log('x', x));
  }

  logout() {
    console.log('logout');
    this.authenticationService.logout();
  }

}
