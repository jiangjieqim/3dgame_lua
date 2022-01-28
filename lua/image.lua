-- local Shape = core.ui.Shape;

Image = {
	
};
Image.__index = Image;

setmetatable(Image, Shape);

--[[local function clickEvt(d,p)
	print(d,p);
end
--]]

---��ʼ��Image����
---@param cam ��ǰ��Camera�ռ�
function Image:new(w,h,renderlist)
	local self = Shape:new(w,h,true,renderlist);
	setmetatable(self, Image);
	self:settype(core.UI_TYPE.Image);

	self:init();
	self:mouseEnable(false);--Ĭ�Ϲر�����¼�
	--self:on(EVENT_ENGINE_SPRITE_CLICK,clickEvt,self);
	return self;
end

function Image:init()
	local sw,sh = self:get_size();
	local img = self:create_typical(sw,sh);
	self.container = img;
	--��������
	local _mater = tmat_create_empty("simple;grid9vbo");--9����ģʽ������
	core.meterial.set(img,_mater);

	self:add(img,self.renderlist);
end

---* ���õ��ǵ�����icon,�Ǻϲ��Ĵ�ͼ��,
---* ֱ���õ���sprite_set_9grid�ӿ�,
---* �����ÿ��url����һ��texture
---@param url string
function Image:seticon(url)
	--func_texloadend(self.container,url);
	local sprite = self.container;
	
	local _mater = self:getMaterial();
	tmat_delAllTex(_mater);--ɾ�������е�����������

	local tex = func_get_tex_cache(core.atals,url);--�ӻ�����ߴ���һ��������
	tmat_pushTex(_mater,tex);
	--func_setIcon(sprite,url);
	local sw,sh = func_get_sprite_size(sprite);
	core.parse9GridTex(_mater,sw,sh,url,3,3,3,3);
end