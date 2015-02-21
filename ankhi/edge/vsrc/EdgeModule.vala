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
		extring edg = extring.set_static_string("edge");
		extring ver = extring.set_static_string("0.0.0");
		base(&edg,&ver);
	}
	public override int init() {
		extring command = extring.set_static_string("command");
		PluginManager.register(&command, new M100Extension(new FastEdgeCommand(), this));
		PluginManager.register(&command, new M100Extension(new OpencvCannyCommand(), this));
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
