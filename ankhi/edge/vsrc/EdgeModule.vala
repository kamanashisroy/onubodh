using aroop;
using shotodol;
using onubodh;

/**
 * \ingroup ankhi
 * \defgroup edgedetect Edge Detecting Module
 */
/**
 * \addtogroup edgedetect
 * @{
 */
public class onubodh.EdgeModule : DynamicModule {
	public EdgeModule() {
		name = etxt.from_static("edge");
	}
	public override int init() {
		txt command = new txt.from_static("command");
		Plugin.register(command, new M100Extension(new FastEdgeCommand(), this));
		Plugin.register(command, new M100Extension(new OpencvCannyCommand(), this));
		return 0;
	}

	public override int deinit() {
		base.deinit();
		return 0;
	}

	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new EdgeModule();
	}
}
/** @} */
