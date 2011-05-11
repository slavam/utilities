# encoding: UTF-8
require 'prawn'
require "#{File.dirname(__FILE__)}/../example_helper.rb"

class Notice < Prawn::Document
  def to_pdf(sub, debts, counters)
    font "#{Prawn::BASEDIR}/data/fonts/aricyr.ttf"
    font_size 9
    text "Код ЕРЦ: " 
    font "#{Prawn::BASEDIR}/data/fonts/aricyrb.ttf";
    bl = y - bounds.absolute_bottom + 2
    draw_text sub.code_erc.to_s+'  Счет на оплату жилищно-коммунальных и прочих услуг за '+
      (debts[0].date_dolg - 1.month).strftime("%B %Y "), :at => [45, bl]
    font "#{Prawn::BASEDIR}/data/fonts/aricyr.ttf"
    text "Адрес: "+sub.address+' '+sub.full_name.to_utf

    bounding_box [(bounds.width-250), bounds.top], :width => 250 do
      text "Код ЕРЦ: "+sub.code_erc.to_s+" Извещение за "+
#        I18n.l(debts[0].date_dolg, :format => :short)+
        (debts[0].date_dolg - 1.month).strftime("%B %Y ")+" Адрес: "+
        sub.address+' '+sub.full_name.to_utf
    end
 
    font_size 7
    
    font "#{Prawn::BASEDIR}/data/fonts/aricyr.ttf"
    data = []
    s = 0
    i = 0
    for d in debts do
      debt = 0.0
      if d.sum_dolg.to_f != 0 
        if d.sum_dolg.to_f > 0
          debt = d.sum_dolg.to_utf+ "\n" +'долг' 
        else
          debt = d.sum_dolg.to_utf+ "\n" +'переплата'
#          debt = BigDecimal(d.sum_dolg).ceil(2).abs.to_f.to_s+ "\n" +' переплата'
        end
      else
        debt = ''
      end
      
#      s = s+d.sum_month.to_f
      benefits = ''
      benefits = (d.rate_lg1.to_f > 0.04 or d.rate_lg2.to_f > 0.04 or d.rate_lg3.to_f > 0.04 or d.rate_lg4.to_f > 0.04 or d.rate_lg5.to_f > 0.04) ? ' льг. ' : ' без льгот'
      benefits = benefits +
        (d.rate_lg1.to_f > 0.04 ? ' '+ d.rate_lg1.to_s : '')+
        (d.rate_lg2.to_f > 0.04 ? ' '+ d.rate_lg2.to_s : '')+
        (d.rate_lg3.to_f > 0.04 ? ' '+ d.rate_lg3.to_s : '')+
        (d.rate_lg4.to_f > 0.04 ? ' '+ d.rate_lg4.to_s : '')+
        (d.rate_lg5.to_f > 0.04 ? ' '+ d.rate_lg5.to_s : '')
#      counts_values = ''
#      counts_values = (d.end_count.to_f > 0 or d.end_count2.to_f > 0 or d.end_count3.to_f > 0) ? ' послед.показания:' : ''
#      counts_values = counts_values +
#         ((counters[i]["end_count"]).to_f>0 ? ' сч1:'+ counters[i]["end_count"] : '') +
#        (d.end_count2.to_f > 0 ? ' сч2:'+ d.end_count2.to_s : '') +
#        (d.end_count3.to_f > 0 ? ' сч3:'+ d.end_count3.to_s : '')

      volume = ''
      cw = [40, 55, 30, 35, 25, 35, 40]
      ccw = [40, 40, 40, 30]
      if ((counters[i]["end_count"]).to_f > 0 or (counters[i]["end_count2"]).to_f > 0 or (counters[i]["end_count3"]).to_f > 0)
        counters_values = make_table([
          ((counters[i]["end_count"]).to_f > 0 ? [Time.now.to_date.to_s, 
            (counters[i]["month_count"]), 
            (counters[i]["end_count"]),
            ((counters[i]["end_count"]).to_f-(counters[i]["month_count"]).to_f).to_s] : []),
          ((counters[i]["end_count2"]).to_f > 0 ? ["",
            (counters[i]["month_count2"]), 
            (counters[i]["end_count2"]),
            ((counters[i]["end_count2"]).to_f-(counters[i]["month_count2"]).to_f).to_s] : []),
          ((counters[i]["end_count3"]).to_f > 0 ? ["",
            (counters[i]["month_count3"]), 
            (counters[i]["end_count3"]),
            ((counters[i]["end_count3"]).to_f-(counters[i]["month_count3"]).to_f).to_s] : [])],
          :column_widths => ccw, :cell_style => {:padding => 2})
            volume = ((counters[i]["end_count"]).to_f-(counters[i]["month_count"]).to_f +
              (counters[i]["end_count2"]).to_f-(counters[i]["month_count2"]).to_f +
              (counters[i]["end_count3"]).to_f-(counters[i]["month_count3"]).to_f).to_s
      else
        counters_values = make_table([["","","",""]], :column_widths => ccw)
      end

      case d.utility_id 
        when 1 then volume = d.total_area.to_s+'м2'
        when 2, 5, 10 then volume = (d.resident_number.to_i > 0 ? d.resident_number.to_s+'чел.' : '')
        when 7 then volume = d.heat_area.to_s+'м2'
        when 8, 20, 21, 39, 41 then
          if ((counters[i]["end_count"]).to_f > 0 or (counters[i]["end_count2"]).to_f > 0 or (counters[i]["end_count3"]).to_f > 0)
#            volume = volume+"м3"
          end    
      end
      seven_cells = make_table([[d.sum_dolg1.to_utf, d.utility.to_utf, volume,
        d.sum_month, d.sum_recalculation, '0', debt]], :column_widths => cw, :cell_style => {:padding => 2})
      two_cells = make_table([['Л.счет № '+d.bank_book+' '+
        d.full_name.to_utf+
        (d.resident_number.to_i > 0 ? ' прож. '+d.resident_number.to_s : '')+
        (d.tarif.to_f > 0 ? ' тариф '+d.tarif.to_s+'грн/'+d.unit.to_utf : '')+
        benefits 
#        + counts_values
        ],[seven_cells]], :column_widths => [260])
      
      
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
        data << [provider, two_cells, (counters[i]["sum_month"]).to_s,"", "", d.utility.to_utf, (counters[i]["sum_month"]).to_s]
      else  
        data << [provider, two_cells, 
          (counters[i]["sum_month"]).to_f.to_s, counters_data, "", d.utility.to_utf, (counters[i]["sum_month"]).to_s, counters_data]
      end 
      s = s + (counters[i]["sum_month"]).to_f
      i += 1
    end
    subheder1 = make_table([["Дата", "Нач.", "Кон.", "Разн."]], :column_widths => ccw, :cell_style => {:padding => 3})
    subheder2 = make_table([["Показания счетчиков"],[subheder1]])
    headers = ["Поставщик услуг","Долг на "+(debts[0].date_dolg - 1.month).strftime("%d.%m.%Y"),
      "Услуга","Объем","Начислено","Перерасчет","Оплачено","Долг на "+debts[0].date_dolg.strftime("%d.%m.%Y"),
      "Сумма платежа", subheder2, "", "Вид оплаты", "Сумма платежа", subheder2]

    move_down 10

    chw = [80, 40, 55, 30, 35, 25, 35, 40, 50, 150, 10, 60, 40, 150]
#    he = table([headers], :column_widths => chw, :row_colors => %w[cccccc ffffff], :cell_style => {:padding => [0,0]}, columns(0).align = :center)
    bl = y-10
    he = table([headers]) do |t|
      t.column_widths = chw
      t.row_colors = %w[cccccc ffffff]
      t.cell_style = {:padding => 0}
      t.columns(0..8).align = :center
      t.columns(11..12).align = :center
    end  
    da = make_table(data) do |t|
      t.column_widths  = [80, 260, 50, 150, 10, 60, 40, 150]
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
number_helper = Object.new.extend(ActionView::Helpers::NumberHelper) 
bl = y-20
font "#{Prawn::BASEDIR}/data/fonts/aricyrb.ttf";
draw_text "ИТОГО:       "+ number_helper.number_to_currency(s, :unit => "грн.", :format => "%n %u"), :at => [300, bl]
draw_text "Подпись плательщика______________", :at => [400, bl]
draw_text "ИТОГО:       "+ number_helper.number_to_currency(s, :unit => "грн.", :format => "%n %u"), :at => [570, bl]
draw_text "Подпись плательщика______________", :at => [660, bl]

    move_down 20
    stef = "public/images/slogan.png"  
    image stef 
    render
  end
end
