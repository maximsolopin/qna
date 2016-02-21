ThinkingSphinx::Index.define :answer, with: :active_record do
  # fields
  indexes body
  indexes user.display_name, as: :author, sortable: true

  # attributes
  has user_id, question_id, created_at, updated_at
end