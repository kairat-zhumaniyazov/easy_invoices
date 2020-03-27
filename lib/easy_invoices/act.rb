require_relative 'generator'

class EasyInvoices::Act < EasyInvoices::Generator

  DIR = %w'public system pdfs atcs'

  FIELDS = %i'
    title
    execuror
    customer
    positions
    execuror_position
    execuror_name
    customer_position
    customer_name
  '

end
