Easypeasy.Comment = DS.Model.extend
  body:                DS.attr 'string'
  parent_id:           DS.attr 'number'
  parent_name:         DS.attr 'string'
  created_at:          DS.attr 'date'
  pod_latest_comment:  DS.belongsTo('parent', inverse: 'pod_latest_comment')
  game:                DS.belongsTo('game', inverse: 'comments')