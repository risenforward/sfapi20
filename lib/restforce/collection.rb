require 'generator' if RUBY_VERSION =~ /\A1\.8/

module Restforce
  class Collection
    include Enumerable

    # Given a hash and client, will create an Enumerator that will lazily
    # request Salesforce for the next page of results.
    def initialize(hash, client)
      @client = client
      @raw_page = hash
    end

    # Yield each value on each page.
    def each
      @raw_page['records'].each { |record| yield SObject.new(record, @client) }

      next_page.each { |record| yield record } if has_next_page?
    end

    # Return the size of the Collection without making any additional requests.
    def size
      @raw_page['totalSize']
    end
    alias_method :length, :size

    # Return the current and all of the following pages.
    def pages
      [self] + (has_next_page? ? next_page.pages : [])
    end

    # Returns true if there is a pointer to the next page.
    def has_next_page?
      !@raw_page['nextRecordsUrl'].nil?
    end

    # Returns the next page as a Restforce::Collection if it's available, nil otherwise.
    def next_page
      @next_page ||= @client.get(@raw_page['nextRecordsUrl']).body if has_next_page?
    end
  end
end
