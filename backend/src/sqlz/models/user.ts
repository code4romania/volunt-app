import * as Sequelize from 'sequelize'

export interface UserAttributes {
  id?: string
  firstName?: string
  lastName?: string
  email?: string
  pwd?: string
  slackId?: string
  city?: string
  facebookUrl?: string
  linkedinUrl?: string
  twitterUrl?: string
  additionalSkills?: string
  joinReason?: string
}

export interface UserInstance extends Sequelize.Instance<UserAttributes> {
  id: string
  createdAt: Date
  updatedAt: Date
  email: string
  pwd: string
}

export default function defineUser(sequelize: Sequelize.Sequelize, DataTypes) {
  const User = sequelize.define('User', {
    email: DataTypes.STRING,
    pwd: DataTypes.STRING,
    firstName: DataTypes.STRING,
    lastName: DataTypes.STRING,
    slackId: DataTypes.STRING(255),
    city: DataTypes.STRING(50),
    facebookUrl: DataTypes.STRING(50),
    linkedinUrl: DataTypes.STRING(50),
    twitterUrl: DataTypes.STRING(50),
    additionalSkills: DataTypes.TEXT,
    joinReason: DataTypes.TEXT
  }, {
    classMethods: {
      associate: function(models) {
        User.belongsToMany(models.Technology, {
          through: 'UserTechnologies',
          as: 'technologies'
        })
      }
    }
  });
  return User
}
