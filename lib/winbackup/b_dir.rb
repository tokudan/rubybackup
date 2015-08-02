class BDir
  def initialize(source, dest, dir, excludes)
    @src = source
    @dest = dest
    @dir = dir
    @excludes = excludes
    @excluded = false
    @excludes.each { | exclude |
      @excluded = true if File.fnmatch?(exclude, @dir)
      break if @excluded
    }
  end

  def backup?
	r = true
	r = false if @excluded
	r = false if Dir.exists?(@dest + '/' + @dir)
	r
  end

  def backup!
    Dir.mkdir(@dest + '/' + @dir)
  end

  def each_child
	Dir.foreach(@src + '/' + @dir) do |path|
      yield @dir + '/' + path unless path == '.' or path == '..'
    end unless @excluded
  end
end