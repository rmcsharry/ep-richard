class RemoveVideoEmbedCodeFromGame < ActiveRecord::Migration
  change_table :games do |t|
    t.remove :video_embed_code
  end
end
