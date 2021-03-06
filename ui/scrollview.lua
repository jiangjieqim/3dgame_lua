--当前的2dcam句柄,指定sprite必须指定对应的cam引用
-- local function scrollView_get_cam(sv)
-- 	return sv.fbo:get_cam2d();--sv.fbo.cam2d;
-- end

--从itemRender list对象池中获取一个itemRender节点对象,如果对象池中没有就创建一个
local function f_pool_getItem(sv)
    local data = sv.pool;
    for key, value in pairs(data) do
            if(value.used == 0) then
                value.used = 1;
                return value;
            end
	end
	-- local cam = scrollView_get_cam(sv);
    local node = sv.itemFunc(sv.fbo:get_renderlist());
    sv.pool[tostring(node)] = node;    
    return node;
end
--获取当前itemRender的高度,如果非nil取初始化的时候的gap值作为高度
local function f_getItemHeight(sv)
	if(sv.itemHeight==nil) then
		local node = f_pool_getItem(sv);
		node.used = 0                                                                                                                     
		local w,h = func_get_sprite_size(node.view);
		sv.itemHeight = h;
	end
	return sv.itemHeight;
end

--检测item对象是否在遮罩区域外
local function f_checkItemOutside(sv,pos_y)
    if(pos_y   >= sv.sh) then
        return 1;--向下超出
    end

    if(pos_y + f_getItemHeight(sv) <= 0 ) then
        return 2;--向上超出
    end

    return 0;--不在遮罩区域外
end

--设置滚动条组件的坐标
local function scrollView_set_pos(sv,x,y)
	sv.x = x;
	sv.y = y;
	sv.fbo:set_pos(x,y);
end
--从对象池中释放一个节点
local function f_pool_recycs(sv,targetObj)
	local data = sv.pool;
    for key, value in pairs(data) do
		if(value == targetObj) then
			value.used = 0;
			print("recycs");
			return;
		end
	end
end

--释放对象池中的所有节点
local function f_pool_recycs_all(sv)
    local data = sv.pool;
    for key, value in pairs(data) do
        value.used = 0;
	end
end

--根据索引获取该索引对应的数据
local function f_find_data_by_index(sv,index)
	local n = 0;
	for key, value in pairs(sv.dataList) do  
--		print(key,value);
		if(n == index) then
			return value;
		end
		n=n+1;
	end
	return nil;
end

--根据数据获取对应的node引用
local function f_find_node_by_data(sv,data)
	for key, node in pairs(sv.pool) do
		if(node.data == data)then
			return node;
		end
	end
end

--填加一个滚动条
local function f_add_scrollBar(sv)
	---@type NScrollBar
	local sc;
	if(sv.dir == CONST_DIRECTION_VERTICAL) then
		--sc = scrollBar_new(sv.x+sv.sw,sv.y,nil,15,sv.maxSize);
		sc = NScrollBar:new(sv.x+sv.sw,sv.y,15,sv.maxSize);
	else
		print("待实现");
	end
	sv.sc = sc;
   
	local curp = 0;
	
	local curIndex = 0;
	
	local _startIndex = 0;--最新的起始索引
	
	--滑动回调
    local function f_scHandle(progress,param)
		--*************************纵向
		
		--	print(progress,param);
		if(sv.sh >= sv.dataHeight) then
			return;
		end
		local v = progress;
		
		local oy = (sv.dataHeight-sv.sh)*v;
        
		local itemH = f_getItemHeight(sv);
		
		local p = math.floor(oy/itemH);
		local _sub = nil;
		if(p~=curp) then
			--print("******************************* change sub index %d",curp - p);
			_sub = curp - p;
			curp = p;
		end
		
		local iy= oy/itemH-p;
	
		local itemy = -iy*itemH ;
		if(_sub~=nil) then
			curIndex = curIndex-_sub;
		end
		
		local _posList = {};--坐标列表
		for i=0,sv.needCnt-1,1 do
			_posList[i] = itemy;
			itemy = itemy + itemH;
		end
		
		local newList = {};
		local m = 0;
		
		f_pool_recycs_all(sv);--释放对象池中的所有的node
		
		for n = curIndex,curIndex + sv.needCnt - 1 do
			
			local _td = f_find_data_by_index(sv,n);
			
			if(n >= _startIndex and n <= _startIndex + sv.needCnt - 1) then
				--这里的节点只需要重置坐标即可
				
				--print("**************** same data index = ",n,"data",_td);
				local node = f_find_node_by_data(sv,_td);
				node.used = 1;
				sprite_setpos(node.view,0,_posList[m]);				
			else
				--print("need ==> index = ",n,"data",_td);
				newList[m]=_td;
			end
			m = m + 1;
		end
		--print("*********************************");
		for key, value in pairs(newList) do
			--这里的节点要重新刷新节点视图
			local node = f_pool_getItem(sv);
			node.data = value;
			sprite_setpos(node.view,0,_posList[key]);
			sv.itemRefreshFunc(node);
		end
		
		_startIndex = curIndex;
		--********************************************************************
		
		--print(sv.dataList);
--		print(string.format("起始索引为%d,节点数量为%d",_startIndex,sv.needCnt));
		
		--设计思路:对比起始数据和当前变化的数据,过滤求得需要refresh的itemRender节点重新刷新设置数据,偏移不需要重新刷新设置数据的节点
		--这样就要两个列表了
    end
	--scrollBar_bind(sc,f_scHandle);
	sc:bindCallback(f_scHandle,sc);
end

--获取该滚动组件内需要组件item个数
local function f_need_cnt(sv)
	local h = f_getItemHeight(sv);
    local a = sv.sh % h;

    if(a > 0) then a = 1 end
	
    return (math.ceil(sv.sh/h) + a)+2;
end

--数据驱动填充srollView中的数据
local function scrollView_set_data(sv,data)
	sv.dataList = data;
    local _realNeedCnt = f_need_cnt(sv);
    sv.needCnt = _realNeedCnt;
    f_pool_recycs_all(sv);


	local cur_h = 0;
	local n = 0;
    local cnt = 0;
	local h =  f_getItemHeight(sv);
	if(data) then
		for key, value in pairs(data) do      
			--print('key=['..key..']'..'value['..value..']')
			--print(value);
            if(f_checkItemOutside(sv,cur_h)~=0 and (cnt+1>_realNeedCnt)) then
                --print(value,"超出可见区域,渲染剔除!,当前已经创建的节点数;",cnt+1,"创建的渲染节点数:",_realNeedCnt);
            else
                local _node = f_pool_getItem(sv);
                _node.data = value;
				
                local itemView = _node.view;
			    
			    --***********************
			    --纵向
                sprite_setpos(itemView,0,cur_h);
				
				_node.index = n;
				
				--print("设置索引",n);
				
				sv.itemRefreshFunc(_node);--refresh data
				
                n = n + 1;
			    cur_h = cur_h + h;
				
--				print(string.format("n = %d",n));
			    --***********************
            end
            cnt = cnt + 1;	
		end
	end
    
	sv.dataHeight = cnt * h;
end

--销毁滚动条组件
local function scrollView_dispose(sv)
	if(sv.itemDisposeFunc == nil) then
		--print(sv.itemDisposeFunc);
		print("itemDisposeFunc = nil");
	end
	
	--遍历itemRender对象池,根据itemDispose回调销毁itemRender对象
    for key, node in pairs(sv.pool) do
		
		if(node.skin == nil) then
			func_error("node字段skin没有赋值,无效销毁列表渲染子节点!");
		end
		
		sv.itemDisposeFunc(node);
	end
	
	if(sv.fbo) then
		sv.fbo:dispose();
	end
	
	if(sv.sc) then
		sv.sc:dispose();
	end
	
	func_clearTableItem(sv);--清空sv表
end

--gap 自定义的间隔,默认是取itemRender的容器的高度
local function scrollView_init(sw,sh,x,y,gap)
    local sv = {
		fbo,--FBO句柄对象
		sc,--滚动条句柄对象
		
		dataList,--数据列表
		itemFunc,			--item列表的创建方法回调函数
        itemRefreshFunc,	--设置数据,刷新视图的方法回调函数
		itemDisposeFunc,	--销毁itemRender的回调函数函数

        needCnt,--需要的元素节点数,此数量代表当前的pool对象池中需要的最大渲染节点数
		
		x,y,--当前的坐标,相对于窗口的绝对坐标,其实是fbo挂载的sprite的坐标,将帧缓冲渲染到这个sprite而已
		sw,--遮罩区域的宽
		sh,--遮罩区域的高
		dir,--滚动条的滚动方向,是横向还是纵向
		maxSize,--因为现在的sprite用的等宽等高的,所以这里取最大的maxSize作为宽高
		
		dataHeight,--容器总高度，跟dataList有关系

        itemHeight,--单个item渲染节点的高度
		
        pool = {},--itemRender列表的对象池
  --      poolindex = 0;
    };
	local dir = CONST_DIRECTION_VERTICAL;
	if(gap) then
		sv.itemHeight = gap;
	end
	local maxSize = sw;

	if(sw < sh) then
		maxSize = sh;
	end
---[[
	sv.maxSize = maxSize;
	
	sv.sw = sw;
	sv.sh = sh;
	
	sv.dir = dir;
	
	sv.fbo = FboRender:new(maxSize,maxSize);
	sv.fbo:mouseEnable(true);--设置fbo渲染视图可点击
	
	x = x or 0;
	y = y or 0;
	sv.x =x;
    sv.y =y;
	f_add_scrollBar(sv);
    ---[[
	scrollView_set_pos(sv,x,y);
	--]]
	return sv;
end
--**************************************************************
ScrollView = {

};
ScrollView.__index = ScrollView;

---注意:skin资源要先加载好,才能初始化
---@param sw 宽
---@param sh 高
---@param x x轴坐标
---@param y y轴坐标
---@param gap 每个子渲染对象的间隔
function ScrollView:new(x,y,sw,sh,gap)
	local s = scrollView_init(sw,sh,x,y,gap);
	setmetatable(s,ScrollView);
	return s;
end

---绑定相关的回调函数
---@param f_create 设置itemRende的创建回调用于创建每个子节点
---@param itemRefreshFunc 设置刷新视图的回调
---@param f_dispose 设置itemRender销毁回调函数
function ScrollView:bind(f_create,itemRefreshFunc,f_dispose)
	local sv = self;
	sv.itemFunc = 	f_create;
	sv.itemRefreshFunc = itemRefreshFunc;
	sv.itemDisposeFunc = f_dispose;
end

--设置坐标
function ScrollView:set_pos(x,y)
	scrollView_set_pos(self,x,y);
end
--设置数据
function ScrollView:set_data(data)
	scrollView_set_data(self,data);
end
--销毁
function ScrollView:dispose()
	scrollView_dispose(self);
end

---案例1
---fbotex.ps 着色器用来关闭透明通道
function ScrollViewCase1(offsetx,offsety)
	
	local itemW = 90;

	--节点销毁回调
	local function f_dispose(node)
		if(node.tf) then
			node.tf:dispose();
			node.tf = nil;
		end
		
		node.skin:dispose();
	end
	local function clickEvt(name,p)
		local node = p;
		func_print("点击的节点index = "..node.index.." data = "..node.data);
		-- scrollView_dispose(sv);
	end
	
	local function f_create(renderlist)
		local x = 0;
		local y = 0;
		local w = itemW;--item宽度
		local h = 30;
		local url = "smallbtn.png";
		
		local sprite =  Image:new(w,h,renderlist);
		sprite:set_pos(x,y);
		sprite:mouseEnable(true);
		sprite:seticon(url);

		--********************************************************
		
		local node ={};

		if(true) then
			--节点特别多的时候,这里的渲染绘制会比较卡顿,可以考虑用分帧处理渲染
			local tf = NLabel:new(nil,nil,renderlist);			
			sprite:addChild(tf:get_container());
			node.tf = tf;
		end
		node.view = sprite:get_container();
		node.skin = sprite;

		node.data = nil;
		
		node.used = 1;
		node.index = nil;

		sprite:on(EVENT_ENGINE_SPRITE_CLICK,clickEvt,node);
		
		return node;
	end
	--刷新视图
	local function itemRefreshFunc(node)
	--    print(node.data);
		if(node.tf) then
			--fext_clear(node.tf);
			local str = string.format("i = %d,__%d",node.index,node.data);
			--ftext_parse(node.tf,str);
			node.tf:set_text(str);
		end
		--print("index",node.index,"刷新视图,设置数据",node.data);
	end
	--###############################################
	---@type ScrollView
	local sv = ScrollView:new(offsetx or 0,offsety or 0,itemW+5,120);

	---注册函数
	sv:bind(f_create,
		itemRefreshFunc,
		f_dispose);

	---初始化数据
	local t = {};
	for i = 1,10,1 do
		t[i] = i;
	end
	---设置数据
	sv:set_data(t);

	-- ---@type Button
	-- local btn = Button:new();
	-- -- btn:btn_effect(true);
	-- -- btn:set_pos(10,20);
	-- btn:set_label("dispose")
	-- btn:bind_click(function ()
	-- --func_print(11); 
	-- 	-- scrollView_dispose(sv);
	-- 	sv:dispose();

	-- 	btn:dispose();
	-- end);
	return sv;
end