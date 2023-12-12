class CreateRepos < ActiveRecord::Migration[7.1]
  def change
    create_table :repos do |t|
      t.string :name
      t.string :last_commit
      t.time :git_updated_at

      t.timestamps
    end
  end
end
