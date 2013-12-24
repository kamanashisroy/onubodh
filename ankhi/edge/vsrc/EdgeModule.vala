using aroop;
using shotodol;
using onubodh;

public class onubodh.EdgeModule : ModulePlugin {
	FastEdgeCommand fe;
	public override int init() {
		fe = new FastEdgeCommand();
		CommandServer.server.cmds.register(fe);
		return 0;
	}

	public override int deinit() {
		CommandServer.server.cmds.unregister(fe);
		base.deinit();
		return 0;
	}

	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new EdgeModule();
	}
}
