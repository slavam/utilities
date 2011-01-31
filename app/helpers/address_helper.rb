module AddressHelper
  def render_address_card(room_location)
    render :partial => 'address/show', :locals => { :room_location => room_location }
  end

  def render_address_form(form, address)
    render :partial => 'address/form', :object => form, :locals => { :address => address }
  end
end

