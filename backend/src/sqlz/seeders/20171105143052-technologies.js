'use strict';
const data = require('../../data/technologies.json')
const _ = require('lodash');
module.exports = {
  up: function (queryInterface, Sequelize) {
    var output = [];
    _.each(data.types, (values, key) => {
      _.each(values, (name) => {
        output.push({type: key, name: name, createdAt: new Date(), updatedAt: new Date()});
      });
    });

    return queryInterface.bulkInsert('Technologies', output, {});
  },

  down: function (queryInterface, Sequelize) {
    return queryInterface.bulkDelete('Technologies', null, {});
  }
};
