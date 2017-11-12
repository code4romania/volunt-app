'use strict';
module.exports = {
  up: function(queryInterface, Sequelize) {
    return queryInterface.createTable('Users', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      firstName: {
        type: Sequelize.STRING
      },
      lastName: {
        type: Sequelize.STRING
      },
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE
      },
      email: {
        allowNull: false,
        type: Sequelize.STRING(255),
        unique: true
      },
      password: {
        allowNull: false,
        type: Sequelize.STRING(255)
      },
      slackId: {
        type: Sequelize.STRING(255)
      },
      city: {
        type: Sequelize.STRING(50)
      },
      facebookUrl: {
        type: Sequelize.STRING(50)
      },
      linkedinUrl: {
        type: Sequelize.STRING(50)
      },
      twitterUrl: {
        type: Sequelize.STRING(50)
      },
      additionalSkills: {
        type: Sequelize.TEXT
      },
      joinReason: {
        type: Sequelize.TEXT
      }
    });
  },
  down: function(queryInterface, Sequelize) {
    return queryInterface.dropTable('Users');
  }
};
