--创建一个装载fbotextue的sprite
local function f_createSprite(tw,th,tex)
 	local spr = sprite_createEmptyTex(tw,th);
--[[
	local _mater = tmat_create_empty("simple;fbotex");
	local spr = sprite_create_typical(nil,0,0,tw,tw,core.cam2d:get_p());
	core.meterial.set(spr,_mater);
]]



	-- core.rename(spr,core.getName('_fbo_sprite'));	--重命名该FBO Sprite
	
	if (tex) then
        local mat = sprite_get_material(spr);
        tmat_pushTex(mat,tex);
    else
        print("fboTexture is nil");
    end
    return spr;
end

 --[[
	设置坐标(兼容模式)
--]]
local function f_setPos(p,x,y)
	-- local pos = x..","..y;
	-- change_attr(p,"sprite_position",pos)
	sprite_setpos(p,x,y);
end

--print(fbo.ptr);
--**************************************************
--其实是用Sprite用来绘制Fbo对象的
FboRender = {
	-- ptr,cam3d,cam2d,tex,

	--用于渲染的Sprite
	-- spr

	--fbo内部渲染列表
	--renderlist
}
FboRender.__index = FboRender;
setmetatable(FboRender, Base);
---tw,th为2的n次方
function FboRender:new(tw,th)
	-- if(tw % 2~=0 or th % 2~=0) then
	-- 	func_error('FboRender:new 参数tw,th为2的n次方');
	-- end

	local fbo = Base:new();
	setmetatable(fbo, FboRender);
	self:settype(core.UI_TYPE.Nfbo);

	w = w or 128;
	h = h or 128;
	local ptr,cam3d,cam2d,tex,renderlist = fbo_init(tw,th);--构建fbo对象
	fbo.ptr = ptr;
	fbo.cam3d = cam3d;
	---@type Camera
	fbo.cam2d = Camera:new(cam2d);
	
	fbo.tex = tex;
	fbo.renderlist = renderlist;
	fbo.spr = f_createSprite(tw,th,tex);
	fbo_set_spr(ptr,fbo.spr);
	core.add(fbo);---将spr添加到渲染列表
	-- ,core.renderlist
	add_fbo(ptr);--添加到引擎的fbolist中
	return fbo;
end
function FboRender:setRenderList(_list)
	self._sprRenderlist = _list;
end
---设置鼠标可拾取状态,分屏的时候需要设置
function FboRender:mouseEnable(v)
	sprite_enable_click(self.spr,v == true and 1 or 0);
end

--装载fbo的sprite容器句柄
function FboRender:get_container()
	return self.spr;
end

---FBO的渲染链表引用 
---FBOTexNode中的struct LStackNode* renderlist;
function FboRender:get_renderlist()
	return self.renderlist;
end

function FboRender:dispose()
	--print(debug.traceback());
--还需要将添加进来的渲染对象删除掉

	local len = fbo_get_cnt(self.ptr);
	-- print(len);
	if(len > 0)then
		func_error("please remove rendernode from renderlist !");
	end

	core.del(self.spr,self._sprRenderlist);

	fbo_dispose(self.ptr);
	remove_fbo(self.ptr);--将fbo从引擎的fbolist移除
	core.ptr_remove(self.spr);--销毁fbo占用的sprite对象
end

-- function FboRender:get_cam3d()
-- 	func_error('FboRender:get_cam3d()>>>>');
-- 	return self.cam3d;
-- end
---2d camera handler
-- function FboRender:get_cam2d()
-- 	-- func_error('FboRender:get_cam2d()>>>>');
-- 	-- if(core.cam2d:get_p() == self.cam2d:get_p()) then
-- 	-- 	func_error("*");
-- 	-- end
-- 	return self.cam2d:get_p();
-- end
--设置fbo所在的屏幕坐标
function FboRender:set_pos(x,y)
	local fbo = self;
	local spr = fbo.spr;
	f_setPos(spr,x,y);
	---@type Camera
	local cam2d = fbo.cam2d;
	cam2d:set_2dxy(x,y);
end
--显示,隐藏Fbo的Sprite
function FboRender:visible(v)
	if(v) then
		setv(self.spr,FLAGS_VISIBLE);
	else 
		resetv(self.spr,FLAGS_VISIBLE);
	end
end