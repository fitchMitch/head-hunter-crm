module CoreExtensions
  module Hash
    module Merging
      def string_merge(other_hash, separator = ' ')
        merge(other_hash) {|key, old, new| old.to_s + separator + new.to_s }
      end
    end
  end
end
