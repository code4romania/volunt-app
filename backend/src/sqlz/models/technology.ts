import * as Sequelize from 'sequelize'
import * as technologies from '../../data/technologies.json'
import * as _ from 'lodash'

export interface TechnologyAttributes {
  name: string,
  type: string
}

export interface TechnologyInstance extends Sequelize.Instance<TechnologyAttributes> {
  id: string
  createdAt: Date
  updatedAt: Date
}

export default function defineTechnology(sequelize: Sequelize.Sequelize, DataTypes) {
  const types = (<any>technologies).types
  const Technology = sequelize.define('Technology', {
    name: DataTypes.ENUM(_.concat(types.FRONTEND, types.BACKEND)),
    type: DataTypes.ENUM(_.keys(types))
  }, {
    classMethods: {
        associate: function(models) {
          Technology.belongsToMany(models.User, {
            through: models.UserTechnologies
          })
        }
    }
  })
  return Technology
}
