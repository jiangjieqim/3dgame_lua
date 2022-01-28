function vec_distance(x0, y0, z0, x1, y1, z1)
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

--加
function vec3_add(x0, y0, z0, x1, y1, z1)
	 return x0 + x1 , y0 + y1 ,z0 + z1;
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