local Fps = {
}
local core = core;

Fps.__index = Fps;
setmetatable(Fps,Component);
function Fps:new()
	local self = Component:new();
	setmetatable(self, Fps);
	return self;
end

function Fps:awake()

end

function Fps:update()
    ---@type NLabel;
    local label = self.gameObject;
    -- local w,h = label:get_size();
    
    label:set_text(string.format("%s %d",core.getFps(0),core.get_time()/1000));
    
    -- print("fps is update!!!");
end
return Fps;