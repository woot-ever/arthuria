function OnBlobUnMount(blob, mounter)
	print(blob:GetFactoryName())
	print(blob:GetConfigFileName())
	print(blob:GetType())
	return 1
end