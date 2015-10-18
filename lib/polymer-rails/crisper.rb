require 'uri'

module Polymer
  module Rails
    # this class can be used to optimize polymer component initialization 
    # more efficiently on browsers that don't yet support web components.
    # moving the scripts into on script tag outside of the dom-module element
    # means the components initialize quicker on browsers that are using polyfills
    #
    # This class is inspired by: https://github.com/PolymerLabs/crisper
    class Crisper

      SELECTORS = {
        javascript: "script:not([src])"
      }
       
      def initialize(data)
        @adapter = XmlAdapters::Base.factory
        @doc = @adapter.parse_document(data)
      end

      def stringify
        @adapter.stringify(@doc)
      end

      def move_scripts_to_bottom
        concat_scripts = @adapter.css_select(@doc, SELECTORS[:javascript]).inject("") do |result, script|
          inner_script = script.inner_html
          inner_script = inner_script.strip
          last_line = inner_script.lines.last
          inner_script << ";" unless last_line =~ /\/\/|;\s*$|\*\/\s*$/
          result << "\n#{inner_script}"
          script.remove
          result
        end
        body_node = @adapter.css_select(@doc, 'body')[0]
        script_node = @adapter.create_node @doc, 'script', concat_scripts 
        @adapter.add_child body_node, script_node
      end

    end
  end
end
