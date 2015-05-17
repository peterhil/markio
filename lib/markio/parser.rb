require 'hpricot'
require 'date'
module Markio
  class Parser

    # @return [Object]
    #   Nokogiri::HTML data
    def initialize data
      @document = Hpricot data
    end
    
    # Parse bookmarks
    # 
    # @return [Markio::Bookmark]
    #   List of Markio bookmarks
    def parse
      bookmarks = []
      traverse(@document, []) do |bookmark|
        bookmarks << bookmark
      end
      bookmarks
    end

    private

    def traverse node, folders, &block
      return unless node.respond_to?('children') and node.children.to_a.any?
      node.children.each do |child|
        case child.pathname
          when 'dl'
            traverse child, folders, &block
            folders.pop
          when 'a'
            yield parse_bookmark(child, folders)
          when 'h3'
            folders << child.inner_text
          else
            traverse child, folders, &block
        end
      end

    end

    def parse_bookmark(node, folders)
      data = {}
      node.attributes.to_hash.each do |k, a|
        data[k.downcase] = a
      end
      bookmark = Bookmark.new
      bookmark.href = data['href']
      bookmark.title = node.inner_text
      bookmark.folders = (Array.new(folders) + parse_tags(data['tags'])).uniq
      bookmark.add_date = parse_timestamp data['add_date']
      bookmark.last_visit = parse_timestamp data['last_visit']
      bookmark.last_modified = parse_timestamp data['last_modified']
      bookmark.icon_uri = data['icon_uri']
      bookmark.icon = data['icon']
      bookmark.last_charset = data['last_charset']
      bookmark
    end

    def parse_timestamp(timestamp)
      Time.at(timestamp.to_i).to_datetime if timestamp
    end

    def parse_tags(tags)
      tags ? tags.split(/,/x) : []
    end

    def consolidate(bookmarks)
      consolidated = []
      bookmarks.each do |b|
        index = consolidated.index b
        unless index.nil?
          consolidated[index].folders += b.folders
        else
          consolidated << b
        end
      end
      consolidated
    end

  end
end
