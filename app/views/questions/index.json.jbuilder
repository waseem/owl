json.questions do
  json.array! @questions, partial: 'questions/question', as: :question
end
