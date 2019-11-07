local base = "acrylic_element"

HUDELEMENT.Base = base

HUDELEMENT.togglable = true

DEFINE_BASECLASS(base)

if CLIENT then
	local material_no_team = Material("vgui/ttt/dynamic/roles/icon_no_team")
	local material_watching = Material("vgui/ttt/watching_icon")

	local const_defaults = {
		basepos = {x = 0, y = 0},
		size = {w = 60, h = 60},
		minsize = {w = 0, h = 0}
	}

	function HUDELEMENT:PreInitialize()
		hudelements.RegisterChildRelation(self.id, "acrylic_roundinfo", false)
	end

	function HUDELEMENT:Initialize()
		self.parentInstance = hudelements.GetStored(self.parent)
		self.scale = 1.0
		self.basecolor = self:GetHUDBasecolor()

		BaseClass.Initialize(self)
	end

	-- parameter overwrites
	function HUDELEMENT:ShouldDraw()
		return GAMEMODE.round_state == ROUND_ACTIVE
	end

	function HUDELEMENT:InheritParentBorder()
		return true
	end
	-- parameter overwrites end

	function HUDELEMENT:GetDefaults()
		return const_defaults
	end

	function HUDELEMENT:PerformLayout()
		local parent_pos = self.parentInstance:GetPos()
		local parent_size = self.parentInstance:GetSize()
		local parent_defaults = self.parentInstance:GetDefaults()
		local h = parent_size.h
		local w = const_defaults.size.w * h / const_defaults.size.h

		self.basecolor = self:GetHUDBasecolor()
		self.scale = h / parent_defaults.size.h

		self:SetPos(parent_pos.x - w - 5 * self.scale, parent_pos.y)
		self:SetSize(w, h)

		BaseClass.PerformLayout(self)
	end

	function HUDELEMENT:Draw()
		local client = LocalPlayer()
		local pos = self:GetPos()
		local size = self:GetSize()
		local x, y = pos.x, pos.y
		local w, h = size.w, size.h

		-- draw team icon
		local team = client:GetTeam()
		local tm = TEAMS[team]

		local iconSize = h - self.padding
		local icon, c

		if LocalPlayer():Alive() and LocalPlayer():IsTerror() then
			if (team == TEAM_NONE or not tm or tm.alone) then -- support roles without a team
				icon = material_no_team
				c = self.basecolor
			else -- normal role
				icon = tm.iconMaterial
				c = tm.color or Color(0, 0, 0, 255)
			end
		else -- player is dead and spectator
			icon = material_watching
			c = self.basecolor
		end

		self:DrawBg(x, y, w, h, {r = c.r, g = c.g, b = c.b, a = self.basecolor.a})
		self:DrawLines(x, y, w, h)

		if icon then
			draw.FilteredShadowedTexture(x + self.padding * 0.5, y + self.padding * 0.5, iconSize, iconSize, icon, 255, COLOR_WHITE, self.scale)
		end
	end
end
