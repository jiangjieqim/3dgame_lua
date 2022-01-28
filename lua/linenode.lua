--参考范例
-- local s= LineNode:new(3);
-- s:push(-0.5,0.4,0.5);
-- s:push( 0.5, 0.0, 0.5);
-- s:push( -0.5, -0.49, -0.5);
-- s:setcolor(1,0,0);
-- s:graphics_end();
-- --s:dispose();--销毁
--绘制自定义的线段
LineNode = {
	-- _renderlist
	-- is_graphics_end
	-- 	p,--C层的linenode指针
	-- 	tmat,--材质引用
};
LineNode.__index = LineNode;
setmetatable(LineNode, NUnit);

--isPoint = true 使用点模式渲染
function LineNode:new(cnt,isPoint,name)
	local p = NUnit:new();
	setmetatable(p, LineNode);
	local _type = 0;
	if(isPoint) then
		_type = 1;
	end
	
	-- p.p,p.tmat=linenode("create",name or core.getName(),cnt,_type);

	local a = {linenode("create",name or core.getName(),cnt,_type)};
	-- print(a);
	p.p = a[1];
	p.tmat = a[2];
	
	if(isPoint) then
		p:setcolor(1,1,0);
	else
		p:setcolor(1,0,0);
	end
	return p;
end

--[[
	修改对应索引的坐标
	index 从0开始
--]]
function LineNode:mod(index,x,y,z)
	if(self.is_graphics_end ~= 1) then
		func_error("you must be call graphics_end");
	end
	linenode("mod",self.p,index,x,y,z);
end

function LineNode:push(x,y,z)
	linenode("push",self.p,x,y,z);
end
function LineNode:pushAll(ver,len)
	linenode("pushAll",self.p,ver,len);
end
--绘制结束
function LineNode:graphics_end(scale)
	linenode("end",self.p,scale or 1);
	self.is_graphics_end = 1;
	-- core.add(self);
end
--- 设置rgb颜色
function LineNode:setcolor(r,g,b)
	local tmat = self.tmat;
	shader_updateVal(tmat,"r",r);
	shader_updateVal(tmat,"g",g);
	shader_updateVal(tmat,"b",b);
end

function LineNode:dispose()
	core.del(self.p,self._renderlist);
	core.ptr_remove(self.p);
end

function LineNode:setRenderList(_list)
	self._renderlist = _list;
end