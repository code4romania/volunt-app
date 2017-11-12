import * as winston from 'winston'
import { Express, Request, Response } from 'express'
import * as UserRoutes from './users'
import * as TechnologyRoutes from './technology'
import * as AuthRoutes from './auth'
import {login} from '../endpoints/auth'
import * as passport from 'passport'

export function initRoutes(app: Express) {
  winston.log('info', '--> Initialisations des routes')

  app.get('/api', (req: Request, res: Response) => res.status(200).send({
    message: 'server is running!'
  }))

  let authenticate = passport.authenticate('jwt', { session: false })
  UserRoutes.routes(app, authenticate)
  TechnologyRoutes.routes(app, authenticate)
  AuthRoutes.routes(app, authenticate)

  app.all('*', (req: Request, res: Response) => res.boom.notFound())
}
