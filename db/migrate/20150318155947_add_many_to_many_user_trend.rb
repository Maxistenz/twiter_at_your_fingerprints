class AddManyToManyUserTrend < ActiveRecord::Migration

    def change
      create_table :trends do |t|
        t.string :name
        t.string :url
      end

      create_table :trends_users, id: false do |t|
        t.belongs_to :user, index: true
        t.belongs_to :trend, index: true
      end
    end
end
