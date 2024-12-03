class CreateSessions < ActiveRecord::Migration[8.0]
  def up
    execute <<~SQL
      create table sessions (
        id uuid primary key,
        user_id uuid not null references users,
        login_time timestamptz not null,
        created_at timestamptz not null,
        updated_at timestamptz not null
      );

      create index on sessions (user_id);
    SQL
  end

  def down
    execute <<~SQL
      drop table sessions;
    SQL
  end
end
