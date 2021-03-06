# PDF's built-in fonts have very limited support for internationalized text.
# If you need full UTF-8 support, consider using a TTF font instead.
#
# The following line hides this warning:
Prawn::Font::AFM.hide_m17n_warning = true

# Allows for easy use of alternate measurements, such as inches, mm, cm, etc.
require "prawn/measurement_extensions"

prawn_document(
    filename:       @bill.title + '.pdf',
    force_download: false,
    margin:         0.5.in,
    top_margin:     1.in,
    bottom_margin:  1.in,
    info: {
        Title:        @bill.title,
        Author:       'Unknown',
        Subject:      'Bill',
        Keywords:     'Troy, Bill, Code',
        Creator:      'City Clerk',
        Producer:     'Troy City Council',
        CreationDate: Time.now}) do |pdf|

  # paper defaults
  font_size = 12
  pdf.font_size = font_size
  pdf.font("Times-Roman")
  pdf.default_leading font_size*0.2

  # Render each bill
  render 'pdf_templates/bill',
         pdf: pdf,
         font_size: font_size,
         bill: @bill,
         attach: @attach

  # Render page headers
  numbering = @bill.numbering(:abbreviation)
  render 'pdf_templates/header',
         pdf: pdf,
         font_size: font_size,
         right: numbering,
         center: '',
         approved: true

end

