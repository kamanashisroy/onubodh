using aroop;
using shotodol;


public class shotodol.FastEdgeCVCommand : M100Command {
	etxt prfx;
	public override etxt*get_prefix() {
		prfx = etxt.from_static("cv");
		return &prfx;
	}
	public int act_on_file(/*ArrayList<txt> tokens*/etxt*inp, etxt*infile, etxt*outfile, StandardIO io) {
		int ecode = 0;
		if(outfile.is_empty()) {
			outfile.destroy();
			*outfile = etxt.from_static("output.pgm");
		}
		infile.zero_terminate();
		outfile.zero_terminate();
		etxt dlg = etxt.stack(64);
		dlg.printf("<Computer Vision>edge filter:%s -> %s\n", infile.to_string(), outfile.to_string());
		io.say_static(dlg.to_string());
		if(shotodol_fastedge.fastedge_filter.filter(infile.to_string(), outfile.to_string(), &ecode) != 0) {
			dlg.printf("<Computer Vision> Internal error while filtering %d\n", ecode);
			io.say_static(dlg.to_string());
		}
		io.say_static("<Computer Vision>Done\n");
		//infile.destroy();
		//outfile.destroy();
		return 0;
	}
	public override int desc(StandardIO io, M100Command.CommandDescType tp) {
		etxt x = etxt.stack(32);
		switch(tp) {
			case M100Command.CommandDescType.COMMAND_DESC_TITLE:
			x.printf("%s\n", get_prefix().to_string());
			io.say_static(x.to_string());
			break;
			default:
			io.say_static("SYNOPSIS\ncv fastedge -i[infile] -o[outfile]\nDESCRIPTION\ncv command enables you to add fastedge filters to image files. Note that you do not need to specify the file extension. \nEXAMPLE\n\n\tcv fastedge -iinfile.pgm iooutfile.pgm\n");
			break;
		}
		return 0;
	}
}

