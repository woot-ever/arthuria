function OnPlayerHit(pVictim, attacker, damage)
	--local health = pVictim:GetHealth()
	--health = health - (damage / 2)
	--pVictim:SetHealth(health)
	
	if (not pVictim or not attacker) then return damage end
	local id = attacker:GetID()
	local e = ENTITIES[id]
	if (e) then
		return (e.damage or e.type.damage or damage or 0) / (pVictim:GetNumber("base_defense") or 1)
	end
	return damage
end
