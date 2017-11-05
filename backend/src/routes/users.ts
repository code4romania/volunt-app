import { Express } from 'express'
import { UserController } from '../endpoints/_index'

export function routes(app: Express) {

  app.get('/api/users', UserController.UserGet.list)
  app.get('/api/users/:id', UserController.UserGet.get)
  app.post('/api/users', UserController.UserPost.create)
  app.post('/api/users/login', UserController.UserPost.login)

}
