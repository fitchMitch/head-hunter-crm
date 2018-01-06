module People
  module Docx
    extend ActiveSupport::Concern

    included do
      before_destroy :remove_docx
    end

    def index_cv_content
      doc = get_cv
      return if doc == nil
      ctt = []
      doc.paragraphs.each do |pa|
          ctt << pa.text.tr('\'' , ' ')
      end
      content =  ctt.join(' ')
      ActiveRecord::Base.connection.execute <<-SQL
      INSERT INTO pg_search_documents (searchable_type, searchable_id, content, created_at, updated_at)
      VALUES ('Person' ,
              #{self.id} ,
              '#{content}'::text ,
              now(),
              now())
      SQL
    end

    def remove_docx
      self.remove_index_content
      self.cv_docx = nil
      self.save
    end

    def remove_index_content
      ActiveRecord::Base.connection.execute <<-SQL
        DELETE FROM  pg_search_documents where searchable_id = #{self.id}
      SQL
    end

    def set_cv_content
      doc = get_cv
      return if doc == nil
      ctt = []
      doc.paragraphs.each  { |pa| ctt << pa.text.tr('\'' , ' ')}
      self.update(:cv_content => ctt.join(' '))
    end

  end
end
