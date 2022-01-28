-- local Shape = core.ui.Shape;

Image = {
	
};
Image.__index = Image;

setmetatable(Image, Shape);

--[[local function clickEvt(d,p)
	print(d,p);
end
--]]

---初始化Image对象
---@param cam 当前的Camera空间
function Image:new(w,h,renderlist)
	local self = Shape:new(w,h,true,renderlist);
	setmetatable(self, Image);
	self:settype(core.UI_TYPE.Image);

	self:init();
	self:mouseEnable(false);--默认关闭鼠标事件
	--self:on(EVENT_ENGINE_SPRITE_CLICK,clickEvt,self);
	return self;
end

function Image:init()
	local sw,sh = self:get_size();
	local img = self:create_typical(sw,sh);
	self.container = img;
	--创建材质
	local _mater = tmat_create_empty("simple;grid9vbo");--9宫格模式的纹理
	core.meterial.set(img,_mater);

	self:add(img,self.renderlist);
end

---* 设置的是单独的icon,非合并的大图集,
---* 直接用的是sprite_set_9grid接口,
---* 这个是每个url就是一个texture
---@param url string
function Image:seticon(url)
	--func_texloadend(self.container,url);
	local sprite = self.container;
	
	local _mater = self:getMaterial();
	tmat_delAllTex(_mater);--删除材质中的所有纹理句柄

	local tex = func_get_tex_cache(core.atals,url);--从缓存或者创建一个纹理句柄
	tmat_pushTex(_mater,tex);
	--func_setIcon(sprite,url);
	local sw,sh = func_get_sprite_size(sprite);
	core.parse9GridTex(_mater,sw,sh,url,3,3,3,3);
end