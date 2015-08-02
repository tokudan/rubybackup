class Backup
  def initialize(src, dst, excludes)
    @time = Time.now
    @dst = String.new
    @src = String.new
    @destination_path = String.new
    @old_backups = Array.new
    source(src)
    destination(dst)
    @excludes = excludes
    @dirs = Array.new
    @files = Array.new
    @links = Array.new
    $stdout.puts("Backup initialized with source=#{@src} and destination=#{@dst}. Subdirectory will be #{@my_time}")
    $stdout.puts('Using the following old backups for links:')
    @old_backups.each { |line| $stdout.puts(line) }
  end

  def source(src)
    src = File.absolute_path(src)
    if not Dir.exists?(src)
      error = Exception.new('No such directory: ' + src)
      raise error
    end
    # Figure out a decent encoding for filenames...
    encoding = nil
    Dir.foreach(src) { |file|
      encoding = file.encoding
      break
    }
    $stderr.puts "Using #{encoding} for filenames."
    @src = src.encode(encoding)
  end

  def destination(dst)
    dst = File.absolute_path(dst)
    if not Dir.exists?(dst)
      error = Exception.new('No such directory: ' + dst)
      raise error
    end
    # Figure out a decent encoding for filenames...
    encoding = nil
    Dir.foreach(dst) { |file|
      encoding = file.encoding
      break
    }
    $stderr.puts "Using #{encoding} for filenames."
    @dst = dst.encode(encoding)
    @my_time = @time.strftime('%Y-%m-%d--%H-%M-%S')
    @destination_path = @dst + '/' + @my_time
    Dir.foreach(@dst) { |file|
      if Dir.exists?(@dst + '/' + file)
        @old_backups << file unless file == '.' or file == '..'
      end
    }
	@old_backups.sort!
	@old_backups.reverse!
  end

  def prepare
    paths = Array.new
    paths << '' # will be expanded to @src
    while path = paths.shift
      src = @src.encode(path.encoding)
      dst = @src.encode(path.encoding)
      p path.encoding, path, src.encoding, src
      type = File.ftype(src + '/' + path)
      case type
        when 'file'
          f = BFile.new(src, dst, @my_time, path, @excludes, @old_backups)
          if f.backup?
            case f.backup_type
              when :copy
                @files << f
              when :link
                @links << f
              else
                raise Exception.new('Unknown response from BFile class')
            end
          end
        when 'directory'
          d = BDir.new(src, @destination_path, path, @excludes)
          if d.backup? # Necessary for ignores
            @dirs << d
          end
          d.each_child { |c|
            paths << c
            #$stderr.puts("Adding #{c}")
          }
        else
          raise Exception.new("Filetype not recognized: #{type}")
      end
    end
  end

  def backup!
    $stdout.puts('Recreating directory structure...')
    @dirs.each { |dir| dir.backup! }
    $stdout.puts('Populating unchanged files...')
    @links.each { |file| file.backup! }
    $stdout.puts('Copying files...')
    @files.each { |file| file.backup! }
    $stdout.puts('Backup finished.')
    $stdout.puts("#{@dirs.count} directories with #{@files.count} files copied. Additionally #{@links.count} files used from older backups.")
  end
end
