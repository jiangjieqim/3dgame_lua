local DEBUG = 0;--Ĭ�ϵ�ģʽ0:����,1�ر�
core = {};
local core = core;
local m = core;

---ui�����
core.ui = {};
---1:�����Ż�ģʽ,�Ὣmd2�滻��box 0:�ر�
core.optimization = 0;

core.light = {x=0,y=0,z=0};

local FUNC_KEY = {
	---�Ƴ�����
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
FLAGS_DRAW_RAY_COLLISION	=	0x02;	--�������ߺ���	(�Ƿ�������߾�̬��Χ��,���ڲ��� �鿴���߰�Χ��),��ʹû������FLAGS_RAY,��ôҲ�ǿ��Ի������ߺ��ӵ�,�������������鿴
-- FLAGS_LINE_RENDER			=	0x04;	--�Ƿ���ʾ��Ⱦ�߿�
-- FLAGS_OUTLINE				=	0x08;	--�Ƿ���ʾ��Ե����
FLAGS_RAY					=	0x10;	--16�Ƿ��������ʰȡ����(��ֻ����3dʰȡ,2dʰȡ����������)
FLAGS_VISIBLE				=	0x20;	--32��ʾ��������ģ��,(�Ƿ������Ⱦ������)
FLAGS_RENDER_DRAWSKELETON	=	64;		--��Ⱦ�����ڵ�(md5ģ�ͲŻ���ʾ)
FLAGS_ANIM_ADAPTIVE		=	128;		--�Ƿ���ݹؼ�֡��֡������ؼ�֡�Ķ���(�Ƿ�����fps 1,����  0,������)
FLAGS_GLSL_OUTLINE		=	256;		--��GLSLʵ�ֵ�������
-- FLAGS_DRAW_PLOYGON_LINE	=	512;		--�ڵ�һ���������������߿���Ⱦ(�̶�����ģʽ����GL_LINE)
FLAGS_BUTTON_EFFECT		=	1024;	--���ð�ť��Ч(���е���¼���ǰ���²Ż��и���Ч)
FLAGS_DRAW_NORMAL 		= 	2048;	--����
FLAGS_DRAG				=	4096;	--�Ƿ����ק
-- FLAGS_DRAW_PLOYGON_POINT = 	8192;	--��ģʽ
-- FLAGS_DISABLE_CULL_FACE	=	16384;	--������ʾ˫��
-- FLAGS_REVERSE_FACE		=	32768;	--��ת��Ⱦ��,ֻ��������˫����Ⱦ����Ч
GL = {};
GL.GL_POINT=0x1B00;
GL.GL_LINE =0x1B01;
GL.GL_FILL =0x1B02;
---ȡ���޳�����
GL.CULL_FACE_DISABLE = 1;
GL.CULL_FACE_FRONT = 2;
GL.CULL_FACE_BACK = 3;

--[[
--//�ļ����Ͷ���
TYPE_OBJ_FILE = 0--	//obj����
TYPE_MD5_FILE =1 --//md5����
TYPE_MD2_FILE =2 --//md2����
TYPE_SPRITE_FLIE =3--//UI���������е�sprite
--TYPE_TEXT_FILE	=4	--//�ı�����
TYPE_OBJ_VBO_FILE=	5--//VBO�ļ�����

SUFFIX_OBJ ="obj"
SUFFIX_MD5MESH ="md5mesh"
SUFFIX_MD2 ="md2"

--]]

------------------------------------------------------------
LUA_EVENT_RAY_PICK = 1						--ʰȡ����ص�

EVENT_ENGINE_RESIZE	   =102				--resize�¼�

-- EVENT_ENGINE_BASE_UPDATE	 =  102		--base�����¼�
EVENT_ENGINE_SPRITE_CLICK = 104
EVENT_ENGINE_SPRITE_CLICK_DOWN = 105
EVENT_ENGINE_SPRITE_CLICK_MOVE = 106    --click move
-- EVENT_ENGINE_TEX_LOAD_COMPLETE = 108	--������ؽ���
EVENT_ENGINE_COMPLETE		   = 109	--����¼�

CUST_LUA_EVENT_SPRITE_FOCUS_CHANGE =110 --��lua�㷢�ͽ���仯
CUST_LUA_EVENT_INPUT_CHANGE = 111		--input�������ݷ����仯

ENGINE_EVENT_COMPLETE = 1000;	--�����¼�

local event = {
	DISPLAY = 10001,--��ʾ
    UNDISPLAY = 10002,--����
    COMPLETE = 10003,--����¼�

    -- ---* ��ʱ��evtid=21
    -- ---* �ü�ʱ����C�ں˲�evt_dispatch�������¼�,����ֻ��Luaģ�����������.

}
--[[
@api ex_event
@apiGroup core
@apiDescription ��C�ں˵��¼�����


]]
local ex_event = {
	--- ʰȡ����ص�,���Lua���ɷ�
	--- data 0:x 1:y 2:z 3:distance  
	--- distance:�����������εĽ��� ���� �������ľ���
	LUA_EVENT_RAY_PICK = 1,

	---* ��ʱ��evtid=21
    ---* �ü�ʱ����C�ں˲�evt_dispatch�������¼�,����ֻ��Luaģ�����������.
	EVENT_TIMER = 201,

	---������Ⱦ�ص�,ÿһ֡����һ��
	EVENT_ENGINE_RENDER_3D =100,
	EVENT_ENGINE_KEYBOARD  =101,				--ȫ�ּ����¼�
	
	---�����¼�
	EVENT_ENGINE_COMPLETE		 =  103,	

	---����м������¼�
	MOUSE_MID_EVENT = 112,
	---����������
	MOUSE_LEFT_DOWN_EVENT = 113,

	---ˢ��cam
	EVENT_CAM_REFRESH = 114,

	EVENT_ENGINE_SPEC_KEYBOARD = 115,--��������¼�

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
---���ʽӿ�
local material = {}
core.meterial = material;

---Ϊ����p����m����
function material.set(p,m)
	setMaterial(p,m);
end

---Ϊ��������alpha͸����
function material.setAlpha(m,alpha)
	tmat_set_alpha(m,alpha);
    shader_updateVal(m,"mAlpha",alpha);
end

---���ö���ε���Ⱦģʽ
---@param m "Matereal"
---@param v "GL.GL_FILL,GL.GL_LINE,GL_POINT"
function material.setPolyMode(m,v)
	tmat_setPolyMode(m,v);
end

---���ñ����޳�
function material.setCullface(m,v)
	tmat_cullface(m,v);
end

---���ñ���״̬
function material.tmat_get_cullface(m)
	return tmat_get_cullface(m);
end

---����Material����Ⱦ״̬
---@param v "1:ȡ����Ⱦ,0������Ⱦ"
function material.disable(m,v)
	tmat_disable(m,v);
end
--����idת��Ϊ�¼���
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
---��ȡdrawCall����
function core.get_drawcall()
	return set_attr(FUNC_KEY.FUNC_GET_DRAW_CALL);
end

---��ȡ�����VBO������
function core.get_vert_cnt(p)
	return set_attr(FUNC_KEY.FUNC_GET_VERT_COUNT,p);
end

---��ǰ����ִ�е�ʱ��
function core.get_time()
	return set_attr(FUNC_KEY.FUNC_GET_TIME);
end
--return event;


--��ֵö��P

--��������
UI_TYPE = {
	Label = 1,
	Button =2,
	ScrollBar = 3,
	Panel = 4,
	Skin = 5,
	---6 ѡ�����
	CheckBox = 6,
	ProgressBar = 7,--������
	ListBox = 8,--�����б�
	Input = 9,--�������

	---10 image���
	Image = 10,

	---11 shape���
	Shape = 11,
	NScrollBar = 12,--���������
	NListBox = 13,--�б�
	NLabel = 14,--Label
	NPanel = 15,
	---16
	NButton = 16,
	Nfbo = 17,-- Fbo type
};


--�������ͻ�ȡ��������

--[[
@api 	funcgetNameByUIType
@apiPermission admin
@apiVersion 0.3.0
@apiParam {Number} t ����
@apiSuccess {string} name ��ȡ��������
@apiExample {lua} Example usage:
	func_getNameByUIType(UI_TYPE.Label);
	--����һ���ı�"Label"
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
require("xml")	--xml���
require("vec3")	--�Զ�����ѧ��
require("nstack");--��ջ

require("evt")	--�¼�������


--ת����һ����ַ
--"=table: 0082E758"  ===>8578904
local function getDddress(value)
	local len = string.len("table:  ")
	local a = string.len(tostring(value))
	local v = string.sub(tostring(value),len,a)
	local s = tonumber('0x'..v);
	return s;
end

--��"table: ff"ת��Ϊnumber
local function f_get_address(value)
	return getDddress(value);
end

---����һ������,local nameKey = -1;
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
	--ȡ��һ�������еĲ�������
	local node = xml:get_index(0);--xml_get_node_by_index(xml,0);
	local shader = xml_get_str(node,"shader");
	-- func_print("��������:"..url..':'..shader);
	local ps =  xml_get_str(node,"ps");
	
	if(shader == nil) then
		func_error("shader is nil,"..url);
	else			
		if(shader == "") then
			func_error(url);
		end
		
		local _material = tmat_create_empty(shader);

		--�����ͼ�����ʶ���	tex0~~tex7
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


	-- ����һ�����ü�������һ�����ݶ���
	-- url:
	-- 1.������һ��mat������
	-- "\\resource\\material\\wall.mat"

	-- 2.Ҳ�����Ǿ����������
	-- [[<mat shader="simple;vboDiffuse" tex0="\resource\texture\bump2.tga"/>]]

function func_load_material(url)
	local i = string.find(url,"<");
	-- print(a);
	local xml;
	local _material;
	if(i == nil) then
		-- urlΪ���ӵ�ʱ��
		xml = Xml:new();
		xml:load(url);
	elseif(i == 1)then
		-- urlΪ�������õ�ʱ��
		xml = Xml:new();
		xml:loadstr(url);
	end

	if(xml~=nil) then
		_material =	f_parse_mat_xml(xml);
		xml:dispose();
	end
	return _material;
end


--ɾ��table�����Ԫ��(�������еı�Ԫ������)
function func_clearTableItem(point)
	for k, v in pairs(point) do
		point[k] = nil
	end
	-- if(getmetatable(point)) then
	setmetatable(point,nil); --�������Ԫ������Ϊnil
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
---������ӡ��
function func_printTable(t)
	func_print(">>>>> start print table: "..tostring(t),0xff00ff)
	--print("start print table: "..tostring(t))
	local cnt = 0;
	func_print("value\t\t  key",0xff00ff);

	for key, value in pairs(t) do 
		--print('key=['..key..']'..'value['..value..']')
		local s = 'type:'..type(value)..'\t'..tostring(value)
		if(tonumber(value)) then
			
			--ת��Ϊ16��������
			s =  string.format("%#x",tonumber(value)).."\t("..value..")"
		end
		
		func_print(s.."\t\t"..tostring(key))
		
		cnt = cnt + 1;
	end 
	func_print(">>>>> end print table:   ["..tostring(t).."] cnt = "..cnt,0xff00ff)
end

---��ӡһ������ɫ����־������̨  
---s�ı� c��ɫ
function func_print(s,c)
	if(DEBUG == 1)then
		c = c or 0xffff00
		--c = c or 0;
		
		--�����̨�������ɫ���ı���־
		log_print(string.format("%c%c%c%clua: %s\n",0xa8,0x84,0xa8,0x84,s),c);
	end
end
---���������Ϣ
function func_warn(s)
	func_print(s,"0xff0000");
end
---�����쳣��ʱ����һ�����,���ߴ�ӡ��ջ
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
			
				--ȫ����ӡ
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
	-- 	print(debug.traceback());--��û�����������־��ʱ��,����̨Ĭ�������־.
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
	����sprite���������ڸ����������
--]]
function func_set_local_pos(p,x,y)
	local pos = x..","..y;
	change_attr(p,"sprite_set_self_pos",pos);
end

--[[
	��child��ӵ�parent��
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

--�ڴ����Cģ���
function func_gc()
	change_attr(nil,"gc");
	--print('gc')
end

--lua��GC
function func_lua_gc(key)
	local old =  collectgarbage("count");
	--func_print("==> GC֮ǰ LUA VMʹ�õ����ڴ���:"..(collectgarbage("count")*1024).." bytes");
	collectgarbage("collect");
	local n = collectgarbage("count");
	func_print((key or "").."GC��� LUA VMʹ�õ����ڴ���:"..n.."kb,gc��["..((old - n)*1024).."]bytes");
end

--Ϊsprite������ͼ
function func_setIcon(sprite,url)
	--��ȡһ��atalsͼ��,û��ͼ���Ľ����Ǻ�ɫ��
	local atals = core.atals;
	if(atals) then
		--sprite_bindAtals(sprite,atals);

		sprite_texName(sprite,atals,url);
	end
end

--��ȡsprite�Ŀ��
function func_get_sprite_size(o)
	return get_attr(o,"spriteSize")	
end

--����sprite�Ŀ��
function func_set_sprite_size(o,w,h)
	change_attr(o,"sprite_resize",string.format('%d,%d',w,h));
end

--��ȡ���ʰȡ��sprite�������
function func_get_sprite_mouse_xy(o)
	local x , y=get_attr(o,"spriteLocalXY");
	return x,y
end

--�����ļ�����һ���ַ���
function func_loadfile(url)
    return change_attr(nil,"loadfile",url);
end


--�ַ����ָ��table
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


--�൱��addchild
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
		func_error(string.format("type = %s do not imlment",tostring(_type)));	--δʵ��
	end
end

---����child�ĸ������
-- function set_parent(child,parent)
-- 	setmetatable(child, parent);
-- 	child.superClass = parent;
-- end

---ִ��obj����ķ���  
---obj��������  
---funcname������
core.super=function(obj,funcname,...)
	-- if(self.superClass) then
	--print("self����Ԫ��:",getmetatable(self),NLabel);
	
	local old_mtb = getmetatable(obj);--�������Ԫ���ȴ�����,֮��ָ���
	
	--print("getmetatable(NLabel)==Base",getmetatable(NLabel)==Base)
	-- 	print("new:",self.superClass);
		 
	-- end

	local p1 = getmetatable(obj);--��ȡ����obj(self)��Ԫ��
	if(p1 == nil) then
		func_error('p1 is nil');
		return;
	end
	
	local p2 = getmetatable(p1);--��ȡselfԪ���Ԫ��,��������
	if(p2 == nil) then
		func_error('p2 is nil');
		return;
	end

	setmetatable(obj,p2);

	obj[funcname](obj,...);

	setmetatable(obj,old_mtb);
end

--������Ⱦ���
require("NUnit");

--����ı任���
require("Transform");

require("base");
require("linenode");

require("label");--label�Ƕ�ftext���е�һ�η�װ

require("input");

require("cam");

require("fbo")	--fbo

require("shape")	--shape���
require("image")	--image���




require("UnitBase");		--��ɫ��λ
require("md5unit");		--md5����


local function f_time(data,o)
	if(o.c) then
		-- func_print(tostring(o.c)..' is call');
		o.c(o.p);
	end
	
	if(o._repeat == nil) then
		m.clearTimeout(o);--����setTimeout��ص���Դ
	end
end

---��ȡTabel�ĳ���,�����Tabel�е����м�ֵ����
---@param tb Tabel
function m.getLen(tb)
	local n = 0;
	for k, v in pairs(tb) do
		n = n + 1;
	end
	return n;
end
---������ɫ������
function m.p3d_create(vs,ps)
	return progrom3d(0,vs,ps);
end
---ɾ����ɫ������
function m.p3d_del(p)
	progrom3d(1,p);
end
---Ϊ���ʶ���������ɫ������
function m.p3d_set(mat,p)
	progrom3d(2,mat,p);
end
---@param ms �ӳ�ms����ִ��callback
---@param repeat1 "if repeat1 is true,function will be repeate running every frame."
---repeat1 true��ʶ�ظ� Ĭ�ϲ��ظ�
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

---���ص�ǰ��FPS  
---radix(Ĭ��1) 0:ȥС���� 1:����1λ 2:����2λ  
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
		return;--���Ѿ������
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

---��ȡ��ǰ��������ʱ��
function m.now()
	return get_attr(nil,"get_longTime");
end
---���������Ϣ
---@param str string
function m.warning(str)
	str = string.format("warning >>>>>>>>>>>>>>> [%s] %s",str or "",debug.traceback());
	if(DEBUG == 1) then
		func_print(str,0xff00ff);
	else
		print(str);
	end
end

---ptr tabel�е�����ת��Ϊnumber���,number is like (Node Sprite...)
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
			func_error("δʵ�ָ�table��ת��!");
		end
	end

	if(type(ptr) ~= "number") then
		func_error("type(ptr) = "..type(ptr)..",type of ptr must be number!");
	end
	
	return ptr;
end

---���һ����Ⱦ�ڵ㵽��Ⱦ�б�
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
---@param r ��Ⱦ�б�list
---@param p "��Ⱦ�ڵ�LineNode,UnitBase"
function m.add(p,r)
	local _type = type(p);
	
	if(_type == "table") then
		--print(r or core.renderlist,f_get_ptr(p),1);
		local _list = r;
		--or core.renderlist;--�������ĸ���Ⱦ�б�

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

---����Ⱦ�б����Ƴ�һ���ڵ�
---```
---   core.del(n);--�ڶ���dispose֮ǰ����Ⱦ�б���ɾ��
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

--�Ƴ�ģ��,����е�ģ����Ҫ���¼��صĳ�ʼ����,����ʹ�øýӿ�
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
---�Ƿ���debugģʽ
function m.debug(v)
	if(v == true or v == 1)then
		DEBUG=1;
		--log_enable(1);
	elseif(v == false or v == 0)then
		DEBUG=0;
		--log_enable(0);
	end
	func_print(string.format("������debug����״̬:%s",v));
end;
---��ȡģ�͵�����
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

--����ÿһ֡��Ҫ�ļ��ʱ��
local function setDelayMs(ms)
    change_attr(nil,"custDelayMs",ms);
end
---����FPS
---@param v frame percent second
function m.setFps(v)
	func_print(string.format("����fps=%d",v));
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

��������ı���ɫ	<br>
r g bֵ��0~1֮��	<br>

@apiParam {number} r Red Color
@apiExample {lua} Example usage:
	setBackgroundColor(0,0,1);--���ñ���Ϊ��ɫ

@apiExample {c} Example usage:
	setBackgroundColor(0,0,10);
]]
---��������ı���ɫ
function m.setBackgroundColor(r,g,b)
    change_attr(nil,"setBgColor",string.format("%s,%s,%s",r or 0,g or 0,b or 0));
	func_print(string.format("���ñ���ɫ%s %s %s",r,g,b));
end

---�˳�����
function m.exit()
	change_attr(nil,"exit");
end
---ÿһ֡����ĺ���
function m.delayTime()
	return get_attr(nil,"delayTime");
end

---������������
function m.rename(o,value)
	change_attr(o,"rename",tostring(value));
end

---��ȡ��Ļ�ĳߴ�
function m.screen_size()
	return get_attr(nil,"screenSize");
end

---��������ȡ����
function m.find_name(name)
	return find_name(name);
end

---����һ����Դ,ֻ�Ǽ���,��������ص���Ⱦ�б�
---Ĭ�϶��Ǽ���vbo���͵�����
function m.load(url,name)
	name = name or m.getName();
	local o = change_attr(nil,"ex_loadVBO",name,url);
	func_print('����VBO:'..url);
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

---ΪTabel�������ַ
---@param o Tabel
function m.bindAddress(o)
	o.address=f_get_address(o);
end

---@type PluginMan

---��ӡ��Ϣ
function m.print_info()
	get_attr(nil,"ex_info");
	core.texCache:info();
end
---��ȡ���xMouse,yMouse,midDirection
function m.get_mouse_status()
	return get_mouse_status();
end
--------------------------------------------------------------
m.ex_event = ex_event;
m.EVENT = event;--require("event");

---@type Camera
m.cam = nil;--��ǰ����ͼcamera
---@type Camera
-- m.cam2d = nil;
m.texCache = nil;
---����Ĭ�ϵ���Ⱦ�б�
m.renderlist = nil;
m.atals = nil;
---����������
m.engine = nil;
---��ȡ����������ľ��
---@type PluginMan
m.plugin = nil;
---��Ҫ���µ��б�
m.frameUpdateList = {};


---@type NStack
local _calllist;
---@type NStack
local _tempList;

--				���������
--������ظ������ò��,����fpsView���ֹ���ʽС����
--����һ�ּ�����ɢ��ϵ�ģʽ,������ʹ�ÿ�ܲ��㹻С��,
--��չ���ܶ����������ģʽ,�Ƚ��ʺ����󾭳������䶯�����,
--���ǿ��Խ����ֶ��Ĳ��ַ�װ��һ��������й���ʽ��Ӧ��
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

---����ͼ��url.xml url.tga
function atals_load_file(url)
	local arr =f_split(url,"//");
	local cnt = #arr;
	local p1 = "";
	for n = 1, #arr-1 do 
		p1 = p1..arr[n].."//";
	end 
	return atals_load(p1,arr[cnt]);
end

---��ʼ��
--- @param atals_url ��ͼ��
---game_init("//resource//texture//1");
function core.init(atals_url)
	if(core.engine)then
		func_warn("warning,engine is already initialise!!!");
		return;
	end
	core.debug(1);
	--����һ��ͼ��
    -- core.atals = atals_load("//resource//texture//","1");
	if(atals_url == nil) then
		func_error("there no default atals!");--û������Ĭ��ͼ����Դ
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

	local tex = tc:get_tex(atals,icon);--��texCache�������б��л�ȡ
	if(tex == 0) then
		--��ͼ���д���һ����������,������,������������map���ȡ
		tex = atals_new_tex(atals,icon);
	end
	tc:add_tex(atals,icon,tex);
	return tex;
end
function func_del_tex_cache(tex)
	local cnt =  core.texCache:delTex(tex);
	return cnt;
end

---��ǰ����Ϸ֡
function core.getframe()
	return getframe() or 0;
end
---�ڴ����δʹ�õ��ֽ���,�ܵ��ֽ���
function core.memory_info()
	local disableBytes,totalBytes = memory_info();
	return disableBytes,totalBytes;
end

---��ȡ�������3d��������߽�������͸�3d����ľ��ֵ
function core.get_hit()
	-- local ptr,x,y,z,dis = get_hit();
	-- x = math.floor(x * 100)/100;
	-- y = math.floor(y * 100)/100;
	-- z = math.floor(z * 100)/100;
	-- dis = math.floor(dis * 100)/100;
	-- return ptr,x,y,z,dis;
	func_error("has not actualize!");--δʵ��
end

---��һִ֡��,�ڵ�n֡���callLater�ص�֮��  
---����n+1֡ʱ���߻ص�func����
function core.callLater(func,param)
	-- func_print('callLater:'..tostring(func));
	-- core.setTimeout(1,func,param);
	local obj = {
		func = func,
		param = param,

		---��ǰ�Ĺؼ�֡
		frame = 0,
	};
	obj.frame = core.getframe();
	_calllist:push(obj);
	-- stack_push(_calllist,obj);
end
---��ȡ��׺
function m.get_suffix(url)
	local arr = f_split(url,"//");
	local str = arr[table.getn(arr)];
	local a = f_split(str,".");
	return a[table.getn(a)];
end

---time��
---����day,hour,minutes,seconds;
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
---��ӡTabel����
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
	func_error("δʵ�ֽӿ�load_model");
end

---@param n nNum�����nλС��
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

---�ϴ�shader����
function core.shaderUpdateParam(m,...)
	local arr = {...};
	local n = #arr;
	for i = 1,n,2 do
		shader_updateVal(m,arr[i],arr[i+1]);
	end
end
