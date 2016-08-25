function TableComp(a,b)
    if #a ~= #b then 
        return false 
    end
    for k,v in pairs(a) do
        if type(v) == "table" then 
            if not TableComp(v, b[k]) then 
                return false 
            end
        elseif v ~= b[k] then 
            return false 
        end
    end
    return true
end