function fboviewTest()
    local w = 256;
    local h = 256;
    local fbo = FboRender:new(w,h);
    local nskin = NSkin:new();
    nskin:load(
        [[
<ui name="1" type="NPanel" drag="1" center="1" width="200" height="256"/>
<ui name="bg" type="Shape" x="20" y="0" w="128" h="128 r="0" g="0" b="0"  parent="1"/>

]]  

-- <ui name="rotate" type="NScrollBar" x="10" y="180" parent="1"/>
-- <ui name="tri2" type="NButton" x="0" y="200" parent="1" url="tri2.png" w="15" h="15" rotatez="3.14"/>
-- <ui name="tri3" type="NButton" x="20" y="200" parent="1" url="tri2.png" w="15" h="15"/>
    );

    local cam = fbo.cam3d;
    local _model = UnitBase:new();

    -- _model:loadvbo("\\resource\\md2\\bauul.md2","\\resource\\material\\bauul.mat",cam);
    _model:loadvbo("\\resource\\obj\\box.obj","\\resource\\material\\bauul.mat",cam);

    core.add(_model,fbo.renderlist);

    --  core.add(_model);
    local namemap = nskin.namemap;

    local bg = namemap["bg"];
    -- local x,y = nskin:getLocalPos(bg);
    local c = namemap["bg"]:get_container();
 --  func_addchild(c, fbo:get_container(),x,y);
    -- func_addchild(c,fbo:get_container(),0,0);

    -- print(c);
end

fboviewTest();