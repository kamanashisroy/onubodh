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
		estr edg = estr.set_static_string("edge");
		estr ver = estr.set_static_string("0.0.0");
		base(&edg,&ver);
	}
	public override int init() {
		estr command = estr.set_static_string("command");
		Plugin.register(&command, new M100Extension(new FastEdgeCommand(), this));
		Plugin.register(&command, new M100Extension(new OpencvCannyCommand(), this));
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
