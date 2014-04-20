using aroop;
using shotodol;

/**
 * \addtogroup imgdiff
 * @{
 */
public class onubodh.ImageDiffModule : ModulePlugin {
	ImageDiffCommand cmd;
	ImagePatchCommand pcmd;
	public override int init() {
		cmd = new ImageDiffCommand();
		pcmd = new ImagePatchCommand();
		CommandServer.server.cmds.register(cmd);
		CommandServer.server.cmds.register(pcmd);
		return 0;
	}

	public override int deinit() {
		CommandServer.server.cmds.unregister(cmd);
		CommandServer.server.cmds.unregister(pcmd);
		base.deinit();
		return 0;
	}

	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new ImageDiffModule();
	}
}
/** @} */
