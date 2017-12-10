import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss']
})
export class HomeComponent implements OnInit {
  public projects: any[];

  constructor() {
    this.projects = [
      {name: 'Monitorizare Vot', needsMembers: false},
      {name: 'Colabapp', needsMembers: true},
      {name: 'Brain Gain', needsMembers: true},
      {name: 'Centru Civic', needsMembers: false},
    ]
  }

  ngOnInit() {
  }

}
