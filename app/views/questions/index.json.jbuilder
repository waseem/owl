json.pagination do
  json.is_last_page @questions.last_page?
  json.current_page @questions.current_page
end

json.questions do
  json.array! @questions, partial: 'questions/question', as: :question
end
