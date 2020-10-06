--based on the exercism lua luhn algorithm implementation
--should match in Suricata on payloads containing luhn-valid numbers between 15 and 19 digits

function addends(s)
  local result = {}
  for i = #s, 1, -1 do
    local digit = tonumber(s:sub(i, i))
    if #result % 2 > 0 then digit = digit * 2 end
    if digit > 9 then digit = digit - 9 end
    table.insert(result, 1, digit)
  end
  return result
end

function checksum(s)
  local checksum = 0
  for _, addend in ipairs(addends(s)) do
    checksum = checksum + addend
  end
  return checksum
end

function checkluhn(s)
  return checksum(s) % 10 == 0
end

--get packet payload
function init(args)
  local needs = {}
  needs["payload"] = tostring(true)
  return needs
end

function match(args)
  local crads = {}

  --get payload and remove hyphens and spaces
  local payload = tostring(args["payload"]):gsub("-", ""):gsub(" ", "")
  if #payload > 0 then

    --get all of the integer sequences (15-19 digits for the big four)
    for capture in string.gmatch(payload, "([2-6]%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d?%d?%d?%d?)") do
      table.insert(crads, capture)
    end

    if #crads > 0 then
      for i = 1, #crads do

        if tonumber(crads[i]) > 0 then
          --is a valid number, check luhn
          if checkluhn(crads[i]) then
            --we got one
            return 1
          end
        end
      end
    end
  end
  return 0
end

return 0