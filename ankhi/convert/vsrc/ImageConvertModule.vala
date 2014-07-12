using aroop;
using shotodol;

/**
 * \addtogroup imgconvert 
 * @{
 */
public class onubodh.ImageConvertModule : DynamicModule {
	public ImageConvertModule() {
		name = etxt.from_static("convert");
	}
	public override int init() {
		txt command = new txt.from_static("command");
		Plugin.register(command, new M100Extension(new ImageConvertCommand(), this));
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
