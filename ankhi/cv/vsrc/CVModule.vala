using aroop;
using shotodol;

public class shotodol.CVModule : Module {
	CVCommand cmd;
	public override int init() {
		// TODO fillme
		cmd = new CVCommand();
		CommandServer.server.cmds.register(cmd);
		return 0;
	}

	public override int deinit() {
		// TODO fillme
		CommandServer.server.cmds.unregister(cmd);
		return 0;
	}

	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new CVModule();
	}
}
