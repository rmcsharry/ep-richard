Easypeasy.Game = DS.Model.extend
  name:              DS.attr 'string'
  description:       DS.attr 'string'
  instructions:      DS.attr 'string'
  did_you_know_fact: DS.attr 'string'
  top_tip:           DS.attr 'string'
  image_url:         DS.attr 'string'
  video_iframeurl:   DS.attr 'string'
  media_hashed_id:   DS.attr 'string'
  in_default_set:    DS.attr 'boolean'
  position:          DS.attr 'number'
  created_at:        DS.attr 'date'
  comments:          DS.hasMany('comment', {embedded: 'true'})