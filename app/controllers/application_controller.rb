class ApplicationController < ActionController::Base
  helper_method :current_user_session, :current_user
  before_filter :force_utf8_params
  before_filter :set_charset
  protect_from_forgery

def force_utf8_params
  traverse = lambda do |object, block|
    if object.kind_of?(Hash)
      object.each_value { |o| traverse.call(o, block) }
    elsif object.kind_of?(Array)
      object.each { |o| traverse.call(o, block) }
    else
      block.call(object)
    end
    object
  end
  force_encoding = lambda do |o|
    o.force_encoding(Encoding::UTF_8) if o.respond_to?(:force_encoding)
  end
  traverse.call(params, force_encoding)
end

protected

  def current_user
    return @current_user if defined?(@current_user)
#    @current_user = current_user_session && current_user_session.record
    @current_user = current_user_session && current_user_session.user
  end

private
  def set_charset
    @@charset='UTF-8'
#    @headers["Content-Type"] = "text/html; charset=utf-8"
  end

# Extension of String class to handle conversion from/to
    # UTF-8/ISO-8869-1
    class ::String
        require 'iconv'
    
        #
        # Return an utf-8 representation of this string.
        #
        def to_utf
            begin
                Iconv.new("utf-8", "cp1251").iconv(self)
            rescue Iconv::IllegalSequence => e
                STDERR << "!! Failed converting from UTF-8 -> cp1251 (#{self}). Already the right charset?"
                self
            end
        end

        #
        # Convert this string to cp1251
        #
        def to_1251
            begin
                Iconv.new("cp1251", "utf-8").iconv(self)
            rescue Iconv::IllegalSequence => e
                STDERR << "!! Failed converting from cp1251 -> UTF-8 (#{self}). Already the right charset?"
                self
            end
        end
    end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def require_user
    unless current_user
      store_location
      flash_error 'require_user'
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash_error 'require_no_user'
      redirect_to profile_url
      return false
    end
  end
  
  def require_admin
    require_user
    if current_user
      unless current_user.admin?
        flash_error 'require_admin'
        redirect_to profile_url
        return false
      end
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def notice_created
    flash_notice 'created'
  end

  def notice_updated
    flash_notice 'updated'
  end

  def notice_destroyed
    flash_notice 'destroyed'
  end

  def flash_notice(key)
    flash[:notice] = translate_controller key
  end

  def flash_error(key)
    flash[:error] = translate_controller key
  end

  def translate_controller(key)
    name = controller_name.singularize
    translation_opts = { :raise => true }
    I18n.translate "flash.#{name}.#{key}", translation_opts
  rescue I18n::MissingTranslationData => e
    I18n.translate "flash.#{key}", translation_opts.merge(:name => name.humanize)
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

end
