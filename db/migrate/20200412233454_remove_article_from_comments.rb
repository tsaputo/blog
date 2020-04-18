# frozen_string_literal: true

class RemoveArticleFromComments < ActiveRecord::Migration[6.0]
  def change
    remove_reference :comments, :article, null: false, foreign_key: true
  end
end
