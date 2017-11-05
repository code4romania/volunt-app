import { Request, Response } from 'express'
import { TechnologyDao } from '../dao/_index'

export function list(req: Request, res: Response) {
  return TechnologyDao
    .findAll()
    .then(users => res.status(200).send(users))
    .catch(error => res.boom.badRequest(error))
}
