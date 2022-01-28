--------------------------------------------------------------------
-- ��Ϣ�������
local function f_select(list,index,p)
	local self = p;
	local _stat = self._stat;
	--local index =listbox_get_index(list);
	---[[
    if (index == 0) then
		print("windows test!");
    elseif (index == 1) then
        func_gc();
    elseif (index == 2) then
        self:loadfps();
    elseif (index == 3) then
        _stat = not _stat;
--        print(_stat);

        if(_stat) then
        	core.setBackgroundColor(0.1,0.1,0.1);
        else
           	core.setBackgroundColor(0.4,0.4,0.4);
        end
	elseif (index == 4) then
		--lua gc
		func_lua_gc();
    elseif(index == 5) then
		core.cam:reset();
    end
	--]]
end

local InfoWin = {
	list,
	_stat,
	fps,
};
InfoWin.__index= InfoWin;
setmetatable(InfoWin, IPlugin);--�̳��Բ���ӿ�
function InfoWin:new()
	local self = {};
	setmetatable(self, InfoWin);
	self:init();
	return self;
end
--�л���ʾfps
function InfoWin:loadfps()
	if(self.fps==nil) then
		
		self.fps = core.plugin:load("view/FpsView");--���ز��
		self.fps:show();
	else
		core.plugin:unload(self.fps);
		self.fps = nil;
	end
end

function InfoWin:set_pos(x,y)
	self.list:set_pos(x,y);
end

function InfoWin:init()
	
	--[[local list  = listbox_new(x or 0, y or 0);
	listbox_bind(list,f_select);
	
	
	listbox_add(list,"������Ϣ");
	listbox_add(list,"gc");
	listbox_add(list,"fps");
	listbox_add(list,"������ɫ");
	listbox_add(list,"����mesh");
	listbox_add(list,"����cam");
	listbox_set_title(list,"infowin");--]]
	
	local list = NListBox:new(0,0,128);
	list:addItem("������Ϣ");
	list:addItem("gc");
	list:addItem("fps");
	list:addItem("������ɫ");
	list:addItem("LuaGC");
	list:addItem("����cam");
	list:bind(f_select,self);

	
	--listbox_del(list);
	--return list;
	
	
	--list:dispose();
	
	self.list = list;
end

function InfoWin:getName()
	return "InfoWin";
end

function InfoWin:dispose()
	self.list:dispose();
	
	if(self.fps) then
		core.plugin:unload(self.fps);
	end
	
	func_clearTableItem(self);
end

return InfoWin;