using aroop;
using shotodol;

/**
 * \addtogroup imgconvert 
 * @{
 */
public class onubodh.ImageConvertModule : ModulePlugin {
	ImageConvertCommand cmd;
	public override int init() {
		cmd = new ImageConvertCommand();
		CommandServer.server.cmds.register(cmd);
		return 0;
	}

	public override int deinit() {
		CommandServer.server.cmds.unregister(cmd);
		base.deinit();
		return 0;
	}

	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new ImageConvertModule();
	}
}
/** @} */
