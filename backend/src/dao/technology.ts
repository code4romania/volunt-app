import * as uuid from 'uuid'
import db from '../sqlz/models/_index'

export function findAll(): Promise<any> {
  return db.Technology
    .findAll()
}
