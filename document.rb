require "fileutils"

if ARGV.length > 0
  puts "Writes YARD documentation to ./doc"
  exit(1)
end

FileUtils.mkdir_p d="./tmp/dummy_source"

Dir.chdir d

File.open "document.rb", "w" do |f|
  f.puts DATA.read
end

system "mruby document.rb"
system "yard doc gobject*.rb"

# FileUtils.rm_f "../../doc"
`rm -rf ../../doc`
FileUtils.mv "doc", "../../"

Dir.chdir "../../"
`rm -rf tmp`

__END__

DocGen.overide GObject::Object, :get_property do |m|
  m[:symbol] = :g_object_get_property
  m[:method] = true

  arg = DocGen::Output::Argument.new
  arg[:name]        = "name"
  arg[:description] = "the name of the property"
  
  t = arg[:type]  = DocGen::Output::Type.new
  t[:name]        = "String"
  
  m[:arguments]   = [arg]
  
  r = m[:returns] = DocGen::Output::Return.new
  r[:description] = "the property's value"
  rt = r[:type]   = DocGen::Output::Type.new
  
  rt[:name]       = "Object"
end

DocGen.overide GObject::Object, :set_property do |m|
  m[:symbol] = :g_object_set_property
  m[:method] = true

  arg1               = DocGen::Output::Argument.new
  arg1[:name]        = "name"
  arg1[:description] = "the name of the property"
  
  t = arg1[:type]  = DocGen::Output::Type.new
  t[:name]         = "String"
  
  arg2               = DocGen::Output::Argument.new
  arg2[:name]        = "value"
  arg2[:description] = "the value to set to"
  
  t = arg2[:type]  = DocGen::Output::Type.new
  t[:name]         = "::Object"  
  
  m[:arguments]   = [arg1,arg2]
  
  r = m[:returns] = DocGen::Output::Return.new
  rt = r[:type]   = DocGen::Output::Type.new
  
  rt[:name]       = "void"
end

DocGen.overide GObject::Object, :signal_connect do |m|
  m[:symbol] = :g_signal_connect_data
  m[:method] = true

  arg1               = DocGen::Output::Argument.new
  arg1[:name]        = "signal"
  arg1[:description] = "the name of the signal"
  
  t = arg1[:type]  = DocGen::Output::Type.new
  t[:name]         = "String"
  
  arg2               = DocGen::Output::Argument.new
  arg2[:name]        = "b"
  arg2[:description] = "the block to call"
  
  arg2[:type]       = :block
  b = arg2[:block]  = DocGen::Output::Block.new
  b[:parameters]    = [prm=DocGen::Output::Argument.new]
  prm[:type]        = "void"
  prm[:description] = "Any values passed to the block"
  prm[:name]        = 'o'

  
  prt  = b[:returns] = DocGen::Output::Return.new
  prtt = prt[:type]  = DocGen::Output::Type.new
  prtt[:name]        = "void"
  prt[:description]  = "Varies per signal"

  
  m[:arguments]   = [arg1,arg2]
  
  r = m[:returns] = DocGen::Output::Return.new
  rt = r[:type]   = DocGen::Output::Type.new
  
  rt[:name]       = "void"
end

dg = DocGen.new(GObject)

ns = dg.document

YARDGenerator.generate(ns)

