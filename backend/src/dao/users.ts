import * as uuid from 'uuid'
import db from '../sqlz/models/_index'
import { UserInstance } from '../sqlz/models/user'
import * as _ from 'lodash'
import { Transaction } from 'sequelize'

export function create(appUser: UserInstance): Promise<any> {

  return db.sequelize.transaction((t: Transaction) => {
    return db.User
      .create(appUser).then((response) => {
      return Promise.all(_.map(appUser.technologies, (technology) => {
        return db.UserTechnologies.create({
          TechnologyId: technology.id,
          UserId: response.id,
          level: technology.level
        }).catch(() => {
          t.rollback()
        })
      }))
    })
  })
}

export function findAll(): Promise<any> {
  return db.User
    .findAll({ include: [db.Technology] })
}

export function find(id: string): Promise<any> {
  return db.User
    .findById(id, {include: [{
      model: db.Technology
    }]})
}

export function findByCredentials(email: string, password: string): Promise<any> {
  return db.User.findOne({where: {
    email: email,
    password: password
  }})
}

export function login(appUser: UserInstance): Promise<any> {
  return db.User
    .findOne({
      where: {
        email: appUser.email,
        pwd: appUser.password
      }
    })
}
