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
class onubodh.ImageScaleModule : DynamicModule {
	public ImageScaleModule() {
		estr modnm = estr.set_static_string("command");
		estr ver = estr.set_static_string("0.0.0");
		base(&modnm, &ver);
	}
	public override int init() {
		estr command = estr.set_static_string("command");
		Plugin.register(&command, new M100Extension(new ImageScaleCommand(), this));
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
