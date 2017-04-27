Easypeasy.Comment = DS.Model.extend
  body:                DS.attr 'string'
  parent_id:           DS.attr 'number'
  parent_name:         DS.attr 'string'
  created_at:          DS.attr 'date'
  game:                DS.belongsTo('game', inverse: 'comments')