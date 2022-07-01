Alert = {
	
};

Alert.__index = Alert;
function Alert:new()
	local obj = {
        -- nskin NSkin
        -- list NStack
	};

	setmetatable(obj, Alert);
    local nskin = NSkin:new();
    nskin:load(
        [[
<ui name="1" type="NPanel" drag="1" center="1" width="512" height="256" line="0" set_click_close="1"/>
<ui name="label1" type="NLabel" label="desc" x="0" parent="1" width="512" height="256"/>
]]);
    self.nskin = nskin;
    self.list = NStack:new();
    nskin:get_panel():setBgColor(0,0,0);
    local np = nskin:get_panel();
    np:set_clickCallBack(function ()
        local n = self.list:len();
        if(n <= 0)then
            nskin:visible(false);
        else
            self:showText(self.list:pop())
        end
    end);
    nskin:visible(false);
	return obj;
end

function Alert:showText(str)
    local skin = self.nskin;
	local m = skin.namemap;
	--- @class NLabel
	local label = m["label1"];
    local n = self.list:len();
	label:set_text("["..n.."]"..str);
	skin:visible(true);
end
function Alert:show(str)
    if(self.nskin:is_visible())then
        self.list:push(str);
        return;
    end
    self:showText(str)
end