module Platform


  module Ubuntu

    def platform_prefixes
      %w{ubuntu generic}
    end

  end

end

Dosh::Script.send(:include, Platform::Ubuntu)
