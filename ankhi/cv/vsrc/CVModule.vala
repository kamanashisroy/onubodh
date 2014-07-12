using aroop;
using shotodol;
using onubodh;

/**
 * \addtogroup bookdetect
 * @{
 */
public class onubodh.CVModule : DynamicModule {
	public CVModule() {
		name = etxt.from_static("cv");
	}
	public override int init() {
		txt command = new txt.from_static("command");
		Plugin.register(command, new M100Extension(new KmeansCVCommand(), this));
		Plugin.register(command, new M100Extension(new CentroidModelCVCommand(), this));
		Plugin.register(command, new M100Extension(new BookDetectCommand(), this));
		Plugin.register(command, new M100Extension(new StructureDetectCommand(), this));
		Plugin.register(command, new M100Extension(new BarcodeROIDetectCommand(), this));
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
