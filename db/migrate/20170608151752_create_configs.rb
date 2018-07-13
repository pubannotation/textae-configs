class CreateConfigs < ActiveRecord::Migration
  def change
    create_table :configs do |t|
      t.string :name
      t.text :description
      t.text :body
      t.boolean :is_public, default: false

      t.timestamps null: false
    end
    add_index :configs, :name, unique: true
  end
end
