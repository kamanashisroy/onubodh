using aroop;
using shotodol;
using onubodh;

/**
 * \addtogroup bookdetect
 * @{
 */
public class onubodh.CVModule : DynamicModule {
	public CVModule() {
		extring nm = extring.set_static_string("cv");
		extring ver = extring.set_static_string("0.0.0");
		base(&nm,&ver);
	}
	public override int init() {
		extring command = extring.set_static_string("command");
		PluginManager.register(&command, new M100Extension(new KmeansCVCommand(), this));
		PluginManager.register(&command, new M100Extension(new CentroidModelCVCommand(), this));
		PluginManager.register(&command, new M100Extension(new BookDetectCommand(), this));
		PluginManager.register(&command, new M100Extension(new StructureDetectCommand(), this));
		PluginManager.register(&command, new M100Extension(new BarcodeROIDetectCommand(), this));
		return 0;
	}

	public override int deinit() {
		base.deinit();
		return 0;
	}

	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new CVModule();
	}
}
/** @} */
