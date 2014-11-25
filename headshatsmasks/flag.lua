ITEM.Name = 'Flag Hat'
ITEM.Price = 1000
ITEM.Model = 'models/extras/info_speech.mdl'
ITEM.NoPreview = true

local flagAsp = 11/16 -- Most flags seem to have theese proportions
                      -- TODO: figure this out dynamically
local flagFolder = "flags16/"
local matFlag = nil

function ITEM:OnEquip(ply, modifications) --IsValid(modifications.ccode) andstring.lower(system.GetCountry( ))
	if file.Exists( "materials/" .. flagFolder .. string.lower(system.GetCountry( )) .. ".png", "GAME" ) then
		matFlag = Material( flagFolder .. string.lower(system.GetCountry( )) .. ".png", "" )
	end
	--print( modifications.ccode, flagFolder .. string.lower(system.GetCountry( )) .. ".png", IsValid( matFlag ) )
end

function ITEM:PostPlayerDraw(ply, modifications, ply2)
	if matFlag == nil then 
		--if file.Exists( "materials/" .. flagFolder .. modifications.ccode .. ".png", "GAME" ) then
		--	PS:SendModifications(self.ID, modifications)
		--	matFlag = Material( flagFolder .. string.lower(system.GetCountry( )) .. ".png", "" )
		--else
			matFlag = Material( flagFolder .. "europeanunion.png", "" )
		--end
		print("Something happened, and I had to set flag in PostPlayerDraw")
	end
	if not ply == ply2 then return end
	if not ply:Alive() then return end
	if ply.IsSpec and ply:IsSpec() then return end
	
	local offset = Vector(0, 0, 79)
	local ang = LocalPlayer():EyeAngles()
	local pos = ply:GetPos() + offset + ang:Up()
	
	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), 90)
	
	cam.Start3D2D(pos, Angle(0, ang.y, 90), 0.1)
		surface.SetMaterial( matFlag )
		surface.DrawTexturedRect(-25, 50, 50, 50 * flagAsp)
	cam.End3D2D()
end

function ITEM:Modify(modifications)
	PrintTable(modifications)
	modifications.ccode = string.lower(system.GetCountry( ))
	PS:SendModifications(self.ID, modifications)
	matFlag = Material( flagFolder .. string.lower(system.GetCountry( )) .. ".png", "" )
end
