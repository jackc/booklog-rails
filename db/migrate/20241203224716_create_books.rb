class CreateBooks < ActiveRecord::Migration[8.0]
  def up
    execute <<~SQL
      create table books (
        id uuid primary key,
        user_id uuid not null references users,
        title text not null,
        author text not null,
        finish_date date not null,
        format text not null,
        location text,
        created_at timestamptz not null,
        updated_at timestamptz not null
      );

      create index on books (user_id);
    SQL
  end

  def down
    execute <<~SQL
      drop table books;
    SQL
  end
end
