require 'spec_helper'

describe 'Basic Functionality' do
  before(:each) { File.truncate(write_to, 0) }

  it 'version number' do
    expect(Csvdb::VERSION).not_to be nil
  end

  it 'the correct number of rows' do
    table = Csvdb.new(file: stats)
    expect(table.count).to eq 1200
  end

  it 'open and write to a file' do
    table = Csvdb.new(file: one)
    table.write(write_to)
    expect(table).not_to be nil
    File.open(write_to).each_with_index do |line, idx|
      expect(line).to eq("test1,test2\n") if idx == 0
      expect(line).to eq("name1,name2\n") if idx == 1
    end
  end

end

describe 'Query Capabilities' do
  let(:table) { Csvdb.new(file: stats) }

  it 'search for results' do
    expect(table.where { |row| row[3] == '233' }.count).to eq 2
  end

  it 'find by an id' do
    expect( table.find(0).counts ).to eq '741'
  end

  it 'find by a block' do
    expect(table.find { |row| row[table.counts] == '741' }.counts).to eq '741'
  end

  it 'get all records' do
    expect(table.all).to_not be nil
  end

  it 'pluck records' do
    versions = table.pluck(:version)
    expect( versions ).to eq versions.flatten
    expect( versions.count ).to eq 1200
  end

end

describe 'CRUD Functionality' do
  let(:table) { Csvdb.new(file: stats) }
  let(:simple) { Csvdb.new(file: one) }

  it 'create a record' do
    simple.create(test1: 'foo', test2: 'bar')
    expect( simple.find(1).test1 ).to eq 'foo'
    expect( simple.find(1).test2 ).to eq 'bar'
  end

  it 'update a record' do
    rec = simple.find(0)
    expect( rec.test1 ).to eq "name1"
    rec.update(test1: 'foo', test2: 'bar')
    expect( simple.find(0) ).to eq ["foo", "bar"]
    expect( rec.test1 ).to eq "foo"
  end

  it 'delete a record' do
    t1 = simple.count
    rec = simple.find(0)
    expect( simple.find(0) ).to_not eq nil
    rec.delete
    t2 = simple.count
    expect( simple.find(0) ).to eq nil
    expect( t1 ).to eq t2
  end

end
