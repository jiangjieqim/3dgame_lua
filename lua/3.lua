require("core");

local kit = require("utils/kittools");

-- core.setBackgroundColor(0.5,0.5,0.5);
kit.keyLis();
-- ScrollViewCase1(120,10);


kit.checkComp();

-- ScrollViewCase1(120,10);


-- local function newModel()
--     local n = UnitBase:new();
--     local url="\\resource\\obj\\torus.obj";--bauul,triangle
--     local mat = "//resource//material//triangle.mat";
--     n:loadvbo(url,mat);
--     n:load_collide("\\resource\\obj\\torus.obj",true);
--     n:set_position(0,0,-8);
--     local material = n:getMaterial();
--     shader_updateVal(material,"_Alpha",1.0);
--     -- n:load_collide("\\resource\\obj\\torus.obj",true);
--     n:scale(1.0);
--     return n;
-- end
-- -- ---@type FboRender
-- local fbo = FboRender:new(128,128);
-- fbo:set_pos(25,30);
-- fbo:mouseEnable(true);
-- local n = newModel();
-- core.add(n,fbo:get_renderlist());

-- core.add(newModel());

-- ---@type Button
-- local btn = Button:new(fbo:get_renderlist());
-- btn:btn_effect(true);
-- btn:set_pos(10,20);
-- btn:bind_click(function ()
--     func_print("click from FBO!"); 
-- end)

-- local btn = Button:new();
-- btn:btn_effect(true);
-- btn:set_pos(10,20);
-- btn:bind_click(function ()
--    func_print(11); 
-- end);



