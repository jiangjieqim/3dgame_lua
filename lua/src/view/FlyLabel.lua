local core = require("core");

--һ��Ʈ������
local FlyLabel = {
	
};
FlyLabel.__index = FlyLabel;
setmetatable(FlyLabel, IPluginView);

function FlyLabel:new()
	local self = {
        nskin=nil,
        timer = 0,
        endtime = 0,
        sy = 0,
        ms = 0,--��Ҫʹ�õ�ʱ��
        starttime = 0,
        ty = 0,--Ŀ��y��ֵ
    };

    setmetatable(self, FlyLabel);
    local nskin = NSkin:new();
    self.nskin = nskin;
    
    --evt_once(nskin,ENGINE_EVENT_COMPLETE,f_cpmleteHandler);
	nskin:load([[<ui name="1" type="NPanel" drag="1" center="1" width="200" height="20"/>
<ui name="info_label" label="1" type="NLabel" parent="1"/>
]]);
	return self;
end

-- local function fc(self)
    -- self:dispose();
-- end
local function f_time(data,self)
    -- func_print('f_time');
    if(self.endtime<core.now()) then
        evt_off(self.timer,core.ex_event.TIMER,f_time);
        self:dispose();
    else
        local x,y = self.nskin:get_pos();
        local p = (core.now()-self.starttime)/self.ms;
        local ny = (self.sy - self.ty) * p;

        self.nskin:set_pos(x,self.sy - ny);--ÿ���ƶ�����
    end
end
---v:���õ��ı�  
---ms:�ӳ�ɾ���ĺ�����  
---ty:�ƶ�����Ŀ��Y������  
function FlyLabel:set_label(v,ms,ty)
    ms = ms or 500;
    ty = ty or 0;
    local label = self.nskin:find("info_label");
    label:set_text(v);
    --print(EVENT_TIMER);
    -- local o = core.setTimeout(ms or 500,fc,self);
    local curtime = core.now();
    self.starttime = curtime;
    self.endtime = curtime + ms;
    self.timer = timelater_new(10);
    self.ms = ms;
    self.ty = ty;
    --print(self.timer);


    local x,y = self.nskin:get_pos();
    -- print(sx,sy,x,y);
    self.sy = y;--��ʼy������

    evt_on(self.timer,core.ex_event.TIMER,f_time,self);
end

function FlyLabel:getName()
	return "FlyLabel";
end

function FlyLabel:dispose()
    timelater_remove(self.timer);
    self.nskin:dispose();
    func_clearTableItem(self);
end
return FlyLabel;