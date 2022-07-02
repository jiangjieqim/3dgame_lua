-- local Shape = core.ui.Shape;

--���û�������С
local function ftext_set_buffer(txt, v)
    return ftext(txt, "set_buffer",v);
end
---�����ı�����  
---fw:������    
---fh:����߶�  
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
    ftext_set_buffer(p,64);--����Ԥ�ƻ�����
    return p;
end
-- �����ı���������
local function ftext_setpos(txt, x, y)
    ftext(txt, "setpos", string.format("%s,%s", x or 0, y or 0));
end
----�����ı������е��ı�����
-- function func_ftext_setchar(txt,s,x,y)
--    x = x or 0;
--    y = y or 0;
--    return ftext(txt,"setchar",s,string.format("%s,%s",x,y));
-- end
-- ��������ַ�
local function ftext_parse(txt, s)
    return ftext(txt, "parse", s);
end
-- ��ʾ����
local function ftext_vis(txt, v)
    return ftext(txt, "vis", tostring(v));
end

-- ����
local function fext_clear(txt)
    ftext(txt, "clear");
end
--��ȡ�ı�
local function ftext_str(txt)
    return ftext(txt, "str");
end
function ftext_get_wordpos(txt)
--function ftext_getsize(txt)
	--func_error(1);
    return ftext(txt, "wordpos");
end
--��ȡ�ı���w,h
local function ftext_get_wh(txt)
	return ftext(txt,"size");
end

--��ȡftext������,��������sprite
local function ftext_get_container(txt)
	return ftext(txt, "get_container");
end
-- ���������ı�����
local function ftext_reset(txt, s)
--    print(string.len(s));
    fext_clear(txt);
    ftext_parse(txt, s);
end

-- ����
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
setmetatable(NLabel, Base);--����NLabel�̳���Base

---����һ���ı�����
---@param cam Camera����
---@param bgcolor �Ƿ������ı���������ɫ
---@param fontSize �ֺ�
function NLabel:new(w,h,renderlist,bgcolor,fontSize)
	local obj = Base:new();
    setmetatable(obj, NLabel);
    -- self:f1();   --����ȥԪ��NLabel���ҵ�����f1����
	obj:settype(core.UI_TYPE.NLabel);--14
    obj.curstr = "";--��ֹ�ظ�������ͬ���ı�����,����һ���ı���ʶ
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
---����NLabel�������
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