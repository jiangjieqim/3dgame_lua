--local evtlist = {};
local _evtDebug-- = true;--�?否开�?事件日志
---@type NStack
local list = NStack:new();--事件列表

local function f_each(node,p)
	--print(d,p);

	--[[local evt = 
	{
		id = id;
		func = func;
		obj = obj;
        params = params;
		once = once
	}
--]]
	if(node and node.obj == p.obj and node.id == p.id and node.func == p.func) then
		p.find = true;
		func_error("重�?�的事件,事件id = "..p.id);
		return true;
	end
end

local function f_find(node,p)
	if(node and node.obj == p.obj and node.id == p.id and node.func == p.func) then
		p.node = node;
		return true;
	end
end

--node and node.obj == p.obj and 
local function f_find_dispath(node,p)
	if(node.id == p.id) then
		p.node = node;
		return true;
	end
end

local function f_find_dispath_obj(node,p)
	if(node and node.obj == p.obj and node.id == p.id) then
		p.node = node;
		return true;
	end
end
--[[
--�?否是table字�?�串
local function is_table_str(value)
	-- print("cnt:"..#value);
	local theType = type(value);

	if(theType == "number" or theType == "table") then
		return theType == "table";
	end
	
	func_error(theType.."\tis_table_str ================******************************************>");
	-- assert(nil,"aoaoao");

	-- if(theType == "number") then
	-- 	return;
	-- end
	-- print("type:"..theType);
	-- print(theType == "table");

	-- local s = tostring(value);
	-- return string.find(s,"table: ") ~= nil;

end
--]]


--[[
    params:默�?�不传递参�?

    local function f_resize(evtData,self)
        print(c_data);--来自evt_dispatch�?�?	local data;--数据
    end
]]--

--将table�?化为一个Number�?(其实是table的地址引用)
local function f_cv(obj)
	-- func_error(111);

	local theType = type(obj);
	if(theType == "number" ) then
		return obj;
	elseif(theType == "table") then
		local a = obj.address;
		if(a == nil) then
			func_error(tostring(obj).."�?找到address字�??!");
			return 0;
		end
		return a;
	end
	func_error(theType.."  >>>>>>>>>>>>> ================******************************************>");

	-- if(is_table_str(obj)) then
	-- 	local n = func_get_address(obj);
		
	-- 	-- print("============================>>>>>>>>>>>>"..n);
	-- 	func_error("================******************************************>"..n);
		

	-- 	func_print("evt_on==>"..tostring(obj).." �?化为Number:"..string.format("%0x",n));
	-- 	return n;
	-- end
	-- return obj;
end

--根据id�?化为事件�?
local function getEvtStr(id)
	return core.get_event_str(id);
end
--- @param once true或false.�?否只监听一�?
function evt_on(obj,id,func,params,once)
	
	if(id == nil) then
		func_error('id=nil');
		return;
	end

	if(obj == nil) then
		func_error("obj is nil!");
		return;
	end

	obj = f_cv(obj);--is number
	
    if(func == nil) then
        func_error("func = nil");
    end
	if(_evtDebug) then
		--local str = string.format("绑定事件 evt id = %d , obj = %d",id,obj);
		--local str = string.format("绑定事件 evt id=(%s),obj=(%s) params=(%s)",getEvtStr(id),tostring(obj),tostring(params));
		--func_print(str);
		func_print('注册事件 '..getEvtStr(id));--..tostring(obj or 'nil')..(params or 'nil')
		-- print('********'..id);
	end
	evt_off(obj,id,func);

	local findobj = {};
	findobj.obj = obj;
	findobj.id = id;
	findobj.func = func;
	findobj.find = false;
	list:for_each(f_each,findobj);
	if(findobj.find)then
		
	else
		local evt = 
		{
			id = id;
			func = func;
			obj = obj;
			params = params;
			once = once;
		}
		--local v = tonumber(f_cv(evt));
		list:push(evt);
		
		--func_print("add之后事件"..id.."数量"..list:len());
	end
--	evtlist[evt] = evt;
	findobj = nil;
end

function evt_once(obj,id,func,params)
	evt_on(obj,id,func,params,true);
end

---�?否有该事�? obj:对象引用,  <br>id:事件id,func:函数引用
---@param obj 对象引用�?
---@param id 事件id
---@param func 函数引用
function evt_has(obj,id,func)
	--[[for k, v in pairs(evtlist) do
		local node = evtlist[k];
		if(node and node.id == id and node.func == func and node.obj == obj) then
			return true
		end
	end
	return false--]]
	
	local findobj = {};
	findobj.obj = obj;
	findobj.id = id;
	findobj.func = func;
	findobj.node = nil;
	
	list:for_each(f_find,findobj);
	
	if(findobj.node) then
		return true;
	end
    return false;
end
--移除事件 并且释放事件引用
function evt_off(obj,id,func)
	if(evt_has(obj,id,func) == false) then
		--	func_print('didnt has event id!'..id,0xff0000);
		return;
	end
--[[
	if(evt_has(obj,id,func)==false)then
		local str = string.format("evt_has移除[%d]事件[%d]失败! 事件不存�?",obj,id);
		func_print(str);
		return;
	end
--]]

	
	local ok = false;
	--[[
	for k, v in pairs(evtlist) do
		local node = evtlist[k];
		if(node and node.id == id and node.func == func and node.obj == obj) then
			
			local str = string.format("移除事件 evt_off==> evt.id = "..id..",obj = "..obj);
			func_print(str);
			
			

			evtlist[node]=nil;
			func_clearTableItem(node);
			node = nil;
			ok = true;
		end
	end
	--]]
	local findobj = {};
	findobj.obj = obj;
	findobj.id = id;
	findobj.func = func;
	findobj.node = nil;
	
	list:for_each(f_find,findobj);
	if(findobj.node) then
		if(_evtDebug) then
			local str = string.format("移除事件 evt_off==> evt.id = "..id..",obj = "..obj);
			func_print(str);
		end
		list:del(findobj.node);
		--func_print("del之后的事�?"..id.."数量"..list:len());
		ok = true;
		
	else
		func_error("移除对象["..obj.."]的事件["..id.."]失败!");
	end
	
	findobj = nil;
	
	--[[if(ok~=true) then
		func_print("移除事件"..id.."失败!",0xff0000);
	end--]]
	
	return ok;
end
local function f_callBack(findobj)
	local node = findobj.node;
	if(node) then

		if(_evtDebug)then	
			func_print('事件派发 evt_dispatch:'..getEvtStr(node.id)..' 参数:'..tostring(node.params));	
		end

		node.func(findobj.data,node.params);--data:C层传递的参数 node.params:Lua层传递的参数
		if(node.once) then
			
			--local str = string.format("evt_dispatch之后移除事件 evt id = %d  node = (%s) obj =(%d)  data=(%s) node.params=(%s)",id,tostring(node),obj,tostring(data),tostring(node.params));
			--func_print(str);
			
			evt_off(findobj.obj,findobj.id,node.func);--obj,id,func
		end
	end
end
---函数遍历回调
local function f_dispath_AnyObj(node,p)
	if(node and node.obj == p.obj and node.id == p.id) then
		p.node = node;
		f_callBack(p);
	end
end

--全局事件
function evt_dispatch(...)
	 --id,data,obj
	local obj; --指向的�?�象
	local id;  --事件id
	local data;--数据
--	obj ,id,data = f_parse({...});
	local arr = {...};
	obj = arr[1];
	id  = arr[2];
	data= arr[3];

	if(#arr > 3) then
		-- print('*************************');
		data = {};
		for i,j in pairs (arr) do
			-- print(i,j);
			if(i >= 3) then
				data[i-3] = j;
			end
		end
		-- print('*************************');
		-- for i,j in pairs (data) do
		-- 	print("data",i,j);
		-- end
	end

	obj = f_cv(obj);
	
	local findobj = {};
	findobj.obj = obj;
	findobj.id = id;
	findobj.node = nil;
	findobj.data = data;

	
	if (obj == 0) then
		--全局事件
		--[[for k, v in pairs(evtlist) do
			local node = evtlist[k];
			if(node and node.id == id) then
				node.func(data,node.params);
				if(node.once) then
					evt_off(obj,id,node.func);--obj,id,func
					--func_print("移除全局事件"..id);
				end
			end
		end--]]
		list:for_each(f_find_dispath,findobj);
		local node = findobj.node;
		if(node)then
			if(_evtDebug)then
				func_print('全局事件派发 evt_dispatch all:'..getEvtStr(node.id)..' 参数:'..tostring(node.params));
			end
			node.func(data,node.params);
			if(node.once) then
				evt_off(obj,id,node.func);--obj,id,func
				--func_print("移除全局事件"..id);
			end
		end
	else
		-- list:for_each(f_find_dispath_obj,findobj);
		-- f_callBack(findobj);
		list:for_each(f_dispath_AnyObj,findobj);
	end
	--print(id);
end