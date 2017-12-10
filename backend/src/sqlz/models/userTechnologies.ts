import * as Sequelize from 'sequelize'
import * as _ from 'lodash'
import * as technologies from '../../data/technologies.json'

export interface UserTechnologiesAttributes {
}

export interface UserTechnologiesInstance extends Sequelize.Instance<UserTechnologiesAttributes> {
  createdAt: Date
  updatedAt: Date
}

export default function defineTechnology(sequelize: Sequelize.Sequelize, DataTypes) {
  const levels = (<any>technologies).levels;

  const UserTechnologies = sequelize.define('UserTechnologies', {
    level: {
      type: DataTypes.ENUM,
      values: levels
    }
  })
  return UserTechnologies
}
