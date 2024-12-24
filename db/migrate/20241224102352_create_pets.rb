class CreatePets < ActiveRecord::Migration[7.1]
  def change
    create_table :pets do |t|
      t.string :pet_type, null: false
      t.string :tracker_type, null: false
      t.integer :owner_id, null: false
      t.boolean :in_zone, default: true
      t.boolean :lost_tracker, default: false

      t.timestamps
    end
  end
end
