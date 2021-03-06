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
	ImageScaleModule() {
		extring modnm = extring.set_static_string("command");
		extring ver = extring.set_static_string("0.0.0");
		base(&modnm, &ver);
	}
	public override int init() {
		extring command = extring.set_static_string("command");
		PluginManager.register(&command, new M100Extension(new ImageScaleCommand(), this));
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
