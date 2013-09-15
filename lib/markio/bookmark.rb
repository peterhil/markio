require 'date'
class Markio::Bookmark
  # ## NETSCAPE-Bookmark format settings
  # @param [String] :title, :href, :add_date, :last_visit, :last_modified, :folders, :icon_uri, :icon, :last_charset
  
  # @!attribute [rw] title
  # @return [String] title of item, example The Ruby Reflector in <DT><A ...>The Ruby Reflector</A>
  attr_accessor :title
  
  # @!attribute [rw] href
  # @return [String] <DT><A HREF="http://rubyreflector.com/ActionScript"... >...</A>
  attr_accessor :href
  
  # @!attribute [rw] add_date
  # @return [String] <DT><A ... ADD_DATE="1377884090"... >...</A>
  attr_accessor :add_date
  
  # @!attribute [rw] last_visit
  # @return [String] LAST_VISIT
  attr_accessor :last_visit
  
  # @!attribute [rw] last_modified
  # @return [String] <DT><A ... LAST_MODIFIED="1377884090"... >...</A>
  attr_accessor :last_modified
  
  # @attribute [rw] folders
  # @return [String] folders of bookmark items, example "Ruby" is a folder <DT><H3 ...>Ruby</H3>
  attr_accessor :folders
  
  # @return [String] <DT><A ... ICON_URI="http://reflectornetwork.com/favicon.ico"... >...</A>
  attr_accessor :icon_uri
  
  # @attribute [rw] icon
  # @return [String] ICON as raw data/base64, example '<DT><A ... ICON="data:image/png;base64,iVBO.....5CYII="... >...</A>'
  attr_accessor :icon
  
  # @return [String] <DT><A ... LAST_CHARSET="UTF-8">...</A>
  attr_accessor :last_charset

  # @return [Bookmark] Bookmark data
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
