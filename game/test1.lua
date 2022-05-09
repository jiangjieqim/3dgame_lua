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

require("BauulAvatar");
--print(string.format("version = [%s]",_VERSION));


require("utils/kittools");
----------------------------------------------------------------------
local Main = {

}
Main.__index = Main;
function Main:new()
    local obj = {
        
    };
    setmetatable(obj, Main);

    -- obj.name = "This is myName";
    -- local mt = {init=obj.init,name = obj.name};
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
    --场景�??间添加一个box
    local box = UnitBase:new();
    box:loadvbo("\\resource\\obj\\box.obj","\\resource\\material\\bauul2.mat");
    core.meterial.setPolyMode(box:getMaterial(),GL.GL_LINE);
    core.meterial.setCullface(box:getMaterial(),GL.CULL_FACE_DISABLE);
    core.add(box);

    local v = 0;
    local p1;
    -- local p2 = 1;
    local function frender2()
        --旋转
        v=v + core.delayTime()/2048;
        box:rotate_vec(v,0,1,0);
        -- print(v);
        if(v >= 8) then
            core.clearTimeout(p1);
        end
    end
    -- 
    p1 = core.frameloop(1,frender2);
    --############################################################


    -- core.cam:rx(math.pi/2);
    -- local n = UnitBase:new();
    -- n:loadvbo("\\resource\\md2\\bauul.md2","\\resource\\material\\bauul.mat");
    -- core.add(n);

    --horse  ?

    local _plane = UnitBase:new();
    _plane:loadvbo("\\resource\\obj\\plane.obj","\\resource\\material\\horse.mat",100);
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

    core.cam:set_pos(0,-31.5,-41);
    core.cam:set_rotate(-math.pi/8,0,0);

    local avatar = BauulAvatar:new();
    
    local function onTouchClick(data)
        -- dbg.breakHere();
        -- p2 = p2*-1;
        -- print("dasdahdjkashkj");

        if(avatar:p_isNil())then
            print("avatar is not initialized!");
            return;
        end

        local x = data[0];
        local y = data[1];
        local z = data[2];
        local distance = data[3];
    --    print(x,y,z);
        
        if(avatar) then
            avatar:move(x,y,z,0,10);
            -- core.cam:set_pos(0-x,-31.5-y,-41-z);
            
            -- core.setTimeout(1000,function ()
            --     core.cam:refresh();
            --     end)
        end

        -- dbg.waitIDE();


        -- curR = curR + math.pi/4;
        -- avatar:rx(curR);
        -- print(curR);
        --print("aaaaaaaaaa!!!!!");
    end

    evt_on(_plane:get_p(),core.ex_event.LUA_EVENT_RAY_PICK,onTouchClick);




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
        local x,y,z = core.cam:get_rotate();
        print(math.random().." fps:"..core.get_fps()..core.get_drawcall()..">"..string.format("%s,%s,%s",x,y,z));
        
    end);
    -- func_printTable(core);

    local function frenderUi()
        local x,y,z = core.cam:get_pos();
        local rx,ry,rz = core.cam:get_rotate();
        local s1 = "";
        local fps = core.get_fps();
        if(avatar) then
            local px,py,pz = avatar:get_pos();
            s1 = string.format("avatarPos %.2f,%.2f,%.2f",px,py,pz);
            -- core.cam:set_pos(0-px,-31.5-py,-41-pz);
        -- core.setTimeout(1000,function ()
        --     core.cam:refresh();
        -- end)
            -- setv(avatar.p,FLAGS_BASE_IS_MOVEING);
            -- print(avatar.p);
            -- print(avatar:is_moving());
            -- print(avatar:isMoving());
            if(avatar:isMoving()) then
                core.cam:refresh();
                -- print("update...");
                avatar:setStatus(BauulAvatar.EStatus.Run);
            else
                avatar:setStatus(BauulAvatar.EStatus.Stand);
            end
        end

        -- print();
        label1:set_text(">"..string.format("fps:%s camPos %.2f,%.2f,%.2f camRotate %.2f,%.2f,%.2f %s",fps,
                        x,y,z,rx,ry,rz,s1));
        -- core.cam:refresh();

    end
    -- 
    core.frameloop(16.6,frenderUi);


    -- local function frender3()
    --     core.cam:refresh();
    -- end
    -- core.frameloop(100,frender3);

    local p1 = 0;
    local function bkey(key) 
        print("***********"..key);
        if(key == core.KeyEvent.KEY_Q) then
            -- p1 = p1 +  math.pi/8;
            -- core.cam:rz(p1);
            -- core.cam:refresh();

        elseif(key == core.KeyEvent.KEY_W) then
            -- p1 = p1 -  math.pi/8;
            -- core.cam:rz(p1);
        end
    end
    local function speckey(key)
        print("speckey",key);
        if(key == core.KeyEvent.GLUT_KEY_LEFT) then

        elseif(key == core.KeyEvent.GLUT_KEY_RIGHT) then

        end
    end
    kit.keyLis(bkey,speckey);
end

local main = Main:new();
main:init();
