local Run = false

AddEventHandler("playerSpawned", function ()
    if not Run then
        ShutdownLoadingScreenNui()
        Run = true
    end
end)

-- If the loading screen have more errors tell me ✌🏻❤️
