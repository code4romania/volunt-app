import * as Sequelize from 'sequelize'

export interface ProjectAttributes {
  name: string,
  description: string,
  startDate: Date,
  status: any,
  techStack: any
}

export interface ProjectInstance extends Sequelize.Instance<ProjectAttributes> {
  id: string
  createdAt: Date
  updatedAt: Date
}

export default function defineProject(sequelize: Sequelize.Sequelize, DataTypes) {
  const Project = sequelize.define('Project', {
    name: DataTypes.STRING,
    description: DataTypes.TEXT,
    startDate: DataTypes.DATE,
    status: DataTypes.JSON,
    techStack: DataTypes.JSON
  }, {
    classMethods: {
      associate: function(models) {
        // associations can be defined here
      }
    }
  })
  return Project
}

