ITEM.Name = 'Flag Hat'
ITEM.Price = 1000
ITEM.Model = 'models/extras/info_speech.mdl'
ITEM.NoPreview = true

local flagAsp = 11/16 -- Most flags seem to have theese proportions
                      -- TODO: figure this out dynamically
local flagFolder = "flags16/"
local matFlag = nil

function ITEM:OnEquip(ply, modifications) --IsValid(modifications.ccode) andstring.lower(system.GetCountry( ))
	--if modifications.ccode == nil then
	--	modifications.ccode = self:FigureFlag()
	--	print("OnEquip: Figure flag" )
	--end
	--print( "OnEquip: " .. modifications.ccode )
	-- PS:SendModifications(self.ID, modifications)
end

function ITEM:FigureFlag()
	if file.Exists( "materials/" .. flagFolder .. string.lower(system.GetCountry( )) .. ".png", "GAME" ) then
		return string.lower(system.GetCountry( ))
	else
		return "europeanunion"
	end
end

function ITEM:PostPlayerDraw(ply, modifications, ply2)
	if not ply == ply2 then return end
	if not ply:Alive() then return end
	if ply.IsSpec and ply:IsSpec() then return end
	if ply.matFlag == nil or !string.find(ply.matFlag:GetName(), modifications.ccode .. ".png") then 
		--if file.Exists( "materials/" .. flagFolder .. modifications.ccode .. ".png", "GAME" ) then
		--	PS:SendModifications(self.ID, modifications)
		--	matFlag = Material( flagFolder .. string.lower(system.GetCountry( )) .. ".png", "" )
		--else
		print("Pre reset: ")
		PrintTable(modifications)
		print(".")
		if modifications.ccode == nil then
			print("PostPlayerDraw: Figure flag" )
			modifications.ccode = self:FigureFlag()
		end
		ply.matFlag = Material( flagFolder .. modifications.ccode .. ".png", "" )
		--end
		print("Something happened, and I had to set flag in PostPlayerDraw " .. modifications.ccode)
	end
	
	local offset = Vector(0, 0, 79)
	local ang = LocalPlayer():EyeAngles()
	local pos = ply:GetPos() + offset + ang:Up()
	
	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), 90)
	
	cam.Start3D2D(pos, Angle(0, ang.y, 90), 0.1)
		surface.SetMaterial( ply.matFlag )
		surface.DrawTexturedRect(-25, 50, 50, 50 * flagAsp)
	cam.End3D2D()
end

function ITEM:PlayerSpawn(ply)
	ply.matFlag = nil
    ply:PS_Notify('You have respawned!')
end

function ITEM:Modify(modifications)
	local FlagPanel = vgui.Create( "DPanel" )
	FlagPanel:SetPos( 10, 30 ) -- Set the position of the panel
	FlagPanel:SetSize( 200, 200 ) -- Set the size of the panel

	local FlagLabel = vgui.Create( "DLabel", FlagPanel )
	FlagLabel:SetPos( 10, 10 ) -- Set the position of the label
	FlagLabel:SetText( "Select a flag" ) -- Set the text of the label
	FlagLabel:SizeToContents() -- Size the label to fit the text in it
	FlagLabel:SetDark( 1 ) -- Set the colour of the text inside the label to a darker one
	local FlagHolder = vgui.Create( "DGrid", FlagPanel )
	FlagHolder:SetPos( 10, 30 )
	FlagHolder:SetSize( 180, 180 )
	FlagHolder:SetColWide( 32 )
	FlagHolder:SetVerticalScrollbarEnabled( ) 
	local files, directories = file.Find( "materials/" .. flagFolder .. "*", "GAME" )
	for k, v in pairs(files) do 
		local FlagImg = vgui.Create( "DImageButton" )
		FlagImg:SetSize( 32, 32*flagAsp )
		FlagImg:SetImage( flagFolder .. v )
		FlagImg.DoClick = function()
			modifications.ccode = string.Split(v, ".")[1]
			print( "Click: " .. v .. modifications.ccode)
			PS:SendModifications(self.ID, modifications)
			--ply.matFlag = nil
			FlagPanel:Remove()
		end
		FlagHolder:AddItem( FlagImg )
	end
	
	--PrintTable(modifications)
	--if not IsValid(modifications.ccode) then
	--	modifications.ccflag = self:FigureFlag()
	--end
	--print( modifications.ccode )
	--PS:SendModifications(self.ID, modifications)
	--matFlag = Material( flagFolder .. string.lower(system.GetCountry( )) .. ".png", "" )
end
