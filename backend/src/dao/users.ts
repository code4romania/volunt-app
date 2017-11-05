import * as uuid from 'uuid'
import db from '../sqlz/models/_index'
import { UserInstance } from './../sqlz/models/user'

export function create(appUser: UserInstance): Promise<any> {
  return db.User
    .create(appUser)
}

export function findAll(): Promise<any> {
  return db.User
    .findAll({ include: [{ all: true }] })
}

export function find(id: string): Promise<any> {
  return db.User
    .findById(id)
}

export function login(appUser: UserInstance): Promise<any> {
  return db.User
    .findOne({
      where: {
        email: appUser.email,
        pwd: appUser.pwd
      }
    })
}
