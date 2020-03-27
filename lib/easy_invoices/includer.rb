module EasyInvoices
  module Includer
    
    def can_generate_document options = {}
      @easy_invoices_options = options

      class_eval do
        def self.easy_invoices_options
          @easy_invoices_options
        end
      end

      include EasyInvoices::Base
    end

  end
end