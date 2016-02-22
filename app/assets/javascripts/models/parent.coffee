Easypeasy.Parent = DS.Model.extend
  name:                                   DS.attr 'string'
  first_name:                             DS.attr 'string'
  pod_name:                               DS.attr 'string'
  slug:                                   DS.attr 'string'
  pod_latest_comment:                     DS.belongsTo 'comment'
  pod_latest_comment_parent_name:         DS.attr 'string'
  pod_latest_comment_game_name:           DS.attr 'string'
