module EasyInvoices
  module Base

    DIGIT_RUBLEJ = { always_show_fraction: true, fraction_formatter: '%.2d', integrals_delimiter: ' ' }

    def generate_act(options = {})
      generate_with(:act, options)
    end

    def generate_invoice(options = {})
      generate_with(:invoice, options)
    end

    def generate_with(kind, options = {})
      begin
        check_easy_invoices_options(kind)
        check_document_data_method_existing
        generate_params_hash(kind, options)
        calculate_act_total_sum
        file = "EasyInvoices::#{kind.to_s.classify}".constantize.generate(@params_hash, options[:file_name])
        options[:success_callback].call(file) if options.dig(:success_callback)
        return { result: :success, file: file }
      rescue => e
        puts e.message
        options[:error_callback].call(file) if options.dig(:error_callback)
        return { result: :error, error_message: e.message }
      end
    end

    protected

    def check_easy_invoices_options(kind)
      @options = self.class.easy_invoices_options
      raise('EasyInvoices options not found') unless @options
      @kinds = @options.dig(:kind)
      raise('EasyInvoices document kind not found') unless @kinds
      tmp_msg = "EasyInvoices document kinds not included #{kind}"
      if @kinds.is_a?(Array)
        raise(tmp_msg) unless @kinds.include?(kind)
      else
        raise(tmp_msg) unless @kinds == kind
      end
      true
    end

    def check_document_data_method_existing
      raise('EasyInvoices document_data method not defined in model') unless respond_to?(:document_data, true)
    end

    def generate_params_hash(kind, options)
      @params_hash = {
        sings: self.class.easy_invoices_options.dig(:signs, kind),
        with_signs: options.dig(:with_signs).nil? ? true : options[:with_signs]
      }

      "EasyInvoices::#{kind.to_s.classify}".constantize::FIELDS.each do |field|
        @params_hash[field] = document_data(kind, field) rescue "Value for #{field} not found"
      end
    end

    def calculate_act_total_sum
      @params_hash[:total_sum] =  @params_hash[:positions].map { |pos| pos[:cost] * pos[:amount] }.reduce(:+)
    end
  end
end