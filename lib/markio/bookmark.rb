require 'date'
class Markio::Bookmark
  # ## NETSCAPE-Bookmark format settings
  # @param [String] :title, :href, :add_date, :last_visit, :last_modified, :folders, :icon_uri, :icon, :last_charset
  
  # @return [String] Bookmark title of item, example `The Ruby Reflector` in `<DT><A ...>The Ruby Reflector</A>`
  attr_accessor :title
  
  # @return [String] Bookmark item url (HREF), example '<DT><A HREF="http://rubyreflector.com/ActionScript"....'
  attr_accessor :href
  
  # @return [String] ADD_DATE, example `<DT><A ... ADD_DATE="1377884090"... `
  attr_accessor :add_date
  
  # @return [String] !!!WRONG param last_visit, there are no last_visit in NETSCAPE-Bookmark
  attr_accessor :last_visit
  
  # @return [String] LAST_MODIFIED, example `<DT><A ... LAST_MODIFIED="1377884090"... `
  attr_accessor :last_modified
  
  # @return [String] folders where bookmark consist, example Ruby is a folder `<DT><H3 ...>Ruby</H3>`
  attr_accessor :folders
  
  # @return [String] ICON_URI, example `<DT><A ... ICON_URI="http://reflectornetwork.com/favicon.ico"... >...</A>`
  attr_accessor :icon_uri
  
  # @return [String] ICON as raw data/base64, example '<DT><A ... ICON="data:image/png;base64,iVBO.....5CYII="... >...</A>'
  attr_accessor :icon
  
  # @return [String] LAST_CHARSET, example '<DT><A ... LAST_CHARSET="UTF-8">...</A>'
  attr_accessor :last_charset

  # @return [Bookmark]
  def self.create data
    bookmark = new
    bookmark.title = data[:title]
    bookmark.href = data[:href]
    bookmark.add_date = data[:add_date] || DateTime.now
    bookmark.last_visit = data[:add_date]
    bookmark.last_modified = data[:last_modified]
    bookmark.folders = data[:folders] || []
    bookmark.icon_uri = data[:icon_uri]
    bookmark.icon = data[:icon]
    bookmark.last_charset = data[:last_charset]
    bookmark
  end

  def == other
    unless other.nil? or other.class != self.class
      other.href == href and other.title == title
    end
  end
end
