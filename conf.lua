configuration = {}
configuration.debugBoundingBox = false

function love.conf(t)
	t.title = "Viking Runner"
	t.window.width = 1280
	t.window.height = 720
	t.window.fullscreen = false
  t.modules.physics = false
end