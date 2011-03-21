require 'rubygems'
require 'prawn'
require 'rghost'
require 'rghost_barcode'
include RGhost
class PayersController < ApplicationController
  before_filter :find_human, :except => [:search, :find_payer_by_address, :update_counters]
  before_filter :get_city_id, :except => [:find_payer_by_address, :show, :update_counters]
  before_filter :find_period, :only => [:show, :show_payers, :show_housing, :show_tariffs, :show_exemptions, 
    :order, :order_print, :debt, :test, :show_utszn_data]
  before_filter :find_payers, :only => [:show_payers]
  before_filter :find_room_params, :only => [:show_housing]
  before_filter :find_debts, :only => [:show, :order, :order_print, :debt, :show_utszn_data]
  before_filter :find_tariffs, :only => [:show_tariffs]
  before_filter :find_exemptions, :only => [:show_exemptions]
  before_filter :find_order, :only => [:order]
  before_filter :find_history, :only => [:show_histories]

  def update_count_debt
    redirect_to :action => "order", :id => 1
  end
  
  def update_counters
#    find_debt
    respond_to do |format|
      format.js do
        render (:update) do |page|
          page['.update_counters'].insert_html :bottom, :partial => 'update_3counters'
#                                      :object => @survey.questions.build
        end
#        render (:update) do |page|
#          page.alert('Something is not right here')
#          page.replace_html ".update_counters", ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
#          page['.update_counters'].hide # same thing as $('my_div').hide
#        end
#        number = params[:number]
#       render(:update) do |page|
#          page.replace_html  'update_counters', :partial => 'update_counters'
#         page['search'].hide
#         page.replace "search", ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
#         page.replace_html 'area_code_results_message',""
#       end
      end
    end
##    respond_to do |format|
##      format.html { redirect_to(posts_url) }
##      format.js  { render :nothing => true }
##    end
  end

  def test
  end

  def show
  end

  def show_payers
  end

  def show_housing
  end

  def show_tariffs
  end

  def show_histories
  end

  def show_exemptions
  end
  
  def order_print
    RGhost::Config::GS[:path]='C:\gs\gs9.00\bin\gswin32.exe'
#    i = 0
#    for d in @debts  do
#      d.sum_month = params[:debt][i]["sum_month"]
#      i += 1
#    end
    output = Notice.new(:page_size => "A4", :page_layout => :landscape, :margin => 10).to_pdf @human, @debts, params[:debt]

    respond_to do |format|
      format.pdf do
        send_data output, :filename => "order.pdf", :type => "application/pdf", :format => 'pdf'
      end
    end
  end

  def passport
    RGhost::Config::GS[:path]='C:\gs\gs9.00\bin\gswin32.exe'
    doc=RGhost::Document.new :paper => [5,3]
    doc.barcode_interleaved2of5(@human.code_erc.to_s, {:y => 1.3, :height=>1.5, 
      :border=>{:width=>4, :left=>15, :right=>15, :show=>true},  
      :text=>{:offset=>[0, -12], :size=>11}})
    doc.render :png, :filename => 'public/images/foo.png' 
  end

  def passport_print
    output = Passport.new.to_pdf(@human)
    respond_to do |format|
      format.pdf do
        send_data output, :filename => "passport.pdf", :type => "application/pdf", :format => 'pdf'
      end
    end
  end

  def order
    if @order
      redirect_to :action => "show", :code_erc => params[:code_erc], :id_city => params[:id_city]  
    end
  end

=begin
    if not @order
      @order = Order.new
      for d in @debts do
        oi = OrderItem.new
        oi.amount = d.sum_month
        oi.utility_name = d.utility
        oi.debt = d.sum_dolg
        oi.expense = d.sum_month
        oi.start_date = '04.02.2010'.to_date
        @order.order_items << oi
      end
    end
=end

  def order_save
    redirect_to :action => "show", :code_erc => params[:code_erc], :id_city => params[:id_city]  
  end
  
  def debt
  end
  
  def update_debts
    redirect_to :action => "show", :code_erc => params[:code_erc], :id_city => params[:id_city]  
  end

  def search
    if params[:code_erc]>''
      if params[:home]>''
        @human = Payer.find(:first, :conditions => ["code_erc=? and id_city=?", params[:code_erc], @id_city])
        if @human.room_location.house_location.house.n_house != params[:home].to_i
          flash_error 'wrong_home'
          redirect_to firms_path
        end
        if @human.room_location.room.n_room>0
          if params[:room]==''
            flash_error 'room_absent'
            redirect_to firms_path
          else
            if @human.room_location.room.n_room != params[:room].to_i
              flash_error 'wrong_room'
              redirect_to firms_path
            else
              redirect_to payer_path @human
            end
          end
        else
          if params[:room]>''
            flash_error 'wrong_room'
            redirect_to firms_path
          end
        end
      else  
        flash_error 'home_absent'
        redirect_to firms_path
      end      
    else
      flash_error 'code_erc_absent'
      redirect_to firms_path
    end
#    redirect_to human_path   
  end
  
  def find_payer_by_address
    if params[:room_id]
      @human = Payer.find(:first, :conditions => ["id_room_location=?", params[:room_id]])
    else
      @human = Payer.find(:first, :conditions => ["id_room_location=?", params[:room][:id]])
    end
    if !@human
      flash_error 'code_erc_absent'
      redirect_to firms_path
    else
#      redirect_to :action => "show", :id => @human.id
      redirect_to :action => "show_utszn_data", :id => @human.id
    end
  end
  
  def show_utszn_data
    @utszn_data = Payer.find(:all,
      :select => 'f.name, u.name utility, bb.code_firm, bb.bank_book, ha.* , bad.*, bal.*, bar.*, bat.* ',
      :conditions => ["humans.id=? and bad.id_period =? 
        and ? between ha.id_period_begin and ha.id_period
        and ? between bar.id_period_begin and bar.id_period
        and ? between bat.id_period_begin and bat.id_period
        and ? between bal.id_period_begin and bal.id_period", 
        @human.id, @period.id, @period.id, @period.id, @period.id, @period.id],
      :joins => 'inner join bankbooks bb on humans.id=bb.id_human 
        inner join bankbook_utilities bu on bu.id_bankbook = bb.id
        inner join utilities u on u.code = bu.code_utility
        inner join firms f on f.code = bb.code_firm
        inner join bankbook_attributes_debts bad on bad.id_bankbook_utility = bu.id
        inner join bankbook_attributes_lgots bal on bal.id_bankbook_utility = bu.id
        inner join bankbook_attributes_tarifs bat on bat.id_bankbook_utility = bu.id
        inner join bankbook_attributes_rooms bar on bar.id_bankbook = bb.id
        inner join bankbook_attributes_humans ha on bb.id=ha.id_bankbook')
    
  end
  
  private

  def get_city_id
    if params[:id_city]
      @id_city = params[:id_city]
    else
      if @human
        @id_city = @human.id_city
      else
        @id_city = params[:city][:id]
      end
    end
  end  
    
  def find_period
    @city = City.find @human.id_city
    if @city.id_parent != 0
      id_main_city = @city.id_parent
    else
      id_main_city = @id_city
    end
    @period = Period.find(:first, :conditions => ["id_city=? and status=1", id_main_city])
  end

  def find_human
    @human = Payer.find params[:id]
  end

  def find_payers
    @payers = Payer.find(:all,
      :select => 'bb.code_firm, bb.bank_book, ha.* ',
      :conditions => ["humans.id=? and ha.id_period>=? and ha.id_period_begin<=?", 
        @human.id, @period.id, @period.id],
      :joins => 'left join bankbooks bb on humans.id=bb.id_human 
        left join bankbook_attributes_humans ha on bb.id=ha.id_bankbook')
  end
  
  def find_room_params
    @room_params = Payer.find(:all,
      :select => 'bb.code_firm, bb.bank_book, ra.* ',
      :conditions => ["humans.id=? and ra.id_period>=? and ra.id_period_begin<=?", 
        @human.id, @period.id, @period.id],
      :joins => 'left join bankbooks bb on humans.id=bb.id_human 
        left join bankbook_attributes_rooms ra on bb.id=ra.id_bankbook')
  end

  def find_debts
    @debts = Payer.find(:all,
      :select => 'bar.total_area, bar.heat_area, bat.tarif, bal.rate_lg1, 
        bal.rate_lg2, bal.rate_lg3, bal.rate_lg4, bal.rate_lg5, bah.full_name, 
        bah.resident_number, bb.code_firm, bb.bank_book, bu.code_utility, f.name firm, 
        u.unit, u.name utility, u.code utility_id, ut.name ut_name, p.description period, d.* ',
      :conditions => ["humans.id=? and d.id_period=?", @human.id, @period.id],
      :joins => 'left join bankbooks bb on humans.id=bb.id_human
        left join firms f on bb.code_firm=f.code
        left join bankbook_utilities bu on bb.id=bu.id_bankbook
        left join utilities u on bu.code_utility=u.code 
        left join utility_types ut on u.id_type=ut.id 
        left join bankbook_attributes_debts d on bu.id=d.id_bankbook_utility
        left join bankbook_attributes_lgots bal on bu.id=bal.id_bankbook_utility and bal.id_period=d.id_period
        left join bankbook_attributes_tarifs bat on bu.id=bat.id_bankbook_utility and bat.id_period=d.id_period
        left join bankbook_attributes_rooms bar on bb.id=bar.id_bankbook and bar.id_period=d.id_period
        left join bankbook_attributes_humans bah on bb.id=bah.id_bankbook and bah.id_period=d.id_period
        left join periods p on p.id=d.id_period
        ')
#        left join counters c on bu.id=c.bankbook_utility_id 
#        left join counter_readings cr on c.id=cr.counter_id 
#        left join last_firm_attributes_view fa on bb.code_firm=fa.code
#        left join last_firm_attributes_view fa on fa.code=bb.code_firm
#        left join wardsUkraine w on fa.mfo=w.mfo , fa.mfo mfo
  end

  def find_tariffs
    @tariffs = Payer.find(:all,
      :select => 'bb.code_firm, bb.bank_book, bu.code_utility, f.name firm, u.name utility, t.* ',
      :conditions => ["humans.id=? and t.id_period>=? and t.id_period_begin<=?", 
        @human.id, @period.id, @period.id],
      :joins => 'left join bankbooks bb on humans.id=bb.id_human
        left join firms f on bb.code_firm=f.code
        left join bankbook_utilities bu on bb.id=bu.id_bankbook
        left join utilities u on bu.code_utility=u.code 
        left join bankbook_attributes_tarifs t on bu.id=t.id_bankbook_utility')
  end

  def find_exemptions
    @exemptions = Payer.find(:all,
      :select => 'bb.code_firm, bb.bank_book, bu.code_utility, f.name firm, u.name utility, e.* ',
      :conditions => ["humans.id=? and e.id_period=?", @human.id, @period.id],
      :joins => 'left join bankbooks bb on humans.id=bb.id_human
        left join firms f on bb.code_firm=f.code
        left join bankbook_utilities bu on bb.id=bu.id_bankbook
        left join utilities u on bu.code_utility=u.code 
        left join bankbook_attributes_lgots e on bu.id=e.id_bankbook_utility')
  end

  def find_order 
    @order = Order.find(:first, :conditions => ["human_id=? and period_id=?", @human.id, @period.id])
  end
  
  def find_history
    @histories = Payer.find(:all,
      :select => 'date_p, bb.bank_book, f.name firm, u.name utility,
        wards.short_name as ward_name, bankbook_payments.nop, summ, dateb, datee',
      :conditions => ["humans.id=? ", @human.id],
      :joins => 'left join bankbooks bb on humans.id=bb.id_human
        left join firms f on bb.code_firm=f.code
        left join bankbook_utilities bu on bb.id=bu.id_bankbook
        left join utilities u on bu.code_utility=u.code 
        inner join bankbook_payments on(bankbook_payments.id_bankbook_utility = bu.id)
        inner join wards on (bankbook_payments.id_ward = wards.id)')
#        inner join file_registrations on(bankbook_payments.id_file = file_registrations.id)
#        left join bankbook_attributes_tarifs t on bu.id=t.id_bankbook_utility')
# order by date_p desc,firm_name,plat_name       
  end
  def find_debt
    @debt = BankbookAttributesDebt.find(:first,
      :conditions => ["id_bankbook_utility=? and id_period=?", params[:debt_id], params[:period_id]])
  end
end
