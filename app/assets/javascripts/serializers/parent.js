Easypeasy.ParentSerializer = DS.ActiveModelSerializer.extend(DS.EmbeddedRecordsMixin, {
    attrs: {
        pod_lc: { deserialize: 'records', serialize: 'false' }
    }
});