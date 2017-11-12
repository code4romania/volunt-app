import {Skill} from './skill.model';

export interface User {
  firstName?: string;
  lastName?: string;
  email?: string;
  phone?: string;
  password?: string;
  otherSkills?: string;
  city?: string;
  motivation?: string;
  technologies?: any[];
  skills: {
    senior: Skill[],
    medium: Skill[],
    junior: Skill[],
    wannabe: Skill[]
  }
}
