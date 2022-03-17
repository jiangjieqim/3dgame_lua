-- package.cpath = package.cpath .. ";c:/Users/TR/.vscode/extensions/tangzx.emmylua-0.3.49/debugger/emmy/windows/x86/?.dll"
package.cpath = package.cpath .. ";"..getenv().."/emmy/emmy_core.dll";
-- 'emmy/emmy_core.dll'

dbg = require("emmy_core");
print(dbg);--[EMMY]lua version: 51
dbg.tcpListen("localhost", 9966);  
-- dbg.waitIDE();


require("core");
require("utils/kittools");
kit.keyLis();


kit.showAxis(5);


-- core.cam:rx(math.pi/2);

-- local n = UnitBase:new();
-- n:loadvbo("\\resource\\md2\\bauul.md2","\\resource\\material\\bauul.mat");
-- core.add(n);

--horse  ?

local _plane = UnitBase:new();
_plane:loadvbo("\\resource\\obj\\plane.obj","\\resource\\material\\horse.mat",10);
-- core.meterial.setCullface(_plane:getMaterial(),GL.CULL_FACE_DISABLE);
_plane:load_collide("\\resource\\obj\\plane.obj",true);



-- n:reverse_face(true);
-- n:load_collide("\\resource\\obj\\plane.obj",true);
-- n:bindRayPick(f_bindRayClick);
core.add(_plane);
local v = 0;
local dir = Vec3:new(1,1,0);

local function frender()
    --旋转
    v=v + core.delayTime()/20480;
    --print(v);
    _plane:rotate_vec(v,dir.x,dir.y,dir.z);
    -- shader_updateVal(_mater,"base_matrix",n:base_matrix());
    -- updateMatirx();
end
-- core.setTimeout(1,frender,nil,true);
-- local DebugView = require("view/DebugView");
-- local panel = DebugView:new();

core.cam:set_pos(0,-4,-15);

local avatar = UnitBase:new();

-- avatar:loadvbo("\\resource\\md2\\bauul.md2","\\resource\\material\\bauul.mat",0.1); avatar:iAxis(math.pi/2,1,0,0);
-- --avatar:get_anim():pause();
-- local anim = avatar:get_anim();
-- anim:push("stand",0,39);
-- anim:push("run",40,45);
-- anim:push("jump",66,71);
avatar:loadvbo("\\resource\\md2\\triangle.md2","\\resource\\material\\bauul.mat",1.0); 
avatar:iAxis(math.pi/2,1,0,0);
local anim = avatar:get_anim();
print("total:"..anim:total());
anim:push("stand",1,4);
anim:play("stand");
-- anim:set_fps(3);

-- avatar:loadvbo("\\resource\\obj\\arrow.obj","\\resource\\material\\bauul.mat",2); 
core.meterial.setCullface(avatar:getMaterial(),GL.CULL_FACE_DISABLE);



-- print("total:",avatar:get_anim():total());
core.add(avatar);
-- print("get_pos:",avatar:get_pos());

local curR = 0;
local function onTouchClick(data)
    local x = data[0];
    local y = data[1];
    local z = data[2];
    local distance = data[3];
--    print(x,y,z);
    avatar:move(x,y,z,0,10);
    dbg.breakHere();
    -- dbg.waitIDE();


    -- curR = curR + math.pi/4;
    -- avatar:rx(curR);
    -- print(curR);
    print("aaaaaaaaaa!!!!!");
end

evt_on(_plane:get_p(),core.ex_event.LUA_EVENT_RAY_PICK,onTouchClick);