class Prybaby

  class << self
    attr_accessor :mode, :lines_modified, :files_modified, :word
  end

  def self.go(args)
    Prybaby.mode = ''
    Prybaby.lines_modified = 0
    Prybaby.files_modified = 0

    process_args(args)

    if self.mode == 'h' || self.mode == 'e'
      puts "Sorry, I didn't recognize those arguments." if self.mode == 'e'
      print_help
    else
      load_files
    end

    print_stats
  end

  def self.print_help
    puts 'Help goes here!'
  end

  def self.process_args(args)
    if args == nil
      self.mode = 'r'
    else
      args = args.gsub('-', '')
      self.mode = 'h' if args == '-help'
      if args.length > 1 || args.scan(/u|r|c/).empty?
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
    end
  end

  def self.remove_breakpoints(file)
    self.word = 'removed'
    file_changed = false
    temp_file = Tempfile.new('tempfile')

    open(file, 'r').each do |l|
      if l.include?('binding.pry')
        self.lines_modified += 1
        file_changed = true
      else
        temp_file << l
      end
    end

    temp_file.close
    FileUtils.mv(temp_file.path, file)
    self.files_modified += 1 if file_changed
  end

  def self.comment_out_breakpoints(file)
    self.word = 'commented out'
    file_changed = false
    temp_file = Tempfile.new('tempfile')

    open(file, 'r').each do |l|
      if l.include?('binding.pry')
        self.lines_modified += 1
        file_changed = true
        temp_file << "\# #{l}"
      else
        temp_file << l
      end
    end

    temp_file.close
    FileUtils.mv(temp_file.path, file)
    self.files_modified += 1 if file_changed
  end

  def self.remove_comments_from_breakpoints(file)
    self.word = 'commented out'
    file_changed = false
    temp_file = Tempfile.new('tempfile')

    open(file, 'r').each do |l|
      if l.include?('binding.pry')
        self.lines_modified += 1
        file_changed = true
        temp_file << "\# #{l}"
      else
        temp_file << l
      end
    end

    temp_file.close
    FileUtils.mv(temp_file.path, file)
    self.files_modified += 1 if file_changed
  end

  def self.print_stats
    if self.lines_modified == 0 && self.files_modified == 0
      puts 'No changes were made.'
    else
      puts "#{self.lines_modified} lines were #{self.word} in #{self.files_modified} files."
    end
  end

end