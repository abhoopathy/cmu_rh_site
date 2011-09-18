# Use the app.rb file to load Ruby code, modify or extend the models, or
# do whatever else you fancy when the theme is loaded.
require 'compass'
require 'sinatra'
require 'sassy-buttons'
require 'coffee-script'
require 'v8'

class Game
  attr_accessor :game_time, :opponent, :our_score, :opponent_score
  @playoff
  @home
  @win

  def initialize(game)

    @game_time = process_time game['year'],game['month'], game['day'],game['time']

    @playoff = game['playoff'].include?('true')
    @home = game['home'].include? 'Carnegie'

    if (@home)
      @opponent = game['away']
      @our_score = game['home_score'].to_i
      @opponent_score = game['away_score'].to_i
    else
      @opponent = game['home']
      @our_score = game['away_score'].to_i
      @opponent_score = game['home_score'].to_i
    end

    @win = (@our_score > @opponent_score)

  end

  def process_time(year,month,day,time_string)
    colon = time_string.index ':'
    minute = time_string[colon+1..colon+2].to_i
    pm = (time_string[colon+3] == "p")
    hour = time_string[0..colon-1].to_i + (pm ? 12 : 0)
    Time.new(year.to_i,month.to_i,day.to_i,hour,minute)
  end

  def result_string
    win? ? "W #{our_score} - #{opponent_score}" : "L #{opponent_score} - #{our_score}"
  end

  def upcoming?
    game_time > Time.new
  end

  def playoff?
    @playoff
  end

  def home?
    @home
  end

  def win?
    @win
  end

end

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
            player[headerList[j].strip] = (lineArray[i][j]).to_s.strip
          end
          resultHash[i-1] = player
        end
        resultHash
      end

      def get_schedule
        gameHashList = csv_to_hash('schedule.csv')
        games = []
        gameHashList.each{|gameHash| games.push(Game.new(gameHash))}
        games
      end

      def get_roster
        csv_to_hash('roster.csv')
      end


    end

  end
end
