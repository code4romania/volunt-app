import * as fs from 'fs'
import * as path from 'path'
import * as Sequelize from 'sequelize'

const config = require('../config/config.json')

// Import model specification from its own definition file.
import { UserInstance, UserAttributes } from './user'
import { TechnologyInstance, TechnologyAttributes } from './technology'
import { UserTechnologiesAttributes, UserTechnologiesInstance } from './userTechnologies'
import {SequelizeStatic} from 'sequelize'

interface DbConnection {
  User: Sequelize.Model<UserInstance, UserAttributes>
  Technology: Sequelize.Model<TechnologyInstance, TechnologyAttributes>
  UserTechnologies: Sequelize.Model<UserTechnologiesInstance, UserTechnologiesAttributes>,
  sequelize: Sequelize.Sequelize
}
let db = {}

const dbConfig = config[process.env.NODE_ENV]
const sequelize = new Sequelize(
  dbConfig['database'],
  dbConfig['username'],
  dbConfig['password'],
  dbConfig
)

const basename = path.basename(module.filename)
fs
  .readdirSync(__dirname)
  .filter(function(file) {
    return (file.indexOf('.') !== 0) && (file !== basename) && (file.slice(-3) === '.js')
  })
  .forEach(function(file) {
    const model = sequelize['import'](path.join(__dirname, file))
    // NOTE: you have to change from the original property notation to
    // index notation or tsc will complain about undefined property.
    db[model['name']] = model
  })

Object.keys(db).forEach(function(modelName) {
  if (db[modelName].associate) {
    db[modelName].associate(db)
  }
})

db['sequelize'] = sequelize

export default <DbConnection>db
