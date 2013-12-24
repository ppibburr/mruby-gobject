GObject::Value
class GObject::Value
  # BUG: bug in mruby likely... `g_value_init` from libgobject-2.0 will segfault
  #      call `init(t)` manually before passing a value to be used by C, only throws a warning
  def init t
    get_struct[:g_type] = t
    get_struct[:data] = n=FFI::MemoryPointer.new(:pointer,FFI::Pointer.size*2)
    return self
  end
  
  def self.new
    q=self::StructClass.new
    q[:g_type] = 0
    wrap q.pointer
  end
end
