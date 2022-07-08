local DEBUG = 0;--默认的模式0:开启,1关闭
core = {};
local core = core;
local m = core;

---ui组件类
core.ui = {};
---1:性能优化模式,会将md2替换成box 0:关闭
core.optimization = 0;

core.light = {x=0,y=0,z=0};

local FUNC_KEY = {
	---移除对象
	FUNC_PTR_REMOVE = 1,

	FUNC_SETV = 2,

	FUNC_RESET = 3,

	FUNC_GETV = 4,

	FUNC_LOAD_COLLIDE = 5,

	FUNC_GET_DRAW_CALL = 6,

	FUNC_GET_VERT_COUNT = 7,

	FUNC_GET_TIME = 8,
}

FLAGS_RENDER_BOUND_BOX	=	0x01;
FLAGS_DRAW_RAY_COLLISION	=	0x02;	--绘制射线盒子	(是否绘制射线静态包围盒,用于测试 查看射线包围盒),即使没有设置FLAGS_RAY,那么也是可以绘制射线盒子的,这样可以用来查看
-- FLAGS_LINE_RENDER			=	0x04;	--是否显示渲染线框
-- FLAGS_OUTLINE				=	0x08;	--是否显示边缘轮廓
FLAGS_RAY					=	0x10;	--16是否具有射线拾取功能(此只用于3d拾取,2d拾取不用这个标记)
FLAGS_VISIBLE				=	0x20;	--32显示或者隐藏模型,(是否加入渲染队列中)
FLAGS_RENDER_DRAWSKELETON	=	64;		--渲染骨骼节点(md5模型才会显示)
FLAGS_ANIM_ADAPTIVE		=	128;		--是否根据关键帧的帧率适配关键帧的动画(是否适配fps 1,适配  0,不适配)
FLAGS_GLSL_OUTLINE		=	256;		--用GLSL实现的轮廓线
-- FLAGS_DRAW_PLOYGON_LINE	=	512;		--在第一个基本材质上用线框渲染(固定管线模式设置GL_LINE)
FLAGS_BUTTON_EFFECT		=	1024;	--设置按钮特效(在有点击事件的前提下才会有该特效)
FLAGS_DRAW_NORMAL 		= 	2048;	--法线
FLAGS_DRAG				=	4096;	--是否可拖拽
-- FLAGS_DRAW_PLOYGON_POINT = 	8192;	--点模式
-- FLAGS_DISABLE_CULL_FACE	=	16384;	--设置显示双面
-- FLAGS_REVERSE_FACE		=	32768;	--反转渲染面,只有设置了双面渲染才有效
GL = {};
GL.GL_POINT=0x1B00;
GL.GL_LINE =0x1B01;
GL.GL_FILL =0x1B02;
---取消剔除背面
GL.CULL_FACE_DISABLE = 1;
GL.CULL_FACE_FRONT = 2;
GL.CULL_FACE_BACK = 3;

--[[
--//文件类型定义
TYPE_OBJ_FILE = 0--	//obj类型
TYPE_MD5_FILE =1 --//md5类型
TYPE_MD2_FILE =2 --//md2类型
TYPE_SPRITE_FLIE =3--//UI界面类型中的sprite
--TYPE_TEXT_FILE	=4	--//文本类型
TYPE_OBJ_VBO_FILE=	5--//VBO文件数据

SUFFIX_OBJ ="obj"
SUFFIX_MD5MESH ="md5mesh"
SUFFIX_MD2 ="md2"

--]]

------------------------------------------------------------
LUA_EVENT_RAY_PICK = 1						--拾取点击回调

EVENT_ENGINE_RESIZE	   =102				--resize事件

-- EVENT_ENGINE_BASE_UPDATE	 =  102		--base更新事件
EVENT_ENGINE_SPRITE_CLICK = 104
EVENT_ENGINE_SPRITE_CLICK_DOWN = 105
EVENT_ENGINE_SPRITE_CLICK_MOVE = 106    --click move
-- EVENT_ENGINE_TEX_LOAD_COMPLETE = 108	--纹理加载结束
EVENT_ENGINE_COMPLETE		   = 109	--完成事件

CUST_LUA_EVENT_SPRITE_FOCUS_CHANGE =110 --向lua层发送焦点变化
CUST_LUA_EVENT_INPUT_CHANGE = 111		--input输入内容发生变化

ENGINE_EVENT_COMPLETE = 1000;	--结束事件

local event = {
	DISPLAY = 10001,--显示
    UNDISPLAY = 10002,--隐藏
    COMPLETE = 10003,--完成事件

    -- ---* 计时器evtid=21
    -- ---* 该计时器从C内核层evt_dispatch过来的事件,我们只在Lua模块这边做监听.

}
--[[
@api ex_event
@apiGroup core
@apiDescription 由C内核的事件定义


]]
local ex_event = {
	--- 拾取点击回调,会给Lua层派发
	--- data 0:x 1:y 2:z 3:distance  
	--- distance:射线与三角形的交点 距离 射线起点的距离
	LUA_EVENT_RAY_PICK = 1,

	---* 计时器evtid=21
    ---* 该计时器从C内核层evt_dispatch过来的事件,我们只在Lua模块这边做监听.
	EVENT_TIMER = 201,

	---引擎渲染回调,每一帧调用一次
	EVENT_ENGINE_RENDER_3D =100,
	EVENT_ENGINE_KEYBOARD  =101,				--全局键盘事件
	
	---结束事件
	EVENT_ENGINE_COMPLETE		 =  103,	

	---鼠标中键滚动事件
	MOUSE_MID_EVENT = 112,
	---鼠标左键按下
	MOUSE_LEFT_DOWN_EVENT = 113,

	---刷新cam
	EVENT_CAM_REFRESH = 114,

	EVENT_ENGINE_SPEC_KEYBOARD = 115,--特殊键盘事件

};
core.KeyEvent = {
	KEY_ESC = 27,
	KEY_1 = 49,
	KEY_2 = 50,
	KEY_3 = 51,
	KEY_4 = 52,

	KEY_A = 97,
	KEY_B = 98,
	KEY_C = 99,
	KEY_D = 100,
	KEY_E = 101,
	KEY_I = 105,
	KEY_Q = 113,
	KEY_W = 119,

	GLUT_KEY_LEFT		=	100,
	GLUT_KEY_UP		=	101,
	GLUT_KEY_RIGHT	=		102,
	GLUT_KEY_DOWN	=		103,
	GLUT_KEY_PAGE_UP=		104,
	GLUT_KEY_PAGE_DOWN=		105,
	GLUT_KEY_HOME		=	106,
	GLUT_KEY_END		=	107,
	GLUT_KEY_INSERT		=	108,
}

require("alert")
--alert common
---@class Alert
local _alert;
function core.alert(str)
	if(_alert == nil) then
		_alert = Alert:new();
	end
	_alert:show(str);
end
---材质接口
local material = {}
core.meterial = material;

---为对象p设置m材质
function material.set(p,m)
	setMaterial(p,m);
end

---为材质设置alpha透明度
function material.setAlpha(m,alpha)
	tmat_set_alpha(m,alpha);
    shader_updateVal(m,"mAlpha",alpha);
end

---设置多边形的渲染模式
---@param m "Matereal"
---@param v "GL.GL_FILL,GL.GL_LINE,GL_POINT"
function material.setPolyMode(m,v)
	tmat_setPolyMode(m,v);
end

---设置背面剔除
function material.setCullface(m,v)
	tmat_cullface(m,v);
end

---设置背面状态
function material.tmat_get_cullface(m)
	return tmat_get_cullface(m);
end

---设置Material的渲染状态
---@param v "1:取消渲染,0开启渲染"
function material.disable(m,v)
	tmat_disable(m,v);
end
--根据id转化为事件名
function m.get_event_str(id)
	return id;
end

function core.ptr_remove(p)
	-- ptr_remove(p);
	set_attr(FUNC_KEY.FUNC_PTR_REMOVE,p);
end

function setv(p,v)
	set_attr(FUNC_KEY.FUNC_SETV,p,v);
end

function resetv(p,v)
	set_attr(FUNC_KEY.FUNC_RESET,p,v);
end

function getv(p,v)
	return set_attr(FUNC_KEY.FUNC_GETV,p,v);
end

function load_collide(p,url,scale)
	return set_attr(FUNC_KEY.FUNC_LOAD_COLLIDE,p, url,scale or 1.0);
end
---获取drawCall数量
function core.get_drawcall()
	return set_attr(FUNC_KEY.FUNC_GET_DRAW_CALL);
end

---获取对象的VBO顶点数
function core.get_vert_cnt(p)
	return set_attr(FUNC_KEY.FUNC_GET_VERT_COUNT,p);
end

---当前引擎执行的时间
function core.get_time()
	return set_attr(FUNC_KEY.FUNC_GET_TIME);
end
--return event;


--键值枚举P

--界面类型
UI_TYPE = {
	Label = 1,
	Button =2,
	ScrollBar = 3,
	Panel = 4,
	Skin = 5,
	---6 选项卡类型
	CheckBox = 6,
	ProgressBar = 7,--进度条
	ListBox = 8,--下拉列表
	Input = 9,--输入组件

	---10 image组件
	Image = 10,

	---11 shape组件
	Shape = 11,
	NScrollBar = 12,--滚动条组件
	NListBox = 13,--列表
	NLabel = 14,--Label
	NPanel = 15,
	---16
	NButton = 16,
	Nfbo = 17,-- Fbo type
};


--根据类型获取其类型名

--[[
@api 	funcgetNameByUIType
@apiPermission admin
@apiVersion 0.3.0
@apiParam {Number} t 类型
@apiSuccess {string} name 获取其类型名
@apiExample {lua} Example usage:
	func_getNameByUIType(UI_TYPE.Label);
	--返回一个文本"Label"
]]
function func_getNameByUIType(t)
	local u = UI_TYPE;
	local a = {
		[u.Label] = "Label",
		[u.Button] = "Button",
		[u.ScrollBar] = "ScrollBar", 
		[u.Panel] = "Panel",
		[u.CheckBox] = "CheckBox",
		[u.ProgressBar] = "ProgressBar",
		[u.ListBox] = "ListBox",
		[u.Image] = "Image",
		[u.Shape] = "Shape",
		[u.NScrollBar] = "NScrollBar",
		[u.NListBox] = "NListBox",
		[u.NLabel] = "NLabel",
		[u.NPanel] = "NPanel",
		[u.NButton] = "NButton",
		[u.Nfbo] = "Nfbo",
	}
	return a[t];
end




require("stack")
require("xml")	--xml组件
require("vec3")	--自定义数学库
require("nstack");--链栈

require("evt")	--事件管理器


--转化出一个地址
--"=table: 0082E758"  ===>8578904
local function getDddress(value)
	local len = string.len("table:  ")
	local a = string.len(tostring(value))
	local v = string.sub(tostring(value),len,a)
	local s = tonumber('0x'..v);
	return s;
end

--将"table: ff"转化为number
local function f_get_address(value)
	return getDddress(value);
end

---生成一个名字,local nameKey = -1;
m.getName = function(suffix)
	local id = get_nameId();
	if(suffix==nil)then
		return tostring(id);
	end
	return string.format("%d%s",id,suffix);
end;


local function f_split(input,delmiter)
    input = tostring(input);
    delmiter = tostring(delmiter);
    if(delmiter == '') then return false end
    local pos,arr = 0,{};

    for st,sp in function() return string.find(input,delmiter,pos,true) end do
        table.insert(arr,string.sub(input,pos,st - 1))
        pos = sp + 1;
    end
    table.insert(arr,string.sub(input,pos));
    return arr;
end

local function f_parse_mat_xml(xml)
	--取第一个索引中的材质配置
	local node = xml:get_index(0);--xml_get_node_by_index(xml,0);
	local shader = xml_get_str(node,"shader");
	-- func_print("解析材质:"..url..':'..shader);
	local ps =  xml_get_str(node,"ps");
	
	if(shader == nil) then
		func_error("shader is nil,"..url);
	else			
		if(shader == "") then
			func_error(url);
		end
		
		local _material = tmat_create_empty(shader);

		--添加贴图到材质对象	tex0~~tex7
		for i = 0,7,1 do
			local texName = "tex"..(i);	
			local _url = xml_get_str(node,texName);
			if(_url ~= nil) then
				tmat_pushTexUrl(_material,_url);
			end
		end
		return _material;
	end
end


	-- 根据一个配置加载生成一个数据对象
	-- url:
	-- 1.可以是一个mat链接如
	-- "\\resource\\material\\wall.mat"

	-- 2.也可以是具体的配置如
	-- [[<mat shader="simple;vboDiffuse" tex0="\resource\texture\bump2.tga"/>]]

function func_load_material(url)
	local i = string.find(url,"<");
	-- print(a);
	local xml;
	local _material;
	if(i == nil) then
		-- url为链接的时候
		xml = Xml:new();
		xml:load(url);
	elseif(i == 1)then
		-- url为具体配置的时候
		xml = Xml:new();
		xml:loadstr(url);
	end

	if(xml~=nil) then
		_material =	f_parse_mat_xml(xml);
		xml:dispose();
	end
	return _material;
end


--删除table下面的元素(遍历所有的表元素引用)
function func_clearTableItem(point)
	for k, v in pairs(point) do
		point[k] = nil
	end
	-- if(getmetatable(point)) then
	setmetatable(point,nil); --将对象的元表设置为nil
		-- print('find del reset metatabe!');
		-- print(getmetatable(point));
	-- end
end

function func_set_position(o,x,y,z)
	change_attr(o,"set_position",string.format("%f,%f,%f",x,y,z));
end
function func_get_position(o)
	return get_attr(o,"xyz");
end
---遍历打印表
function func_printTable(t)
	func_print(">>>>> start print table: "..tostring(t),0xff00ff)
	--print("start print table: "..tostring(t))
	local cnt = 0;
	func_print("value\t\t  key",0xff00ff);

	for key, value in pairs(t) do 
		--print('key=['..key..']'..'value['..value..']')
		local s = 'type:'..type(value)..'\t'..tostring(value)
		if(tonumber(value)) then
			
			--转化为16进制数据
			s =  string.format("%#x",tonumber(value)).."\t("..value..")"
		end
		
		func_print(s.."\t\t"..tostring(key))
		
		cnt = cnt + 1;
	end 
	func_print(">>>>> end print table:   ["..tostring(t).."] cnt = "..cnt,0xff00ff)
end

---打印一个有颜色的日志到控制台  
---s文本 c颜色
function func_print(s,c)
	if(DEBUG == 1)then
		c = c or 0xffff00
		--c = c or 0;
		
		--向控制台输出有颜色的文本日志
		log_print(string.format("%c%c%c%clua: %s\n",0xa8,0x84,0xa8,0x84,s),c);
	end
end
---输出警告信息
function func_warn(s)
	func_print(s,"0xff0000");
end
---程序异常的时候做一次输出,或者打印堆栈
function func_error(msg,func,noAssert)
	msg = msg or "";
	local s = ''
	
	s = 'lua error '..msg..''
	--func_print(s,0xff0000)
	--func_print('lua error:'..s,0xff0000)
	
	-- func_print(s,0xff0000);
	
	s = ''
	if(func) then
		--print ('line num:'..debug.getinfo(1).currentline..',file name:'..debug.getinfo(1).name )
		local info = debug.getinfo(func)
		for k,v in pairs(info) do
			
				--全部打印
				--print(k, ':', info[k])
				
				--linedefined				
				--short_src
				--s = s..tostring(k)..':\t\t'..tostring(info[k])..'\n'
				
				if(tostring(k) == 'linedefined') then
					s = s..'lineNum:'..tostring(info[k])..'\t'
				end
				
				if (tostring(k) == 'short_src') then
					s = s..'file:'..tostring(info[k])..'\t'
				end
		end
	end
	-- func_print(s,0xff0000);
	-- --printTable(debug.getinfo(1))
	-- --print(debug.traceback())
	
	-- func_print(debug.traceback(),0xff0000);
	-- if(DEBUG == 0) then
	-- 	print(debug.traceback());--当没有设置输出日志的时候,控制台默认输出日志.
	-- end
	local s1 = msg..s;
	-- print(s1);
	local s2= string.format("%s\n%s",s1,debug.traceback());
	core.alert(s2);
	print(s2);

	if(noAssert)  then
		
	else
		assert(nil,s);
	end
	--error(msg)
    --print ( debug.getinfo(1).name )
end

--[[
	设置sprite对象的相对于父对象的坐标
--]]
function func_set_local_pos(p,x,y)
	local pos = x..","..y;
	change_attr(p,"sprite_set_self_pos",pos);
end

--[[
	将child添加到parent中
--]]
function func_addchild(parent,child,x,y)
	if(type(parent)~="number" or type(child)~="number") then
		func_error(type(parent)..","..type(child));
	end
	x = x or 0;
	y = y or 0;
	
	if(parent==nil) then
		func_error();
	end
	
	sprite_addChild(parent,child);
	func_set_local_pos(child,x,y);
end

--内存回收C模块的
function func_gc()
	change_attr(nil,"gc");
	--print('gc')
end

--lua的GC
function func_lua_gc(key)
	local old =  collectgarbage("count");
	--func_print("==> GC之前 LUA VM使用的总内存数:"..(collectgarbage("count")*1024).." bytes");
	collectgarbage("collect");
	local n = collectgarbage("count");
	func_print((key or "").."GC完成 LUA VM使用的总内存数:"..n.."kb,gc了["..((old - n)*1024).."]bytes");
end

--为sprite设置贴图
function func_setIcon(sprite,url)
	--获取一个atals图集,没有图集的界面是黑色的
	local atals = core.atals;
	if(atals) then
		--sprite_bindAtals(sprite,atals);

		sprite_texName(sprite,atals,url);
	end
end

--获取sprite的宽高
function func_get_sprite_size(o)
	return get_attr(o,"spriteSize")	
end

--重置sprite的宽高
function func_set_sprite_size(o,w,h)
	change_attr(o,"sprite_resize",string.format('%d,%d',w,h));
end

--获取鼠标拾取的sprite相对坐标
function func_get_sprite_mouse_xy(o)
	local x , y=get_attr(o,"spriteLocalXY");
	return x,y
end

--加载文件返回一个字符串
function func_loadfile(url)
    return change_attr(nil,"loadfile",url);
end


--字符串分割成table
function func_split(str, delimiter)
    delimiter = delimiter or ","
    if str==nil or string.len(str)==0 or delimiter==nil then
        return nil
    end
 
    local result = {}
    for match in (str..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end


--相当于addchild
function func_addnode(parent,n,x,y)
	x = x or 0;
	y = y or 0;
	local _type = n.type;
	
	if(_type == UI_TYPE.ScrollBar) then
		func_addchild(parent,scrollBar_get_container(n),x,y);
	elseif(_type == UI_TYPE.Button)then
		func_addchild(parent,btn_get_container(n),x,y);
	elseif(	
		_type == UI_TYPE.Image
		or _type == UI_TYPE.Shape
		) then
		func_addchild(parent,n.container,x,y);
	elseif(_type == UI_TYPE.ListBox) then
		func_addchild(parent,listbox_get_container(n),x,y);	
	elseif(_type == UI_TYPE.NScrollBar
			or _type == UI_TYPE.ProgressBar 
			or _type == UI_TYPE.NListBox
			or _type == UI_TYPE.NLabel
			or _type == UI_TYPE.NButton
			or _type == UI_TYPE.CheckBox
			or _type == UI_TYPE.Input 
			or _type == UI_TYPE.Nfbo
	) then
		local c = n:get_container();
		if(c == nil) then
			func_error();
		end
		
		--print(c);
		func_addchild(parent,c,x,y);	
	else
		func_error(string.format("type = %s do not imlment",tostring(_type)));	--未实现
	end
end

---设置child的父类对象
-- function set_parent(child,parent)
-- 	setmetatable(child, parent);
-- 	child.superClass = parent;
-- end

---执行obj父类的方法  
---obj对象引用  
---funcname函数名
core.super=function(obj,funcname,...)
	-- if(self.superClass) then
	--print("self对象元表:",getmetatable(self),NLabel);
	
	local old_mtb = getmetatable(obj);--将对象的元表先存起来,之后恢复用
	
	--print("getmetatable(NLabel)==Base",getmetatable(NLabel)==Base)
	-- 	print("new:",self.superClass);
		 
	-- end

	local p1 = getmetatable(obj);--获取对象obj(self)的元表
	if(p1 == nil) then
		func_error('p1 is nil');
		return;
	end
	
	local p2 = getmetatable(p1);--获取self元表的元表,即父对象
	if(p2 == nil) then
		func_error('p2 is nil');
		return;
	end

	setmetatable(obj,p2);

	obj[funcname](obj,...);

	setmetatable(obj,old_mtb);
end

--基础渲染组件
require("NUnit");

--对象的变换组件
require("Transform");

require("base");
require("linenode");

require("label");--label是对ftext进行的一次封装

require("input");

require("cam");

require("fbo")	--fbo

require("shape")	--shape组件
require("image")	--image组件




require("UnitBase");		--角色单位
require("md5unit");		--md5对象


local function f_time(data,o)
	if(o.c) then
		-- func_print(tostring(o.c)..' is call');
		o.c(o.p);
	end
	
	if(o._repeat == nil) then
		m.clearTimeout(o);--回收setTimeout相关的资源
	end
end

---获取Tabel的长度,会计算Tabel中的所有键值数据
---@param tb Tabel
function m.getLen(tb)
	local n = 0;
	for k, v in pairs(tb) do
		n = n + 1;
	end
	return n;
end
---创建着色器对象
function m.p3d_create(vs,ps)
	return progrom3d(0,vs,ps);
end
---删除着色器对象
function m.p3d_del(p)
	progrom3d(1,p);
end
---为材质对象设置着色器对象
function m.p3d_set(mat,p)
	progrom3d(2,mat,p);
end
---@param ms 延迟ms毫秒执行callback
---@param repeat1 "if repeat1 is true,function will be repeate running every frame."
---repeat1 true标识重复 默认不重复
function m.setTimeout(ms,callback,param,repeat1)
	local timer = timelater_new(ms);
	local o = {t=timer,c=callback,p=param,_repeat=repeat1};
	if(repeat1 == true) then
		evt_on(timer,core.ex_event.EVENT_TIMER,f_time,o);
	else
		evt_once(timer,core.ex_event.EVENT_TIMER,f_time,o);
	end
	return o;
end

function m.frameloop(ms,func)
	return core.setTimeout(ms,func,nil,true);
end

---返回当前的FPS  
---radix(默认1) 0:去小数点 1:保留1位 2:保留2位  
function m.getFps(radix)
	radix=radix or 1;
	local v = math.pow(10,radix);
	return math.floor(1000 / core.delayTime() * v) / v;
end
function m.clearTimeout(o)
	if(o == nil) then
		func_error('o is nil');
	end

	if(next(o) == nil) then
		return;--表已经清空了
	end

	--evt_off(o.t,EVENT_TIMER,o.c);
	if(o.t~=nil) then
		timelater_remove(o.t);
		o.t = nil;
	end
	if(o.c~=nil) then
		evt_off(o.t,core.ex_event.EVENT_TIMER,o.c);
		o.c = nil;
	end
	if(o._repeat~=nil) then
		o._repeat=nil;
	end
end

---获取当前进程运行时间
function m.now()
	return get_attr(nil,"get_longTime");
end
---输出警告信息
---@param str string
function m.warning(str)
	str = string.format("warning >>>>>>>>>>>>>>> [%s] %s",str or "",debug.traceback());
	if(DEBUG == 1) then
		func_print(str,0xff00ff);
	else
		print(str);
	end
end

---ptr tabel中的数据转化为number句柄,number is like (Node Sprite...)
local function f_get_ptr(ptr)
	if(ptr == nil) then
		func_error('ptr = nil');
	end

	local _type = type(ptr);

	if(_type == "table") then
		local tb = getmetatable(ptr);
		
		if(	
			--tb == UnitBase or tb == NUnit	or tb == LineNode
			ptr.p ~= nil
		) then
			ptr = ptr.p;
		elseif tb == Button then
			ptr = ptr.img.container;
		elseif 	tb == Image or
				tb == Shape
			then
			ptr = ptr.container;
		elseif tb == FboRender then
			ptr = ptr.spr;
		else
			func_error("未实现该table的转换!");
		end
	end

	if(type(ptr) ~= "number") then
		func_error("type(ptr) = "..type(ptr)..",type of ptr must be number!");
	end
	
	return ptr;
end

---添加一个渲染节点到渲染列表
--[[
local obj = MapEditor:LoadModel();
core.add(obj,core.renderlist);
-- core.del(obj,core.renderlist);
-- obj:dispose();


--------------------------
local btn = Button:new();

core.del(btn);
btn:dispose();
]]
---@param r 渲染列表list
---@param p "渲染节点LineNode,UnitBase"
function m.add(p,r)
	local _type = type(p);
	
	if(_type == "table") then
		--print(r or core.renderlist,f_get_ptr(p),1);
		local _list = r;
		--or core.renderlist;--设置在哪个渲染列表

		local _funcName = "setRenderList";
		
		if(p[_funcName]~=nil and type(p[_funcName])=="function") then			
				-- print(p["setRenderList"]);
			-- print(type(p["setRenderList"]));

			p:setRenderList(_list);
			
			addOrDel(_list,f_get_ptr(p),1);
		else
			func_error("function:".._funcName.." not exist!");
		end
	else
		func_error("p type = ".._type);
	end
end

---从渲染列表中移除一个节点
---```
---   core.del(n);--在对象dispose之前从渲染列表中删除
---   n:dispose();
---```
function m.del(_node,_renderlist)
	local _list = _renderlist;--or core.renderlist;
	local ptr = f_get_ptr(_node);
	addOrDel(_list,ptr);
end

function m.gc()
	func_lua_gc();
end

--移除模块,如果有的模块需要重新加载的初始化的,可以使用该接口
function m.removeRequire( preName )
    for key, _ in pairs(package.preload) do
        if string.find(tostring(key), preName) == 1 then
			print("preload remoeve preName:"..preName);
			package.preload[key] = nil;
        end
    end
    for key, _ in pairs(package.loaded) do
		if string.find(tostring(key), preName) == 1 then
			print("loaded remoeve preName:"..preName);
            package.loaded[key] = nil;
        end
    end
end
---是否开启debug模式
function m.debug(v)
	if(v == true or v == 1)then
		DEBUG=1;
		--log_enable(1);
	elseif(v == false or v == 0)then
		DEBUG=0;
		--log_enable(0);
	end
	func_print(string.format("设置了debug开启状态:%s",v));
end;
---获取模型的类型
function m.get_type(p)
	return	get_attr(p,"type");
end

 function m.get_type_str(p)
	local t = m.get_type(p);
	if(t == 0) then
		return 'obj'
	elseif(t == 1)then
		return 'md5'
	elseif(t == 2)then
		return 'md2'
	elseif(t == 3)then
		return 'sprite'
	elseif(t == 4)then
		return 'text'
	elseif(t == 5)then
		return 'vbo'
	end
end

--设置每一帧需要的间隔时间
local function setDelayMs(ms)
    change_attr(nil,"custDelayMs",ms);
end
---设置FPS
---@param v frame percent second
function m.setFps(v)
	func_print(string.format("设置fps=%d",v));
	local a = math.ceil(1000/v);
	-- print("a = "..a);
	setDelayMs(a);
end

--[[
@api setBackgroundColor
@apiName setBackgroundColor
@apiPermission all
@apiGroup core 
@apiDescription 

设置引擎的背景色	<br>
r g b值在0~1之间	<br>

@apiParam {number} r Red Color
@apiExample {lua} Example usage:
	setBackgroundColor(0,0,1);--设置背景为蓝色

@apiExample {c} Example usage:
	setBackgroundColor(0,0,10);
]]
---设置引擎的背景色
function m.setBackgroundColor(r,g,b)
    change_attr(nil,"setBgColor",string.format("%s,%s,%s",r or 0,g or 0,b or 0));
	func_print(string.format("设置背景色%s %s %s",r,g,b));
end

---退出进程
function m.exit()
	change_attr(nil,"exit");
end
---每一帧间隔的毫秒
function m.delayTime()
	return get_attr(nil,"delayTime");
end

---将对象重命名
function m.rename(o,value)
	change_attr(o,"rename",tostring(value));
end

---获取屏幕的尺寸
function m.screen_size()
	return get_attr(nil,"screenSize");
end

---从引擎层获取对象
function m.find_name(name)
	return find_name(name);
end

---加载一个资源,只是加载,并不会加载到渲染列表
---默认都是加载vbo类型的数据
function m.load(url,name)
	name = name or m.getName();
	local o = change_attr(nil,"ex_loadVBO",name,url);
	func_print('加载VBO:'..url);
	return o;
end

-- M.debug(0);

-- local function fc()
-- 	print("fc..."..func_get_longTime());
-- end

--print("xx..."..func_get_longTime());
--local o = setTimeout(1000,fc);
--clearTimeout(o);

m.UI_TYPE = UI_TYPE;


-- print("core init!!!");

---为Tabel设置其地址
---@param o Tabel
function m.bindAddress(o)
	o.address=f_get_address(o);
end

---@type PluginMan

---打印信息
function m.print_info()
	get_attr(nil,"ex_info");
	core.texCache:info();
end
---获取鼠标xMouse,yMouse,midDirection
function m.get_mouse_status()
	return get_mouse_status();
end
--------------------------------------------------------------
m.ex_event = ex_event;
m.EVENT = event;--require("event");

---@type Camera
m.cam = nil;--当前的视图camera
---@type Camera
-- m.cam2d = nil;
m.texCache = nil;
---引擎默认的渲染列表
m.renderlist = nil;
m.atals = nil;
---引擎句柄引用
m.engine = nil;
---获取插件管理器的句柄
---@type PluginMan
m.plugin = nil;
---需要更新的列表
m.frameUpdateList = {};


---@type NStack
local _calllist;
---@type NStack
local _tempList;

--				插件管理器
--负责加载各种外置插件,例如fpsView这种挂载式小工具
--这是一种极端松散耦合的模式,这样能使用框架层足够小巧,
--扩展功能都是依赖插件模式,比较适合需求经常发生变动的情况,
--我们可以将这种多变的部分封装成一个插件进行挂载式的应用
require("plugin_man");
require("texcache");

local function f_render()
	local frameUpdateList = core.frameUpdateList;
	for k, v in pairs(frameUpdateList) do
		-- print('**',frameUpdateList[k]);
		if(k.isEnable == true) then
			k:update();
		end
	end
end

-- local function onTouchClick()
	-- body
	-- local ptr,x,y,z,dis = core.get_hit();
	-- func_print(string.format("LUA_EVENT_RAY_PICK %#x %s %s %s %s",ptr,x,y,z,dis));
-- end

---加载图集url.xml url.tga
function atals_load_file(url)
	local arr =f_split(url,"//");
	local cnt = #arr;
	local p1 = "";
	for n = 1, #arr-1 do 
		p1 = p1..arr[n].."//";
	end 
	return atals_load(p1,arr[cnt]);
end

---初始化
--- @param atals_url 主图集
---game_init("//resource//texture//1");
function core.init(atals_url)
	if(core.engine)then
		func_warn("warning,engine is already initialise!!!");
		return;
	end
	core.debug(1);
	--构造一个图集
    -- core.atals = atals_load("//resource//texture//","1");
	if(atals_url == nil) then
		func_error("there no default atals!");--没有设置默认图集资源
		return;
	end
	core.atals = atals_load_file(atals_url);

	local engine,cam2d,cam3d,renderlist = getEngine();
	core.engine = engine;
	--core.renderlist = renderlist;
	core.cam = Camera:new(cam3d);
	local cam2d = Camera:new(cam2d);
	core.plugin = PluginMan:new();
	core.texCache = TexCache:new();

	_calllist = NStack:new();
	_tempList = NStack:new();

	evt_on(engine,core.ex_event.EVENT_ENGINE_RENDER_3D,f_render,self);

	-- evt_on(core.engine,core.ex_event.LUA_EVENT_RAY_PICK,onTouchClick);
	core.setBackgroundColor(0.3,0.3,0.3);


	local function getCam2d()
		return cam2d;
	end
	core.getCam2d = cam2d;
end

function core.game_dispose()
	atals_dispose(core.atals);
end

function func_get_tex_cache(atals,icon)
	---@type TexCache
	local tc = core.texCache;

	local tex = tc:get_tex(atals,icon);--从texCache纹理缓存列表中获取
	if(tex == 0) then
		--从图集中创建一块纹理数据,并返回,如果有数据则从map里获取
		tex = atals_new_tex(atals,icon);
	end
	tc:add_tex(atals,icon,tex);
	return tex;
end
function func_del_tex_cache(tex)
	local cnt =  core.texCache:delTex(tex);
	return cnt;
end

---当前的游戏帧
function core.getframe()
	return getframe() or 0;
end
---内存池中未使用的字节数,总的字节数
function core.memory_info()
	local disableBytes,totalBytes = memory_info();
	return disableBytes,totalBytes;
end

---获取点击到的3d对象的射线交点坐标和该3d对象的句柄值
function core.get_hit()
	-- local ptr,x,y,z,dis = get_hit();
	-- x = math.floor(x * 100)/100;
	-- y = math.floor(y * 100)/100;
	-- z = math.floor(z * 100)/100;
	-- dis = math.floor(dis * 100)/100;
	-- return ptr,x,y,z,dis;
	func_error("has not actualize!");--未实现
end

---下一帧执行,在第n帧添加callLater回调之后  
---会在n+1帧时间线回调func方法
function core.callLater(func,param)
	-- func_print('callLater:'..tostring(func));
	-- core.setTimeout(1,func,param);
	local obj = {
		func = func,
		param = param,

		---当前的关键帧
		frame = 0,
	};
	obj.frame = core.getframe();
	_calllist:push(obj);
	-- stack_push(_calllist,obj);
end
---获取后缀
function m.get_suffix(url)
	local arr = f_split(url,"//");
	local str = arr[table.getn(arr)];
	local a = f_split(str,".");
	return a[table.getn(a)];
end

---time秒
---返回day,hour,minutes,seconds;
function m.time2str(i)
	local day = math.floor(i / (3600* 24));
	local hour = math.floor(i/3600);
	local minutes = math.floor((i % 3600)/60);
	local seconds = math.floor(i % 60);
	if(day > 0)then
		minutes = math.ceil(i % 3600 / 60);
		hour = math.floor((i - day*3600*24)/3600);
		return day,hour,minutes,seconds;
	elseif(hour > 0) then
		return hour,minutes,seconds;
	elseif(minutes > 0) then
		return minutes,seconds;
	else
		return seconds;
	end
end

function func_pre_callLater()
	local frame = core.getframe();
	while(_calllist:len() > 0) do
		local t = _calllist:pop();
		if(t.frame == frame - 1) then
			t.func(t.param);
			--func_print('push************len:'.._calllist:len()..','..t.frame..','..frame);
		else
			_tempList:push(t);
		end
	end
	while(_tempList:len() > 0)	do 
		_calllist:push(_tempList:pop());
	end
end

local tablePrinted = {}
---打印Tabel数据
---printTableItem("_G", _G, 0)
function printTableItem(k, v, level)
    for i = 1, level do
        io.write("    ")
    end

    io.write(tostring(k), " = ", tostring(v), "\n")
    if type(v) == "table" then
        if not tablePrinted[v] then
            tablePrinted[v] = true
            for k, v in pairs(v) do
                printTableItem(k, v, level + 1)
            end
        end
    end
end 

function load_model(name,url)
	func_error("未实现接口load_model");
end

---@param n nNum后面的n位小数
function core.getPreciseDecimal(nNum, n)
    if type(nNum) ~= "number" then
        return nNum;
    end
    n = n or 0;
    n = math.floor(n)
    if n < 0 then
        n = 0;
    end
    local nDecimal = 10 ^ n
    local nTemp = math.floor(nNum * nDecimal);
    local nRet = nTemp / nDecimal;
    return nRet;
end

function core.parse9GridTex(_tmat,sw,sh,icon,left,right,top,bottom)
    local x,y,w,h = atals_getTexInfo(core.atals,icon); 
	shader_updateVal(_tmat,"left",left/w);
	shader_updateVal(_tmat,"right",right/w);
	shader_updateVal(_tmat,"top",top/h);
	shader_updateVal(_tmat,"bottom",bottom/h);
	shader_updateVal(_tmat,"sx",sw/w);
    shader_updateVal(_tmat,"sy",sh/h);
end

---上传shader数据
function core.shaderUpdateParam(m,...)
	local arr = {...};
	local n = #arr;
	for i = 1,n,2 do
		shader_updateVal(m,arr[i],arr[i+1]);
	end
end
