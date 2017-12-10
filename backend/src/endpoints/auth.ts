import { Request, Response } from 'express'
import {UserDao} from '../dao/_index'
import * as jwt from 'jsonwebtoken'
import * as _ from 'lodash'

export function login(req: Request, res: Response) {
  let email, password
  if (req.body.email && req.body.password) {
    email = req.body.email
    password = req.body.password
  }

  UserDao.findByCredentials(email, password).then((user) => {
    if (user.password === req.body.password) {
      // from now on we'll identify the user by the id and the id is the only personalized value that goes into our token
      const payload = {id: user.id}
      const token = jwt.sign(payload, 'test')
      res.json(_.merge(user, {token: token}))
    } else {
      res.status(401).json({message: 'passwords did not match'})
    }
  }).catch((err) => {
    res.status(401).json({message: 'no such user found'})
  })
}

export function secret(req: Request, res: Response) {
  res.json({message: 'Success! You can not see this without a token'})
}
