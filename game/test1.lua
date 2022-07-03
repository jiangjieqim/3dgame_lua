-- package.cpath = package.cpath .. ";c:/Users/TR/.vscode/extensions/tangzx.emmylua-0.3.49/debugger/emmy/windows/x86/?.dll"

local function debugEmmy()
    package.cpath = package.cpath .. ";"..getenv().."/emmy/emmy_core.dll";
    dbg = require("emmy_core");

    -- print(dbg);--[EMMY]lua version: 51
    dbg.tcpListen("localhost", 9966);
    -- dbg.waitIDE();--等待EmmyLua New Debug???动执行ide
end

-- debugEmmy();

------------------------------------------------------
require("core");
require("ui")
local core = core;

core.init("//resource//texture//1"); 

local cam = core.cam;

require("lightpanel");

require("BauulAvatar");
require("Npc");
require("FloorMouse");

require("QuatDev");
--print(string.format("version = [%s]",_VERSION));

require("utils/kittools");


local camx = 0;
local camy = -20;
local camz = -20;

local floorMouse = FloorMouse:new();
---渲染地板
-- shader_updateVal(_mater,"lx",0.0);


-- require("outlineball");

local function addShowPlane()
    local ps = [[
        #version 110
        uniform sampler2D texture1;//界面贴图
        varying vec2 out_texcoord;
        void main(void){
            // float uvSacle = 20.0;//纹理缩放
            //vec2 texcoord = vec2(out_texcoord.x * _mUvScale,out_texcoord.y * _mUvScale);
            vec4 finalColor=texture2D(texture1, out_texcoord);
            
            
            //finalColor = texture2D(texture1, mod(out_texcoord, vec2(3.0, 9.0)) * vec2(0.75, 0.5625));

            if(finalColor.r == 1.0 && finalColor.g == 0.0 && finalColor.b == 1.0){
                discard;//丢弃紫色的像素
            }
            gl_FragColor = finalColor;
        }
    ]];

    local vs=[[
        #version 110
        attribute vec3 _Position;
        attribute vec2 _TexCoord;
        varying vec2 out_texcoord;
        uniform mat4 _mat1;
        uniform float _mUvScale;
        void main(){
            _mUvScale;
            out_texcoord =vec2(_TexCoord.x * _mUvScale,_TexCoord.y*_mUvScale);
            // out_texcoord.x = out_texcoord.x/2;
            // out_texcoord.y = out_texcoord.y/2;

            gl_Position = _mat1*vec4(_Position, 1.0);
        }
    ]];
    local p = core.p3d_create(vs,ps);
    
    local _mater = tmat_create_empty();
    core.p3d_set(_mater,p);
    shader_updateVal(_mater,"_mUvScale",20);
    tmat_pushTexUrl(_mater,"\\resource\\texture\\box.tga");
    local floor = UnitBase:new();
    floor:loadvbo("\\resource\\obj\\plane.obj",_mater,100);
    floor:set_position(0,-1,0);
    -- _plane:double_face();
    floor:reverse_face();
    core.add(floor);
    return floor;
end

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
---cam中键缩放
function Main:camControl(avatar)
    -- cam:setParent(avatar);
    local function f_onMouseChange(data)
        local x,y,z = cam:get_pos();
        local speed = 4;
        local tx = y+data*speed
        local tz = z+data*speed;

        if(tx >= -5 or tx <= -40) then
            return;

        end
        
        cam:set_pos(0,tx,tz);
        -- if(data == -1) then
            
        -- else

        -- end
    end

    evt_on(core.engine,core.ex_event.MOUSE_MID_EVENT,f_onMouseChange);
end

function Main:init()
    

    --添加一个FPS显示

    -- local fps = require("view/FpsView");
    -- fps:show(nil,nil,nil,"FPS:%s");

    core.setFps(30);
    --############################################################
    -- local box = UnitBase:new();
    -- box:loadvbo("\\resource\\obj\\teapot.obj","\\resource\\material\\bauul2.mat");
    -- core.meterial.setPolyMode(box:getMaterial(),GL.GL_LINE);
    -- core.meterial.setCullface(box:getMaterial(),GL.CULL_FACE_DISABLE);
    -- core.add(box);
    local box = BauulAvatar:new();
    box:init({res=BauulAvatar.Res.Teapot,x=3,z=0,y=0,scale=2.0});
    box:setColor(1);
    -- print("box.p",box.p,tostring(box));

    local avatar= BauulAvatar:new();
    avatar:init({res=BauulAvatar.Res.Bauul,scale=0.1});
    -- print("box.p",box.p,tostring(box));
    -- self:camControl(avatar);
    -- cam:setParent(avatar);

    print("avatar name:",tostring(avatar:get_name()));
    cam:setTarget(avatar);

    local monster = BauulAvatar:new();
    -- monster:init({res=BauulAvatar.Res.Gobin,scale=0.1});
    monster:init({res=BauulAvatar.Res.Box});
    -- monster:init({res=BauulAvatar.Res.Bauul,scale=0.1});

    local npc =Npc:new();
    npc:init({res=BauulAvatar.Res.Bauul,scale=0.1,x=10,y=0,z=-10});
    npc:ai(avatar);

    


    -- move1();
    -- local a = false;
    core.frameloop(2000,function()
    --    a = not a;
    --    print(a); 
    --    if(a == true)then
        -- monster:move(-10,0,0,0,10);
    --    else
        -- monster:move(0,0,0,0,10);
    --    end 
        local px,py,pz = monster:get_pos();
        
        if(px == -20 and pz == 0) then
            monster:move(0,0,0,0,10);
        elseif(px == 0 and pz == 0) then
            monster:move(-20,0,0,0,10);
        -- elseif(px == 0 and pz == 0) then
            -- monster:move(-20,0,0,0,10);
        else 
            print("err!",px,py,pz);
        
        end
        -- print(">>>",core.get_time());
    end)







    --地板
    local _plane = UnitBase:new();
    _plane:loadvbo("\\resource\\obj\\plane.obj","\\resource\\material\\horse.mat",100);
    -- _plane:double_face();
    -- _plane:drawPloygonLine(true);
    _plane:load_collide("\\resource\\obj\\plane.obj");
    -- n:reverse_face(true);
    -- n:load_collide("\\resource\\obj\\plane.obj",true);
    -- n:bindRayPick(f_bindRayClick);
    core.add(_plane);


    
    
    local showMap=addShowPlane();

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
            avatar:move(x,y,z,0,10);
            local sx,sy,sz = showMap:get_pos();
            local cy = (y - sy)/2;
            floorMouse:set_position(x,y-cy,z);
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
    
    ScrollViewCase1(550,30);

    local namemap = nskin.namemap;

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
        local fps = core.getFps();
        if(avatar) then
            local px,py,pz = avatar:get_pos();
            local xMouse,yMouse,midDirection =  core.get_mouse_status();

            s1 = string.format("avatarPos %.2f,%.2f,%.2f mouse  %.2f,%.2f,%.2f",px,py,pz,xMouse,yMouse,midDirection);
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

        if(monster)then
            if(monster:isMoving()) then
                monster:setStatus(BauulAvatar.EStatus.Run);
            else
                monster:setStatus(BauulAvatar.EStatus.Stand);
            end
        end

        -- print();
        label1:set_text(">"..string.format("fps:%scamPos %.2f,%.2f,%.2f camRotate %.2f,%.2f,%.2f %s",fps,
                        x,y,z,rx,ry,rz,s1));
        -- cam:refresh();
    end


    -- 
    core.frameloop(16.6,frenderUi);
    -- local eg = self:quat();
    -- local floorMat = floorMouse:getMaterial();
    local _mUvScale = 1;
    local function scHandler(v)
        -- print(v);
        _mUvScale = v;
        shader_updateVal(showMap:getMaterial(),"_mUvScale",20+_mUvScale*10);
    end
    -- print("aa:",vec3_between(0,1,0  ,0,-0.6,1));
    --求两个向量的叉乘
    --切割向量
    local qua = quatDev(0,1,0,0,0,1);
    -- local qua = QuatDev:new(0,0,1,0,1,0);

    -- qua:print();6


    local namemap = nskin.namemap;

    local sc=namemap['sc1'];
    sc:bindCallback(scHandler);

    -- local function frender3()
    --     cam:refresh();
    -- end
    -- core.frameloop(100,frender3);


    local curTheta = 0;
    -- local function bkey(key) 
    --     print("***********"..key);
    --     if(key == core.KeyEvent.KEY_Q) then
    --         -- p1 = p1 +  math.pi/8;
    --         -- cam:rz(p1);
    --         -- cam:refresh();

    --     elseif(key == core.KeyEvent.KEY_W) then
    --         -- p1 = p1 -  math.pi/8;
    --         -- cam:rz(p1);
    --     end
    -- end

    cam:set_rotate(-math.pi/4,0,0);
    cam:set_pos(camx,camy,camz);
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
    local function onLookAtEvt()

        curTheta = curTheta +speed;
        update();
    end
    core.frameloop(1000/20,onLookAtEvt);

    core.callLater(function ()
        print('delay:',core.delayTime()); 
        
    end)

    kit.keyLis(nil,speckey);
    
    require("outlinetest");
    require("toontest");
    require("fboviewTest");
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
