import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { User } from '../../models/user.model';

@Component({
  selector: 'app-signup',
  templateUrl: './signup.component.html',
  styleUrls: ['./signup.component.scss']
})
export class SignupComponent implements OnInit {
  public user: User;
  public items:Array<any> = [
    {
      id: '1',
      text: 'AngularJs'
    },
    {
      id: '2',
      text: 'Angular 4'
    },
    {
      id: '3',
      text: 'ExpressJs'
    }
  ];

  constructor(private http: HttpClient) { }

  ngOnInit() {
    this.user = {
      firstName: 'Razvan',
      lastName: 'Ciuca',
      email: 'a@a.com',
      city: 'Bucuresti',
      password: 'qwerty',
      skills: {
        senior: [],
        medium: [],
        junior: [],
        wannabe: [],
      }
    };
  }

  onSubmit(form) {
    console.log('signup', this.user);
    const request = Object.assign({}, this.user);
    request.technologies = Object.keys(request.skills).reduce((skills, level) => {
      request.skills[level].forEach((skill) => {
        skills.push({
          id: skill.id,
          level: level.toUpperCase(),
        })
      });
      return skills;
    }, []);
    delete request.skills;
    console.log('request', request);
    this.http.post('http://localhost:3000/api/users', request)
      .subscribe((response) => {
        console.log('response', response);
      });
  }

  public refreshValue(value:any, type:string):void {
    this.user.skills[type] = value;
  }

  public selected(value:any):void {
    console.log('Selected value is: ', value);
  }

  public removed(value:any):void {
    console.log('Removed value is: ', value);
  }
}
