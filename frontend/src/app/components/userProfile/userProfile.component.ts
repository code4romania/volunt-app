import {Component, OnInit} from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {User} from '../../models/user.model';
import {UserService} from './user.service';

@Component({
  selector: 'app-signup',
  templateUrl: './userProfile.component.html',
  styleUrls: ['./userProfile.component.scss']
})
export class UserProfileComponent implements OnInit {
  public user: User;
  public items: Array<any> = [
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

  constructor(
    private http: HttpClient,
    private userService: UserService) {
  }

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
    console.log('userProfile', this.user);
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
    this.userService.createUser(request)
      .subscribe((response) => {
        console.log('response', response);
      });
  }

  public refreshValue(value: any, type: string): void {
    this.user.skills[type] = value;
  }

  public selected(value: any): void {
    console.log('Selected value is: ', value);
  }

  public removed(value: any): void {
    console.log('Removed value is: ', value);
  }
}
