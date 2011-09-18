#!/usr/bin/ruby

require 'rubygems'
require 'gdocs4ruby'
include GDocs4Ruby

@service = Service.new
@username = nil
@password = nil

def tester
  if ARGV.include?("-d")
      @service.debug = true
  end
  ARGV.each do |ar|
    if ar.match("username=")
      @username = ar.gsub("username=", "")
    end
    if ar.match("password=")
      @password = ar.gsub("password=", "")
    end
  end
  service_test
  document_crud
  find_document
end

def service_test
  puts "---Starting Service Test---"
  puts "1. Authenticate"
  if @service.authenticate(@username, @password)
    successful
  else
    failed
  end
  
  puts "2. Authenticate with GData version 3.0"
  @service = Service.new({:gdata_version => '3.0'})
  if @service.authenticate(@username, @password) and @service.gdata_version == '3.0'
    successful
  else
    failed
  end
end

def document_crud
  puts "---Starting Document Test---"
  @service = Service.new()
  @service.authenticate(@username, @password)
  
  content = '<h1>test content</h1>'
  content1 = '<b>new content</b>'
  content_type = 'html'
  title = 'Test title'
  title1 = 'new title'
  
  puts "1. Create Document"  
  doc = Document.new(@service)
  doc.title = title
  doc.content = content
  doc.content_type = content_type
  if doc.save and doc.title == title and doc.get_content('html').include? 'test content'
    successful
  else
    failed
  end
  
  puts "2. Update Document"  
  doc.title = title1
  doc.content = content1
  doc.content_type = content_type
  if doc.save and doc.title == title1 and doc.get_content('html').include? 'new content'
    successful
  else
    failed
  end
  
  puts "3. Delete Document"
  if doc.delete
    successful
  else
    failed
  end
end

def find_document
  puts "---Starting Query Test---"
  puts "1. Create Document"  
  doc = Document.new(@service)
  doc.title = title
  doc.content = content
  doc.content_type = content_type
  if doc.save and doc.title == title and doc.get_content('html').include? 'test content'
    successful
  else
    failed
  end
  
  puts "2. Find Document"
  
end

def failed(m = nil)
  puts "Test Failed"
  puts m if m
  exit()
end

def successful(m = nil)
  puts "Test Successful"
  puts m if m
end

tester