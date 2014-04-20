using aroop;
using shotodol;

/**
 * \ingroup ankhi
 * \defgroup imgscale Image Scaling module
 */
/**
 * \addtogroup imgscale
 * @{
 */
public class onubodh.ImageScaleModule : ModulePlugin {
	ImageScaleCommand cmd;
	public override int init() {
		cmd = new ImageScaleCommand();
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
		return new ImageScaleModule();
	}
}
/** @} */
