# frozen_string_literal: true

module AutoloadReloader
  module Paths
    def self.concat(paths)
      add(paths, prepend: false)
    end

    def self.push(*paths)
      concat(paths)
    end

    def self.<<(path)
      push(path)
    end

    def self.unshift(*paths)
      add(paths, prepend: true)
    end

    def self.clear
      paths.clear
      Autoloads.remove_all
    end

    def self.replace(paths)
      clear
      concat(paths)
    end

    def self.to_a
      paths.dup.freeze
    end

    class << self
      alias_method :prepend, :unshift
    end

    @paths = []

    class << self
      private

      attr_accessor :paths

      def add(new_paths, prepend: false)
        return if new_paths.empty?
        if prepend
          paths.unshift(*new_paths)
          new_paths.reverse_each do |path|
            Autoloads.add_from_path(path, prepend: true)
          end
        else
          paths.concat(new_paths)
          new_paths.each do |path|
            Autoloads.add_from_path(path, prepend: false)
          end
        end
      end
    end
  end
end
