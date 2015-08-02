class BFile
  def initialize(src, dest, backup, path, excludes, old_backups)
    @src = src
    @dest = dest
    @backup = backup
    @path = path
    @excludes = excludes
    @old_backups = old_backups
    @backup_type = nil
    @use_old_backup = nil
    @excluded = false
    @excludes.each { |exclude|
      @excluded = true if File.fnmatch?(exclude, @path)
      break if @excluded
    }
  end

  def backup?
    not @excluded
  end

  def backup_type
    # Check if the source file matches an old backup, if yes: link, if no: copy
    @backup_type = :copy
    # Add a small chance that the file is copied anyway...
    if rand(100) > 5
      original_stat = File::Stat.new(@src + '/' + @path) # Get reference from the file we have to backup
      @old_backups.each { |old_backup|
        if File.exists?(@dest + '/' + old_backup + '/' + @path)
          fstat = File::Stat.new(@dest + '/' + old_backup + '/' + @path)
          if (fstat<=>original_stat) == 0
            if fstat.size == original_stat.size
              @use_old_backup = old_backup
              @backup_type = :link
              break
            end
          end
        end
      }
    end
    @backup_type
  end

  def backup!
    case @backup_type
      when :copy
        $stdout.puts("Copying #{@path}")
        tf = File.new(@dest + '/' + @backup + '/' + @path, 'w+')
        tf.binmode
        sf = File.new(@src + '/' + @path)
        sf.binmode
        stat = sf.stat
        data = nil
        tf.write(data) while data = sf.read(1024*1024) # read up to 1 MByte at a time
        GC.start # Make sure memory is cleaned up again
        sf.close
        tf.close
        File.utime(stat.atime, stat.mtime, @dest + '/' + @backup + '/' + @path)
      when :link
        File.link(@dest + '/' + @use_old_backup + '/' + @path, @dest + '/' + @backup + '/' + @path)
      # $stdout.puts("Using #{@use_old_backup} for #{@path}")
      else
        raise Exception.new
    end
  end
end