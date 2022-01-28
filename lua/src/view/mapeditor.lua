MapEditor = {};
MapEditor.__index = MapEditor;
---增加一个fps显示title
local function f_showfps(cam)
	core.setfps(12);--24
	---@type FpsView
	local fps = core.plugin:load("view/FpsView");
	fps:show(cam);
	fps.callBack = function()
		local x,y,z = core.cam:get_pos();
		return "\n"..x..','..y..','..z;
	end
end
local function f_init(self)
    local sw,sh = core.screen_size();
    -- print(sh/2);
    ---x轴偏移
    local offsetx = 100;

    local h = sh - 1;
    -- h = h / 2;
    local editorfbo = FboRender:new(h,h);
    editorfbo:mouseEnable(true);
    editorfbo:set_pos(offsetx,0);

    local renderfbo = FboRender:new(h,h/2);
    renderfbo:mouseEnable(true);
    renderfbo:set_pos(h+offsetx+1,0);

    ---设置结构体数据
    self.editorfbo = editorfbo;
    self.renderfbo = renderfbo;

    return self;
end

---静态函数,加载一个测试模型
function MapEditor:LoadModel()
    local url="\\resource\\md2\\triangle.md2";--bauul,triangle
	local mat = "//resource//material//bauul.mat";
    local _model = UnitBase:new();
	_model:loadvbo(url,mat);
	_model:scale(1.0);
	_model:set_position(0,0,-2.5);
	-- local sw,sh = core.screen_size();
	-- fbo:set_pos(128,0);--sw/4 (sh-h)/2
	_model:load_collide('\\resource\\obj\\box.obj',true);
    return _model;
end
---静态函数,加载一个测试的2dSprite界面
---@param cam 当前的cam句柄
function MapEditor:Add_img(cam,x,y,w,h)
    -- body
    local url = "smallbtn.png";
    local _img =  Image:new(w or 100,h or 20);
    _img:set_pos(x or 0,y or 0);
    _img:mouseEnable(true);
    

    _img:seticon(url);
    _img:on(EVENT_ENGINE_SPRITE_CLICK,
        function (name,self)
            func_print('you click '..name..tostring(self));
        end,_img);
    return _img;
end

---地图编辑器
function MapEditor:new()
    local me = {};
    setmetatable(me, MapEditor);
    f_init(me);
    return me;
end

function MapEditor:get_cam3d()
    return 
        self.editorfbo:get_cam3d(),
        self.editorfbo:get_cam2d(),
        self.renderfbo:get_cam3d(),
        self.renderfbo:get_cam2d();
end

function MapEditor:load()
    local cam_cam3d1,cam_2d1,cam_cam3d2,cam_2d2 = self:get_cam3d();
    local model = MapEditor:LoadModel(cam_cam3d1);--core.cam:get_p()
    -- model:setCam(cam_cam3d1);
    -- model:setCam(cam_cam3d2);


    local _img = MapEditor:Add_img(cam_2d1,10,100);
    
    
    -- f_loadmode(cam_r0);
    -- f_add_img(cam_r1,100,50,100,50);

    f_showfps(cam_2d1);
end
