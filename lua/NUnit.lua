------------------------------------------------------
--切换状态
--返回true or false
------------------------------------------------------
local function f_changeFlags(_o,_flag)
	if(_o==nil) then
		func_error("switchFlags 目标对象 = nil")
		return;
	end;
	
	if(_flag == nil)then
		func_error("flag = nil ")
	else
		if	getv(_o,_flag) == 1	then
			resetv(_o,_flag);
		else
			setv(_o,_flag);
		end
		--print('对象'..string.format("%#x",_o).."设置标示".._flag.."状态为:"..getv(_o,_flag) );
	end
	return getv(_o,_flag) == 1;
end

local function func_set_position(o,x,y,z)
	change_attr(o,"set_position",string.format("%f,%f,%f",x,y,z));
end

-- local function func_get_scale(o)
-- 	return get_attr(o,"scale");
-- end

--设置坐标
local function func_set_x(o,x)
	change_attr(o,"x",x)
end
local function func_set_y(o,y)
	change_attr(o,"y",y)
end
local function func_set_z(o,z)
	change_attr(o,"z",z)
end
--#####################################################

---@class NUnit
NUnit = {
	-- _renderlist,
};
NUnit.__index = NUnit;

--- s.p 节点引用地址
function NUnit:new()
	local s = {};
	setmetatable(s, NUnit);
	print("NUnit",s);

	return s;
end
function NUnit:setRenderList(_list)
	--func_error("未实现setRenderList()接口.");
	self._renderlist = _list;
end
function NUnit:dispose()
	core.del(self,self._renderlist);
	-- print("NUnit:dispose()");
end

--获取模型的类型
function NUnit:get_type()
	return core.get_type(self.p);
end

--设置当前的对象的cam
function NUnit:setCam(cam)
	func_error("setCam now!!!"..tostring(cam));
	-- set_cam(self.p,cam);--使用指定的cam
end

--获取句柄
function NUnit:get_p()
	if(self.p == nil) then
		func_error("self.p is not initialise!");--未初始化
	end
    return self.p;
end
---p是否为nil
function NUnit:p_isNil()
	if(self.p == nil)then
		return true;
	end
	return false;
end

function NUnit:visible(v)
	if(v) then
		setv(self.p,FLAGS_VISIBLE);--显示
	else	
		resetv(self.p,FLAGS_VISIBLE);--隐藏
	end
end

function NUnit:f_set_flag(flag,v)
	if(v) then
		self:setv(flag);
		--print(v);
	else
		self:resetv(flag);
	end
end

--反转面渲染
function NUnit:reverse_face(v)
	self:f_set_flag(FLAGS_REVERSE_FACE,v);
end
--获取其材质句柄
function NUnit:getMaterial()
    if(self.material == nil) then
        func_error("self.material=nil!");
    end
    return self.material;
end
---双面显示(取消剔除背面)
function NUnit:double_face()
	core.meterial.setCullface(self:getMaterial(),GL.CULL_FACE_DISABLE);
end

---设置为线框渲染
function NUnit:drawPloygonLine(v)
	local m = self:getMaterial();
	local value;
	if(v == true) then
		value = GL.GL_LINE;
	else
		value = GL.GL_FILL;
	end
	core.meterial.setPolyMode(self:getMaterial(),value);
end


--背面剔除
-- function NUnit:cullFace(v)
	-- self:f_set_flag(FLAGS_DISABLE_CULL_FACE,v);
-- end

function NUnit:is_visible()
	return getv(self.p,FLAGS_VISIBLE) == 1;
end
---设置缩放比率
---@param value 缩放值0~1.0
function NUnit:scale(value)
	-- print(value);
    change_attr(self.p,"scale",value);
end

function NUnit:setv(v)
    setv(self.p,v)
end
function NUnit:resetv(v)
    resetv(self.p,v)
end
function NUnit:getv(v)
    return getv(self.p,v)
end

function NUnit:get_scale()
	-- return func_get_scale(self.p);
	return get_attr(self.p,"scale");
end
--获取轴角度,该值是math.pi的倍数
function NUnit:get_angle()
	return get_attr(self.p,"angle");
end

--获取rx,ry,rz的值
function NUnit:get_rotate()
	--return get_attr(self.p,"rotate");
	func_error("未实现!");
end

--获取其x,y,z坐标
function NUnit:get_pos()
	local x,y,z =  get_attr(self.p,"xyz");
	return x,y,z;
end

--绕自定义轴旋转r欧拉角
--normal 是否单位化向量
function NUnit:rotate_vec(r,x,y,z)
--[[	if(normal) then
		local x1,y1,z1 = vec3Normalize(x,y,z);
		
		print(x1,y1,z1);
	end--]]
	change_attr(self.p,"rotate_vec",x,y,z,r);
end
--- 设置初始化轴偏移,当需要自定义一个轴为基轴的时候，可以使用该接口。
function NUnit:iAxis(r,x,y,z)
	change_attr(self.p,"iAxis",x,y,z,r);
end

function NUnit:rx(v)
	--func_setRotateX(self.p,v)
	-- print(v);
    self:rotate_vec(v,1,0,0);
end

function NUnit:ry(v)
--    func_setRotateY(self.p,v)
    self:rotate_vec(v,0,1,0);
end
function NUnit:rz(v)
--    func_setRotateZ(self.p,v)
    self:rotate_vec(v,0,0,1);
end
function NUnit:x(v)
    func_set_x(self.p,v);
end

function NUnit:y(v)
    func_set_y(self.p,v);
end
function NUnit:z(v)
    func_set_z(self.p,v);
end

function NUnit:set_position(x,y,z)
    func_set_position(self.p,x,y,z);
end

--获取对象名
function NUnit:get_name()
    return get_attr(self.p,"get_name")
end

----设置对象的关键帧帧率
function NUnit:set_fps(v)
	change_attr(self.p,"fps",tostring(v))
end

--切换flag
function NUnit:changeFlag(flag)
	f_changeFlags(self.p,flag);
end

function NUnit:setParent(v)
	setParent(self.p,v.p);
end