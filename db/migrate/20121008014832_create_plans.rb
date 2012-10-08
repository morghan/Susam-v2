class CreatePlans < ActiveRecord::Migration
  def self.up
    create_table :plans do |t|
      t.integer :subject_id
      t.float :examen_1
      t.float :acumulado_1
      t.float :examen_2
      t.float :acumulado_2
      t.float :examen_3
      t.float :acumulado_3
      t.float :examen_4
      t.float :acumulado_4

      t.timestamps
		end
  end

  def self.down
		drop_table :plans
  end
end
