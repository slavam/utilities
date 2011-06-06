# encoding: UTF-8
require 'prawn'
require "#{File.dirname(__FILE__)}/../example_helper.rb"

class Utszn < Prawn::Document
  def to_pdf(sub, utszn_data)
#    font "#{Prawn::BASEDIR}/data/fonts/aricyr.ttf"
    font_size 9
    font "#{Prawn::BASEDIR}/data/fonts/aricyrb.ttf";
    bl = y - bounds.absolute_bottom + 2
    draw_text 'Довiдка вiд '+Time.now.strftime("%d.%m.%Y"), :at => [45, bl]
    font "#{Prawn::BASEDIR}/data/fonts/aricyr.ttf"
    text "Видана "+sub.full_name.to_utf
    text "Адреса "+sub.address
    text "Кiлькiсть зареэстрованих "
    text "Кiлькiсть пiльговикiв "
    text "Ознака однокiмнатноi квартири "
 
    font_size 7
    
    font "#{Prawn::BASEDIR}/data/fonts/aricyr.ttf"
    data = []
    data2 = []
    i = 0
    for d in utszn_data do
      debt = 0.0

      data << [d.name.to_utf, d.utility.to_utf, d.bank_book.to_utf, d.water_heater > 0 ? "Да" : '', "", 
        d.tarif_f.to_s, d.heat_area.to_s, d.total_area.to_s, "", ""]
      data2 << [d.name.to_utf, d.utility.to_utf, d.sum_01122006.to_s, d.sum_dolg.to_s,
        d.date_dog.to_date.to_s > '1901-01-01' ? d.date_dog.to_date : '',
        (d.month_count.to_f+d.month_count2.to_f+d.month_count3.to_f).to_s,
        "", "", "", "", "", "", "", "", "", "", ""]
      i += 1
    end
    headers = ["Надавач послуг",
      "Послуга","Особовий рахунок","Прилад","Наявнiсть пiльги, %","Фактичнчй тариф","Опалювальна площа",
      "Загальна площа", "Оплата з пiльгами", "Оплата по нормi"]

    move_down 10

    chw = [150, 80, 50, 50, 30, 35, 35, 40, 40, 40, 40]
#    he = table([headers], :column_widths => chw, :row_colors => %w[cccccc ffffff], :cell_style => {:padding => [0,0]}, columns(0).align = :center)
    bl = y-10
    he = table([headers]) do |t|
      t.column_widths = chw
      t.row_colors = %w[cccccc ffffff]
      t.cell_style = {:padding => 0}
      t.columns(0..9).align = :center
    end  
    da = make_table(data) do |t|
      t.column_widths = chw
    end
    table ([[da]])
    
    move_down 10
      
    headers = ["Надавач послуг", "Послуга","Борг на 01.12.2006", "Сума поточного боргу","Дата угоди про погашення",
      (utszn_data[0].date_dolg).strftime("%B %Y "),
      (utszn_data[0].date_dolg - 1.month).strftime("%B %Y "),
      (utszn_data[0].date_dolg - 2.month).strftime("%B %Y "),
      (utszn_data[0].date_dolg - 3.month).strftime("%B %Y "),
      (utszn_data[0].date_dolg - 4.month).strftime("%B %Y "),
      (utszn_data[0].date_dolg - 5.month).strftime("%B %Y "),
      (utszn_data[0].date_dolg - 6.month).strftime("%B %Y "),
      (utszn_data[0].date_dolg - 7.month).strftime("%B %Y "),
      (utszn_data[0].date_dolg - 8.month).strftime("%B %Y "),
      (utszn_data[0].date_dolg - 9.month).strftime("%B %Y "),
      (utszn_data[0].date_dolg - 10.month).strftime("%B %Y "),
      (utszn_data[0].date_dolg - 11.month).strftime("%B %Y ")]
    chw = [150, 80, 50, 50, 40, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35]
    bl = y-10
    he = table([headers]) do |t|
      t.column_widths = chw
      t.row_colors = %w[cccccc ffffff]
      t.cell_style = {:padding => 0}
      t.columns(0..16).align = :center
    end  
    da = make_table(data2) do |t|
      t.column_widths = chw
    end
    table ([[da]])
      
#table ([[da, he, da]])
=begin    
#      :position   => :left,
#      :font_size => 10,
#      :headers    => headers,
#      :width      => 500,
#      :header_color => 'cccccc',
#      :border_style => :grid,
#      :align_headers => :center
#    move_down 10
#    text "ИТОГО: "; text s.to_s, :align => :right
 options = {
    :width    => bounds.width * 0.3,
    :height   => bounds.width * 0.3,
    :overflow => :ellipses,
    :at       => [200, 100],
    :align    => :right,
    :document => self
  }
  stroke_color("555555")
    box = Prawn::Text::Box.new("ИТОГО: " * 20, options)
    box.render

  subtable = Prawn::Table.new([%w[one two], %w[three four]], self)

table([["Subtable ->", subtable, "<-"]])

#  table([%w[foo bar baz<b>baz</b>], %w[baz bar <i>foo</i>foo]], 
#  table([["sdfsa"], ["dfgs"]], 
#        :cell_style => { :padding => 12, :inline_format => true },
#        :width => bounds.width)

  widths = [50, 90, 170, 90, 90, 150]
  headers = ["Date", "Patient Name", "Description", "Charges / Payments", 
             "Patient Portion Due", "Balance"]

  head = make_table([headers], :column_widths => widths)
  data = []

  def row(date, pt, charges, portion_due, balance)
    rows = charges.map { |c| ["", "", c[0], c[1], "", ""] }

    # Date and Patient Name go on the first line.
    rows[0][0] = date
    rows[0][1] = pt

    # Due and Balance go on the last line.
    rows[-1][4] = portion_due
    rows[-1][5] = balance

    # Return a Prawn::Table object to be used as a subtable.
    make_table(rows) do |t|
      t.column_widths = [50, 90, 170, 90, 90, 150]
      t.cells.style :borders => [:left, :right], :padding => 2
      t.columns(4..5).align = :right
    end

  end

  data << row("1/1/2010", "", [["Balance Forward", ""]], "0.00", "0.00")
  50.times do
    data << row("1/1/2010", "John", [["Foo", "Bar"], 
                                     ["Foo", "Bar"]], "5.00", "0.00")
  end

  table([[head], *(data.map{|d| [d]})], :header => true,
        :row_colors => %w[cccccc ffffff]) do
    
    row(0).style :background_color => '000000', :text_color => 'ffffff'
    cells.style :borders => []
  end
=end

#    bounding_box [336, bl], :width => 200, :height => (bl-y+10) do
#      line_width(2)
#      stroke_bounds
#  end
number_helper = Object.new.extend(ActionView::Helpers::NumberHelper) 
bl = y-20
font "#{Prawn::BASEDIR}/data/fonts/aricyrb.ttf";
#draw_text "ИТОГО:       "+ number_helper.number_to_currency(s, :unit => "грн.", :format => "%n %u"), :at => [300, bl]
#draw_text "Подпись плательщика______________", :at => [400, bl]
#draw_text "ИТОГО:       "+ number_helper.number_to_currency(s, :unit => "грн.", :format => "%n %u"), :at => [570, bl]
#draw_text "Подпись плательщика______________", :at => [660, bl]

    move_down 20
    stef = "public/images/slogan.png"  
    image stef 
    render
  end
end
