

class AdminSettings
    include ActiveModel::Model
    include ActiveModel::Serialization

    attr_accessor :login_with_otp


    def initialize(attributes={})
        # @context = context
        # @login_with_otp = context[:login_with_otp]

        super(attributes)
    end



    def attributes
    {'login_with_otp' => nil}
    end


   


  end