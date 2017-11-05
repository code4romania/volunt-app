import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-signup',
  templateUrl: './signup.component.html',
  styleUrls: ['./signup.component.scss']
})
export class SignupComponent implements OnInit {
  public user: any;

  constructor() { }

  ngOnInit() {
    this.user = {};
  }

  onSubmit(form) {
    console.log('signup', form.value);
  }
}
