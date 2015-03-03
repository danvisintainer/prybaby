class Prybaby

  class << self
    attr_accessor :mode, :lines_modified, :files_modified, :word
  end

  def self.go(args)
    Prybaby.mode = ''
    Prybaby.lines_modified = 0
    Prybaby.files_modified = 0

    process_args(args)
    load_files
    print_stats
  end

  def self.print_usage
    puts "USAGE: prybaby [option]"
  end

  def self.print_help
    print_usage
    puts "-r: Remove breakpoints from files."
    puts "-c: Comment out lines with pry breakpoints."
    puts "-u: Uncomment lines with pry breakpoints."
  end

  def self.process_args(args)
    if args == nil
      self.mode = 'c'
    else
      args = args.gsub('-', '')
      self.mode = 'h' if args == '-help'
      if args.length > 1 || args.scan(/u|r|c|h/).empty?
        self.mode = 'e'
      elsif 
        self.mode = args
      end
    end
  end

  def self.load_files()
    if self.mode == 'r'
      Dir.glob(File.join(".", "**", "*.rb")).each { |file| remove_breakpoints(file) }
    elsif self.mode == 'c'
      Dir.glob(File.join(".", "**", "*.rb")).each { |file| comment_out_breakpoints(file) }
    elsif self.mode == 'u'
      Dir.glob(File.join(".", "**", "*.rb")).each { |file| remove_comments_from_breakpoints(file) }
    elsif self.mode == 'e'
      print_usage
    elsif self.mode == 'h'
      print_help
    end
  end

  def self.remove_breakpoints(file)
    self.word = 'removed'
    file_changed = false
    temp_file = Tempfile.new('tempfile')

    open(file, 'r').each do |l|
                     # if l.include?('binding.pry')
        self.lines_modified += 1
        file_changed = true
      else
        temp_file << l
      end
    end

    if file_changed
      temp_file.close
      FileUtils.mv(temp_file.path, file)
      self.files_modified += 1
    end
  end

  def self.comment_out_breakpoints(file)
    self.word = 'commented out'
    file_changed = false
    temp_file = Tempfile.new('tempfile')

    open(file, 'r').each do |l|
      if l.strip[0] == '#'
        temp_file << l
                        # elsif l.include?('binding.pry')
        self.lines_modified += 1
        file_changed = true

                                       # temp_file << "#{' ' * l.index('binding.pry')}\# #{l.strip}\n"
      else
        temp_file << l
      end
    end

    if file_changed
      temp_file.close
      FileUtils.mv(temp_file.path, file)
      self.files_modified += 1
    end
  end

  def self.remove_comments_from_breakpoints(file)
    self.word = 'uncommented'
    file_changed = false
    temp_file = Tempfile.new('tempfile')

    open(file, 'r').each do |l|
                     # if l.include?('binding.pry') && l.include?('#')
        spaces = l.index('#')
        temp_file << "#{' ' * spaces}#{l[spaces + 2..l.length]}"
        self.lines_modified += 1
        file_changed = true
      else
        temp_file << l
      end
    end

    if file_changed
      temp_file.close
      FileUtils.mv(temp_file.path, file)
      self.files_modified += 1
    end
  end

  def self.print_stats
    if self.lines_modified == 0 && self.files_modified == 0
      puts 'PRYBABY: No changes were made.'
    else
      puts "PRYBABY: #{self.lines_modified} lines were #{self.word} in #{self.files_modified} files."
    end
  end
end