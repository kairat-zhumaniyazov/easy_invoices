require 'wicked_pdf'
require 'ru_propisju'
require_relative 'generator'

class EasyInvoices::Invoice < EasyInvoices::Generator

  DIR = %w'public system pdfs invoices'

  FIELDS = %i'
    title
    supplier_requisites
    bank_name
    bank_bik
    bank_city
    bank_account
    bank_inn
    bank_kpp
    bank_recipient_name
    bank_recipient_account
    buyer_requisiter
    positions
    payment_terms
    director_name
    buhgalter_name
  '

end
