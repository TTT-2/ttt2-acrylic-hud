local blur_hud, blur_base

HUD.voicePaint = function(s, w, h)
	if not IsValid(s.ply) then return end

	if not hudelements or not huds then return end

	blur_hud = blur_hud or huds.GetStored("acrylic")
	blur_base = blur_base or hudelements.GetStored("acrylic_element")

	if not blur_hud or not blur_base then return end

	if not blur_hud.basecolor then return end

	blur_base:DrawBg(0, 0, w, h, {r = s.Color.r, g = s.Color.g, b = s.Color.b, a = blur_hud.basecolor.a})
	blur_base:DrawLines(0, 0, w, h)
end
