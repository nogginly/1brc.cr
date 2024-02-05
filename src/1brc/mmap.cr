# This is already inside Crystal; I'm keeping this here to help document my use of
# `mmap`
lib LibC
  # PROT_EXEC   =   0x04
  # PROT_NONE   =   0x00
  # PROT_READ   =   0x01
  # PROT_WRITE  =   0x02
  # MAP_FIXED   = 0x0010
  # MAP_PRIVATE = 0x0002
  # MAP_SHARED  = 0x0001
  # MAP_ANON    = 0x1000
  # MAP_FAILED  = Pointer(Void).new(-1)

  fun mmap(addr : Void*, length : SizeT, prot : Int, flags : Int, fd : Int, offset : OffT) : Void*
  fun munmap(addr : Void*, length : SizeT) : Int
end
