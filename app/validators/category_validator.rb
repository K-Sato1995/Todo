class CategoryValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    arry = value.split(',')
    record.errors.add attribute, 'では空白のタグを登録することはできません。' if arry.include?('')
    record.errors.add attribute, 'では同じ名前のタグを登録することはできません。' unless arry.uniq == arry
  end
end
