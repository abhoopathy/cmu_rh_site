# Use the app.rb file to load Ruby code, modify or extend the models, or
# do whatever else you fancy when the theme is loaded.
require 'compass'
require 'sinatra'
require 'sassy-buttons'
require 'coffee-script'
require 'v8'
require 'GDocs4Ruby'

class Roster
  attr_accessor :players

  def initialize(playerarr)
    @players = playerarr.sort {|a,b| a.last_name <=> b.last_name}
  end

  def get_by_position(pos)
    @players.find_all {|player| player.position == pos}
  end

end

class Player
  attr_accessor :first_name, :last_name, :number, :position, :goals

  def initialize(player)
    @first_name = player['first']
    @last_name = player['last']
    @number = player['number']
    @goals = player['goals']
    @position = player['position']
  end

  def full_name
    "#{@first_name} #{@last_name}"
  end

end

class Schedule
  attr_accessor :games, :year #year is indexed by year season begins in, (i.e. 2010 refers to 2010-2011 season)

  def initialize(gamearr, year)
    @games = gamearr.sort {|a,b| a.game_time <=> b.game_time}
    @year = year
  end

  def get_past_games
    games.findall {|game| game.upcoming? == false}
  end

  def get_playoff_games
    games.findall {|game| game.playoff? == false}
  end
  
  def get_upcoming_games
    games.findall {|game| game.upcoming? == true}
  end
end

class Game
  attr_accessor :game_time, :opponent, :our_score, :opponent_score
  @playoff
  @home
  @win

  def initialize(game)

    @game_time = process_time game['year'],game['month'], game['day'],game['time']

    @playoff = game['playoff'].downcase.include?('true')
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

  def truncate_opponent
    @opponent.gsub('University','U.').gsub('College','Coll.')

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
    @roster
    @schedule

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

      #TODO make this accept a year, but default to current year in param for archival purposes, then pass this to Schedule.new
      def schedule
        if !@schedule
          games = []
          gameHashList = csv_to_hash('schedule.csv')
          gameHashList.each{|gameHash| games.push(Game.new(gameHash))}
          @schedule = Schedule.new(games, 2010)
        else
          return @schedule
        end
      end

      def roster
        if !@roster
          playerHashList = csv_to_hash('roster.csv')
          players = []
          playerHashList.each{|playerHash| players.push(Player.new(playerHash))}
          @roster = Roster.new(players)
          return @roster
        else
          return @roster
        end
      end

      #def get_schedule_gdoc
      #  service = GDocs4Ruby::Service.new
      #  service.authenticate('cmu.inline@gmail.com', 'gotartans')
      #  # [#<GDocs4Ruby::Spreadsheet:0x007f82ec26e078 @xml="<entry xmlns:app='http://www.w3.org/2007/app' xmlns:docs='http://schemas.google.com/docs/2007' gd:etag='&quot;GlcPUUpIFCp7ImBr&quot;' xmlns:gAcl='http://schemas.google.com/acl/2007' xmlns:gCal='http://schemas.google.com/gCal/2005' xmlns:gd='http://schemas.google.com/g/2005' xmlns:georss='http://www.georss.org/georss' xmlns:gml='http://www.opengis.net/gml' xmlns:openSearch='http://a9.com/-/spec/opensearch/1.1/' xmlns='http://www.w3.org/2005/Atom'><id>https://docs.google.com/feeds/documents/private/full/spreadsheet%3A0AiOeagsvFZGmdF82RGZ5a19yUjB4WkJYSU1TQ0dyVGc</id><published>2011-09-18T22:29:30.736Z</published><updated>2011-09-18T22:30:20.066Z</updated><app:edited xmlns:app='http://www.w3.org/2007/app'>2011-09-18T22:32:26.568Z</app:edited><category label='viewed' scheme='http://schemas.google.com/g/2005/labels' term='http://schemas.google.com/g/2005/labels#viewed'/><category label='spreadsheet' scheme='http://schemas.google.com/g/2005#kind' term='http://schemas.google.com/docs/2007#spreadsheet'/><title>Schedule</title><content src='https://docs.google.com/feeds/download/spreadsheets/Export?key=0AiOeagsvFZGmdF82RGZ5a19yUjB4WkJYSU1TQ0dyVGc' type='text/html'/><link href='https://docs.google.com/spreadsheet/ccc?key=0AiOeagsvFZGmdF82RGZ5a19yUjB4WkJYSU1TQ0dyVGc&amp;hl=en_US' rel='alternate' type='text/html'/><link href='https://spreadsheets.google.com/feeds/worksheets/0AiOeagsvFZGmdF82RGZ5a19yUjB4WkJYSU1TQ0dyVGc/private/full' rel='http://schemas.google.com/spreadsheets/2006#worksheetsfeed' type='application/atom+xml'/><link href='https://spreadsheets.google.com/feeds/0AiOeagsvFZGmdF82RGZ5a19yUjB4WkJYSU1TQ0dyVGc/tables' rel='http://schemas.google.com/spreadsheets/2006#tablesfeed' type='application/atom+xml'/><link href='https://docs.google.com/feeds/documents/private/full/spreadsheet%3A0AiOeagsvFZGmdF82RGZ5a19yUjB4WkJYSU1TQ0dyVGc' rel='self' type='application/atom+xml'/><link href='https://docs.google.com/feeds/documents/private/full/spreadsheet%3A0AiOeagsvFZGmdF82RGZ5a19yUjB4WkJYSU1TQ0dyVGc' rel='edit' type='application/atom+xml'/><link href='https://docs.google.com/feeds/media/private/full/spreadsheet%3A0AiOeagsvFZGmdF82RGZ5a19yUjB4WkJYSU1TQ0dyVGc' rel='edit-media' type='text/html'/><author><name>cmu.inline</name><email>cmu.inline@gmail.com</email></author><gd:resourceId>spreadsheet:0AiOeagsvFZGmdF82RGZ5a19yUjB4WkJYSU1TQ0dyVGc</gd:resourceId><gd:lastModifiedBy><name>cmu.inline</name><email>cmu.inline@gmail.com</email></gd:lastModifiedBy><gd:lastViewed>2011-09-18T22:29:50.091Z</gd:lastViewed><gd:quotaBytesUsed>0</gd:quotaBytesUsed><docs:writersCanInvite value='true'/><gd:feedLink href='https://docs.google.com/feeds/acl/private/full/spreadsheet%3A0AiOeagsvFZGmdF82RGZ5a19yUjB4WkJYSU1TQ0dyVGc' rel='http://schemas.google.com/acl/2007#accessControlList'/></entry>", @service=#<GDocs4Ruby::Service:0x007f82ec1af308 @gdata_version="2.1", @auth_token="DQAAAJoAAABCv-mwwKE3W4Lusc6Xy9bROuzv0tXe1GYMyjWf6I5oUqcY8pf-4rqXr1AvEhfkXNknHNMeu3PZkbvlygbXyfDm3Prk4T8n--MOXkI4XVN_gyIwZ3PTcZg1C569jJVNdpiCTAmdMhHvBh7FtN3qyBLklA8TH57YXgmVJ3eR_uIPmseq6hO-95l-uwW-Ua9AmYgMhvdckVkNqDm2eqWDun2t", @account="cmu.inline@gmail.com", @password="gotartans">, @exists=true, @kind="spreadsheet", @feed_uri="https://docs.google.com/feeds/documents/private/full/spreadsheet%3A0AiOeagsvFZGmdF82RGZ5a19yUjB4WkJYSU1TQ0dyVGc", @parent_uri=nil, @edit_uri="https://docs.google.com/feeds/documents/private/full/spreadsheet%3A0AiOeagsvFZGmdF82RGZ5a19yUjB4WkJYSU1TQ0dyVGc", @acl_uri="https://docs.google.com/feeds/acl/private/full/spreadsheet%3A0AiOeagsvFZGmdF82RGZ5a19yUjB4WkJYSU1TQ0dyVGc", @etag="\"GlcPUUpIFCp7ImBr\"", @content_uri="https://docs.google.com/feeds/download/spreadsheets/Export?key=0AiOeagsvFZGmdF82RGZ5a19yUjB4WkJYSU1TQ0dyVGc", @title="Schedule", @feed_links=[{:label=>"viewed", :scheme=>"http://schemas.google.com/g/2005/labels", :term=>"http://schemas.google.com/g/2005/labels#viewed"}, {:label=>"spreadsheet", :scheme=>"http://schemas.google.com/g/2005#kind", :term=>"http://schemas.google.com/docs/2007#spreadsheet"}, {:rel=>"http://schemas.google.com/acl/2007#accessControlList", :href=>"https://docs.google.com/feeds/acl/private/full/spreadsheet%3A0AiOeagsvFZGmdF82RGZ5a19yUjB4WkJYSU1TQ0dyVGc"}], @categories=[{:label=>"viewed", :scheme=>"http://schemas.google.com/g/2005/labels", :term=>"http://schemas.google.com/g/2005/labels#viewed"}, {:label=>"spreadsheet", :scheme=>"http://schemas.google.com/g/2005#kind", :term=>"http://schemas.google.com/docs/2007#spreadsheet"}, {:rel=>"http://schemas.google.com/acl/2007#accessControlList", :href=>"https://docs.google.com/feeds/acl/private/full/spreadsheet%3A0AiOeagsvFZGmdF82RGZ5a19yUjB4WkJYSU1TQ0dyVGc"}], @include_etag=true, @folders=[], @edit_content_uri="https://docs.google.com/feeds/media/private/full/spreadsheet%3A0AiOeagsvFZGmdF82RGZ5a19yUjB4WkJYSU1TQ0dyVGc", @viewed=true, @content_type=nil, @content=nil, @published=2011-09-18 22:29:30 UTC, @updated=2011-09-18 22:30:20 UTC, @author_name="cmu.inline", @author_email="cmu.inline@gmail.com", @id="spreadsheet:0AiOeagsvFZGmdF82RGZ5a19yUjB4WkJYSU1TQ0dyVGc", @html_uri="https://docs.google.com/spreadsheet/ccc?key=0AiOeagsvFZGmdF82RGZ5a19yUjB4WkJYSU1TQ0dyVGc&hl=en_US", @bytes_used="0", @type="spreadsheet">]
      #  id = 'spreadsheet:0AiOeagsvFZGmdF82RGZ5a19yUjB4WkJYSU1TQ0dyVGc'
      #  s = GDocs4Ruby::Spreadsheet.find(service, {:id => id})
      #  s.download_to_file('csv','schedule.csv')
      #  yield
      #end


    end #end helper

  end #end app class
end #end nesta module
