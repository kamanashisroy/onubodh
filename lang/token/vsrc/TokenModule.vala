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
	TokenModule() {
		extring nm = extring.set_static_string("string token");
		extring ver = extring.set_static_string("0.0.0");
		base(&nm,&ver);
	}
	
	public override int init() {
		extring command = extring.set_static_string("command");
		PluginManager.register(&command, new M100Extension(new XMLTransformCommand(), this));
		extring test = extring.set_static_string("unittest");
		PluginManager.register(&test, new AnyInterfaceExtension(new XMLTransformTest(), this));
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
