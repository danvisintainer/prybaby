class Prybaby

  class << self
    attr_accessor :mode, :lines_modified, :files_modified
  end

  def self.go(args)
    binding.pry

    Prybaby.mode = ''
    Prybaby.lines_modified = 0
    Prybaby.files_modified = 0

    process_args(args)

    if self.mode == 'h' || 'e'
      puts "Sorry, I didn't recognize those arguments." if self.mode == 'e'
      print_help
    else
      load_files
    end

  end

  def self.print_help
    puts 'Help goes here!'
  end

  def self.process_args(args)
    args = args.gsub('-', '')
    self.mode = 'h' if args == 'help'

    if args.length > 1 || args.scan(/u|r|c/).empty?
      self.mode = 'e'
    else
      self.mode = args
    end
  end

  def self.load_files()
    Dir.glob(File.join(".", "**", "*.rb")).each do |file|
      remove_breakpoints(file)
    end

    print_removed_breakpoint_stats
  end

  def self.remove_breakpoints(file)
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

  end

  def self.print_removed_breakpoint_stats
    binding.pry
    if self.lines_modified == 0 && self.files_modified == 0
      puts 'No changes were made.'
    else
      puts "#{self.lines_modified} were removed in #{self.files_modified} files."
    end
  end

end