local cfg = cfg
local fields = "180226"

local function supportUkraine(name, setKickReason, deferrals)
    if not cfg.enabled then return end
    local player = source
    deferrals.defer()
    Wait(0)
    deferrals.update(("#^5s^3U^7 - %s"):format("Слава Україні!"))
    Wait(0)
    local ip = GetPlayerEP(player)
    -- local ip = "80.92.32.0" -- test ip
    
    -- FREE API but limited to 45 HTTP requests x minute... https://members.ip-api.com/
    PerformHttpRequest(("http://ip-api.com/json/%s?fields=%s"):format(ip,fields), function(statusCode, text, headers)
        if statusCode == 200 then
            local data = json.decode(text)
            if data.status == "fail" then
                deferrals.done()
            end
            if data.countryCode == "RU" then
                deferrals.done(("[sU] - %s"):format(cfg.rumessage))
                print("#^5s^3U^7 - ^3" .. name .. "^7 - (^3" .. ip .. "^7) - ^2kicked for connecting from ^1Russian Federation^7")
                return
            end
            if data.proxy == true then
                deferrals.done(("[sU] - %s"):format(cfg.vpnmessage))
                print("#^5s^3U^7 - ^3" .. name .. "^7 - (^3" .. ip .. "^7) - ^2kicked for using a ^1VPN^7")
                return
            end
        end
        deferrals.done()
    end, "GET")
end

AddEventHandler("playerConnecting", supportUkraine)

print("#^5s^3U^7 - ^2Loaded!^7")