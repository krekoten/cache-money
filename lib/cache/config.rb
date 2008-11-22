module Cache
  module Config
    def self.included(a_module)
      a_module.module_eval do
        extend ClassMethods
        delegate :repository, :to => "self.class"
      end
    end
    
    module ClassMethods
      DEFAULT_OPTIONS = {
        :indices => [Cache::IndexSpec.new(:id)],
        :ttl => 1.day
      }
      
      def index(attributes, options = {})
        cache_config.indices << Cache::IndexSpec.new(attributes, options)
      end
      
      def repository
        cache_config.repository
      end

      def indices
        cache_config.indices
      end
      
      private
      def cache_config=(options)
        write_inheritable_attribute :cache_config, Config.new(DEFAULT_OPTIONS.merge(options))
      end
      
      class Config
        attr_reader :ttl, :indices, :repository
        
        def initialize(options = {})
          @indices = options[:indices]
          @ttl = options[:ttl]
          @repository = options[:repository]
        end
        
        def dup
          Config.new(:indices => @indices.dup, :ttl => @ttl, :repository => @repository)
        end
      end
    end
  end
end
