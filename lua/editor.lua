require("modelshow")
--************************************************************
Editor = {
	-- linelist,
	-- modelshow,
	-- fps,
};
Editor.__index = Editor;

--创建箭头
local function f_craeteAxis(x,y,z)
	local ln= LineNode:new(2);
	ln:setcolor(x,y,z);
	ln:push(0,0,0);
	ln:push(x,y,z);
	ln:graphics_end();
	core.add(ln);
	return ln
end

--创建线框
local function f_createLines(n,s)
	if(n == 1) then
		func_error("f_createLines n is error!");
	end
	
	local list = stack_new();

	s = s or 1;--线段半径
	local _l = n / 2;--_l or 1;

	--print(n,index);
	
	--print(s);
	for i = 0,n,1 do 
		local ln= LineNode:new(2);
		ln:setcolor(0.5,0.5,0.5);
		local x = (i-n/2)*s;
		--print(x,s);
		ln:push(x,0,-_l);
		ln:push(x,0,_l);
		ln:graphics_end();
		core.add(ln);
		stack_push(list,ln);
	end
	
	for i = 0,n,1 do 
		local ln= LineNode:new(2);
		ln:setcolor(0.5,0.5,0.5);
		local z = (i-n/2)*s;
		--print(x,s);
		ln:push(-_l,0,z);
		ln:push(_l,0,z);
		ln:graphics_end();
		core.add(ln);
		stack_push(list,ln);
	end
	return list;
end

function Editor:new()
	local self = {};
	setmetatable(self, Editor);
	-- self:createLine();
	--self.modelshow = ModleShow:new(self);
	return self;
end

function Editor:createAxis()
	self.axis = NStack:new();
	self.axis:push(f_craeteAxis(1,0,0));
	self.axis:push(f_craeteAxis(0,1,0));
	self.axis:push(f_craeteAxis(0,0,1));
end

---构造场景中的视图线框
function Editor:createLine()
	self.linelist = f_createLines(2,1);
end

local function f_delLines(node,index,p)
	--print(node,index,p);
	node:dispose();
end

function Editor:dispose()
	--print(self);
	if(self.linelist) then
		stack_foreach(self.linelist,f_delLines);
	end
	
	if(self.fps) then
		self.fps:dispose();
	end

	if(self.modelshow) then
		self.modelshow:dispose();
	end

	local axis = self.axis;
	if(axis) then
		while(axis:len() > 0) do
			local line = axis:pop();
			line:dispose();
		end
		axis:dispose();
	end

	func_clearTableItem(self);
end

---显示FPS  
---返回一个FpsView句柄
function Editor:showfps()
	if(self.fps == nil) then
		local _cls = require("view/FpsView");
		---@type FpsView
		local fps = _cls:new();
		fps:show();
		self.fps = fps;
	end
	return self.fps;
end