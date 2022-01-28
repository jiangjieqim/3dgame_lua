NStack = {
	
};

--[[
��������1:
local function f_each(d,p)
	print(d,p);
end

local n = NStack:new();
n:push("a");
n:push("b");
n:push("c");
n:del("b");
print(n:len());
n:for_each(f_each,"ppp1");
n:dispose();

--#################################
��������2:


local i = 0;
local function f_each(d,p)
	print(i,d,p);
	i = i + 1;
end

local n = NStack:new();
n:push("a");
n:push("b");
n:push("c");

n:del("b");
local p = n:pop();
print("len:",n:len(),p);

n:for_each(f_each,"ppp1");
n:dispose();
--#################################


]]

NStack.__index = NStack;

local function create_node(data)
	local node = {data,pre,next};
	node.data = data;
	return node;
end
function NStack:new()
	local self = {node=nil};
	setmetatable(self, NStack);
	self.node = create_node();
	return self;
end

function NStack:push(data)
	local node = create_node(data);
	
	node.next = self.node.next;
	node.pre = self.node;
	self.node.next = node;
end

---���ջ
function NStack:clear()
	while(self:len() > 0)
	do
		self:pop();
	end
end

--���ݽڵ��е�����ɾ��һ���ڵ�
function NStack:del(data)

	local p = self.node;
	
	while(p~=nil and p.next~=nil)
	do
		if(p~=nil) then
			local pre = p;
			p = p.next;
			if(p.data == data) then
				local next = p.next;
				if(next~=nil) then
					next.pre= pre;
				end
				pre.next = next;
				p.next = nil;
				return true;
			end
		end
	end
	
end

function NStack:pop()
	local p;
	--local pNode;
	p = self.node.next;
	if(p==nil) then
		return;
	end
	--pNode = p.next;
	p.pre = self.node;
	self.node.next = p.next;
	return p.data;	
end
function NStack:for_each(f,param)
	local s = self.node;
	local top,p;
	top = s;
	p = top;
	
	while(p.next~=nil)
	do
		p = p.next;
		if(f(p.data,param)~=nil) then
			break;
		end
	end
end

--��ǰ��������
function NStack:len()
	local p;
	local count = 0;
	p = self.node;
	while(p~=nil and p.next~=nil)
	do
		p = p.next;
		count = count + 1;
	end
	return count;
end

--������ջ
function NStack:dispose()
	local p;
	local q;
	p = self.node;
	while(p~=nil)
	do
		q = p;
		p = p.next;
		if(q~=nil) then
			func_clearTableItem(q);
			q = nil;
		end
	end
	self.node = nil;
	func_clearTableItem(self);
end