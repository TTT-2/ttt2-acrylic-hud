local blur_hud

HUD.voicePaint = function(s, w, h)
	if not IsValid(s.ply) then return end

	if not hudelements then return end

	blur_hud = blur_hud or hudelements.GetStored("acrylic_element")

	if not blur_hud then return end

	-- TODO basecolor is never defined?
	if not blur_hud.basecolor then return end

	blur_hud:DrawBg(0, 0, w, h, {r = s.Color.r, g = s.Color.g, b = s.Color.b, a = blur_hud.basecolor.a})
	blur_hud:DrawLines(0, 0, w, h)
end
