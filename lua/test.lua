---打印所有的表
function func()
    -- body
    local tablePrinted = {}
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
    printTableItem("_G", _G, 0);
end

-- package.path=";"..getenv().."\\lua\\?.lua"
-- require("core");


-- print(gcinfo());gcinfo() - 返回使用中插件内存的占用量(kb)以及当前垃圾收集器的使用量(kB).




----[[
-- print(">>>"..package.path);
--获取进程的执行路径

local env = getenv();
local fold = env; 
print(string.format("version = [%s]",_VERSION));
package.path=";"..fold.."\\lua\\?.lua"
package.path=package.path..";"..fold.."\\lua\\src\\?.lua";
--print('package.path = '..package.path);


local core = require("core");



core.debug(1);



-- local btn = Button:new();
-- btn:dispose();
-- btn:visible(false);

-- local label = NLabel:new();
-- label:set_text("hello");
-- label:set_pos(250,0);


 ---@type NLabel
-- local label = NLabel:new(128,128);
-- -- print('BaseClass:',Base,'NLabel',NLabel);
-- -- print('label =',label);
-- label:set_text(math.random());
-- label:dispose();

-- print(core.time2str(463616));


---]]

local cam = 0;

local p1 = UnitBase:new();

-- print(p1);
--,'\\resource\\obj\\plane.obj'
-- p1:loadvbo("\\resource\\md2\\bauul.md2","//resource//material//bauul.mat",cam);
-- core:add(p1,core.renderlist);

p1:loadvbo("\\resource\\obj\\plane.obj","//resource//material//horse.mat");
-- p1:cullFace(true);
-- p1:reverse_face(false);
core.add(p1);
p1:scale(100);

----[[
local anim = true;
local n;
if(anim == true) then
    n = UnitBase:new();
    n:loadvbo("\\resource\\md2\\bauul.md2",
        "//resource//material//bauul.mat",cam);
    n:scale(0.1);
    -- n:set_position(0,0,-0.5);
    core.add(n);
    ---@type Animator
    local anim = n:get_anim();
    anim:push("stand",0,39);
    anim:push("jump",66,71);
	anim:play("stand");
    n:load_collide('\\resource\\obj\\box.obj',true,15.0);
    -- print(anim:total());
  

else
    n = UnitBase:new();
    n:loadvbo("\\resource\\md2\\triangle.md2","//resource//material//bauul.mat",cam);
    -- n:set_position(0,0,-0.5);
    n:load_collide('\\resource\\obj\\box.obj',true);
    core.add(n);--,fbo:get_list()
end

--]]
local v = 0;
core.setTimeout(1,function ()
    v = v - math.pi/90;
    n:rotate_vec(v,0,1,0);
end,nil,true);


--[[
local fbo = FboRender:new(128,128);
local cam = fbo:get_cam3d();
fbo:set_pos(10,30);
]]

-- core.cam:set_pos(0,-1,-5.5);

-- local s = core.ui.Shape:new();
-- s:set_pos(50,50);
-- s:setcolor(1,0,0);

core.setfps(15);

-- core.setTimeout(1,function  ()
--     -- print(math.random());
--     print(core.delayTime());
-- end,nil,true);

-- local sharp = 


-- func();


local DebugView = require("view/DebugView");
local panel = DebugView:new();
core.cam:set_pos(0,-20,-20);
core.cam:rx(-math.pi /4);
