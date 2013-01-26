module Flex
  module Deprecation

    extend self

    def warn(old, new, called=1)
      Conf.logger.warn "#{old} is deprecated in favour of #{new}, and will be removed in a next version (called at: #{caller[called]})"
    end

    module Module

      def extended(obj)
        Deprecation.warn(self, self::NEW_MODULE, 2)
        obj.extend self::NEW_MODULE
      end

      def included(base)
        Deprecation.warn(self, self::NEW_MODULE, 2)
        base.send :include, self::NEW_MODULE
      end

    end

  end


  ### DEPRECATIONS ###

  Configuration.instance_eval do
    # temprary deprecation warnings
    def base_uri
      Deprecation.warn 'Flex::Configuration.base_uri', 'Flex::Configuration.http_client.base_uri'
      http_client.base_uri
    end
    def base_uri=(val)
      Deprecation.warn 'Flex::Configuration.base_uri=', 'Flex::Configuration.http_client.base_uri='
      http_client.base_uri = val
    end
    def http_client_options
      Deprecation.warn 'Flex::Configuration.http_client_options', 'Flex::Configuration.http_client.options'
      http_client.options
    end
    def http_client_options=(val)
      Deprecation.warn 'Flex::Configuration.http_client_options=', 'Flex::Configuration.http_client.options='
      http_client.options = val
    end
    def raise_proc
      Deprecation.warn 'Flex::Configuration.raise_proc', 'Flex::Configuration.http_client.raise_proc'
      http_client.raise_proc
    end
    def raise_proc=(val)
      Deprecation.warn 'Flex::Configuration.raise_proc=', 'Flex::Configuration.http_client.raise_proc='
      http_client.raise_proc = val
    end
  end


  class Variables
    def add(*hashes)
      Deprecation.warn 'Flex::Variables#add', 'Flex::Variables#deep_merge!'
      replace deep_merge(*hashes)
    end
  end


  module Struct::Mergeable
    def add(*hashes)
      Deprecation.warn 'Flex::Variables#add', 'Variables#deep_merge!'
      replace deep_merge(*hashes)
    end
  end


  module ClassProxy::Loader::Doc
    def info(*names)
      Deprecation.warn 'flex.info', 'flex.doc'
      doc *names
    end
  end


  module Result::Collection
    NEW_MODULE = Struct::Paginable
    extend Deprecation::Module
  end

end
