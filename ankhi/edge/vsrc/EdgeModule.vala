using aroop;
using shotodol;
using onubodh;

public class onubodh.EdgeModule : ModulePlugin {
	FastEdgeCommand fe;
	OpencvCannyCommand cn;
	public override int init() {
		fe = new FastEdgeCommand();
		cn = new OpencvCannyCommand();
		CommandServer.server.cmds.register(fe);
		CommandServer.server.cmds.register(cn);
		return 0;
	}

	public override int deinit() {
		CommandServer.server.cmds.unregister(fe);
		CommandServer.server.cmds.unregister(cn);
		base.deinit();
		return 0;
	}

	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new EdgeModule();
	}
}
