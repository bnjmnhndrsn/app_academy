require_relative '../phase6/controller_base'
require_relative '../bonus/router'
require 'active_support/core_ext'

module PhaseBonus 
  class ControllerBase < Phase6::ControllerBase
    include UrlHelper
    
    def initialize(req, res, route_params = {})
      include_helpers
      super(req, res, route_params)
    end
  end
end
