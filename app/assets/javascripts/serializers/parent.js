Easypeasy.ParentSerializer = DS.ActiveModelSerializer.extend(DS.EmbeddedRecordsMixin, {
    attrs: {
        pod_latest_comment: { deserialize: 'records', serialize: 'false' }
    }
});