local core = core;
------------------------------------------------------
--�л�״̬
--����true or false
------------------------------------------------------
local function f_changeFlags(_o,_flag)
	if(_o==nil) then
		func_error("switchFlags Ŀ����� = nil")
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
		--print('����'..string.format("%#x",_o).."���ñ�ʾ".._flag.."״̬Ϊ:"..getv(_o,_flag) );
	end
	return getv(_o,_flag) == 1;
end

-- local function func_get_scale(o)
-- 	return get_attr(o,"scale");
-- end

--��������
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

--- s.p �ڵ����õ�ַ
function NUnit:new()
	local s = {};
	setmetatable(s, NUnit);
	-- print("NUnit",s);

	return s;
end
function NUnit:setRenderList(_list)
	--func_error("δʵ��setRenderList()�ӿ�.");
	self._renderlist = _list;
end
function NUnit:dispose()
	core.del(self,self._renderlist);
	-- print("NUnit:dispose()");
end

--��ȡģ�͵�����
function NUnit:get_type()
	return core.get_type(self.p);
end

--���õ�ǰ�Ķ����cam
function NUnit:setCam(cam)
	func_error("setCam now!!!"..tostring(cam));
	-- set_cam(self.p,cam);--ʹ��ָ����cam
end

--��ȡ���
function NUnit:get_p()
	if(self.p == nil) then
		func_error("self.p is not initialise!");--δ��ʼ��
	end
    return self.p;
end
---p�Ƿ�Ϊnil
function NUnit:p_isNil()
	if(self.p == nil)then
		return true;
	end
	return false;
end

function NUnit:visible(v)
	if(v) then
		setv(self.p,FLAGS_VISIBLE);--��ʾ
	else	
		resetv(self.p,FLAGS_VISIBLE);--����
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

--��ת����Ⱦ
function NUnit:reverse_face()
	local m = self:getMaterial();
	local type = core.meterial.tmat_get_cullface(m);
	if(type == GL.CULL_FACE_DISABLE) then
		func_error("type = " .. type.." don`t use CULL_FACE_DISABLE!");
	elseif(type == GL.CULL_FACE_BACK) then
		core.meterial.setCullface(m,GL.CULL_FACE_FRONT);
	elseif(type == GL.CULL_FACE_FRONT)then
		core.meterial.setCullface(m,GL.CULL_FACE_BACK);
	end
end
--��ȡ����ʾ��
function NUnit:getMaterial()
    if(self.material == nil) then
        func_error("self.material=nil!");
    end
    return self.material;
end
---˫����ʾ(ȡ���޳�����)
function NUnit:double_face()
	core.meterial.setCullface(self:getMaterial(),GL.CULL_FACE_DISABLE);
end

---����Ϊ�߿���Ⱦ
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


--�����޳�
-- function NUnit:cullFace(v)
	-- self:f_set_flag(FLAGS_DISABLE_CULL_FACE,v);
-- end

function NUnit:is_visible()
	return getv(self.p,FLAGS_VISIBLE) == 1;
end
---�������ű���
---@param value ����ֵ0~1.0
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
--��ȡ��Ƕ�,��ֵ��math.pi�ı���
function NUnit:get_angle()
	return get_attr(self.p,"angle");
end

--��ȡrx,ry,rz��ֵ
function NUnit:get_rotate()
	--return get_attr(self.p,"rotate");
	func_error("δʵ��!");
end

--��ȡ��x,y,z����
function NUnit:get_pos()
	local x,y,z = func_get_position(self.p); --get_attr(self.p,"xyz");
	return x,y,z;
end

--���Զ�������תrŷ����
--normal �Ƿ�λ������
function NUnit:rotate_vec(r,x,y,z)
--[[	if(normal) then
		local x1,y1,z1 = vec3Normalize(x,y,z);
		
		print(x1,y1,z1);
	end--]]
	change_attr(self.p,"rotate_vec",x,y,z,r);
end
--- ���ó�ʼ����ƫ��,����Ҫ�Զ���һ����Ϊ�����ʱ�򣬿���ʹ�øýӿڡ�
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

--��ȡ������
function NUnit:get_name()
    return get_attr(self.p,"get_name")
end

----���ö���Ĺؼ�֡֡��
function NUnit:set_fps(v)
	change_attr(self.p,"fps",tostring(v))
end

--�л�flag
function NUnit:changeFlag(flag)
	f_changeFlags(self.p,flag);
end

function NUnit:setParent(v)
	setParent(self.p,v.p);
end