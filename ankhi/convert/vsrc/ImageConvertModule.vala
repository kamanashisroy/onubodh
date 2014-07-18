using aroop;
using shotodol;

/**
 * \addtogroup imgconvert 
 * @{
 */
class onubodh.ImageConvertModule : DynamicModule {
	ImageConvertModule() {
		estr nm = estr.set_static_string("convert");
		estr ver = estr.set_static_string("0.0.0");
		base(&nm,&ver);
	}
	public override int init() {
		estr command = estr.set_static_string("command");
		Plugin.register(&command, new M100Extension(new ImageConvertCommand(), this));
		return 0;
	}

	public override int deinit() {
		base.deinit();
		return 0;
	}

	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new ImageConvertModule();
	}
}
/** @} */
