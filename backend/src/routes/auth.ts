import { Express } from 'express'
import { AuthController } from '../endpoints/_index'
import * as passport from 'passport'

export function routes(app: Express, autheniticate: any) {
  app.post('/api/login', AuthController.login)
  app.get('/api/secret', autheniticate, AuthController.secret)
}
