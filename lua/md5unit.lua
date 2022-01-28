Md5Unit = {
	
};

Md5Unit.__index = Md5Unit;
setmetatable(Md5Unit, NUnit);

function Md5Unit:new()
	local s = NUnit:new();
	setmetatable(s,Md5Unit);
	return s;
end
--�������������
function Md5Unit:get_anim()
	
end
--����ģ��
function Md5Unit:load(cam,model,material)
	---@type NUnit
	local self = self;
	func_error("δʵ�ֽӿ�load_model");
	self.p = load_model(core.getName(),model  or "\\resource\\md5\\wolf\\body.md5mesh");
	core.meterial.set(self.p,self:load_material(material or "//resource//material//wolf.mat"));
	
	md5_loadAnim(self.p, "\\resource\\md5\\wolf\\walk.md5anim","walk");
	self:setv(FLAGS_ANIM_ADAPTIVE);

	self:setCam(cam);
	self:set_fps(260);
	self:visible(true);
end

function Md5Unit:dispose()
	core.ptr_remove(self.p);
	func_clearTableItem(self);
end

--���ƹ����ڵ�
function Md5Unit:drawSkeleton(v)
	local flag = FLAGS_RENDER_DRAWSKELETON;
	if(v) then
		self:setv(flag);
	else
		self:resetv(flag);
	end
end
--���õ�ǰ֡
function Md5Unit:set_frame(v)
	change_attr(self.p, "setframe", v)
end
--��ȡ�����ؼ�֡��(md5)
function Md5Unit:frame_count()
	return get_attr(self.p,"frameCount");
end
