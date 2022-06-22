-- UnitBaseEvent = 10000;
-- UnitBaseEndMsg = "UnitBaseEndMsg";--移动结束
require("animator")

---@class UnitBase : NUnit
---@field pvm_matrix number
--*************************************************************
--只实现 p = TYPE_OBJ_VBO_FILE 类型的对象
UnitBase = {
    -- p,--角色句柄,是引擎中的md2,obj,md5引用的值
    -- anim,--动作管理器句柄
    -- material,--材质句柄
    -- ptrCollide,--碰撞盒对象引用,struct CollideBox* ptrCollide
    --**********************************************************
    -- moveEnd 移动结束回调
    -- moveX,moveY,moveZ :move目的坐标
    };
UnitBase.__index = UnitBase;

setmetatable(UnitBase, NUnit);

function UnitBase:new()
    local s = NUnit:new();
    setmetatable(s,UnitBase);
    -- print("UnitBase",s);
    s._ismoving = false;
    return s;
end

function UnitBase:dispose()
    core.super(self,"dispose");
    if(self._line) then
        self._line:dispose();
    end
	if(self.anim) then
		self.anim:dispose();
	end
	core.ptr_remove(self.p);
	func_clearTableItem(self);
end

--设置对象的cam的矩阵空间
local function f_setCam(self)
    self:setCam(core.cam:get_p());
end

-- local function loadmat(_self,url)
--     _self.material = func_load_material(url);
-- 	return _self.material;
-- end

--动作管理器句柄
---@type Animator
function UnitBase:get_anim()
    if(self.anim==nil) then
        func_error('self.anim is nil!');
    end
    return self.anim;
end

---是否有动画
function UnitBase:has_anim()
    if(self.anim==nil) then
        return false;
    end
    return true;
end

-- --加载材质
-- function UnitBase:load_material(url)
--     self.material = func_load_material(url);
-- 	return self.material;
-- end

--- HeadInfo->m 输入的变换矩阵 即模型自身的矩阵
function UnitBase:base_matrix()
   return get_attr(self.p,"base_matrix");
end

function  UnitBase:pvm_matrix()
    return get_attr(self.p,"pvm_matrix");
end

---设置材质
function UnitBase:setmat(_material)
    if(self.p == nil) then
        func_error("self.p = nil");
    end
    -- setMaterial(self.p,_material);
    core.meterial.set(self.p,_material);
    self.material = _material;
end

---struct Node*为模型增加一条管线渲染,目的是解决多管道渲染模型
---可实现多管线渲染
function UnitBase:push_material(material)
    --[[
            /*
        *统一的渲染调用接口
        */
        void
        node_render(struct Node* p){
            struct HeadInfo* base =	base_get(p);
            void* ob = anim_playByFPS(p->anim);
            vbo_render(ob,base->tmat);
            if(p->matlist){
                LStack_ergodic(p->matlist,f_updateShaderNode,ob);
            }
        }
    ]]

    --其实struct HeadInfo本身有一个tmat材质句柄
    --那么struct Node*的matlist的材质句柄用于多管线渲染的

    node_push_material(self.p,material);
end

--加载VBO模型,会赋值材质
--如果maturl是string就是一个链接
--如果maturl是number就是一个材质句柄
function UnitBase:loadvbo(url,maturl,_scale)
    local m = core.load(url);
    local ctype = type(maturl);
    if(ctype == "string")then
        self.material = func_load_material(maturl);
        --local material = loadmat(self,maturl); --self:load_material(maturl);
        --core.meterial.set(m,material);
    elseif(ctype == "number") then
        self.material = maturl;
    end
    
    if(self.material~=nil)then
        core.meterial.set(m,self.material);
    end

    self.p = m;
    self:visible(true);
    local suffix = core.get_suffix(url);
    if(suffix~= "obj") then
        self.anim = Animator:new(self.p);--初始化动画管理器句柄
    else
        --func_error(modelURL);
    end
    self:scale(_scale or 1.0);
end

function UnitBase:set_position(x,y,z)
    change_attr(self.p,"set_position",string.format("%f,%f,%f",x,y,z));
end

-- function UnitBase:set_speed(v)
--     self.speed = v;
-- end

--绑定一个点击事件
-- function UnitBase:bindRayPick(func)
--     --print(self:getv(FLAGS_RAY));
--     self:setv(FLAGS_RAY);
--     evt_on(self.p,LUA_EVENT_RAY_PICK,func);
-- end

-- local function drawByVertex(p,x,y,z)
--     local a = {get_collideVer(p)};
--     -- print(a);
--     local len = a[1];

--     ---@type LineNode
--     local _line= LineNode:new(len/3);

--     local c = 0;
--     local pos = {};
--     local k=0;
--     for i = 2,len+1 do
--         -- print(i,a[i]);
--         pos[c] = a[i];
--         c = c + 1;
--         if(c >=3) then 
--             k=k+1;
--             -- print(k,"##",pos[0],pos[1],pos[2]);
--             _line:push(pos[0]+x,pos[1]+y,pos[2]+z);
--             c = 0;
--         end
--     end
--     _line:setcolor(0,1,1);
--     _line:graphics_end();
--     core.add(_line);
--     -- _line:dispose();
--     return _line;
-- end

local function drawByVertex(p,x,y,z,scale)
    local ver,len = get_collideVer(p);
    -- print(ver,string.format("%#x",ver),len);
    ---@type LineNode
    local _line= LineNode:new(len/3);
    _line:pushAll(ver,len);
    _line:setcolor(1,1,1);
    _line:graphics_end(scale);
    _line:set_position(x,y,z);
    core.add(_line);
    return _line;
end

-- local function drawRayCollison(_self,v)
--     if(_self.ptrCollide == nil) then 
--         func_error("must be UnitBase:load_collide!");--没有设置碰撞盒对象
--     end
--     local flag = FLAGS_DRAW_RAY_COLLISION;
--     if(not v) then resetv(_self.p,flag) else setv(_self.p,flag) end;
-- end
---加载一个碰撞盒子,此接口在fbo模式的渲染窗口中鼠标拾取是无效的
---@param url string模型URL'\\resource\\obj\\box.obj'传递一个自定义的obj,或者md2模型,会计算出AABB Box的最大顶点坐标
-- -@param scale 缩放值
function UnitBase:load_collide(url,bShow)
    self.ptrCollide = load_collide(self.p,url,1.0)
	-- change_attr(self.p,"collide_load",url or "\\resource\\obj\\box.obj", string.format("%d,%.3f",0,scale or 1.0));--torus
	setv(self.p,FLAGS_RAY);
    -- drawRayCollison(self,bShow);
    if(bShow) then
        local x,y,z =self:get_pos();
        self._line = drawByVertex(self.p,x,y,z,self:get_scale());
    end
end

--- 让角色按照消耗time毫秒移动到坐标xyz
function UnitBase:move_to(time,x,y,z)
    time = time or 0;
    -- change_attr(self.p,"lookat",string.format("%f,%f,%f,%f",x,y,z,time));
    change_attr(self.p,"move",string.format("%d,%f,%f,%f",time,x,y,z));
end

--- 让角色按照time毫秒转向某个方向
function UnitBase:look_at(x,y,z,time)
    time = time or 0;
	change_attr(self.p,"lookat",string.format("%f,%f,%f,%f",x,y,z,time));
end
local function f_endCall(data,_self)
    --- @type UnitBase
    local self = _self;
    -- print(core.get_time(),"f_endCall",self:get_p(),"name:",data);

    -- local p = core.find_name(self:get_p());
--    local u = allUnits[data];
    -- func_set_anim(p,"stand");

    -- self:get_anim():play("stand");

    evt_off(self:get_p(),core.ex_event.EVENT_ENGINE_COMPLETE,f_endCall);
    self._ismoving = false;
    -- evt_dispatch(p,UnitBaseEvent,UnitBaseEndMsg);
    self:set_position(self.moveX,self.moveY,self.moveZ);

    -- print("f_endCall::",self:get_pos());
    
    if(self.moveEnd~=nil) then
        self.moveEnd();
    end
end
---@param lookatTime lookat需要的时间毫秒  
---@param moveSpeed 移动的速度.1秒移动的像素距离
function UnitBase:move(x,y,z,lookatTime,moveSpeed,moveEnd)
    --print(x,y,z);
    x = tonumber(x);
    y = tonumber(y);
    z = tonumber(z);
    local o = self:get_p();
    self.moveEnd = moveEnd;
	local px,py,pz = self:get_pos();--func_get_xyz(o);
    self.moveX = x;
    self.moveY = y;
    self.moveZ = z;
    -- print(self:get_name());

	y = py;
	--print(self.offset_y);
	local distance = vec3_distance(px,py,pz,x,y,z);--求其平面距离
	-- print('distance:',distance);
    
    self:look_at(x,y,z,lookatTime);--转向目标坐标
    
	--print("look at:",x,y,z);
	-- func_set_anim(self.p,"run");
    
    -- self:get_anim():play("run");
    self._ismoving = true; 
    evt_on(o,core.ex_event.EVENT_ENGINE_COMPLETE,f_endCall,self);
    
--    print(core.get_time(),'distance*useTime:',distance,moveSpeed,self:get_p(),"cur x y z",px,py,pz);
    --- 移动到目标坐标
	self:move_to(distance / moveSpeed*1000,x,y,z);
end
--是否在移动
function UnitBase:isMoving()
    return self._ismoving;
end
