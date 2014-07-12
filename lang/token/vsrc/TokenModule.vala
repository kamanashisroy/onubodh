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
public class onubodh.TokenModule : DynamicModule {
	public override int init() {
		txt command = new txt.from_static("command");
		Plugin.register(command, new M100Extension(new XMLTransformCommand(), this));
		return 0;
	}

	public override int deinit() {
		base.deinit();
		return 0;
	}

	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new TokenModule();
	}
}
/** @} */
