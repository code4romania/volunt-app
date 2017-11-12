import { Express } from 'express'
import { TechnologyController } from '../endpoints/_index'
import * as passport from 'passport'

export function routes(app: Express, authenticate: any) {

  app.get('/api/technologies', authenticate, TechnologyController.list)
}
