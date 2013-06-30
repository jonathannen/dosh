module Platform


  module Ubuntu

    def platform_prefixes
      # %w{ubuntu/12.04LTS ubuntu debian linux}
      %w{ubuntu generic}
    end

  end

end

Dosh::Script.send(:include, Platform::Ubuntu)
