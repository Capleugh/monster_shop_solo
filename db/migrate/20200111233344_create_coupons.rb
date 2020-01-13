class CreateCoupons < ActiveRecord::Migration[5.1]
  def change
    create_table :coupons do |t|
      t.string :name
      t.string :code
      t.float :percent
      t.references :merchant, foreign_key: true

      t.timestamps
    end
  end
end
