require("core");
local byte = require("utils/byte");
core.debug(1);

core.setBackgroundColor(0.1,0.1,0.1);



local function test0()
    ---@type DebugView
    local DebugView = require("view/DebugView");
    local panel = DebugView:new();


    -- panel:set_mouse_mid();
    -- ---@type FpsView
    -- local fps = require("view/FpsView");
    -- fps:show();

    core.plugin:toggle('view/SettingView');
end



-- panel:dispose();

--[[
require("editor");
local e1 = Editor:new();
e1:createLine();
e1:createAxis();
e1:showfps();
--]]

local function test1()
    core.setfps(30);

    local function f_showFBO(w,h)
        local url="\\resource\\md2\\bauul.md2";--bauul,triangle
        local mat = "//resource//material//bauul.mat";
        local fbo = FboRender:new(w,h);
        fbo:mouseEnable(true);
        fbo:set_pos(10,100);
        -- local cam = fbo:get_cam3d();
        -- local cam2d = fbo:get_cam2d();

        
        -- cam = nil;
        
        ---@type UnitBase
        local _model = UnitBase:new();
        _model:loadvbo(url,mat);
        -- _model:scale(0.05);
        _model:set_position(0,0,-2.5);
        -- core.add(_model);
        core.add(_model,fbo:get_renderlist());
        
        -- core.del(_model,fbo:get_list());

        -- local sw,sh = core.screen_size();
        -- fbo:set_pos(128,0);--sw/4 (sh-h)/2
        _model:load_collide('\\resource\\obj\\box.obj',true);
    end
    -- core.cam:set_pos(0,-1,-5.5);

    f_showFBO(256,128);
end

-- test1();

-- socket_init();







local p= lsocket_bind("127.0.0.1",6000);

-- local btn = Button:new();
-- btn:set_label("close")
-- btn:bind_click(function()
--     lsocket_close(p);
-- end);
-- kit.anim_label(0,50,500);

-- local bs = mbyte("new");
-- mbyte("bs_write_start",bs,128);
-- mbyte("bs_writeInt",bs,223);
-- mbyte("bs_writeUTF",bs,3,"Abc");
-- -- print(bs);
-- -- --
-- -- local str,len = mbyte("bs_getChars",bs);



-- local rs = mbyte("new");
-- local mlen = mbyte("bs_copy",bs,rs);

-- mbyte("dispose",bs);


-- print(
--     mbyte("bs_readInt",rs),    
--     mbyte("bs_readUTF",rs));
-- mbyte("bs_readInt",rs)

-- local bs = byte.new(128);
-- byte.writeUTF(bs,"djahsdashd");

-- byte.writeInt(bs,123);

-- local ns = byte.new();
-- byte.copy(bs,ns);
-- print(
--     byte.readUTF(ns),    
--     byte.readInt(ns));
