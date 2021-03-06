-- local Shape = core.ui.Shape;

--进度条组件
ProgressBar={
	
	container,--容器 Shape
	
	--**********************************
	bar;--Shape
	barwidth,--进度条数据
	barheight,
};
ProgressBar.__index = ProgressBar;
setmetatable(ProgressBar, Base);

function ProgressBar:new(x,y,w,h)
	local self = Base:new();
	setmetatable(self, ProgressBar);
	self:settype(core.UI_TYPE.ProgressBar);--7

	w = w or 80;
	h = h or 10;
	
	local gap = 4;	
	
	local sprite = Shape:new(w,h);
	--sprite:seticon("checkbox.png");
	self.container = sprite;
	
	self.barwidth = w - gap;
	self.barheight= h - gap;
	
	local bar1 = Shape:new(self.barwidth,self.barheight);
	bar1:setcolor(0,1,0);
	--func_addchild(sprite,bar1:get_container(),gap/2,gap/2);
	sprite:addChild(bar1:get_container(),gap/2,gap/2);
	
	
	self.bar = bar1;
	
	--self:progress(0.2);
	return self;
end

function ProgressBar:get_container()
	local c = self.container:get_container();
	return c;
end

--设置百分比
function ProgressBar:progress(v)
	local bar = self.bar;
	--local o = self.bar;
	
	if(bar == nil) then
		func_error();
		return;
	end
	if(v <=0) then
	--	resetv(o,FLAGS_VISIBLE);--进度值小于0就隐藏掉bar,优化drawcall
		bar:visible(false);
	else
		if(v > 1.0) then
			func_error("值超过1.0!");
		else
			--setv(o,FLAGS_VISIBLE);
			bar:visible(true);
			local w = v * self.barwidth;
			bar:set_width(w);
		end
	end
end

function ProgressBar:visible(v)
	local bar = self.bar;
	local container = self.container;
	container:visible(v);
	bar:visible(v);
end

--销毁
function ProgressBar:dispose()
	self.bar:dispose();
	self.container:dispose();
	func_clearTableItem(self);
end