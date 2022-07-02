Camera = {
	---camera���
	-- p,

	---�任����
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

--ModelViewģ����ͼ����
function Camera:model()
	return cam(self.p,"model");
end
function Camera:normal()
	return cam(self.p,"normal");
end
--����camera��3d����
function Camera:set_pos(x,y,z)
	-- print(x,y,z);
	cam(self.p,"set_xyz",x or 0,y or 0,z or 0);
	self:refresh();
end

function Camera:get_pos()
	return cam(self.p,"get_xyz");
end
---��ȡ��λ��
function Camera:get_rotate()
	return cam(self.p,"get_rotate");
end

--����camera
function Camera:reset()
	cam(self.p,"reset");
end

--��ȡcamera��C��ľ��
function Camera:get_p()
	return self.p;
end

--ˢ��model����
function Camera:refresh()
	cam(self.p,"refresh");
end

--����camera��rx��ֵ
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

--����cam
function Camera:dispose()
	func_clearTableItem(self);
end

--��һ������cam
function Camera:bind(o)
	func_error("δʵ��!Camera:bind(o)");
end

---���ø�����  
---v:�̳���struct HeadInfo*�Ķ���
function Camera:setParent(v)
	if(v.p == nil)then
		func_error("check v.p!");
	end
	cam(self.p,"cam_setParent",v.p);
end
---����target����,֮��ִ��core.cam:refresh()
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