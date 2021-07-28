class AddGpsToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :latitude, :string
    add_column :posts, :longitude, :string
  end
end
