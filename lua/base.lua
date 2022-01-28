Base = {
	
};

Base.__index = Base;
function Base:setname(name)
	self.name = name;
end

function Base:new()
	local obj = {
		name = nil,--该对象的名字
		type = nil,--该对象的类型
		address = nil,--地址
		complist = nil;--组件列表
	};

	setmetatable(obj, Base);
	core.bindAddress(obj);--设置其地址
	return obj;
end

---调用父类的方法  
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
	--print(self,"设置类型"..t);
	self.type = t;	
end

function Base:gettype()
	return self.type;
end

function Base:setname(name)
	--print(string.format("设置名字为[%s]",name));
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

---添加组件控制器
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

---移除组件控制器
function Base:removeComponent(Comp)
	local key = Comp;
	local c = self.complist[key];
	if(self.complist~=nil and c~=nil)then
		c:sleep();
		core.frameUpdateList[c] = nil;
		self.complist[key] = nil;
	end	
end

---组件基类
Component = {}
Component.__index = Component;
---唤醒
function Component:awake()
--	print(self,'Component:awake()');
end
---休眠 在组件目标对象removeComponent的时候触发
function Component:sleep()
--	print(self,'Component:sleep()');
end
---更新状态
function Component:update()
--	print(self,'Component:update()');
end

function Component:new()
	local self = {
		---绑定的对象
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
--************单例**************
Instance={
	ins,--单例引用
};
Instance.__index = Instance;

function Instance:new()
	local self = {};
	setmetatable(self, Instance);
	--print(tostring(self).."单例初始化");
	return self;
end

--单例
function Instance:getIns()
    if self.ins == nil then
        self.ins = self:new();
    end
    return self.ins;
end