class Tweet
  attr_reader :text, :date, :color, :images

  KEYWORDS  = [
      "t+o+u+c+h+d+o+w+n", " td ", "fie+ld go+a+l", " fg ", "safety",
      "i+n+t+e+r+c+e+p+t+i+o+n", "f+u+m+b+l+e", "punt", "s+a+c+k", " int ", "block", "pick", "drop",
      "kickoff", "kick off", "1q", "2q", "3q", "4q", "quarter", "halftime", " ht ", "injury", "penalty", "flag",
      "challenge", "overtime", "final", "first", "second", "third",  "fourth", "six", "win", "red zone", "end zone"
      ]

  def initialize tweet
    @text = tweet.text
    @date = tweet.created_at
    @color = nil
    @images = tweet.media
  end
end
