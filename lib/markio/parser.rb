require 'nokogiri'
require 'date'
module Markio
  class Parser

    # @return [Object]
    #   Nokogiri::HTML data
    def initialize data
      @document = Nokogiri::HTML data
    end
    
    # Finds an object or list of objects in the db using a query
    # 
    # @return [String, Array<String>, nil] the object or objects to
    #   find in the database. Can be nil.
    # 
    # @tagname This is
    #   indented tag data
    #
    # @meta_data_tag some data
    # @!directive_tag some data
    # * UNCHECKED      0
    # * BOGUS          1
    # * INDETERMINATE  2
    # * INSECURE       3
    # * SECURE         4  (success)
    #
    # @param (see #initialize)
    # @author Loren Segal
    # @deprecated Use {#my_new_method} instead of this method because
    #   it uses a library that is no longer supported in Ruby 1.9.
    #   The new method accepts the same parameters.
    # @note This method may modify our application state!
    def parse
      bookmarks = []
      traverse(@document, []) do |bookmark|
        bookmarks << bookmark
      end
      consolidate bookmarks
    end

    private

    def traverse node, folders, &block
      node.xpath("./*").each do |child|
        case child.name.downcase
          when 'dl'
            traverse child, folders, &block
            folders.pop
          when 'a'
            yield parse_bookmark(child, folders)
          when 'h3'
            folders << child.text
          else
            if child.children.any?
              traverse child, folders, &block
            end
        end
      end

    end

    def parse_bookmark(node, folders)
      data = {}
      node.attributes.each do |k, a|
        data[k.downcase] = a.value
      end
      bookmark = Bookmark.new
      bookmark.href = data['href']
      bookmark.title = node.text
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
