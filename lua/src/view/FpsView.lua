---Fps��ͼ��
local FpsView = {
	
};

FpsView.__index = FpsView;
setmetatable(FpsView, IPlugin);--�̳��Բ���ӿ�

--�������
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

---���ص�ǰ��FPS
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

--ж�ز��,�����ٲ��
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

---��ʾ
---@param cam Camera����
function FpsView:show(cam,x,y,formatstr)
----[[
	if(self.label==nil) then
		self.label = NLabel:new(64,64,cam);
		self.label:set_text("fps");
	end
--]]
	
	if(self.label) then
		--����label
		self.label:set_pos(x or 0,y or 0);
		self.label:visible(true);
	end
		
	self.formatstr = formatstr;
	
----[[

	--���Ӽ�ʱ��
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