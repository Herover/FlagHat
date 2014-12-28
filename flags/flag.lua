ITEM.Name = 'Flag Hat'
ITEM.Price = 1000
ITEM.Model = 'models/extras/info_speech.mdl'
ITEM.NoPreview = true

local flagAsp = 11/16 -- Most flags seem to have theese proportions
                      -- TODO: figure this out dynamically
local flagFolder = "flags16/"
local defaultFlag = "europeanunion"

function ITEM:OnEquip(ply, modifications)
	if modifications.ccode == nil then
		modifications.ccode = defaultFlag
	end
end

function ITEM:FigureFlag()
	if file.Exists( "materials/" .. flagFolder .. string.lower(system.GetCountry( )) .. ".png", "GAME" ) then
		return string.lower(system.GetCountry( ))
	else
		return defaultFlag
	end
end

--function ITEM:PlayerSpawn(ply, modifications)
--	print("spawn")
--	ply.matFlag = nil
--end

function ITEM:PostPlayerDraw(ply, modifications, ply2)
	if not ply == ply2 then return end
	if not ply:Alive() then return end
	if ply.IsSpec and ply:IsSpec() then return end
	if ply.matFlag == nil or modifications.ccode == nil or !(ply.matFlag:GetName() == flagFolder .. modifications.ccode) then 
		print("Pre reset: ")
		PrintTable(modifications)
		if ply.matFlag == nil then print("matFlag is nil")
		else print("Invalidated flag")
		end
		if modifications.ccode == nil then
			print("PostPlayerDraw: Figure flag -- THIS IS BAD" )
			modifications.ccode = defaultFlag
		end
		ply.matFlag = Material( flagFolder .. modifications.ccode .. ".png", "" )
		ply.FlagCC = modifications.ccode
		--end
		print("Flag is " .. ply.matFlag:GetName())
		

		for k, v in pairs( player.GetAll() ) do
			print("FlagHat: Invalidating no." .. k)
			--v.matFlag = nil
			if !v.FlagCC == nil then
				p.matFlag = Material( flagFolder .. p.FlagCC .. ".png", "" )
				print( v.FlagCC )
			end
		end
		
	end
	
	local offset = Vector(0, 0, 79)
	local ang = LocalPlayer():EyeAngles()
	local pos = ply:GetPos() + offset + ang:Up()
	
	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), 90)
	
	cam.Start3D2D(pos, Angle(0, ang.y, 90), 0.1)
		surface.SetMaterial( ply.matFlag )
		surface.SetDrawColor( 255, 255, 255, 200 )
		surface.DrawTexturedRect(-25, 50, 175, 175 * flagAsp)
	cam.End3D2D()
end

function ITEM:Modify(modifications)
	local FlagPanel = vgui.Create( "DPanel" )
	FlagPanel:SetPos( ScrW( )/2 - 50, 30 )
	FlagPanel:SetSize( 200, 220 )

	local FlagLabel = vgui.Create( "DLabel", FlagPanel )
	FlagLabel:SetPos( 10, 10 )
	FlagLabel:SetText( "Select a flag" )
	FlagLabel:SizeToContents()
	FlagLabel:SetDark( 1 ) -- Set the colour of the text inside the label to a darker one
	local FlagHolder = vgui.Create( "DScrollPanel", FlagPanel )
	FlagHolder:SetPos( 10, 30 )
	FlagHolder:SetSize( 180, 180 )
	local files, directories = file.Find( "materials/" .. flagFolder .. "*", "GAME" )
	local flagW = 32
	local flagH = 32*flagAsp
	local eachRow = 5
	for k, v in pairs(files) do 
		local FlagImg = vgui.Create( "DImageButton", FlagHolder )
		FlagImg:SetPos((k % eachRow) * flagW, math.floor(k/eachRow) * flagH)
		FlagImg:SetSize( flagW, flagH )
		FlagImg:SetImage( flagFolder .. v )
		FlagImg.DoClick = function()
			modifications.ccode = string.Split(v, ".")[1]
			print( "Click: " .. v .. modifications.ccode)
			PS:SendModifications(self.ID, modifications)
			FlagPanel:Remove()
		end
	end
end
