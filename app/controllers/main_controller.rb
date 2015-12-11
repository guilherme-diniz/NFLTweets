class MainController < ApplicationController
  before_action :set_client, only: [:search]

  def index
    @teams =  YAML.load_file( File.join( Rails.root, 'app', 'config', 'teams.yml' ))
  end

  def search
    @away_team = params[:away]
    @home_team = params[:home]
    @date = Time.parse params[:date]
    @teams =  YAML.load_file( File.join( Rails.root, 'app', 'config', 'teams.yml' ))

    hashtag = "#{@teams[@away_team]}vs#{@teams[@home_team]}"

    account_away_team = @client.user_search(@away_team, count: 10).delete_if{|x| not (x.name =~ /#{@away_team}/i)}.sort_by{|x| -x.followers_count}.first
    account_home_team = @client.user_search(@home_team, count: 10).delete_if{|x| not (x.name =~ /#{@home_team}/i)}.sort_by{|x| -x.followers_count}.first

    query = "##{hashtag} from:NFL"
    hashtag_results = @client.search(query, lang: :en).to_a
    home_results = @client.search("from:#{account_home_team.screen_name} -rt", lang: :en, since: @date.strftime("%Y-%m-%d") , until: (@date + 1.day).strftime("%Y-%m-%d") ).to_a
    away_results = @client.search("from:#{account_away_team.screen_name} -rt", lang: :en, since: @date.strftime("%Y-%m-%d") , until: (@date + 1.day).strftime("%Y-%m-%d") ).to_a

    popular_results = @client.search("##{hashtag} ", lang: :en, result_type: :popular).to_a

    @count = hashtag_results.count + home_results.count + away_results.count
    @results = hashtag_results + home_results + away_results +  popular_results
    @results.uniq!

  #   @timeline = []
  #   hashtag_results.each do |result|
  #     @timeline << Tweet.new(result, 0)
  #   end

  #   home_results.each do |result|
  #     @timeline << Tweet.new(result, 1)
  #   end

  #   away_results.each do |result|
  #     @timeline << Tweet.new(result, 2)
  #   end
    binding.pry
    @results.delete_if{|x| not (Tweet::KEYWORDS.any?{|w| x.text =~ /#{w}/i})}
    @results.sort_by!{|tweet| tweet.created_at.to_i}
    @results.delete_if{|x| x.created_at < @date }

    @timeline = []
    @results.each do |result|
      tweet = Tweet.new result
      @timeline << tweet
    end


  end

  private
  def set_client
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key    = "8RpFIQIVraqgK4KaGL9rPJeQK"
      config.consumer_secret = "7L6uiP0kDwz3mAdlJ3BKqWarBR0yJc5PDM925nYCCwEvr0yvAp"
      config.access_token = "110405261-gRcWqaMQTBtafqztD8jN7TZbFcDHqffjnn0x7QPR"
      config.access_token_secret = "DOhrehBsBckOhKDorMyBWZTGpAIPyUr6odZPlrx4G6kxN"
    end
  end

end
