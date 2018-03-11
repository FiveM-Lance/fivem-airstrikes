--------------------
--Airstrike Bomber--
--------------------

--]]CREDITS[[--

--MythicalBro
--Lance Good

--------------------
--Airstrike Bomber--
--------------------

function f(n)
	n = n + 0.00000
	return n
end

local airstrike,targetting,surveillance = false,false,false
local cam = nil
local countdown = false
local countdown_text = 3

menu = Menu.new("Airstrike","",0.15,0.1,0.28,0.4,0)
menu.config.pcontrol = false
menu:addButton("Targetting","Fire an Airstrike on a target.")
menu:addButton("Surveillance","Observe the Area using the optics of the Airstrike Camera.")

function DrawTextXY(text, settings)
	if settings == nil then
		settings = {}
	end
	if settings.rgba == nil then
		settings.rgba = {255,255,255,255}
	end
	SetTextFont(settings.font or 4)
	SetTextProportional(0)
	SetTextScale(settings.scale or 0.4, settings.scale or 0.4)
	if settings.right then
		SetTextRightJustify(1)
		SetTextWrap(0.0,settings.x or 0.5)
	end
	SetTextColour(settings.rgba[1] or 255, settings.rgba[2] or 255, settings.rgba[3] or 255, settings.rgba[4] or 255)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(settings.centre or 0)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(settings.x or 0.5 , settings.y or 0.5)	
end

function menu:OnMenuOpen()
	targetting = false
	surveillance = false
end

function menu:OnMenuClose()
end

function menu:onButtonSelected(name,btn)
	if name == "Targetting" then
		targetting = true
		menu:Close()
	elseif name == "Surveillance" then
		surveillance = true
		menu:Close()
	end
end

function FireAirstrike(lock,var)
	Citizen.CreateThread(function()
		countdown = true
		countdown_text = 3
		Citizen.Wait(1000)
		countdown_text = 2
		Citizen.Wait(1000)
		countdown_text = 1
		Citizen.Wait(1000)
		countdown = false
		SetFocusArea(pos, 0, 0, 0)
		local ped = GetPlayerPed(-1)
		local veh = GetVehiclePedIsIn(ped, false)
		local pos = GetEntityCoords(veh)
		local height = GetEntityHeightAboveGround(veh)
		SetFocusArea(pos, 0, 0, 0)
		if not HasWeaponAssetLoaded(GetHashKey("VEHICLE_WEAPON_SPACE_ROCKET")) then
			RequestWeaponAsset(GetHashKey("VEHICLE_WEAPON_SPACE_ROCKET"), 31, 0)
			while not HasWeaponAssetLoaded(GetHashKey("VEHICLE_WEAPON_SPACE_ROCKET")) do
				Citizen.Wait(0)
			end
		end
		local offset = GetObjectOffsetFromCoords(pos.x,pos.y,pos.z,heading,0,0,0)
		RequestCollisionAtCoord(offset)
		offset = GetObjectOffsetFromCoords(pos.x,pos.y,pos.z,heading,0,0,0)
		ShootSingleBulletBetweenCoords(offset+vector3(0,0,5), offset, 5000, 0, GetHashKey("VEHICLE_WEAPON_SPACE_ROCKET"), GetPlayerPed(-1), 1, 0, f(9000))
		offset = GetObjectOffsetFromCoords(pos.x,pos.y,pos.z,heading,f(-3),0,0)
		ShootSingleBulletBetweenCoords(offset+vector3(0,0,5), offset, 5000, 0, GetHashKey("VEHICLE_WEAPON_SPACE_ROCKET"), GetPlayerPed(-1), 1, 0, f(9000))
		offset = GetObjectOffsetFromCoords(pos.x,pos.y,pos.z,heading,f(3),0,0)
		ShootSingleBulletBetweenCoords(offset+vector3(0,0,5), offset, 5000, 0, GetHashKey("VEHICLE_WEAPON_SPACE_ROCKET"), GetPlayerPed(-1), 1, 0, f(9000))
		offset = GetObjectOffsetFromCoords(pos.x,pos.y,pos.z,heading,0,f(-3),0)
		ShootSingleBulletBetweenCoords(offset+vector3(0,0,5), offset, 5000, 0, GetHashKey("VEHICLE_WEAPON_SPACE_ROCKET"), GetPlayerPed(-1), 1, 0, f(9000))
		offset = GetObjectOffsetFromCoords(pos.x,pos.y,pos.z,heading,0,f(3),0)
		ShootSingleBulletBetweenCoords(offset+vector3(0,0,5), offset, 5000, 0, GetHashKey("VEHICLE_WEAPON_SPACE_ROCKET"), GetPlayerPed(-1), 1, 0, f(9000))
	end)
end

Citizen.CreateThread(function()
	while true do
		
		Citizen.Wait(0)

		local ped = GetPlayerPed(-1)
		local veh = GetVehiclePedIsIn(ped, false)
		local model = GetEntityModel(veh)
		local displaytext = GetDisplayNameFromVehicleModel(model)

		if IsEntityDead(ped) then
			airstrike = not airstrike
			StopScreenEffect("DeathFailNeutralIn")
			menu:Close()
			local ped = GetPlayerPed(-1)
			FreezeEntityPosition(ped, false)
			SetEntityVisible(ped, true)
			SetEntityCollision(ped, true, 1)
			SetEntityInvincible(ped, false)
			SetPedDiesInWater(ped, 1)
			SetCamActive(cam,false)
			StopCamPointing(cam)
			RenderScriptCams(0,0,0,0,0,0)
			DisplayRadar(true)
			SetFocusEntity(ped)
		end
		if IsControlJustPressed(0, 86) and displaytext == "LAZER" then
			airstrike = not airstrike
			if airstrike then
				menu:Open()
				local ped = GetPlayerPed(-1)
				local pos = GetEntityCoords(ped)
				FreezeEntityPosition(ped, true)
				SetEntityVisible(ped, false, 0)
				SetEntityCollision(ped, false, 0)
				SetEntityInvincible(ped, true)
				SetPedDiesInWater(ped, 0)
				if not DoesCamExist(cam) then
					cam = CreateCam("DEFAULT_SCRIPTED_CAMERA",false)
					AttachCamToEntity(cam, veh, vector3(0,0,-1), true)
					SetCamRot(cam,-f(90),f(180),f(270),2)
					SetCamActive(cam,true)
					StopCamPointing(cam)
					RenderScriptCams(true,true,0,0,0,0)
				else
					AttachCamToEntity(cam, veh, vector3(0,0,-1), true)
					SetCamRot(cam,-f(90),f(180),f(270),2)
					SetCamActive(cam,true)
					StopCamPointing(cam)
					RenderScriptCams(true,true,0,0,0,0)
				end
				targetting = false
				DisplayRadar(false)
				StartScreenEffect("DeathFailNeutralIn",0,true)
			else
				StopScreenEffect("DeathFailNeutralIn")
				menu:Close()
				local ped = GetPlayerPed(-1)
				FreezeEntityPosition(ped, false)
				SetEntityVisible(ped, true)
				SetEntityCollision(ped, true, 1)
				SetEntityInvincible(ped, false)
				SetPedDiesInWater(ped, 1)
				SetCamActive(cam,false)
				StopCamPointing(cam)
				RenderScriptCams(0,0,0,0,0,0)
				DisplayRadar(true)
				SetFocusEntity(ped)
			end
		end
		if airstrike then
			if not HasStreamedTextureDictLoaded("helicopterhud") then
				RequestStreamedTextureDict("helicopterhud")
				while not HasStreamedTextureDictLoaded("helicopterhud") do
					Citizen.Wait(0)
				end
			end
			if not HasStreamedTextureDictLoaded("securitycam") then
				RequestStreamedTextureDict("securitycam")
				while not HasStreamedTextureDictLoaded("securitycam") do
					Citizen.Wait(0)
				end
			end
			if not HasStreamedTextureDictLoaded("crosstheline") then
				RequestStreamedTextureDict("crosstheline")
				while not HasStreamedTextureDictLoaded("crosstheline") do
					Citizen.Wait(0)
				end
			end
			if not menu:isVisible() then
				if countdown then
					DrawTextXY('~r~FIRING IN',{ centre= 1,x = 0.5, y = 0.3, scale = 0.85})
					DrawTextXY('~r~'..countdown_text,{ centre= 1,x = 0.5, y = 0.36, scale = 0.85})
				end
				if targetting or surveillance then
					DrawSprite("helicopterhud", "hud_corner", f(0.1), f(0.1), f(0.015), f(0.02), f(0.0), 255, 255, 255, 255)
					DrawSprite("helicopterhud", "hud_corner", f(0.9), f(0.1), f(0.015), f(0.02), f(90), 255, 255, 255, 255)
					DrawSprite("helicopterhud", "hud_corner", f(0.1), f(0.9), f(0.015), f(0.02), f(270), 255, 255, 255, 255)
					DrawSprite("helicopterhud", "hud_corner", f(0.9), f(0.9), f(0.015), f(0.02), f(180), 255, 255, 255, 255)
					DrawSprite("crosstheline", "timer_largecross_32", f(0.5), f(0.5), f(0.025), f(0.04), f(0.0), 255, 255, 255, 255)
					if not surveillance then
						DrawSprite("helicopterhud", "hud_lock", f(0.5), f(0.5), f(0.06), f(0.09), f(0.0), 255, 255, 255, 255)
					end
					for i = 0,32 do
						if NetworkIsPlayerActive(i) and IsEntityDead(GetPlayerPed(i)) == false then
							local pos = GetEntityCoords(GetPlayerPed(i))
							local b,x,y = N_0xf9904d11f1acbec3(pos.x,pos.y,pos.z)
							if i == PlayerId() then
								if not b then
									DrawTextXY('~b~YOU',{x = x, y = y-0.04, centre = 1})
									DrawSprite("helicopterhud", "hud_lock", f(x), f(y), f(0.025), f(0.035), f(0.0), 50, 155, 255, 255)
								else
									DrawSprite("helicopterhud", "hudarrow", f(x), f(y), f(0.015), f(0.025), f(0.0), 50, 155, 255, 255)
								end
							else
								if not b then
									DrawSprite("helicopterhud", "hud_lock", f(x), f(y), f(0.025), f(0.035), f(0.0), 100, 255, 100, 255)
								else
									DrawSprite("helicopterhud", "hudarrow", f(x), f(y), f(0.015), f(0.025), f(0.0), 100, 255, 100, 255)
								end
							end
						end
					end
				end
				if IsControlJustReleased(2,202) then
					if targetting or surveillance then
						menu:Open()
					else
						airstrike = not airstrike
						StopScreenEffect("DeathFailNeutralIn")
						menu:Close()
						local ped = GetPlayerPed(-1)
						FreezeEntityPosition(ped, false)
						SetEntityVisible(ped, true)
						SetEntityCollision(ped, true, 1)
						SetEntityInvincible(ped, false)
						SetPedDiesInWater(ped, 1)
						SetCamActive(cam,false)
						StopCamPointing(cam)
						RenderScriptCams(0,0,0,0,0,0)
						DisplayRadar(true)
						SetFocusEntity(ped)
					end
				end
				if targetting or surveillance then
					if IsPauseMenuActive() == false then
						local rotation = GetCamRot(cam,2)
						local position = GetCamCoord(cam)
						local heading = rotation.z
						if targetting then
							if IsDisabledControlJustPressed(2,201) or IsDisabledControlJustPressed(2,24) then
								if countdown == false then
									FireAirstrike(false)
								end
							end
						end
					end
				end
			else
			end
		end
	end
end)

Citizen.CreateThread(function()
	local toggled = 0
	while true do
		Citizen.Wait(0)
		local ped = GetPlayerPed(-1)
		local veh = GetVehiclePedIsIn(ped, false)
		local model = GetEntityModel(veh)
		local displaytext = GetDisplayNameFromVehicleModel(model)
		if displaytext ~= "LAZER" then
			SetSeethrough(false)
			SetNightvision(false)
			toggled = 0
		elseif IsControlJustPressed(1,74) and toggled == 0 then --"Night Vision"
			SetSeethrough(false)
			SetNightvision(true)
			toggled = 1
		elseif IsControlJustPressed(1,74) and toggled == 1 then --"Thermal Vision"
			SetNightvision(false)
			SetSeethrough(true)
			toggled = 2
		elseif IsControlJustPressed(1,74) and toggled == 2 then --"Normal Vision"
			SetSeethrough(false)
			SetNightvision(false)
			toggled = 0
		end
	end
end)
