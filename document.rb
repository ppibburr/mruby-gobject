require "fileutils"

if ARGV.length > 0
  puts "Writes YARD documentation to ./doc"
  exit(1)
end



`rm -rf ./tmp`
`mkdir ./tmp`

File.open("./tmp/runner.rb","w") do |f|
  f.puts DATA.read
end
runner = File.expand_path("./tmp/runner.rb")
od = File.expand_path(Dir.getwd)
`rm -rf doc`
Dir.chdir("../mruby-girffi-docgen-html/")
system "ruby bin/docgen --lib=GObject --runner=#{runner}"
`cp -rf ./tmp/doc #{od}/`
`rm -rf ./tmp`

Dir.chdir od
`rm -rf ./tmp`


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
g = DocGen::Generator::HTML.new(ns)
g.generate
