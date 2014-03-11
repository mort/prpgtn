class CreateChannelInvites < ActiveRecord::Migration
  def change
    create_table :channel_invites do |t|
      t.references :channel
      t.references :sender
      t.references :recipient
      t.string :email
      t.string :token
      t.integer :status, :null => false, :default => 1
      t.datetime :accepted_at
      t.datetime :declined_at
      t.datetime :expired_at
      t.timestamps
    end
  end
end
