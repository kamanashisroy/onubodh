using aroop;
using shotodol;
using onubodh;

/**
 * \defgroup token Tokenizer module
 */
/**
 * \addtogroup token
 * @{
 */
public class onubodh.TokenModule : ModulePlugin {
	XMLTransformCommand xtrans;
	public override int init() {
		xtrans = new XMLTransformCommand();
		CommandServer.server.cmds.register(xtrans);
		return 0;
	}

	public override int deinit() {
		CommandServer.server.cmds.unregister(xtrans);
		base.deinit();
		return 0;
	}

	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new TokenModule();
	}
}
/** @} */
