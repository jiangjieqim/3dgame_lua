local Fps = require("Fps");
local core = core;
local DebugView = {
	
};
DebugView.__index = DebugView;
function DebugView:refreshLabel()
	---@type NLabel
	local label = self.nskin:find("mid_label");
	-- print(label);
	local str = "";
	local camx,camy,camz = core.cam:get_pos();
	str = str .. string.format("cam:%.3f %.3f %.3f\n",camx,camy,camz);
	
	str = str .. "drawCall: "..core.get_drawcall().." ";
	if(self.mid ~= nil) then
		-- str = str + string.format("mid: %d",self.mid);
		-- print(self.mid);
		str = str .. string.format("mid:%d x:%d y:%d",self.mid,self.cx,self.cy);
	end
	
	if(self.ptr~=nil) then
		local ptr = self.ptr;
		local _vertCnt = core.get_vert_cnt(ptr);
		str = str .. '\n' .. string.format("ptr:%#x \nhit:%.2f %.2f %.2f pos:%.2f %.2f %.2f \nvert %d",
		ptr,self.hitx,self.hity,self.hitz,self.x,self.y,self.z,
		_vertCnt);
	end
	
	label:set_text(str);
	--  label:set_text("string.ForMatstring.formatstring.formatb\ta c  d");

end
local function f_onMouseChange(data,self)
	local x,y,mid = core.get_mouse_status();
	-- print('***************',data,x,y,mid);

	self.mid = mid;
	self.cx = x;
	self.cy = y;
	-- print("set data");
	self:refreshLabel();
end
-- local b = false;
local function f_onRayPick(data,self)
	-- print(data,self);
	local ptr,x,y,z,dis = core.get_hit();
	local px,py,pz = get_attr(ptr,"xyz");
	self.hitx = x;
	self.hity = y;
	self.hitz = z;
	self.x = px;
	self.y = py;
	self.z = pz;
	self.ptr = ptr;
	self:refreshLabel();

	-- print(b);
	-- b = not b;
	-- setv(ptr,FLAGS_DISABLE_CULL_FACE)
	-- local type = FLAGS_REVERSE_FACE;--FLAGS_REVERSE_FACE,FLAGS_DISABLE_CULL_FACE
	-- if(b) then
		-- setv(ptr,type);
	-- else
		-- resetv(ptr,type);
	-- end
	getPtrInfo(ptr);--打印当前的节点信息,接口ex.c ---> ex_render_one_node(void* data,void* cam2d,void* cam3d)接口中的void* data
end

function DebugView:new()
	local self = {
		nskin = nil,
		mid,--中键滚动
		cx,cy,--屏幕点击的坐标
		hitx,hity,hitz,--射线拾取的点坐标
		x,y,z,--拾取对象的坐标
		pick,
		ptr,--拾取到的对象句柄
	};
    setmetatable(self, DebugView);
    -- self.label = NLabel:new(256,256,cam);
	
	local nskin = NSkin:new();

	---disable_render="0" 
	-- drag="1"
	nskin:load(
		[[
			<ui name="1" type="NPanel" line="1"  center="0" width="200" height="300" x="10" y="10"/>
			<ui name="fps_label_1" y="0" label="fps" width="64" height="64" type="NLabel" parent="1"/>
			<ui name="fps_label" x="20" y="0" label="fps" width="128" height="128" type="NLabel" parent="1"/>
			<ui name="mid_label" label="" y="13" width="256" height="256" type="NLabel" parent="1"/>
	]]);
	self.nskin = nskin;
	-- <ui name="img1" type="Image" x="0" y="0" w="16" h="16" value="checkbox.png" parent="1"/>
	-- local img1 = nskin:find("img1");
	-- img1:polyMode(GL.GL_LINE);

	evt_on(core.engine,core.ex_event.MOUSE_MID_EVENT,f_onMouseChange,self);
	evt_on(core.engine,core.ex_event.MOUSE_LEFT_DOWN_EVENT,f_onMouseChange,self);
	evt_on(core.engine,core.ex_event.LUA_EVENT_RAY_PICK,f_onRayPick,self);

	---@type NLabel
	local fps_label = self.nskin:find("fps_label");
	--print("***",fps_label);
	fps_label:addComponent(Fps);
	-- fps_label:removeComponent(Fps);
	-- fps_label:dispose();

	--[[
	evt_on(0,core.ex_event.EVENT_ENGINE_KEYBOARD,function(data)
		print(data);
		local key = tonumber(data);
		
		local fps = fps_label:getComponemt(Fps);
		fps:enable(not fps:is_enable())
	end);
	]]

	-- self.nskin:set_pos(100,100);
	return self;
end

function DebugView:dispose()
	-- if(self.label) then
	-- 	--print("dispose self.label!");
	-- 	self.label:dispose();
	-- end

	self.nskin:dispose();
    func_clearTableItem(self);
end

-- function DebugView:setLabel(mid)
-- 	---@type NLabel
-- 	-- local label = self.nskin:find("mid_label");
-- 	-- label:set_text(string.format("mouse mid:%s",mid or "undefined"));
-- end

return DebugView;