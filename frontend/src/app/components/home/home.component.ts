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
      {name: 'Monitorizare Vot', mainPositions: [true, true, false, true, true]},
      {name: 'Colabapp', mainPositions: [true, false, false, true, true]},
      {name: 'Brain Gain', mainPositions: [true, true, false, true, true]},
      {name: 'Centru Civic', mainPositions: [true, true, false, true, true]},
    ]
  }

  ngOnInit() {
  }

}
