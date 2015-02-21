using aroop;
using shotodol;

/**
 * \addtogroup imgdiff
 * @{
 */
public class onubodh.ImageDiffModule : DynamicModule {
	ImageDiffModule() {
		extring md = extring.set_static_string("imgdiff");
		extring ver = extring.set_static_string("0.0.0");
		base(&md,&ver);
	}
	
	public override int init() {
		extring command = extring.set_static_string("command");
		PluginManager.register(&command, new M100Extension(new ImageDiffCommand(), this));
		PluginManager.register(&command, new M100Extension(new ImagePatchCommand(), this));
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
