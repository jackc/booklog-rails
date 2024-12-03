class CreateUsers < ActiveRecord::Migration[8.0]
  def up
    execute <<~SQL
      create extension citext;

      create table users (
        id uuid primary key,
        username citext not null,
        password_digest text not null,
        created_at timestamptz not null,
        updated_at timestamptz not null
      );

      create unique index on users (username);
    SQL
  end

  def down
    execute <<~SQL
      drop table users;

      drop extension citext;
    SQL
  end
end
