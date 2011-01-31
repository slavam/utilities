# encoding: UTF-8
require 'prawn'
class Passport < Prawn::Document
  def to_pdf(sub)
    font "#{Prawn::BASEDIR}/data/fonts/aricyrb.ttf"
    bounding_box [0, 700], :width => 150 do
      text "Код абонента:"
      text "Фамилия, имя, отчество:"
      text "Адрес:"
      move_down 10
      text "Штрих-код:"
    end
    font "#{Prawn::BASEDIR}/data/fonts/aricyr.ttf"
    bounding_box [150, 700], :width => 300 do
      text sub.code_erc.to_s
      text sub.full_name.to_utf
      text sub.address
      
      stef = "public/images/foo.png"  
      image stef
    end
    render
  end
end