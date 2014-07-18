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
class onubodh.TokenModule : DynamicModule {
	TokenModule() {
		estr nm = estr.set_static_string("string token");
		estr ver = estr.set_static_string("0.0.0");
		base(&nm,&ver);
	}
	
	public override int init() {
		estr command = estr.set_static_string("command");
		Plugin.register(&command, new M100Extension(new XMLTransformCommand(), this));
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
