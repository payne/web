
class Exercises
  include Enumerable

  def initialize(dojo, key)
    @parent = dojo
    @key = key
    @path = env_var.value(@key)
    disk[cache_path].write_json_once(cache_filename) { make_cache }
  end

  attr_reader :parent, :path

  def each(&block)
    all.values.each(&block)
  end

  def [](name)
    all[name]
  end

  include CacheProperties

  private

  def all
    @all ||= read_cache
  end

  def make_cache
    cache = {}
    disk[path].each_dir do |dir_name|
      # .git dir is stripped out if running on web server
      # with named data volumes from [./cyber-dojo start-point create...]
      # but .git dir is not stripped out if running on *local* server
      if dir_name != '.git'
        cache[dir_name] = { text: make(dir_name).text }
      end
    end
    cache
  end

  def read_cache
    cache = {}
    disk[cache_path].read_json(cache_filename).each do |name, hash|
      cache[name] = make(name, hash['text'])
    end
    cache
  end

  def make(dir_name, text = nil)
    Exercise.new(self, dir_name, text)
  end

  include NearestAncestors
  def env_var; nearest_ancestors(:env_var); end
  def disk; nearest_ancestors(:disk); end

end
