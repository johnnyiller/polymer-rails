require "spec_helper"
require "polymer-rails/xml_adapters/base"
require "polymer-rails/crisper"

describe Polymer::Rails::Crisper do

  let(:data){ '<dom-module id="test-module">
      <ul>
        <li custom-json=\'{test: "value"}\' custom-atrr="{{cattr}}" data-attr="some data"></li>
      </ul>
      <div class$="{{myclass}}"></div>
      <script>
        function(){
          var test = "something";
        }
        var test = "something"
      </script>
    </dom-module>
    <dom-module id="test-module-two">
      <ul>
        <li custom-json2=\'{test_two: "value_two"}\' custom-atrr2="{{cattr}}" data-attr2="some data"></li>
      </ul>
      <div class$="{{myclasstwo}}"></div>
      <script>
        function(){
          var test = "something two";
        }
        var test = "something two";
      </script>
    </dom-module>'
  }

  context '#move_scripts_to_bottom' do 
    subject do 
      doc = described_class.new(data)
      doc.move_scripts_to_bottom
      doc
    end

    it 'moves inline scripts to the bottom of the page' do 
      expect(subject.stringify).to include('</dom-module><script>')
      expect(subject.stringify).not_to include('</script></dom-module>')
      expect(subject.stringify).to include('class$="{{myclass}}"')
      expect(subject.stringify).to include('custom-json2=\'{test_two: "value_two"}\'')
    end

  end

end
