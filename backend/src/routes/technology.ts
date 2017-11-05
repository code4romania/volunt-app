import { Express } from 'express'
import { TechnologyController } from '../endpoints/_index'

export function routes(app: Express) {

  app.get('/api/technologies', TechnologyController.list)
}
