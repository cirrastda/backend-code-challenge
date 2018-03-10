class CreateRoutes < ActiveRecord::Migration[5.1]
  def change
    create_table :routes do |t|
      t.references :place_origin, index: true
      t.references :place_destiny, index: true
      t.bigint :distance

      t.timestamps
    end
  end
end
