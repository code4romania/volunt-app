'use strict';
const data = require('../../data/technologies.json');
const _ = require('lodash');
module.exports = {
  up: function(queryInterface, Sequelize) {
    return queryInterface.createTable('Technologies', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      name: {
        type: Sequelize.ENUM(_.concat(data.types.FRONTEND, data.types.BACKEND, data.types.SOFT_SKILLS))
      },
      type: {
        type: Sequelize.ENUM(_.keys(data.types))
      },
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE
      }
    });
  },
  down: function(queryInterface, Sequelize) {
    return queryInterface.dropTable('Technologies');
  }
};
