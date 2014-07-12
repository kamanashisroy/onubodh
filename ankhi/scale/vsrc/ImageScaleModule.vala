using aroop;
using shotodol;

/**
 * \ingroup ankhi
 * \defgroup imgscale Image Scaling module
 */
/**
 * \addtogroup imgscale
 * @{
 */
public class onubodh.ImageScaleModule : DynamicModule {
	public override int init() {
		txt command = new txt.from_static("command");
		Plugin.register(command, new M100Extension(new ImageScaleCommand(), this));
		return 0;
	}

	public override int deinit() {
		base.deinit();
		return 0;
	}

	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new ImageScaleModule();
	}
}
/** @} */
