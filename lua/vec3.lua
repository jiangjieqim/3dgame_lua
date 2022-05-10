--两向量距离
function vec3_distance(x0, y0, z0, x1, y1, z1)
    return math.sqrt(math.pow(x0 - x1, 2) + math.pow(y0 - y1, 2) + math.pow(z0 - z1, 2));
end

function vec3_len(x, y, z)
    return math.sqrt(x * x + y * y + z * z);
end
--向量归一
function vec3_normal(x, y, z)
    local length = vec3_len(x, y, z);
    if (length <= 0) then
        func_error("vec3_normal!!!");
    end
    x = x / length;
    y = y / length;

    z = z / length;
    return x, y, z;
end

--乘法
function vec3_mult(x,y,z,v)
    return x * v,y * v,z * v;
end

--除法
function vec3_div(x,y,z,v)
    return x / v,y / v,z / v;
end

--加
function vec3_add(x0, y0, z0, x1, y1, z1)
	 return x0 + x1 , y0 + y1 ,z0 + z1;
end

--减
function vec3_sub(x0, y0, z0, x1, y1, z1)
    return x0 - x1 , y0 - y1 ,z0 - z1;
end

-- 叉乘
function vec3_cross(x0, y0, z0, x1, y1, z1)
    return y0 * z1 - z0 * y1,
		   z0 * x1 - x0 * z1, 
		   x0 * y1 - y0 * x1;
end

-- 点乘
function vec3_dot(x0, y0, z0, x1, y1, z1)
    return x0 * x1 + y0 * y1 + z0 * z1;
end
--求两向量中间夹角向量
function vec3_between(sx, sy, sz, ex, ey, ez)
    local x2,y2,z2 = vec3_normal(sx,sy,sz);--start
    local x3,y3,z3 = vec3_normal(ex,ey,ez);--end
    local d = vec3_distance(x2,y2,z2,x3,y3,z3)*0.5;
    local nx,ny,nz = vec3_sub(x3,y3,z3,x2,y2,z2);
    local mx,my,mz = vec3_normal(nx,ny,nz);
    local v1,v2,v3= vec3_mult(mx,my,mz,d);
    return vec3_normal(vec3_add(v1,v2,v3,sx,sy,sz));
end

--[[
function MathHelper.GetVector3Dot(v1, v2)
    return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z
end
 
-- 向量叉乘
function MathHelper.GetVector3Cross(v1, v2)
    local v3 ={x = v1.y*v2.z - v2.y*v1.z , y = v2.x*v1.z-v1.x*v2.z , z = v1.x*v2.y-v2.x*v1.y}
    return v3
end
 
-- 向量的模
function MathHelper.GetVector3Module(v)
    return math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
end
 
-- 求两向量间夹角
function MathHelper.GetVector3Angle(v1, v2)
    local cos = MathHelper.GetVector3Dot(v1, v2)/ (MathHelper.GetVector3Module(v1)*MathHelper.GetVector3Module(v2))
    return math.acos(cos) * 180 / math.pi
end
]]
--###########################################################
Vec3 = {};
Vec3.__index = Vec3;

function Vec3:new(x,y,z)
    local s = {};
    setmetatable(s,Vec3);
    s.x = x or 0;
    s.y = y or 0;
    s.z = z or 0;
    return s;
end
---向量归一化
function Vec3:normalize()
    local x,y,z = vec3_normal(self.x,self.y,self.z);
    self.x = x;
    self.y = y;
    self.z = z;
end