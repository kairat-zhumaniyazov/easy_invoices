require "easy_invoices/base"
require "easy_invoices/version"
require "easy_invoices/includer"
require "easy_invoices/act"
require "easy_invoices/invoice"
require "easy_invoices/configuration"

module EasyInvoices

  class Error < StandardError; end

  BASE_SIGN_SIZE = 200

  ActiveSupport.on_load(:active_record) do
    extend EasyInvoices::Includer
  end

  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
