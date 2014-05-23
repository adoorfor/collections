ActiveRecord::Schema.define do
  self.verbose = false

  create_table :organisations, :force => true do |t|
    t.string :name
    t.timestamps
  end

  create_table :organisation_members, :force => true do |t|
    t.integer :user_id, :null => false
    t.integer :organisation_id, :null => false
    t.string :role, :null => false, :default => 'member'
    t.timestamps
  end

  add_index :organisation_members, [:user_id, :organisation_id]

  create_table :users, :force => true do |t|
    t.string :name
    t.timestamps
  end

  # Collection Proxy Adapter Spec
  create_table :bear_cats, :force => true do |t|
    t.integer :cat_id, :null => false
    t.integer :bear_id, :null => false
    t.string :role, :null => false, :default => 'member'
    t.timestamps
  end
end
