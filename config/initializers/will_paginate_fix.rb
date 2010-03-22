# protects against nasty error from will_paginate plugin
module WillPaginate
  class Collection < Array
    def initialize(page, per_page, total = nil)
      @current_page = page !~ /\D+/ ? page.to_i : (raise ActiveRecord::RecordNotFound, "Incorrect Page Params Format: #{page}")
      @per_page     = per_page.to_i
      self.total_entries = total if total
    end
  end
end