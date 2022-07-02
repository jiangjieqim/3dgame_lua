Camera = {
	---camera句柄
	-- p,

	---变换矩阵
	-- transform,	
};

Camera.__index = Camera;

function Camera:new(p)
	local self = {};
	setmetatable(self,Camera);
	self.p = p;
	self.transform = Transform:new();
	return self;
end

function Camera:set_2dxy(x,y)
	cam(self.p,"set_2dxy",x or 0,y or 0);
end
function Camera:perctive()
	return cam(self.p,"perctive");
end

--ModelView模型视图矩阵
function Camera:model()
	return cam(self.p,"model");
end
function Camera:normal()
	return cam(self.p,"normal");
end
--设置camera的3d坐标
function Camera:set_pos(x,y,z)
	-- print(x,y,z);
	cam(self.p,"set_xyz",x or 0,y or 0,z or 0);
	self:refresh();
end

function Camera:get_pos()
	return cam(self.p,"get_xyz");
end
---获取角位移
function Camera:get_rotate()
	return cam(self.p,"get_rotate");
end

--重置camera
function Camera:reset()
	cam(self.p,"reset");
end

--获取camera的C层的句柄
function Camera:get_p()
	return self.p;
end

--刷新model矩阵
function Camera:refresh()
	cam(self.p,"refresh");
end

--设置camera的rx的值
function Camera:rx(v)
	-- print(self.p,"rx",v);
	cam(self.p,"rx",v);
	self:refresh();
end

function Camera:ry(v)
	cam(self.p,"ry",v);
	self:refresh();
end

function Camera:rz(v)
	cam(self.p,"rx",v);
	self:refresh();
end

function Camera:set_rotate(rx,ry,rz)
	cam(self.p,"rx",rx);
	cam(self.p,"ry",ry);
	cam(self.p,"rz",rz);
	self:refresh();
end

--销毁cam
function Camera:dispose()
	func_clearTableItem(self);
end

--绑定一个对象到cam
function Camera:bind(o)
	func_error("未实现!Camera:bind(o)");
end

---设置父对象  
---v:继承自struct HeadInfo*的对象
function Camera:setParent(v)
	if(v.p == nil)then
		func_error("check v.p!");
	end
	cam(self.p,"cam_setParent",v.p);
end
---设置target对象,之后执行core.cam:refresh()
function Camera:setTarget(v)
	if(v == nil) then
		cam(self.p,"cam_setTarget");
	else
		if(v.p == nil)then
			func_error("check v.p!");
		end
		cam(self.p,"cam_setTarget",v.p);
	end
	self:refresh();
end