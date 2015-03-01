class Prybaby

  class << self
    attr_accessor :lines_modified, :files_modified
  end

  def self.go(args)
    Prybaby.lines_modified = 0
    Prybaby.files_modified = 0
    load_files
  end

  def self.load_files
    puts "Loading files..."

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

  def self.print_removed_breakpoint_stats
    binding.pry
    if self.lines_modified == 0 && self.files_modified == 0
      puts 'No changes were made.'
    else
      puts "#{self.lines_modified} were removed in #{self.files_modified} files."
    end
  end

end