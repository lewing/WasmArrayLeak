
var Module = {
	//TOTAL_MEMORY: 268435456,
	onRuntimeInitialized: function () {
		MONO.mono_load_runtime_and_bcl (
		config.vfs_prefix,
		config.deploy_prefix,
		config.enable_debugging,
		config.file_list,
		function () {
			config.add_bindings ();
			App.init ();
		}
	)
	},
};