require 'spec_helper'

describe 'Basic Functionality' do
  it 'has a version number' do
    expect(Csvdb::VERSION).not_to be nil
  end

  it 'can open and write to a file' do
    table = Csvdb.new(file: 'docs/one.csv')
    table.write('docs/write_to.csv')
    expect(table).not_to be nil
    File.open('docs/write_to.csv').each_with_index do |line, idx|
      expect(line).to eq 'test1,test2' if idx == 1
      expect(line).to eq 'name1,name2' if idx == 2
    end
  end

end
