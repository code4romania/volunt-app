import { Express } from 'express'
import { AuthController } from '../endpoints/_index'
import * as passport from 'passport';

export function routes(app: Express) {

  app.post('/api/login', AuthController.login)
  app.get('/api/secret', passport.authenticate('jwt', { session: false }), AuthController.secret)
}
