module Restforce
  class SObject < Restforce::Mash

    def sobject_type
      self.attributes.type
    end

    # Public: Get the describe for this sobject type
    def describe
      @client.describe(sobject_type)
    end

    # Public: Persist the attributes to Salesforce.
    #
    # Examples
    #
    #   account = client.query('select Id, Name from Account').first
    #   account.Name = 'Foobar'
    #   account.save
    def save
      ensure_id
      @client.update(sobject_type, attrs)
    end

    def save!
      ensure_id
      @client.update!(sobject_type, attrs)
    end

    # Public: Destroy this record.
    #
    # Examples
    #
    #   account = client.query('select Id, Name from Account').first
    #   account.destroy
    def destroy
      ensure_id
      @client.destroy(sobject_type, self.Id)
    end

    def destroy!
      ensure_id
      @client.destroy!(sobject_type, self.Id)
    end

    # Public: Returns a hash representation of this object with the attributes
    # key and parent/child relationships removed.
    def attrs
      self.to_hash.reject { |key, _| key =~ /.*__r/ || key =~ /^attributes$/ }
    end

    def to_sparam
      self.Id
    end

  private

    def ensure_id
      raise 'You need to query the Id for the record first.' unless self.Id?
    end

  end
end
