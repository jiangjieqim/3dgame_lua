require("IPlugin")	--����ӿڶ���
--local EVENT = require("event")	--����ӿڶ���

--print("�����������ʼ��");
PluginMan = {
	--list,--����б�
};
PluginMan.__index = PluginMan;
function PluginMan:new()
	local self = {};
	setmetatable(self, PluginMan);
	self.insList = {}--�����б�
	--self.list = stack_new();
	
	return self;
end
function PluginMan:getInfo(p)
	return p:getName().." "..tostring(p);
end

--���ز��

function PluginMan:load(plugin)
	-- local url = "../include/lua/"..plugin.."";
	local p = require(plugin):new();
	func_print(">>>>�����ʼ�����"..self:getInfo(p).." url="..plugin);
	return p;
end

--�л��򿪼̳���IPluginView��ģ��
--mode :
--0 �л�����	-1	�ر� 1��
function PluginMan:toggle(plugin,mode,data)
	mode = mode or 0;

	---@type IPluginView
	local view  = self.insList[plugin];
	
	if(view == nil) then
		self.insList[plugin] = self:load(plugin);
		view = self.insList[plugin];
		if(mode == 0) then
			mode = 1;--��һ��Ĭ��Ϊ����״̬
		end
	end
	view:setData(data);
	view:showByMode(mode);



	return view;
end

--ж�ز��
--�ڴ�й©,����֮
--[[
function PluginMan:unload(p)
	p:unload();
	func_print("<<<<ж�ز��"..f_getInfo(p));	
	
	--setmetatable(getmetatable(p),nil);
	--setmetatable(p, nil);
	
	--print(getmetatable(p));
end
--]]

