module TracksHelper
  def ugly_lyrics(lyrics)
    escaped = h(lyrics.chomp.split("\n").map { |line| "♫ #{line}"}.join("\n"))
    "<pre>#{escaped}</pre>".html_safe
  end
end