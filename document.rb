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

DocGen.overide GObject::Object, :get_property do
  param :name => [String, "The property name"]
  returns Object, "The value"
end

DocGen.overide GObject::Object, :set_property do
  param :name => [String, "The property name"]
  param :value => [Object, "The value"]
  returns "void"  
end

DocGen.overide GObject::Object, :signal_connect do
  param   :name => [String, "The signal name"]
  returns "void"
  
  yieldparam   :o => ["void", "Anything passed to the block, varies per signal"]
  yieldreturns "void", "Varies per signal" 
end

dg = DocGen.new(GObject)

ns = dg.document

YARDGenerator.generate(ns)

