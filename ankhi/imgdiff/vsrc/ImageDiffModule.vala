using aroop;
using shotodol;

/**
 * \addtogroup imgdiff
 * @{
 */
public class onubodh.ImageDiffModule : DynamicModule {
	public override int init() {
		txt command = new txt.from_static("command");
		Plugin.register(command, new M100Extension(new ImageDiffCommand(), this));
		Plugin.register(command, new M100Extension(new ImagePatchCommand(), this));
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
