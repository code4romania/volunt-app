class AddAuthorToStatusReport < ActiveRecord::Migration[5.0]
  def change
    add_reference :status_reports, :author, index: true, foreign_key: {to_table: :profiles}
  end
end
