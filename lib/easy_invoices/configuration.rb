class EasyInvoices::Configuration

  attr_accessor :act_dir, :invoice_dir

  def initialize
    @act_dir = nil
    @invoice_dir = nil
  end

end