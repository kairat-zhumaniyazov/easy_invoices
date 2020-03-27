require 'wicked_pdf'
require 'ru_propisju'

class EasyInvoices::Generator

  def self.generate(invoice_params, file_name)
    self.new(invoice_params, file_name).process
  end

  def initialize(invoice_params, file_name)
    @invoice_params = invoice_params
    @file_name = file_name.nil? ? "#{SecureRandom.hex}.pdf" : "#{file_name}.pdf"
  end

  def process
    check_dir

    File.open(target_file, 'wb') do |file|
      file << rendered_pdf
    end

    target_file
  end

  protected

  def check_dir
    FileUtils.mkdir_p(target_dir) unless File.directory?(target_dir)
  end

  def target_dir
    Rails.root.join(*self.class::DIR)
  end

  def target_file
    target_dir.join @file_name
  end

  def current_dir
    File.expand_path(File.dirname(__FILE__))
  end

  def template_path
    "#{current_dir}/templates/#{self.class.name.demodulize.downcase}"
  end

  def rendered_pdf
    WickedPdf.config = {
      'no-background': false,
      image: true
    }
    WickedPdf.new.pdf_from_string( rendered_view )
  end

  def rendered_view
    ApplicationController.render(
      file: template_path,
      layout: false,
      locals: @invoice_params
    )
  end

end