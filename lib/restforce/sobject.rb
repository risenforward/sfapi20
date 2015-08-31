module Restforce
  class SObject < Hashie::Mash
    attr_reader :sobject_type

    def initialize(source_hash = nil, client = nil, default = nil, &blk)
      self.build(source_hash) if source_hash
      default ? super(default) : super(&blk)
    end

    def build(hash)
      attributes = hash.delete('attributes')
      @sobject_type = attributes['type']
      mash = Hashie::Mash.new(hash)
      self.replace(mash)
    end

  end
end
