local Byte = {};
---初始化一个byte对象,len默认0,不初始化缓冲区
---```lua
--- local bs = byte.new(128);
--- byte.writeUTF(bs,"1234ab",6);
--- byte.writeInt(bs,123);
--- local ns = byte.new();
--- byte.copy(bs,ns);
--- print( byte.readUTF(ns),byte.readInt(ns));
---```
---检测字节对象bs是否异常,缓冲区是否溢出
function Byte.check(bs)
    local len,buffersize = mbyte("bs_getLen",bs);
    -- print("**",len,buffersize);
    if(len > buffersize) then
        --缓冲区的空间小于需要存储的数据空间
        local str = string.format("buffersize(%d bytes) is less then len(%d bytes), buffer is overflow!",buffersize,len);
        func_error(str);
    end
end
function Byte.new(len)
    local bs = mbyte("new");
    len = len or 0;
    if(len > 0) then
        mbyte("bs_write_start",bs,len);
    end
    -- print("new len=",len);
    return bs;
end

function Byte.writeInt(bs,v)
    mbyte("bs_writeInt",bs,v);
end
function Byte.writeUTF(bs,s)
    mbyte("bs_writeUTF",bs,s);
    -- print("***",byte.getLen(bs));
end
---
---
function Byte.copy(bs,rs)
    local mlen = mbyte("bs_copy",bs,rs);
    return mlen;
end

function Byte.readInt(bs)
    return mbyte("bs_readInt",bs);
end

function Byte.readUTF(bs)
    return mbyte("bs_readUTF",bs);
end

return Byte;