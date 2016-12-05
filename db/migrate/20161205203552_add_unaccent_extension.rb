# https://www.postgresql.org/docs/9.1/static/unaccent.html
class AddUnaccentExtension < ActiveRecord::Migration[5.0]
  def up
    execute "create extension unaccent"
  end

  def down
    execute "drop extension unaccent"
  end
end
