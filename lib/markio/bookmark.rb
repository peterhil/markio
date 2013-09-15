require 'date'
class Markio::Bookmark
  # Create bookmark format
  # @param :title, :href, :add_date, :last_visit, :last_modified, :folders, :icon_uri, :icon, :last_charset
  
  attr_accessor :title, :href, :add_date, :last_visit, :last_modified, :folders, :icon_uri, :icon, :last_charset

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
