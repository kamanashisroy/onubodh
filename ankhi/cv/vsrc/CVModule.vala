using aroop;
using shotodol;
using onubodh;

/**
 * \addtogroup bookdetect
 * @{
 */
public class onubodh.CVModule : ModulePlugin {
	KmeansCVCommand km;
	CentroidModelCVCommand cm;
	StructureDetectCommand std;
	BookDetectCommand ss;
	BarcodeROIDetectCommand barc;
	public override int init() {
		km = new KmeansCVCommand();
		cm = new CentroidModelCVCommand();
		ss = new BookDetectCommand();
		std = new StructureDetectCommand();
		barc = new BarcodeROIDetectCommand();
		CommandServer.server.cmds.register(km);
		CommandServer.server.cmds.register(cm);
		CommandServer.server.cmds.register(ss);
		CommandServer.server.cmds.register(std);
		CommandServer.server.cmds.register(barc);
		return 0;
	}

	public override int deinit() {
		CommandServer.server.cmds.unregister(km);
		CommandServer.server.cmds.unregister(cm);
		CommandServer.server.cmds.unregister(ss);
		CommandServer.server.cmds.unregister(std);
		CommandServer.server.cmds.unregister(barc);
		base.deinit();
		return 0;
	}

	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new CVModule();
	}
}
/** @} */
