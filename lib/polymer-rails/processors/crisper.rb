require 'polymer-rails/crisper'
if Polymer::Rails::LEGACY_SPROCKETS
  require 'polymer-rails/processors/sprockets_v2_processor'
else
   require "polymer-rails/processors/sprockets_v3_processor"
end

module Polymer
  module Rails
    module Processors
      class Crisper < Polymer::Rails::SprocketsProcessor
        
        def process
          #@component.  
          @component.stringify
        end

      private

        def prepare(input)
          @context = input[:environment].context_class.new(input)
          @component = Polymer::Rails::Crisper.new(input[:data])
        end


        
      end
    end
  end
end

