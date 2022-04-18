require("core");
local core = core;
-- print("This is Test!");


core.init("//resource//texture//1"); 


local function f_cpmlete(self)

end

local nskin = NSkin:new();
-- evt_once(nskin,ENGINE_EVENT_COMPLETE,f_cpmlete);
-- f_cpmlete();
-- nskin:load("\\resource\\ui\\crl.xml","gundi.png;checkbox.png;smallbtn.png");
nskin:load("\\resource\\ui\\crl.xml");

