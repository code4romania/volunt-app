import { Express } from 'express'
import { AuthController } from '../endpoints/_index'
import {check} from 'express-validator/check'

export function routes(app: Express, autheniticate: any) {
  app.post('/api/login', [
    check('email').isEmail().withMessage('must be an email'),
    check('password').isLength({min: 5})
  ], AuthController.login)
  app.get('/api/secret', autheniticate, AuthController.secret)
}
