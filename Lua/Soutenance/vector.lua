-- vector metatable:
Vector = {}
Vector.__index = Vector

-- vector constructor:
function Vector.New(x, y)
  local v = {x = x or 0, y = y or 0}
  setmetatable(v, Vector)
  return v
end

-- vector addition:
function Vector.__add(a, b)
  return Vector.New(a.x + b.x, a.y + b.y)
end

-- vector subtraction:
function Vector.__sub(a, b)
  return Vector.New(a.x - b.x, a.y - b.y)
end

-- multiplication of a vector by a scalar:
function Vector.__mul(a, b)
  if type(a) == "number" then
    return Vector.New(b.x * a, b.y * a)
  elseif type(b) == "number" then
    return Vector.New(a.x * b, a.y * b)
  else
    error("Can only multiply vector by scalar.")
  end
end

-- dividing a vector by a scalar:
function Vector.__div(a, b)
   if type(b) == "number" then
      return Vector.New(a.x / b, a.y / b)
   else
      error("Invalid argument types for vector division.")
   end
end

-- vector equivalence comparison:
function Vector.__eq(a, b)
	return a.x == b.x and a.y == b.y
end

-- vector not equivalence comparison:
function Vector.__ne(a, b)
	return not Vector.__eq(a, b)
end

-- unary negation operator:
function Vector.__unm(a)
	return Vector.New(-a.x, -a.y)
end

-- vector < comparison:
function Vector.__lt(a, b)
	 return a.x < b.x and a.y < b.y
end

-- vector <= comparison:
function Vector.__le(a, b)
	 return a.x <= b.x and a.y <= b.y
end

-- vector value string output:
function Vector.__tostring(v)
	 return "(" .. v.x .. ", " .. v.y .. ")"
end

function Vector.GetNorm(a)
    return math.sqrt(a.x^2 + a.y^2);
end

-- Normalize vector
function Vector.Normalize(a)
    local N = Vector.GetNorm(a);
    a.x = a.x / N;
    a.y = a.y / N;
end

return Vector;