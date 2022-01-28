Base = {
	
};

Base.__index = Base;
function Base:setname(name)
	self.name = name;
end

function Base:new()
	local obj = {
		name = nil,--�ö��������
		type = nil,--�ö��������
		address = nil,--��ַ
		complist = nil;--����б�
	};

	setmetatable(obj, Base);
	core.bindAddress(obj);--�������ַ
	return obj;
end

---���ø���ķ���  
---self:super("dispose");  
---self:super("callfunc",param0,param1);  
function Base:super(funcname,...)
	core.super(self,funcname,...);
end

-- function Base:call(key1,key2)
--     print("Base:",key1,key2);
-- end


function Base:dispose()
	-- print('>>>>>>>>>>>>>>>>>>>> base dispose!',self);
end

function Base:settype(t)
	--print(self,"��������"..t);
	self.type = t;	
end

function Base:gettype()
	return self.type;
end

function Base:setname(name)
	--print(string.format("��������Ϊ[%s]",name));
	self.name = name;
end

function Base:getname()
	return self.name;
end

function Base:getComponemt(Comp)
	if(self.complist ~= nil) then
		return self.complist[Comp];
	end
end

---������������
function Base:addComponent(Comp)
	if(self.complist == nil) then
		self.complist = {};
	end
	if(self.complist[Comp]==nil) then
		local c = Comp:new();
		c:awake();
		self.complist[Comp] = c;
		
		c.gameObject = self;
		--print('@@@@@@',Comp,c,c.gameObject,'*',self);

		--c:update();
	end
	if(core.getLen(self.complist) > 0)then
		local c = self.complist[Comp];
		core.frameUpdateList[c] = c;
	end
end

---�Ƴ����������
function Base:removeComponent(Comp)
	local key = Comp;
	local c = self.complist[key];
	if(self.complist~=nil and c~=nil)then
		c:sleep();
		core.frameUpdateList[c] = nil;
		self.complist[key] = nil;
	end	
end

---�������
Component = {}
Component.__index = Component;
---����
function Component:awake()
--	print(self,'Component:awake()');
end
---���� �����Ŀ�����removeComponent��ʱ�򴥷�
function Component:sleep()
--	print(self,'Component:sleep()');
end
---����״̬
function Component:update()
--	print(self,'Component:update()');
end

function Component:new()
	local self = {
		---�󶨵Ķ���
		gameObjct = nil,
		isEnable = true,
	};
	setmetatable(self, Component);
	return self;
end

function Component:enable(v)
	self.isEnable = v;
end

function Component:is_enable(v)
	return self.isEnable;
end
--************����**************
Instance={
	ins,--��������
};
Instance.__index = Instance;

function Instance:new()
	local self = {};
	setmetatable(self, Instance);
	--print(tostring(self).."������ʼ��");
	return self;
end

--����
function Instance:getIns()
    if self.ins == nil then
        self.ins = self:new();
    end
    return self.ins;
end