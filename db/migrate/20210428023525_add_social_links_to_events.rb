class AddSocialLinksToEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :carrd_url, :string
    add_column :events, :discord_invite, :string
    add_column :events, :twitch_url, :string
    add_column :events, :dj_url, :string
  end
end
