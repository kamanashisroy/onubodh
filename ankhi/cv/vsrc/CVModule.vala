using aroop;
using shotodol;
using onubodh;

/**
 * \addtogroup bookdetect
 * @{
 */
public class onubodh.CVModule : ModulePlugin {
	KmeansCVCommand km;
	CentroidModelCVCommand cm;
	BookDetectCommand ss;
	public override int init() {
		km = new KmeansCVCommand();
		cm = new CentroidModelCVCommand();
		ss = new BookDetectCommand();
		CommandServer.server.cmds.register(km);
		CommandServer.server.cmds.register(cm);
		CommandServer.server.cmds.register(ss);
		return 0;
	}

	public override int deinit() {
		CommandServer.server.cmds.unregister(km);
		CommandServer.server.cmds.unregister(cm);
		CommandServer.server.cmds.unregister(ss);
		base.deinit();
		return 0;
	}

	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new CVModule();
	}
}
/** @} */
