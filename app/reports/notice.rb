# encoding: UTF-8
require 'prawn'
require "#{File.dirname(__FILE__)}/../example_helper.rb"

class Notice < Prawn::Document
  def to_pdf(sub, debts, dates)
    font "#{Prawn::BASEDIR}/data/fonts/aricyr.ttf"
    font_size 9
    text "Код ЕРЦ: " 
    font "#{Prawn::BASEDIR}/data/fonts/aricyrb.ttf";
    bl = y - bounds.absolute_bottom + 2
    draw_text sub.code_erc.to_s+'  Счет на оплату жилищно-коммунальных и прочих услуг на '+
      debts[0].date_dolg.to_date.to_s, :at => [45, bl]
#    stroke_line [0, bl], [0, bl + font.ascender]
    font "#{Prawn::BASEDIR}/data/fonts/aricyr.ttf"
    text "Адрес: "+sub.address+' '+sub.full_name.to_utf

#    draw_text "Код ЕРЦ: "+sub.code_erc.to_s, :at => [bounds.width-250, bl]
    bounding_box [(bounds.width-250), bounds.top], :width => 250 do
      text "Код ЕРЦ: "+sub.code_erc.to_s+" Извещение за "+debts[0].date_dolg.to_date.to_s+" Адрес: "+
        sub.address+' '+sub.full_name.to_utf
    end
 
    font_size 7
    
#    move_text_position 16
#    stroke_horizontal_rule    
#    font "#{Prawn::BASEDIR}/data/fonts/aricyrb.ttf"
#   font "#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf"
#    text "заполняется абонентом", :indent_paragraphs => 450
    font "#{Prawn::BASEDIR}/data/fonts/aricyr.ttf"
    data = []
    s = 0
    i = 0
    for d in debts do
#      from = dates[i]["start(3i)"]+'.'+dates[i]["start(2i)"]+'.'+dates[i]["start(1i)"]
#      to = dates[i]["end(3i)"]+'.'+dates[i]["end(2i)"]+'.'+dates[i]["end(1i)"]
      debt = 0.0
      if d.sum_dolg.to_f != 0 
        if d.sum_dolg.to_f > 0
          debt = d.sum_dolg+ "\n" +' долг' 
        else
          debt = d.sum_dolg+ "\n" +' переплата'
#          debt = BigDecimal(d.sum_dolg).ceil(2).abs.to_f.to_s+ "\n" +' переплата'
        end
      else
        debt = '0'
      end
      
      s = s+d.sum_month.to_f
      volume = ''
      case d.utility_id 
        when 1 then volume = d.total_area.to_s+'м2'
        when 2, 5, 10 then volume = d.resident_number.to_s+'чел.'
        when 7 then volume = d.heat_area.to_s+'м2'
      end
      benefits = ''
      benefits = (d.rate_lg1.to_f > 0.04 or d.rate_lg2.to_f > 0.04 or d.rate_lg3.to_f > 0.04 or d.rate_lg4.to_f > 0.04 or d.rate_lg5.to_f > 0.04) ? ' льг. ' : ' без льгот'
      benefits = benefits +
        (d.rate_lg1.to_f > 0.04 ? ' '+ d.rate_lg1.to_s : '')+
        (d.rate_lg2.to_f > 0.04 ? ' '+ d.rate_lg2.to_s : '')+
        (d.rate_lg3.to_f > 0.04 ? ' '+ d.rate_lg3.to_s : '')+
        (d.rate_lg4.to_f > 0.04 ? ' '+ d.rate_lg4.to_s : '')+
        (d.rate_lg5.to_f > 0.04 ? ' '+ d.rate_lg5.to_s : '')
      counts_values = ''
      counts_values = (d.end_count.to_f > 0 or d.end_count2.to_f > 0 or d.end_count3.to_f > 0) ? ' послед.показания:' : ''
      counts_values = counts_values +
         ((dates[i]["end_count"]).to_f>0 ? ' сч1:'+ dates[i]["end_count"] : '') +
#        (d.end_count.to_f > 0 ? ' сч1:'+ d.end_count.to_s : '') +
        (d.end_count2.to_f > 0 ? ' сч2:'+ d.end_count2.to_s : '') +
        (d.end_count3.to_f > 0 ? ' сч3:'+ d.end_count3.to_s : '')

#      cw = [50, 90, 40, 50, 40, 50, 60]
      cw = [35, 55, 30, 35, 25, 35, 40]
      seven_cells = make_table([[d.sum_dolg1, d.utility.to_utf, volume,
        d.sum_month, d.sum_recalculation, '0', debt]], :column_widths => cw, :cell_style => {:padding => 2})
      two_cells = make_table([['Л.счет № '+d.bank_book+' '+
        d.full_name.to_utf+' прож. '+d.resident_number.to_s+
        (d.tarif.to_f > 0 ? ' тариф '+d.tarif.to_s+'грн/'+d.unit.to_utf : '')+
        benefits + counts_values
        ],[seven_cells]], :column_widths => [255])
#      v = []
      ccw = [40, 40, 40, 30]
      if ((dates[i]["end_count"]).to_f > 0 or (dates[i]["end_count2"]).to_f > 0 or (dates[i]["end_count3"]).to_f > 0)
#        if d.end_count.to_f > 0
#          v << ["Date","2",d.end_count,"4"]
#          v [2][2] = "Date"
#        end
#        v << ["Date","2","","4"]
#        , ["Date","2",d.end_count2,"4"]
        counters_values = make_table([
          ((dates[i]["end_count"]).to_f > 0 ? [Time.now.to_date.to_s,d.end_count,dates[i]["end_count"],d.month_count] : []),
          ((dates[i]["end_count2"]).to_f > 0 ? ["",d.end_count2,dates[i]["end_count2"],""] : []),
          ((dates[i]["end_count3"]).to_f > 0 ? ["",d.end_count3, dates[i]["end_count3"], ""] : [])], :column_widths => ccw, :cell_style => {:padding => 2})
      else
        counters_values = make_table([["","","",""]], :column_widths => ccw)
      end
      i += 1
      counter_name = ''
      case d.utility_id 
        when 8 then counter_name = "Электросчетчики"
        when 20 then counter_name = "Газовые счетчики"
        when 21 then counter_name = "Водомеры на холодную воду"
        when 39 then counter_name = "Водомеры на горячую воду"
        when 41 then counter_name = "Тепломеры"
      end
      counters_data = make_table([[counter_name],[counters_values]], :column_widths => [150])
      provider = d.ut_name.to_utf+' '+d.firm.to_utf+' Т.счет: '+'МФО: '
      #, :cell_style => {:padding => [0, 0, 2, 0]})
      if counter_name == ''
        data << [provider, two_cells, "","", "", d.utility.to_utf, d.sum_dolg1, ""]
      else  
        data << [provider, two_cells, "",counters_data, "", d.utility.to_utf, d.sum_dolg1, "", counters_data]
      end  
    end
    subheder1 = make_table([["Дата", "Нач.", "Кон.", "Разн."]], :column_widths => ccw, :cell_style => {:padding => 3})
    subheder2 = make_table([["Показания счетчиков"],[subheder1]])
#    cw3 =[10, 40]
#    subheder3 = make_table([["1", "2"]])
    headers = ["Поставщик услуг","Долг на "+debts[0].period.to_utf,
      "Услуга","Объем","Начислено","Перерасчет","Оплачено","На "+debts[0].date_dolg.to_date.to_s,
      "Сумма платежа", subheder2, "", "Вид оплаты", "Долг на "+debts[0].date_dolg.to_date.to_s, "Сумма платежа", subheder2]

    move_down 10

    chw = [80, 35, 55, 30, 35, 25, 35, 40, 50, 150, 10, 40, 40, 40, 150]
#    he = table([headers], :column_widths => chw, :row_colors => %w[cccccc ffffff], :cell_style => {:padding => [0,0]}, columns(0).align = :center)
    bl = y-10
    he = table([headers]) do |t|
      t.column_widths = chw
      t.row_colors = %w[cccccc ffffff]
      t.cell_style = {:padding => 0}
      t.columns(0..8).align = :center
      t.columns(11..13).align = :center
    end  
    da = make_table(data) do |t|
      t.column_widths  = [80, 255, 50, 150, 10, 40, 40, 40, 150]
#      t.cells.style :padding => 2
#      t.cell_style = {:padding => 3}
#      t.columns(0).align = :center
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
bl = y-20  
draw_text "ИТОГО:", :at => [300, bl]
draw_text "ИТОГО:", :at => [595, bl]
bl = y-20
draw_text "Подпись плательщика______________", :at => [400, bl]
draw_text "Подпись плательщика______________", :at => [680, bl]
#   
#  self.font_size = 9

    move_down 20
    stef = "public/images/slogan.png"  
    image stef 
    render
  end
end
