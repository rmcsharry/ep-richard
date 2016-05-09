Easypeasy.GameSerializer = DS.RESTSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    comments: { deserialize: 'records', serialize: 'false' }
  }
});
