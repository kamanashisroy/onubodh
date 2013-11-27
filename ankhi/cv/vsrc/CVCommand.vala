using aroop;
using shotodol;


public class shotodol.CVCommand : M100Command {
	etxt prfx;
	FastEdgeCVCommand? fe;
	KmeansCVCommand? km;
	CentroidModelCVCommand? cm;
	public CVCommand() {
		fe = new FastEdgeCVCommand();
		km = new KmeansCVCommand();
		cm = new CentroidModelCVCommand();
	}
	~CVCommand() {
		fe = null;
		km = null;
		cm = null;
	}
	public override etxt*get_prefix() {
		prfx = etxt.from_static("cv");
		return &prfx;
	}
	int parse_input_and_output_file(etxt*inp, etxt*infile, etxt*outfile) {
		LineAlign.next_token(inp, infile); // second token
		if(infile.char_at(0) == '-' && infile.char_at(2) == 'i' ) {
			infile.shift(2);
		}
		if(infile.is_empty()) {
			return -1;
		}
		if(outfile.char_at(0) == '-' && outfile.char_at(2) == 'o' ) {
			outfile.shift(2);
		}
		LineAlign.next_token(inp, outfile); // third token
		return 0;
	}

	public override int act_on(/*ArrayList<txt> tokens*/etxt*cmdstr, StandardIO io) {
		io.say_static("<Computer Vision>\n");
		etxt inp = etxt.stack_from_etxt(cmdstr);
		int i = 0;
		for(i = 0; i < 32; i++) {
			etxt token = etxt.EMPTY();
			LineAlign.next_token(&inp, &token); // second token
			if(token.is_empty()) {
				break;
			}
			switch(i) {
				case 0:
				// skip command(help) argument
				continue;
				case 1:
					etxt infile = etxt.EMPTY();
					etxt outfile = etxt.EMPTY();
					if(parse_input_and_output_file(&inp, &infile, &outfile) != 0) {
						break;
					}
					if(token.equals_static_string("fastedge")) {
						io.say_static("<Computer Vision> Performing fast edge filter\n");
						fe.act_on_file(&inp, &infile, &outfile, io);
					} else if(token.equals_static_string("kmeans")) {
						io.say_static("<Computer Vision> Performing fast kmeans cluster\n");
						km.act_on_file(&inp, &infile, &outfile, io);
					} else if(token.equals_static_string("centroid")) {
						io.say_static("<Computer Vision> Applying centroid method\n");
						cm.act_on_file(&inp, &infile, &outfile, io);
					}
				break;
				default:
				break;
			}
		}
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
			io.say_static("SYNOPSIS\ncv [operation] -i[infile] -o[outfile]\nDESCRIPTION\ncv command enables you to add filters to image files. Note that you do not need to specify the file extension. The operation argument can be 'edge' or 'kmeans' or 'centroid'.\nEXAMPLE\nTo detect edges of an image, you can type\n\n\tcv edge -iinfile.pgm -ooutfile.pgm\n");
			break;
		}
		return 0;
	}
}
