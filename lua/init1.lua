local env = getenv();
local fold = env;--"c:\\gl_3dgame_sub_0524";
--[[
package.cpath = package.cpath .. ";c:/Users/Administrator.B124KVZ6GK0IWF6/.vscode/extensions/tangzx.emmylua-0.3.49/debugger/emmy/windows/x86/?.dll"
dbg = require("emmy_core");
dbg.tcpListen("localhost", 9966);
--]]

--dbg.waitIDE() --��Unityͣ�����ȴ�Idea��������
--dbg.breakHere() --Ӳ�ϵ㣬ǿ�Ƶȴ�

print(string.format("version = [%s]",_VERSION));

package.path=";"..fold.."\\lua\\?.lua";--��������?


--����ҵ��ģ��
package.path=package.path..";"..fold.."\\lua\\src\\?.lua";
print('package.path = '..package.path);


local core = require("core");
core.debug(1);


-- local LineBox = require("linebox");

-- core.game_init();
local plug = core.plugin;

-- local color = {a = "aa",b = "nn"}
-- print("######################",table.getn(color),core.getLen(color));

core.setBackgroundColor(0.4,0.4,0.4);
require("editor");
require("view/mapeditor");


local function loadAvatarView()
	local obj = {
		url="\\resource\\md2\\triangle.md2",--bauul,triangle
		mat = "//resource//material//bauul.mat",
		scale = 1,
		-- scale = 0.003,
		x = 0,
		y = 0,
		z = -0.15,
	};

	plug:toggle("view/AvatarView",0,obj);
end

---@type Button
local btn;

local btns = {};
local cnt = 0;
function f_onkey(data)
	local key = tonumber(data);
	
	if(key == KEY_VALUE.KEY_ESC) then
        core.exit();
	elseif(key == 13) then
		--�س�
		-- print("delayMs = "..core.delayTime());
		core.print_info();
		
	elseif(key == 49) then
		--1
		loadAvatarView();
	elseif(key == 50) then
		--2
		---@type FlyLabel
		local label = plug:load("view/FlyLabel");
		local sx,sy = core.screen_size();
		-- print(sx,sy);
		label:set_label(math.random(),1000,sy*0.25);

	elseif(key == 51) then
		--3
		plug:toggle("view/SettingView");

	elseif(key == 52) then
		--4
		-- func_lua_gc("4_1");
	end
end

local function init()
	--print(core.now());
	--print(cam);
	core.setBackgroundColor(0.3,0.3,0.3);
	

	local e1 = Editor:new();
	core.cam:set_pos(0,-1,-5.5);

	-- evt_on(nil,core.ex_event.EVENT_ENGINE_KEYBOARD,f_onkey);
end

local function f_bindRayClick(p)
	local ptr,x,y,z = core.get_hit();--��ȡ���ߵĽ�������
	func_print(string.format('##### you call function: f_bindRayClick:%.3f %.3f %.3f',x,y,z));
	-- line:mod(1,x,y,z);
	
	-- --self.u:move(x,y,z);
	-- self.u:look_at(x,y,z,0);
end
local function load_md2()
	-- local data = {
	-- 	url="\\resource\\md2\\bauul.md2",--	triangle	bauul
	-- 	url="\\resource\\md2\\triangle.md2",--	triangle	bauul
	-- 	-- mat = "//resource//material//bauul.mat",
	-- }	
	local cam = core.cam:get_p();

	local url = "\\resource\\md2\\bauul.md2";
	local mat = "//resource//material//bauul.mat";
	local m = UnitBase:new();
	m:loadvbo(url,mat,cam);
	
	-- m:scale(0.003);
	-- m:scale(0.1);
	m:set_position(0,0,-2.5);
	-- m:load_collide("\\resource\\obj\\box.obj",true);
	m:load_collide('\\resource\\md2\\triangle.md2',true);
	m:bindRayPick(f_bindRayClick);
	---@type Animator

	-- local anim = m:get_anim();
	-- anim:push("jump",66,71);
	-- anim:play("jump");
	-- m:anim_push("jump",66,71);
	-- m:anim_play("jump");

	return m;
end




--teapot,box,torus

-- print(core.find_name(uboot:get_name()));

-- print(core.get_type_str(uboot.p));



-- print(cam:get_pos());
evt_on(0,core.ex_event.EVENT_ENGINE_KEYBOARD,f_onkey);

-- example_input();



-- -@type NUnit
-- local n = NUnit:new();
-- n:





-- ---@type Md5Unit

-- local md5 = Md5Unit:new();
-- md5:load();
-- core.cam:set_pos(0,0,-90);



local function f_showFBO(w,h)
	local url="\\resource\\md2\\triangle.md2";--bauul,triangle
	local mat = "//resource//material//bauul.mat";
    local fbo = FboRender:new(w,h);
	fbo:mouseEnable(true);
	local cam = fbo:get_cam3d();
	local cam2d = fbo:get_cam2d();


	


	local _model = UnitBase:new();
	_model:loadvbo(url,mat,cam);
	_model:scale(1.0);
	_model:set_position(0,0,-2.5);
	local sw,sh = core.screen_size();
	fbo:set_pos(128,0);--sw/4 (sh-h)/2
	_model:load_collide('\\resource\\obj\\box.obj',true);
end
local function func1()
	local url="\\resource\\obj\\torus.obj";--bauul,triangle
	local mat = "//resource//material//bauul.mat";
	local _model = UnitBase:new();
	_model:loadvbo(url,mat);
	_model:scale(0.5);
	_model:set_position(0,0,-2.5);
	
	_model:load_collide(url,true);--'\\resource\\obj\\box.obj'
end
-- f_showFBO(256,128);
-- func1();




-- _shape:setcolor();

-- f_showfps();
-- load_md2();

-- loadAvatarView();

-- init();

-- -- func_printTable(core);

-- local time = core.now();
-- local uboot = UnitBase:new();
-- uboot:loadvbo("\\resource\\obj\\torus.obj", "//resource//material//bauul.mat");
-- uboot:scale(0.5);
-- uboot:set_position(0,1,0);
-- func_print(string.format('���� %d ����',core.now() - time));



-- local _mapEditor = MapEditor:new();
-- _mapEditor:load();

-- local obj = MapEditor:LoadModel();

-- core.add(obj);

-- core.del(obj);
-- obj:dispose();

--�����߶�
local e1 = Editor:new();
e1:createLine();
e1:createAxis();
e1:showfps();
-- e1:dispose();





-- ScrollViewCase1();


-- local btn = Button:new();
-- btn:dispose();

core.cam:set_pos(0,-1,-5.5);

-- plug:toggle("view/SettingView");


-- func_print("a");

-- local timer = timelater_new(10);
-- evt_on(timer,core.ex_event.TIMER,function (data)
-- 	-- print('en***',data);
-- 	timelater_remove(timer);
-- end);



-- local fps = plug:load("view/FpsView");
-- fps:show();

