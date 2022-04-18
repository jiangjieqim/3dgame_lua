---Fps视图类
local FpsView = {
	
};

FpsView.__index = FpsView;
setmetatable(FpsView, IPlugin);--继承自插件接口

--插件加载
function FpsView:new()
	local self = {
		label,
		timer,
		formatstr,
		callBack,
	};
	setmetatable(self, FpsView);
	return self;
end

---返回当前的FPS
local function fps()
	return math.floor(1000 / core.delayTime() * 10) / 10;
end

local function f_fps_timer(data,param)
	
	local self = param;
	local _fps = fps();
	local str = _fps;
	if(self.formatstr) then
		str = string.format(self.formatstr,_fps);
	end
	if(self.callBack) then
		str = str..self.callBack();
	end

	if(self.label) then
		-- print('###########f_fps_timer:('..str..')'..core.delayTime());
		self.label:set_text(str);
	end
end

--卸载插件,即销毁插件
function FpsView:dispose()
	if(self.timer) then
		timelater_remove(self.timer);
	end
	self:hide();
	if(self.label) then
		--print("dispose self.label!");
		self.label:dispose();
	end
	--setmetatable(self, nil);
	func_clearTableItem(self);
end

---显示
---@param cam Camera引用
function FpsView:show(cam,x,y,formatstr)
----[[
	if(self.label==nil) then
		self.label = NLabel:new(64,64,cam);
		self.label:set_text("fps");
	end
--]]
	
	if(self.label) then
		--创建label
		self.label:set_pos(x or 0,y or 0);
		self.label:visible(true);
	end
		
	self.formatstr = formatstr;
	
----[[

	--增加计时器
	if(self.timer==nil) then
		self.timer = timelater_new(250);
		evt_on(self.timer,core.ex_event.TIMER,f_fps_timer,self);
	end	
--]]
end

function FpsView:getName()
	return "FpsView";
end

function FpsView:hide()
	if(self.label) then
		self.label:visible(false);
	end
	if(self.timer) then
		evt_off(self.timer,core.ex_event.TIMER,f_fps_timer);
		self.timer = nil;
	end
end

return FpsView;