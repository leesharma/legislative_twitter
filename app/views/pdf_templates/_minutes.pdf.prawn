# Title
title_width = 3.in
pdf.text_box "TROY CITY\n#{@meeting.organization.name.upcase} MINUTES\nREGULAR MEETING\n#{@meeting.date.to_formatted_s :long}",
             align: :center,
             style: :bold,
             width: title_width,
             at: [pdf.bounds.width/2-title_width/2 , pdf.bounds.top]
pdf.move_down font_size*8




# Intro Text
data = [["Pledge of Allegiance\nRoll Call\nGood News Agenda\nVacancy List"],
        ["Pursuant to Section 2.72-2 entitled \"Public Forum\" of the Special Rules ofOrder of the Troy City Council a period of time shall be designated during each regular or special meeting of the City Council as a public forum during which citizens of the City shall be permitted to address the Council on legislation on that meeting's agenda and on any subject appropriate to the conduct ofTroy City government. Length of time allotted for citizen comment shall be no longer than five (5) minutes per speaker. At the completion of the agenda, citizen's comment shall be no longer than five (5) minutes per speaker appropriate to any subject to the conduct of Troy City government."],
        ["\nLOCAL LAW"]]
pdf.table(data) do
  cells.borders = []
  # row(1).font_style = :italic
  row(2).font_style = :bold
  row(2).style align: :center
end

pdf.move_down font_size


# Legislations Table
pdf.text @meeting.grouped_folios.inspect
@meeting.grouped_folios.each do |legislation_type, folios|
  data = [[ {content: legislation_type.pluralize(folios.count).upcase, colspan: 3} ]]
  folios.each do |folio|
    data << [folio.legislation.legislative_numbering(:integer).to_s+'.', {content:folio.legislation.title, colspan: 2}]
    data << ['','Sponsor', folio.sponsor]
    data << ['','Notes', 'lorem ipsum'*100]
    data << ['','Final Vote', folio.vote]
    2.times { data << ['','',''] }
  end
  pdf.table(data, header:true) do
    cells.borders = []
    column(0).width = 0.5.in
    column(1).width = 1.in
    row(0).font_style = :bold
    row(0).style align: :center
  end
  pdf.move_down font_size*2
end