-- local Shape = core.ui.Shape;

--设置缓冲区大小
local function ftext_set_buffer(txt, v)
    return ftext(txt, "set_buffer",v);
end
---创建文本对象  
---fw:字体宽度    
---fh:字体高度  
local function ftext_create(w, h, fw, fh,renderlist)
    --cam = cam or core.cam2d:get_p();
    local name = core.getName();
    w = w or 64;
    h = h or 64;

    -- 12,11
    fw = fw or 13;
    fh = fh or 12;
--    fw = fw or 16;fh = fh or 15;
    local p = ftext(nil, "create", name, string.format("%s,%s,%s,%s", w, h, fw, fh),renderlist);
    -- or core.renderlist
    ftext_set_buffer(p,64);--设置预制缓冲区
    return p;
end
-- 设置文本对象坐标
local function ftext_setpos(txt, x, y)
    ftext(txt, "setpos", string.format("%s,%s", x or 0, y or 0));
end
----设置文本对象中的文本坐标
-- function func_ftext_setchar(txt,s,x,y)
--    x = x or 0;
--    y = y or 0;
--    return ftext(txt,"setchar",s,string.format("%s,%s",x,y));
-- end
-- 解析多个字符
local function ftext_parse(txt, s)
    return ftext(txt, "parse", s);
end
-- 显示隐藏
local function ftext_vis(txt, v)
    return ftext(txt, "vis", tostring(v));
end

-- 擦除
local function fext_clear(txt)
    ftext(txt, "clear");
end
--获取文本
local function ftext_str(txt)
    return ftext(txt, "str");
end
function ftext_get_wordpos(txt)
--function ftext_getsize(txt)
	--func_error(1);
    return ftext(txt, "wordpos");
end
--获取文本的w,h
local function ftext_get_wh(txt)
	return ftext(txt,"size");
end

--获取ftext的容器,此容器是sprite
local function ftext_get_container(txt)
	return ftext(txt, "get_container");
end
-- 重新设置文本对象
local function ftext_reset(txt, s)
--    print(string.len(s));
    fext_clear(txt);
    ftext_parse(txt, s);
end

-- 销毁
local function fext_dispose(txt)
    if(txt) then
        ftext(txt, "dispose");
    else
        func_error("txt = nil");
    end
end

--***************************************************
NLabel = {
	
};
NLabel.__index = NLabel;

-- set_parent(NLabel,Base);
setmetatable(NLabel, Base);--设置NLabel继承自Base

---创建一个文本对象
---@param cam Camera引用
---@param bgcolor 是否设置文本背景的颜色
---@param fontSize 字号
function NLabel:new(w,h,renderlist,bgcolor,fontSize)
	local obj = Base:new();
    setmetatable(obj, NLabel);
    -- self:f1();   --这里去元表NLabel里找到方法f1调用
	obj:settype(core.UI_TYPE.NLabel);--14
    obj.curstr = "";--防止重复绘制相同的文本对象,缓存一个文本标识
    if(bgcolor==true) then
        obj.bg = Shape:new(w,h,nil,renderlist);
        obj.bg:setcolor(0,0,0);
    end

    if( fontSize )then
        local size = fontSize or 13;
            obj.tf = ftext_create(w,h,size,size+1,renderlist);
        else
            obj.tf = ftext_create(w,h,13,12,renderlist);
        end
	return obj;
end

-- function NLabel:f1()
--     print('f1');
-- end
function NLabel:set_text(s)
    if(self.curstr == s) then
    else
        self.curstr = s;
        ftext_reset(self.tf,s);
    end
end

function NLabel:set_pos(x,y)
	ftext_setpos(self.tf,x,y);
end
-- function NLabel:get_pos()
--     return ftext_get_wordpos(self.tf);
-- end
function NLabel:get_size()
	return ftext_get_wh(self.tf);
end

function NLabel:get_text()
	return ftext_str(self.tf);
end

function NLabel:visible(v)
	if(v) then
		v = 1;
	else
		v = 0;
	end
	ftext_vis(self.tf,v);
end

----[[
---销毁NLabel组件对象
function NLabel:dispose()
    self:super("dispose");
    -- print('>>>>>>>>>>>>> NLabel:dispose',self);
    fext_dispose(self.tf);
    if(self.bg) then
        self.bg:dispose();
    end
	func_clearTableItem(self);
end

--]]

--[[
    function NLabel:call(key1,key2)
    print("NLabel:",key1,key2);
end
]]

function NLabel:get_container()
	return ftext_get_container(self.tf);
end