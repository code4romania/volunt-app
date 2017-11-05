import { Request, Response } from 'express'
import { UserDao } from '../../dao/_index'

export function list(req: Request, res: Response) {
  return UserDao
    .findAll()
    .then(users => res.status(200).send(users))
    .catch(error => res.boom.badRequest(error))
}

export function get(req: Request, res: Response) {
  return UserDao
    .find(req.params.id)
    .then(user => res.status(200).send(user))
    .catch(error => res.boom.badRequest(error))
}
