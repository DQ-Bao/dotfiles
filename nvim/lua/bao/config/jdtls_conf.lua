local function get_jdtls()
	local mason_registry = require("mason-registry")
	local jdtls = mason_registry.get_package("jdtls")
	local jdtls_path = vim.fn.fnamemodify(jdtls:get_install_path(), ":p")
	-- Obtain the path to the jar which runs the language server
	local launcher = vim.fn.glob(jdtls_path .. "plugins/org.eclipse.equinox.launcher_*.jar")
	local config = jdtls_path .. "config_win"
	local lombok = jdtls_path .. "lombok.jar"
	return launcher, config, lombok
end

local function get_workspace()
	local home = os.getenv("HOME")
	local workspace_path = home .. "/dev/java_workspace/"
	local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
	local workspace_dir = workspace_path .. project_name
	return workspace_dir
end

local function get_bundles()
	local bundles = {}
	return bundles
end

local function java_keymaps()
	-- Allow yourself to run JdtCompile as a Vim command
	vim.cmd(
		"command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)"
	)
	-- Allow yourself/register to run JdtUpdateConfig as a Vim command
	vim.cmd("command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()")
	-- Allow yourself/register to run JdtBytecode as a Vim command
	vim.cmd("command! -buffer JdtBytecode lua require('jdtls').javap()")
	-- Allow yourself/register to run JdtShell as a Vim command
	vim.cmd("command! -buffer JdtJshell lua require('jdtls').jshell()")

	local map = vim.keymap.set
	local telescope = require("telescope.builtin")

	-- Copy from lspconfig configuration
	map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Code rename" })
	map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
	map("n", "gd", vim.lsp.buf.definition, { desc = "Code go to definition" })
	map("n", "gi", telescope.lsp_implementations, { desc = "Code go to implementations" })
	map("n", "gr", telescope.lsp_references, { desc = "Code go to references" })
	map("n", "K", vim.lsp.buf.hover, { desc = "Code hover" })
	-- Java specific keymaps
	map("n", "<leader>jo", "<cmd> lua require('jdtls').organize_imports()<cr>", { desc = "Java Organize Imports" })
	map("n", "<leader>jv", "<Cmd> lua require('jdtls').extract_variable()<cr>", { desc = "Java Extract Variable" })
	map(
		"v",
		"<leader>jv",
		"<esc><cmd> lua require('jdtls').extract_variable(true)<cr>",
		{ desc = "Java Extract Variable" }
	)
	map("n", "<leader>jc", "<cmd> lua require('jdtls').extract_constant()<cr>", { desc = "Java Extract Constant" })
	map(
		"v",
		"<leader>jc",
		"<esc><cmd> lua require('jdtls').extract_constant(true)<cr>",
		{ desc = "Java Extract Constant" }
	)
	map("n", "<leader>ju", "<cmd> JdtUpdateConfig<cr>", { desc = "Java Update Config" })
end

local function setup_jdtls()
	local jdtls = require("jdtls")
	local launcher, os_config, lombok = get_jdtls()
	local workspace_dir = get_workspace()
	local bundles = get_bundles()
	local root_dir = vim.fn
		.fnamemodify(jdtls.setup.find_root({ "mvnw", "gradlew", "pom.xml", "build.gradle" }), ":p")
		:gsub("\\", "/")
	local capabilities = {
		workspace = {
			configuration = true,
			didChangeWatchedFiles = { dynamicRegistration = false },
		},
		textDocument = {
			completion = {
				snippetSupport = false,
			},
		},
	}
	local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

	for k, v in pairs(lsp_capabilities) do
		capabilities[k] = v
	end

	local extendedClientCapabilities = jdtls.extendedClientCapabilities
	extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

	local cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xmx1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-javaagent:" .. lombok,
		"-jar",
		launcher,
		"-configuration",
		os_config,
		"-data",
		workspace_dir,
	}

	local settings = {
		java = {
			-- Enable code formatting
			format = {
				enabled = true,
				-- Use the Google Style guide for code formattingh
				settings = {
					url = "file:///" .. vim.fn.stdpath("config") .. "/lang_servers/palantir-java-style.xml",
					profile = "PalantirStyle",
				},
			},
			-- Enable downloading archives from eclipse automatically
			eclipse = {
				downloadSource = true,
			},
			-- Enable downloading archives from maven automatically
			maven = {
				downloadSources = true,
			},
			-- Enable method signature help
			signatureHelp = {
				enabled = true,
			},
			-- Use the fernflower decompiler when using the javap command to decompile byte code back to java code
			contentProvider = {
				preferred = "fernflower",
			},
			-- Setup automatical package import oranization on file save
			saveActions = {
				organizeImports = true,
			},
			-- Customize completion options
			completion = {
				-- When using an unimported static method, how should the LSP rank possible places to import the static method from
				favoriteStaticMembers = {
					"org.hamcrest.MatcherAssert.assertThat",
					"org.hamcrest.Matchers.*",
					"org.hamcrest.CoreMatchers.*",
					"org.junit.jupiter.api.Assertions.*",
					"java.util.Objects.requireNonNull",
					"java.util.Objects.requireNonNullElse",
					"org.mockito.Mockito.*",
				},
				-- Try not to suggest imports from these packages in the code action window
				filteredTypes = {
					"com.sun.*",
					"io.micrometer.shaded.*",
					"java.awt.*",
					"jdk.*",
					"sun.*",
				},
				-- Set the order in which the language server should organize imports
				importOrder = {
					"java",
					"jakarta",
					"javax",
					"com",
					"org",
				},
			},
			sources = {
				-- How many classes from a specific package should be imported before automatic imports combine them all into a single import
				organizeImports = {
					starThreshold = 9999,
					staticThreshold = 9999,
				},
			},
			-- How should different pieces of code be generated?
			codeGeneration = {
				-- When generating toString use a json format
				toString = {
					template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
				},
				-- When generating hashCode and equals methods use the java 7 objects method
				hashCodeEquals = {
					useJava7Objects = true,
				},
				-- When generating code use code blocks
				useBlocks = true,
			},
			-- If changes to the project will require the developer to update the projects configuration advise the developer before accepting the change
			configuration = {
				updateBuildConfiguration = "interactive",
				runtimes = {
					{
						name = "JavaSE-17",
						path = "c:/Program Files/Java/jdk-17",
					},
					{
						name = "JavaSE-21",
						path = "c:/Program Files/Java/jdk-21",
					},
				},
			},
			-- enable code lens in the lsp
			referencesCodeLens = {
				enabled = false,
			},
			-- enable inlay hints for parameter names,
			inlayHints = {
				parameterNames = {
					enabled = "all",
				},
			},
		},
	}

	local init_options = {
		bundles = bundles,
		extendedClientCapabilities = extendedClientCapabilities,
	}

	local function on_init(client)
		if client.config.settings then
			client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
		end
	end

	local function on_attach(_, _)
		java_keymaps()
		-- Enable jdtls commands to be used in Neovim
		require("jdtls.setup").add_commands()
	end

	local config = {
		cmd = cmd,
		root_dir = root_dir,
		settings = settings,
		capabilities = capabilities,
		init_options = init_options,
		on_init = on_init,
		on_attach = on_attach,
	}

	require("jdtls").start_or_attach(config)
end

return {
	setup_jdtls = setup_jdtls,
}
