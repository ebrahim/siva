class CreateWordRepresentations < ActiveRecord::Migration
  def self.up
    create_table :word_representations do |t|
      t.string :text
      t.references :word

      t.timestamps
    end
  end

  def self.down
    drop_table :word_representations
  end
end
