local js_react = {}

function js_react.plugins(use)
	use("MaxMEllon/vim-jsx-pretty")
end

local js = require("languages.javascript")
js_react.setup = js.setup
js_react.bindings = js.bindings

return js_react
