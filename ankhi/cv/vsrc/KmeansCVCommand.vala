using aroop;
using shotodol;


public class shotodol.KmeansCVCommand : M100Command {
	etxt prfx;
	public override etxt*get_prefix() {
		prfx = etxt.from_static("cv");
		return &prfx;
	}
	public int act_on_file(/*ArrayList<txt> tokens*/etxt*inp, etxt*infile, etxt*outfile, StandardIO io) {
		etxt kval_str = etxt.EMPTY();
		int kval = 30;
		int ecode = 0;
		LineAlign.next_token(inp, &kval_str); // fourth token
		if(!kval_str.is_empty()) {
			kval = kval_str.to_int();
		}
		if(outfile.is_empty()) {
			outfile.destroy();
			*outfile = etxt.from_static("output.ppm");
		}
		infile.zero_terminate();
		outfile.zero_terminate();
		etxt dlg = etxt.stack(64);
		dlg.printf("<Computer Vision>kmeans cluster:%s -> %s\n", infile.to_string(), outfile.to_string());
		io.say_static(dlg.to_string());
		if(shotodol_dryman_kmeans.dryman_kmeans.cluster(infile.to_string(), outfile.to_string(), kval, &ecode) != 0) {
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
			io.say_static("SYNOPSIS\ncv kmeans -i[infile] -o[outfile]\nDESCRIPTION\ncv command enables you to add kmeans classifier to image files. Note that you do not need to specify the file extension. \nEXAMPLE\n\n\tcv kmeans -iinfile.pgm iooutfile.pgm\n");
			break;
		}
		return 0;
	}
}

