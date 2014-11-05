require_relative '../phase6/router'
require_relative '../bonus/url_helper'
require 'active_support/core_ext'

module PhaseBonus
  class BetterRouter < Phase6::Router
    
    def resources(name, actions)
      actions.each do |action|
        hash = UrlHelper::get_url_hash(action, name)
        self.send(hash[:method], hash[:pattern], "#{name.to_s.capitalize}Controller".constantize, action)
      end
    end
    
  end
end