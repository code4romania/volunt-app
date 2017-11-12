import { Request, Response } from 'express'
import { UserDao } from '../../dao/_index'

export function create(req: Request, res: Response) {
  req.getValidationResult()
    .then(function(result) {
      if (result.isEmpty()) {
        return UserDao.create(req.body)
          .then(appuser => res.status(201).send(appuser))
          .catch(error => res.boom.badRequest(error))
      } else {
        res.boom.badRequest('Validation errors', result.mapped())
      }
    })
}

export function login(req: Request, res: Response) {
  req.getValidationResult()
    .then(function(result) {
      if (result.isEmpty()) {
        return UserDao.login(req.body)
      } else {
        res.boom.badRequest('Validation errors', result.mapped())
      }
    })
    .then(appuser => res.status(200).send(appuser))
    .catch(error => res.boom.badRequest(error))
}
