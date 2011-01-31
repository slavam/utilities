require 'prawn'
class Town < Prawn::Document
  def to_pdf(sub)
    font "#{Prawn::BASEDIR}/data/fonts/aricyrb.ttf"
    bounding_box [0, 700], :width => 150 do
      text "Код:"
      text "Название:"
      text "Название 2:"
      text "Код КОАТУУ:"
    end
    font "#{Prawn::BASEDIR}/data/fonts/aricyr.ttf"
    bounding_box [150, 700], :width => 300 do
      text sub.id.to_s
      text sub.name_rus
      text sub.name_ukr
      text sub.code_koatuu.to_s
      
    end
     
    render
  end
end