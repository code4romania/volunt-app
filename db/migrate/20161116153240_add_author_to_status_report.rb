class AddAuthorToStatusReport < ActiveRecord::Migration[5.0]
  def change
    add_reference :status_reports, :author, index: true, foreign_key: {to_table: :profiles}
  end
end
# TODO Delete this before going live, or else everyone will have to rebuild their DB