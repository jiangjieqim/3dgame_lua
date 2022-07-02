-- local Shape = core.ui.Shape;

local DIRECTION_HORIZONTAL = 0	--ˮƽ,�� 
local DIRECTION_VERTICAL   = 1 	--��ֱ,��

NScrollBar = {
	-- bg,--�ɹ����ı���(Image)
	-- btn,--��������С��ť
	
	-- --�ص����ص�����
	-- callBack,
	-- callBackParam,
};

NScrollBar.__index = NScrollBar;
setmetatable(NScrollBar, Base);

local function 
f_setBarPostion(sprite,scrollbtn)
	--�����ķ���
	local dragDirection=scrollbtn:get_drag_type();
	--�����ֲ�����
	local local_x,local_y = sprite:local_mouse_xy();
	
	--������������
	local bx,by = 0,0;--sprite:get_pos();

	--�������Ŀ��
	local sprite_w,sprite_h = sprite:get_size();

	--С��ť�Ŀ��
	local sc_w,sc_h = scrollbtn:get_size();
				
	if(dragDirection == DIRECTION_HORIZONTAL) then
		local v = local_x;
		local target_x = bx + v;
		--print("����С��ť��λ��:"..tostring(target_x)..","..tostring(by)..",sc_w="..sc_w..',sc_h='..sc_h..',sprite_w='..sprite_w..',sprite_h='..sprite_h)
		if (target_x > sprite_w  - sc_w + bx) then
			target_x = sprite_w - sc_w + bx;
			--print('����!!!')
		end

		--sprite_setpos(scrollbtn,target_x,by);
		scrollbtn:set_pos(target_x,by);
		
		--print("��������***",target_x,by);
		return v / sprite_w;
	else
		local v = local_y;
		local target_y = by + v ;
		--print("����С��ť��λ��:"..tostring(target_x)..","..tostring(by)..",sc_w="..sc_w..',sc_h='..sc_h..',sprite_w='..sprite_w..',sprite_h='..sprite_h)

		if (target_y > sprite_h  - sc_h + by) then
			target_y = sprite_h - sc_h + by;
			--print('����!!!')
		end
		
--		sprite_setpos(scrollbtn,bx,target_y);
		scrollbtn:set_pos(bx,target_y);
		
		--print("##",bx,target_y);
		return v / sprite_h;
	end
	
--]]
end

--�������α��ƶ���ʱ�򴥷�
local function f_luaDrag_move(progress,self)    
	-- if(progress == nil) then
	-- 	func_error("progress = nil!");
	-- end
	if(self.callBack) then
		--print(progress,self);
		self.callBack(progress,self.callBackParam);
	end
end

local function f_scrollBarClick(name,self)
	local v = f_setBarPostion(self.bg,self.btn);
	f_luaDrag_move(v,self);
end

function NScrollBar:bindCallback(callBack,callBackParam)
	self.callBack = callBack;
	self.callBackParam = callBackParam;
end
function NScrollBar:visible(v)
	local bg = self.bg;
	local btn = self.btn;
	bg:visible(v);
	btn:visible(v);
end
function NScrollBar:new(x,y,cw,ch)
	local self = Base:new();
	self:settype(core.UI_TYPE.NScrollBar);--12

	setmetatable(self, NScrollBar);
	if(cw == 0) then cw = nil end
	if(ch == 0) then ch = nil end

	--����Ĭ�ϵĿ��
	cw = cw or 100;
	ch = ch or 15;
	
	local _dragDirection;	--�����ķ���
	local barSize;			--������ĳߴ�
	if(cw > ch) then
		_dragDirection=DIRECTION_HORIZONTAL;
		barSize = ch;
	else
		_dragDirection=DIRECTION_VERTICAL;
		barSize = cw;
	end
	
	--�����ɻ����ı���
	local bg = Image:new(cw,ch);
	bg:mouseEnable(true);
	bg:set_pos(x or 0,y or 0);
	bg:seticon("checkbox.png");
	self.bg = bg;	
	--����С��ť
	local btn = Shape:new(barSize,barSize);
	--local btn = Image:new(barSize,barSize); 
	--btn:seticon("gundi.png");
	
	btn:mouseEnable(true);
	btn:setcolor(0,1,0);
	btn:set_drag_type(_dragDirection);
	--���ÿ���ק��Χ
	btn:set_drag_rect(0,0,cw,ch);
	
	self.btn = btn;
	
	bg:addChild(btn:get_container());

	bg:on(EVENT_ENGINE_SPRITE_CLICK,f_scrollBarClick,self);
	btn:on(EVENT_ENGINE_SPRITE_CLICK_MOVE,f_luaDrag_move,self);
	
	--self:set_pos(0,0);
	return self;
end

function NScrollBar:get_container()
	local bg = self.bg;
	return bg:get_container();
end

function NScrollBar:dispose()
	local bg = self.bg;
	local btn = self.btn;
	bg:off(EVENT_ENGINE_SPRITE_CLICK,f_scrollBarClick);
	bg:dispose();
	
	btn:off(EVENT_ENGINE_SPRITE_CLICK_MOVE,f_luaDrag_move);
	btn:dispose();
	
	func_clearTableItem(self);
end
