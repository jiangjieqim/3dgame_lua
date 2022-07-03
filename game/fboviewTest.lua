require("core");
require("ui");
require("BauulAvatar");
require("utils/kittools");
local core = core;
core.init("//resource//texture//1");

kit.keyLis();

local function createModel(renderlist)
--    local _model = UnitBase:new();
    local _model = BauulAvatar:new();
    _model:init({res=BauulAvatar.Res.Bauul,scale=0.1,renderlist=renderlist,x=0,y=0,z=-10});

    -- _model:loadvbo("\\resource\\md2\\bauul.md2","\\resource\\material\\bauul.mat",0.05);
    -- _model:loadvbo("\\resource\\obj\\box.obj","\\resource\\material\\bauul.mat",1);
    -- _model:set_position(0,0,-10);
    -- _model:iAxis(math.pi/2,1,0,0);
    local anim = _model:get_anim();

    if(anim) then
        anim:push("stand",0,39);
        anim:push("run",40,45);
        anim:push("jump",66,71);
        anim:play("stand");
    end
    return _model;
end
function fboviewTest()
    local w = 256;
    local h = 256;

    local _model;

    local nskin = NSkin:new();
    nskin.f_callBack_r = function(v)
        _model:rotate_vec(v*math.pi,0,1,0);
    end
    nskin:load(
[[
<ui name="1" type="NPanel" drag="1" center="0" x="350" y="30" width="200" height="200" line="1"/>
<ui name="bg" type="Shape" x="20" y="0" w="128" h="128 r="0" g="0" b="0" line="0" parent="1"/>
<ui name="fbo1" type="Nfbo" x="20" y="0" w="128" h="128" parent="1"/>
<ui name="sc1" type="NScrollBar" x="20" y="130" parent="1" func="f_callBack_r"/>
]]
-- <ui name="bg" type="Shape" x="20" y="0" w="128" h="128" r="0" g="0" b="0" line="1" parent="1"/>
-- <ui name="bg" type="Shape" x="20" y="0" w="128" h="128" r="0" g="0" b="0" line="0" parent="1"/>
-- <ui name="bg" type="Shape" x="20" y="0" w="128" h="128" r="0" g="0" b="0" line="1" parent="1"/>
-- <ui name="rotate" type="NScrollBar" x="10" y="180" parent="1"/>
-- <ui name="tri2" type="NButton" x="0" y="200" parent="1" url="tri2.png" w="15" h="15" rotatez="3.14"/>
-- <ui name="tri3" type="NButton" x="20" y="200" parent="1" url="tri2.png" w="15" h="15"/>
-- <ui name="sc2" type="NScrollBar" x="20" y="160" parent="1" w="128" h="20"/>
-- <ui name="gray" type="6" x="0" y="180" label="gray" parent="1"/>
);
-- 
    local fbo1 = nskin.namemap["fbo1"];
    _model = createModel(fbo1.renderlist);
   
    -- _model:dispose();
    -- nskin:dispose();
    -- core.alert("asdsadhaAAs");
end

local function testui()
    local nskin = NSkin:new();
    nskin:load(
[[
<ui name="1" type="NPanel" drag="1" center="0" x="0" y="300" width="200" height="200" line="0"/>
]]);
-- <ui name="gray" type="0-" y="0" label="gray" func="f_callBack_gray" parent="1"/>
-- <ui name="sc2" type="NScrollBar" x="0" y="20" parent="1" w="128" h="20"/>
end

fboviewTest();
-- testui();