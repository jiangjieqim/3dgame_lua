-- package.cpath = package.cpath .. ";c:/Users/TR/.vscode/extensions/tangzx.emmylua-0.3.49/debugger/emmy/windows/x86/?.dll"

local function debugEmmy()
    package.cpath = package.cpath .. ";"..getenv().."/emmy/emmy_core.dll";
    dbg = require("emmy_core");

    -- print(dbg);--[EMMY]lua version: 51
    dbg.tcpListen("localhost", 9966);
    -- dbg.waitIDE();--等待EmmyLua New Debug�??动执行ide
end

-- debugEmmy();

------------------------------------------------------
require("core");
require("ui")
local core = core;

core.init("//resource//texture//1"); 

local cam = core.cam;

require("BauulAvatar");
require("QuatDev");
--print(string.format("version = [%s]",_VERSION));


require("utils/kittools");
----------------------------------------------------------------------
local Main = {

}
Main.__index = Main;
function Main:new()
    local obj = {
        box,
    };
    setmetatable(obj, Main);

    -- obj.name = "This is myName";
    -- local mt = {init=obj.init,name = obj.name};
    -- cam:set_pos(0,-31.5,-41);
    -- cam:set_rotate(-math.pi/8,0,0);

    
    return obj;
end

function Main:print()
    
end

function Main:init()
    
    kit.showAxis(5);

    --添加一个FPS显示

    -- local fps = require("view/FpsView");
    -- fps:show(nil,nil,nil,"FPS:%s");

    core.setfps(20);
    --############################################################
    -- local box = UnitBase:new();
    -- box:loadvbo("\\resource\\obj\\teapot.obj","\\resource\\material\\bauul2.mat");
    -- core.meterial.setPolyMode(box:getMaterial(),GL.GL_LINE);
    -- core.meterial.setCullface(box:getMaterial(),GL.CULL_FACE_DISABLE);
    -- core.add(box);
    local box = BauulAvatar:new();
    box:init(BauulAvatar.Res.Teapot,{x=3,z=0,y=0,scale=2.0})
    box:setColor(1);
    print("box.p",box.p,tostring(box));

    local avatar= BauulAvatar:new();
    avatar:init(BauulAvatar.Res.Box);
    print("box.p",box.p,tostring(box));
    cam:setTarget(box);


--[[
    local mat = "\\resource\\material\\shape.mat";
    local n = UnitBase:new();
    n:loadvbo("\\resource\\obj\\torus1.obj",mat);--teapot   torus
    print("n.p",n.p,tostring(n));
    local n1 = UnitBase:new();
    n1:loadvbo("\\resource\\obj\\torus1.obj",mat);--teapot   torus
    -- line = true;
    print("n1.p",n1.p,tostring(n1));
    print("n.p",n.p,tostring(n));
    core.add(n);
    core.add(n1);
]]

    -- self.box:setColor(1,0,0);
    -- local boxName = self.box:get_name();
    -- print("name:",boxName);-- 3茶壶

    -- local v = 0;
    -- local p1;
    -- -- local p2 = 1;
    -- local function frender2()
    --     --旋转
    --     v=v + core.delayTime()/2048;
    --     box:rotate_vec(v,0,1,0);
    --     -- print(v);
    --     if(v >= 8) then
    --         core.clearTimeout(p1);
    --     end
    -- end
    -- -- 
    -- p1 = core.frameloop(1,frender2);
    --############################################################


    -- cam:rx(math.pi/2);
    -- local n = UnitBase:new();
    -- n:loadvbo("\\resource\\md2\\bauul.md2","\\resource\\material\\bauul.mat");
    -- core.add(n);

   








    local _plane = UnitBase:new();
    _plane:loadvbo("\\resource\\obj\\plane.obj","\\resource\\material\\horse.mat",100);
    -- _plane:double_face();
    -- _plane:drawPloygonLine(true);
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

    

    -- local config = avatar:addRotateBox();
    
    -- box:setParent(avatar);
    -- cam:setParent(avatar);

    -- local target = BauulAvatar:new(BauulAvatar.Res.Box,{x=5,y=0,z=5});
    -- local name = target:get_name();
    -- print(name);

    local function onTouchClick(data)
        -- dbg.breakHere();
        -- p2 = p2*-1;
        -- print("dasdahdjkashkj");

        if(avatar~=nil and avatar:p_isNil())then
            print("avatar is not initialized!");
            return;
        end

        local x = data[0];
        local y = data[1];
        local z = data[2];
        local distance = data[3];
    --    print(x,y,z);
        
        if(avatar) then
            -- avatar:move(x,y,z,0,10);

            -- cam:set_pos(0-x,-31.5-y,-41-z);
            
            -- core.setTimeout(1000,function ()
            --     cam:refresh();
            --     end)
        end

        -- dbg.waitIDE();


        -- curR = curR + math.pi/4;
        -- avatar:rx(curR);
        -- print(curR);
        --print("aaaaaaaaaa!!!!!");
    end

   evt_on(_plane:get_p(),core.ex_event.LUA_EVENT_RAY_PICK,onTouchClick);


    -- self:addPlane();

    -- print("init");
    -- print(self['init']);
    -- print(self.name)
    -- self:print();
    local nskin = NSkin:new();
    nskin:load("\\resource\\ui\\crl.xml");
    local btn =nskin:find("infoBtn");
    local label1 =nskin:find("label1");
    btn:bind_click(function()
        -- print("fps:"..core.get_fps()..core.get_drawcall());
        -- local x,y,z = cam:get_rotate();
        -- print(math.random().." fps:"..core.get_fps()..core.get_drawcall()..">"..string.format("%s,%s,%s",x,y,z));
        
        -- if(_plane:is_visible()) then
            -- _plane:visible(false);
        -- else
            -- _plane:visible(true);
        -- end
        -- cam:refresh();


        
    end);
    -- func_printTable(core);

    local function frenderUi()
        local x,y,z = cam:get_pos();
        local rx,ry,rz = cam:get_rotate();
        local s1 = "";
        local fps = core.get_fps();
        if(avatar) then
            local px,py,pz = avatar:get_pos();
            s1 = string.format("avatarPos %.2f,%.2f,%.2f",px,py,pz);
            -- cam:set_pos(0-px,-31.5-py,-41-pz);
        -- core.setTimeout(1000,function ()
        --     cam:refresh();
        -- end)
            -- setv(avatar.p,FLAGS_BASE_IS_MOVEING);
            -- print(avatar.p);
            -- print(avatar:is_moving());
            -- print(avatar:isMoving());
            if(avatar:isMoving()) then
                cam:refresh();
                -- print("update...");
                avatar:setStatus(BauulAvatar.EStatus.Run);
            else
                avatar:setStatus(BauulAvatar.EStatus.Stand);
            end
        end

        -- print();
        label1:set_text(">"..string.format("fps:%scamPos %.2f,%.2f,%.2f camRotate %.2f,%.2f,%.2f %s",fps,
                        x,y,z,rx,ry,rz,s1));
        -- cam:refresh();
    end


    -- 
    core.frameloop(16.6,frenderUi);
    local eg = self:quat();
    local function scHandler(v)
        --print(v);
        -- v = v * 0.5;
        -- local x, y, z,w=self:quat_slerp(0,1,0,	 0,0,1, v);
        -- print(x, y, z,w);
        
        -- eg:mod(1,vec3_mult(x,y,z,20));

        -- cam:set_rotate(0,math.pi  * v * 2,0);
    end
    -- print("aa:",vec3_between(0,1,0  ,0,-0.6,1));
    --求两个向量的叉乘
    --切割向量
    local qua = quatDev(0,1,0,0,0,1);
    -- local qua = QuatDev:new(0,0,1,0,1,0);

    -- qua:print();6



    local sc=nskin:find('sc1');
    sc:bindCallback(scHandler);

    -- local function frender3()
    --     cam:refresh();
    -- end
    -- core.frameloop(100,frender3);


    local curTheta = 0;
    local function bkey(key) 
        print("***********"..key);
        if(key == core.KeyEvent.KEY_Q) then
            -- p1 = p1 +  math.pi/8;
            -- cam:rz(p1);
            -- cam:refresh();

        elseif(key == core.KeyEvent.KEY_W) then
            -- p1 = p1 -  math.pi/8;
            -- cam:rz(p1);
        end
    end

    cam:set_rotate(-math.pi/8,0,0);
    cam:set_pos(0,-40,-40);
    local speed = math.pi/180;
    local function update()
        local ax = 0;
        local ay = 1;
        local az = 0;
        local sx = 1;
        local sy = 0;
        local sz = 1;
        local x,y,z=vec3RotatePoint3d(curTheta,ax,ay,az,sx,sy,sz);            
        x,y,z = vec3_mult(x,y,z,5);

        -- x =  0 ;y = 0;z =0;
        -- x = math.sin(curTheta) * 5;
        -- y = x;



        -- -- y = y+5;
        -- -- cam:set_pos(0,-31.5,-41);
        -- cam:set_pos(x,y-10,z);
        
        box:set_position(x,0,z);

        -- -- local cx,cy,cz = avatar:get_pos();
        -- box:look_at(0,0,0);
        -- -- box:rz(math.pi/4);
        -- print(x,y,z,string.format("%.2f",box:get_angle()/math.pi));

        -- -math.pi/8
        -- cam:set_rotate(0,-box:get_angle(),0);
        --   x,y,z = vec3_mult(x,y,z,10);

        -- print(x,y,z);
        -- cam:set_pos(0,-31.5,-41);
        -- cam:set_pos(x,y-10,z);
        -- cam:set_rotate(-math.pi/8,0,0);
        cam:refresh();
    end
    local function speckey(key)
        -- print("speckey",key);
        
   
     

        if(key == core.KeyEvent.GLUT_KEY_LEFT) then
            curTheta = curTheta +speed;
            update();

        elseif(key == core.KeyEvent.GLUT_KEY_RIGHT) then
            curTheta = curTheta -speed;
            update();
        end
        
    end
    -- local function onLookAtEvt()
    --     curTheta = curTheta +speed;
    --     update();
    -- end
    -- core.frameloop(16.6,onLookAtEvt);


    kit.keyLis(bkey,speckey);
    
end

function Main:quat()
    local size = 20;
    -- 	--旋转的向量
	-- local tg = LineNode:new(2);
	-- tg:setcolor(0,1,0);
	-- tg:push(0,0,0);
	-- tg:push(0,size,0);
	-- tg:graphics_end();
    -- core.add(tg);

    --目标向量
	local eg = LineNode:new(2);
	eg:setcolor(0,1,1);
	eg:push(0,0,0);
	eg:push(0,size,0);
	eg:graphics_end();
    core.add(eg);
    return eg;
end

function Main:quat_slerp(x0, y0, z0, x1, y1,z1, v)
        local x2,y2,z2 =vec3_normal(x1,y1,z1);
        -- eg:mod(1,x2,y2,z2);
        
--		mid:mod(1,0.707,-0.707,0);
        -- local x3,y3,z3 = getMid(x0, y0, z0, x1, y1,z1);
        -- x3,y3,z3=vec3_normal(x3,y3,z3);
        
        -- mid:mod(1,x3,y3,z3);--设置重点的坐标
    return quat("Quat_slerp", x0, y0,z0, x1, y1,z1, v);
end
---地板
function Main:addPlane()
    local p = UnitBase:new();
    local scale = 100;
    p:loadvbo("\\resource\\obj\\plane.obj","\\resource\\material\\bauul2.mat",scale);
    p:set_position(0,-1,0);
    -- core.meterial.setPolyMode(box:getMaterial(),GL.GL_LINE);
    core.meterial.setCullface(p:getMaterial(),GL.CULL_FACE_DISABLE);
    core.add(p);
    -- cam:refresh();
end

local main = Main:new();
main:init();
-- main:quat();
