using aroop;
using shotodol;


public class shotodol.CentroidModelCVCommand : M100Command {
	etxt prfx;
	public override etxt*get_prefix() {
		prfx = etxt.from_static("cv");
		return &prfx;
	}
	public int act_on_file(/*ArrayList<txt> tokens*/etxt*inp, etxt*infile, etxt*outfile, StandardIO io) {
		etxt y_str = etxt.EMPTY();
		int x = 10,y = 10;
		if(!outfile.is_empty()) {
			x = outfile.to_int();
		}
		LineAlign.next_token(inp, &y_str); // third token
		if(!y_str.is_empty()) {
			y = y_str.to_int();
		}
		infile.zero_terminate();
		etxt dlg = etxt.stack(128);
		dlg.printf("<Computer Vision> Applying centroid method on:%s, at point (%d,%d)\n", infile.to_string(), x, y);
		io.say_static(dlg.to_string());
		CentroidModel cm = new CentroidModel(infile.to_string());
		cm.prepare();
		if(cm.findEdges(x,y,io) == 0) {
			io.say_static("<Computer Vision>Found something interesting\n");
		}
		io.say_static("<Computer Vision>Done\n");
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
			io.say_static("SYNOPSIS\ncv centroid -i[infile] -o[outfile]\nDESCRIPTION\ncv command enables you to add kmeans classifier to image files. Note that you do not need to specify the file extension. \nEXAMPLE\n\n\tcv kmeans -iinfile.pgm -ooutfile.pgm\n");
			break;
		}
		return 0;
	}
}

