import { Express } from 'express'
import { UserController } from '../endpoints/_index'
import * as passport from 'passport'

export function routes(app: Express, authenticate: any) {

  app.get('/api/users', authenticate, UserController.UserGet.list)
  app.get('/api/users/:id', authenticate, UserController.UserGet.get)
  app.post('/api/users', UserController.UserPost.create)
  app.post('/api/users/login', authenticate, UserController.UserPost.login)

}
