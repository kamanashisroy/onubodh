using aroop;
using shotodol;

/**
 * \addtogroup imgdiff
 * @{
 */
class onubodh.ImageDiffModule : DynamicModule {
	ImageDiffModule() {
		estr md = estr.set_static_string("imgdiff");
		estr ver = estr.set_static_string("0.0.0");
		base(&md,&ver);
	}
	
	public override int init() {
		estr command = estr.set_static_string("command");
		Plugin.register(&command, new M100Extension(new ImageDiffCommand(), this));
		Plugin.register(&command, new M100Extension(new ImagePatchCommand(), this));
		return 0;
	}

	public override int deinit() {
		base.deinit();
		return 0;
	}

	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new ImageDiffModule();
	}
}
/** @} */
