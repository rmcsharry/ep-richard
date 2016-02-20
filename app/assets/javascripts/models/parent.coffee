Easypeasy.Parent =  DS.Model.extend
  name:					DS.attr 'string'
  first_name:			DS.attr 'string'
  pod_name:				DS.attr 'string'
  slug:					DS.attr 'string'
  pod_lc:				DS.belongsTo 'comment'
  pod_lc_parent_name:	DS.attr 'string'
  pod_lc_game_name:		DS.attr 'string'
