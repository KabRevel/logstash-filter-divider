# encoding: utf-8
require 'spec_helper'
require "logstash/filters/divider"

describe LogStash::Filters::Divider do

  describe "Config with value LINE_RETURN and Cancel equals FALSE" do
    let(:config) do <<-CONFIG
      filter {
        divider {
            value => "\\n"
            cancel => false
        }
      }
    CONFIG
    end

    sample("message" => 'file1.xml\nfile2.xml') do

        expect(subject[0].get("message")).to eq('file1.xml\nfile2.xml')
        expect(subject[1].get("message")).to eq('file1.xml')
        expect(subject[2].get("message")).to eq('file2.xml')
    end
  end

  describe "Config with value LINE_RETURN and Cancel equals TRUE" do
    let(:config) do <<-CONFIG
      filter {
        divider {
            value => "\\n"
            cancel => true
        }
      }
    CONFIG
    end

    sample("message" => 'file1.xml\nfile2.xml') do

        expect(subject[0].get("message")).to eq('file1.xml')
        expect(subject[1].get("message")).to eq('file2.xml')
    
    end
  end


end
