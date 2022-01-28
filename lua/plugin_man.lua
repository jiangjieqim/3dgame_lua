require("IPlugin")	--插件接口定义
--local EVENT = require("event")	--插件接口定义

--print("插件管理器初始化");
PluginMan = {
	--list,--插件列表
};
PluginMan.__index = PluginMan;
function PluginMan:new()
	local self = {};
	setmetatable(self, PluginMan);
	self.insList = {}--单例列表
	--self.list = stack_new();
	
	return self;
end
function PluginMan:getInfo(p)
	return p:getName().." "..tostring(p);
end

--加载插件

function PluginMan:load(plugin)
	-- local url = "../include/lua/"..plugin.."";
	local p = require(plugin):new();
	func_print(">>>>插件初始化完毕"..self:getInfo(p).." url="..plugin);
	return p;
end

--切换打开继承自IPluginView的模块
--mode :
--0 切换开启	-1	关闭 1打开
function PluginMan:toggle(plugin,mode,data)
	mode = mode or 0;

	---@type IPluginView
	local view  = self.insList[plugin];
	
	if(view == nil) then
		self.insList[plugin] = self:load(plugin);
		view = self.insList[plugin];
		if(mode == 0) then
			mode = 1;--第一次默认为开启状态
		end
	end
	view:setData(data);
	view:showByMode(mode);



	return view;
end

--卸载插件
--内存泄漏,废弃之
--[[
function PluginMan:unload(p)
	p:unload();
	func_print("<<<<卸载插件"..f_getInfo(p));	
	
	--setmetatable(getmetatable(p),nil);
	--setmetatable(p, nil);
	
	--print(getmetatable(p));
end
--]]

