# Use the app.rb file to load Ruby code, modify or extend the models, or
# do whatever else you fancy when the theme is loaded.
require 'compass'
require 'sinatra'
require 'sassy-buttons'
require 'coffee-script'

module Nesta
  class App
    configure do
      Compass.configuration do |config|
        config.project_path= File.dirname(__FILE__)
        config.sass_dir = 'views'
        config.environment = :development
        config. relative_assets = true
        config.http_path = "/"
      end

      set :haml, { :format => :html5 }
      set :sass, Compass.sass_engine_options

    end

   
    helpers do

      get '/js/*.js' do
        filename = params[:splat][0]
        file = "views/js/#{filename}.coffee"
        if File.exists? file
          return CoffeeScript.compile File.read(file)
        else
          file = "content/pages/js/#{filename}.coffee"
          return CoffeeScript.compile File.read(file)
        end

      end

      def csv_to_hash(csv)
        lineArray = []
        File.open(csv, 'r').each do |line|
          lineArray.push((line.gsub(/\n/,'')).split(','))
        end
        resultHash = []
        headerList = lineArray[0]
        for i in (1...lineArray.length) do
          player = Hash.new
          for j in (0...headerList.length) do
            player[headerList[j]] = lineArray[i][j]
          end
          resultHash[i-1] = player
        end
        resultHash
      end

      def get_schedule
        csv_to_hash('schedule.csv')
      end

      def get_roster
        csv_to_hash('roster.csv')
      end


    end

  end
end
