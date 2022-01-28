--��ǰ��2dcam���,ָ��sprite����ָ����Ӧ��cam����
-- local function scrollView_get_cam(sv)
-- 	return sv.fbo:get_cam2d();--sv.fbo.cam2d;
-- end

--��itemRender list������л�ȡһ��itemRender�ڵ����,����������û�оʹ���һ��
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
--��ȡ��ǰitemRender�ĸ߶�,�����nilȡ��ʼ����ʱ���gapֵ��Ϊ�߶�
local function f_getItemHeight(sv)
	if(sv.itemHeight==nil) then
		local node = f_pool_getItem(sv);
		node.used = 0                                                                                                                     
		local w,h = func_get_sprite_size(node.view);
		sv.itemHeight = h;
	end
	return sv.itemHeight;
end

--���item�����Ƿ�������������
local function f_checkItemOutside(sv,pos_y)
    if(pos_y   >= sv.sh) then
        return 1;--���³���
    end

    if(pos_y + f_getItemHeight(sv) <= 0 ) then
        return 2;--���ϳ���
    end

    return 0;--��������������
end

--���ù��������������
local function scrollView_set_pos(sv,x,y)
	sv.x = x;
	sv.y = y;
	sv.fbo:set_pos(x,y);
end
--�Ӷ�������ͷ�һ���ڵ�
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

--�ͷŶ�����е����нڵ�
local function f_pool_recycs_all(sv)
    local data = sv.pool;
    for key, value in pairs(data) do
        value.used = 0;
	end
end

--����������ȡ��������Ӧ������
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

--�������ݻ�ȡ��Ӧ��node����
local function f_find_node_by_data(sv,data)
	for key, node in pairs(sv.pool) do
		if(node.data == data)then
			return node;
		end
	end
end

--���һ��������
local function f_add_scrollBar(sv)
	---@type NScrollBar
	local sc;
	if(sv.dir == CONST_DIRECTION_VERTICAL) then
		--sc = scrollBar_new(sv.x+sv.sw,sv.y,nil,15,sv.maxSize);
		sc = NScrollBar:new(sv.x+sv.sw,sv.y,15,sv.maxSize);
	else
		print("��ʵ��");
	end
	sv.sc = sc;
   
	local curp = 0;
	
	local curIndex = 0;
	
	local _startIndex = 0;--���µ���ʼ����
	
	--�����ص�
    local function f_scHandle(progress,param)
		--*************************����
		
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
		
		local _posList = {};--�����б�
		for i=0,sv.needCnt-1,1 do
			_posList[i] = itemy;
			itemy = itemy + itemH;
		end
		
		local newList = {};
		local m = 0;
		
		f_pool_recycs_all(sv);--�ͷŶ�����е����е�node
		
		for n = curIndex,curIndex + sv.needCnt - 1 do
			
			local _td = f_find_data_by_index(sv,n);
			
			if(n >= _startIndex and n <= _startIndex + sv.needCnt - 1) then
				--����Ľڵ�ֻ��Ҫ�������꼴��
				
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
			--����Ľڵ�Ҫ����ˢ�½ڵ���ͼ
			local node = f_pool_getItem(sv);
			node.data = value;
			sprite_setpos(node.view,0,_posList[key]);
			sv.itemRefreshFunc(node);
		end
		
		_startIndex = curIndex;
		--********************************************************************
		
		--print(sv.dataList);
--		print(string.format("��ʼ����Ϊ%d,�ڵ�����Ϊ%d",_startIndex,sv.needCnt));
		
		--���˼·:�Ա���ʼ���ݺ͵�ǰ�仯������,���������Ҫrefresh��itemRender�ڵ�����ˢ����������,ƫ�Ʋ���Ҫ����ˢ���������ݵĽڵ�
		--������Ҫ�����б���
    end
	--scrollBar_bind(sc,f_scHandle);
	sc:bindCallback(f_scHandle,sc);
end

--��ȡ�ù����������Ҫ���item����
local function f_need_cnt(sv)
	local h = f_getItemHeight(sv);
    local a = sv.sh % h;

    if(a > 0) then a = 1 end
	
    return (math.ceil(sv.sh/h) + a)+2;
end

--�����������srollView�е�����
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
                --print(value,"�����ɼ�����,��Ⱦ�޳�!,��ǰ�Ѿ������Ľڵ���;",cnt+1,"��������Ⱦ�ڵ���:",_realNeedCnt);
            else
                local _node = f_pool_getItem(sv);
                _node.data = value;
				
                local itemView = _node.view;
			    
			    --***********************
			    --����
                sprite_setpos(itemView,0,cur_h);
				
				_node.index = n;
				
				--print("��������",n);
				
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

--���ٹ��������
local function scrollView_dispose(sv)
	if(sv.itemDisposeFunc == nil) then
		--print(sv.itemDisposeFunc);
		print("itemDisposeFunc = nil");
	end
	
	--����itemRender�����,����itemDispose�ص�����itemRender����
    for key, node in pairs(sv.pool) do
		
		if(node.skin == nil) then
			func_error("node�ֶ�skinû�и�ֵ,��Ч�����б���Ⱦ�ӽڵ�!");
		end
		
		sv.itemDisposeFunc(node);
	end
	
	if(sv.fbo) then
		sv.fbo:dispose();
	end
	
	if(sv.sc) then
		sv.sc:dispose();
	end
	
	func_clearTableItem(sv);--���sv��
end

--gap �Զ���ļ��,Ĭ����ȡitemRender�������ĸ߶�
local function scrollView_init(sw,sh,x,y,gap)
    local sv = {
		fbo,--FBO�������
		sc,--�������������
		
		dataList,--�����б�
		itemFunc,			--item�б�Ĵ��������ص�����
        itemRefreshFunc,	--��������,ˢ����ͼ�ķ����ص�����
		itemDisposeFunc,	--����itemRender�Ļص���������

        needCnt,--��Ҫ��Ԫ�ؽڵ���,����������ǰ��pool���������Ҫ�������Ⱦ�ڵ���
		
		x,y,--��ǰ������,����ڴ��ڵľ�������,��ʵ��fbo���ص�sprite������,��֡������Ⱦ�����sprite����
		sw,--��������Ŀ�
		sh,--��������ĸ�
		dir,--�������Ĺ�������,�Ǻ���������
		maxSize,--��Ϊ���ڵ�sprite�õĵȿ�ȸߵ�,��������ȡ����maxSize��Ϊ���
		
		dataHeight,--�����ܸ߶ȣ���dataList�й�ϵ

        itemHeight,--����item��Ⱦ�ڵ�ĸ߶�
		
        pool = {},--itemRender�б�Ķ����
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
	sv.fbo:mouseEnable(true);--����fbo��Ⱦ��ͼ�ɵ��
	
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

---ע��:skin��ԴҪ�ȼ��غ�,���ܳ�ʼ��
---@param sw ��
---@param sh ��
---@param x x������
---@param y y������
---@param gap ÿ������Ⱦ����ļ��
function ScrollView:new(x,y,sw,sh,gap)
	local s = scrollView_init(sw,sh,x,y,gap);
	setmetatable(s,ScrollView);
	return s;
end

---����صĻص�����
---@param f_create ����itemRende�Ĵ����ص����ڴ���ÿ���ӽڵ�
---@param itemRefreshFunc ����ˢ����ͼ�Ļص�
---@param f_dispose ����itemRender���ٻص�����
function ScrollView:bind(f_create,itemRefreshFunc,f_dispose)
	local sv = self;
	sv.itemFunc = 	f_create;
	sv.itemRefreshFunc = itemRefreshFunc;
	sv.itemDisposeFunc = f_dispose;
end

--��������
function ScrollView:set_pos(x,y)
	scrollView_set_pos(self,x,y);
end
--��������
function ScrollView:set_data(data)
	scrollView_set_data(self,data);
end
--����
function ScrollView:dispose()
	scrollView_dispose(self);
end

---����1
function ScrollViewCase1(offsetx,offsety)
	
	--�ڵ����ٻص�
	local function f_dispose(node)
		if(node.tf) then
			node.tf:dispose();
			node.tf = nil;
		end
		
		node.skin:dispose();
	end
	local function clickEvt(name,p)
		local node = p;
		func_print("����Ľڵ�index = "..node.index.." data = "..node.data);
		-- scrollView_dispose(sv);
	end
	
	local function f_create(renderlist)
		local x = 0;
		local y = 0;
		local w = 90;
		local h = 30;
		local url = "smallbtn.png";
		
		local sprite =  Image:new(w,h,renderlist);
		sprite:set_pos(x,y);
		sprite:mouseEnable(true);
		sprite:seticon(url);

		--********************************************************
		
		local node ={};

		if(true) then
			--�ڵ��ر���ʱ��,�������Ⱦ���ƻ�ȽϿ���,���Կ����÷�֡������Ⱦ
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
	--ˢ����ͼ
	local function itemRefreshFunc(node)
	--    print(node.data);
		if(node.tf) then
			--fext_clear(node.tf);
			local str = string.format("i = %d,__%d",node.index,node.data);
			--ftext_parse(node.tf,str);
			node.tf:set_text(str);
		end
		--print("index",node.index,"ˢ����ͼ,��������",node.data);
	end
	--###############################################
	---@type ScrollView
	local sv = ScrollView:new(offsetx or 0,offsety or 0,100,120);

	---ע�ắ��
	sv:bind(f_create,
		itemRefreshFunc,
		f_dispose);

	---��ʼ������
	local t = {};
	for i = 1,10,1 do
		t[i] = i;
	end
	---��������
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