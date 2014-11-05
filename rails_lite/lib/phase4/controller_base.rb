require_relative '../phase3/controller_base'
require_relative './session'

module Phase4
  class ControllerBase < Phase3::ControllerBase
    def redirect_to(url)
      self.session.store_session(@res)
      self.flash.store_flash(@res)
      super(url)
    end

    def render_content(content, type)
      self.session.store_session(@res)
      self.flash.store_flash_now(@res)
      super(content, type)
    end

    # method exposing a `Session` object
    def session
      @session ||= Session.new(@req)
    end
    
    def flash
      @flash ||= Flash.new(@req)
    end
  end
end
