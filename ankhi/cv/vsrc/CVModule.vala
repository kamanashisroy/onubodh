using aroop;
using shotodol;

public class shotodol.CVModule : ModulePlugin {
	FastEdgeCVCommand fe;
	KmeansCVCommand km;
	CentroidModelCVCommand cm;
	public override int init() {
		fe = new FastEdgeCVCommand();
		km = new KmeansCVCommand();
		cm = new CentroidModelCVCommand();
		CommandServer.server.cmds.register(fe);
		CommandServer.server.cmds.register(km);
		CommandServer.server.cmds.register(cm);
		return 0;
	}

	public override int deinit() {
		CommandServer.server.cmds.unregister(fe);
		CommandServer.server.cmds.unregister(km);
		CommandServer.server.cmds.unregister(cm);
		base.deinit();
		return 0;
	}

	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new CVModule();
	}
}
