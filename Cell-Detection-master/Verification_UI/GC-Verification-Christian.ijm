Imagefilepath=File.openDialog("Open Image");
imagePar=File.getParent(Imagefilepath);

open(Imagefilepath);

do{
	IterateList();
	Dialog.create("User Choice");
	Dialog.addCheckbox("Show Best Positions", false);
	Dialog.show();
	UserResp3 = Dialog.getCheckbox();

} while(UserResp3) 

print("FINISHED");


function IterateList(){
	Csvfilepath=File.openDialog("Open CSV");
	title = File.getNameWithoutExtension(Csvfilepath);
	
	//Load 3D results
	test = File.openAsString(Csvfilepath);
	
	//Break down data by lines
	lines=split(test, "\n");
	
	//Get Object Number
	lenTable = lines.length;
	
	//Get Column names
	headers = split(lines[0],",");

	xPos = 0;
	yPos = 0;
	zPos = 0;

	for(j=0;j<headers.length;j++){
		if(headers[j] == "X"){
			xPos = j;
		}
		if(headers[j] == "Y"){
			yPos = j;
		}
		if(headers[j] == "Z"){
			zPos = j;
		}
	}

	//Create input arrays
	GoodPos = newArray();
	GoodPosx = newArray();
	GoodPosy = newArray();
	GoodPosz = newArray();
	
	for(i=1;i<lenTable;i++){
		CurValue = split(lines[i],",");
		
		//Get XYZ positions
		CurxPos = parseFloat(CurValue[xPos]);
		CuryPos = parseFloat(CurValue[yPos]);
		CurzPos = parseFloat(CurValue[zPos]);
	
		//print("X"+CurxPos);
		//print("Y"+CuryPos);
		//print("Z"+CurzPos);
	
		run("Set... ", "zoom=700 x="+CurxPos+" y="+CuryPos+"");
		setSlice(CurzPos);
	
		Dialog.create("Test");
		Dialog.addCheckbox("ADD Position", false);
		Dialog.addCheckbox("Abort", false);
		Dialog.show();
		UserResp = Dialog.getCheckbox();
		UserResp2 = Dialog.getCheckbox();
	
		if(UserResp){
			GoodPos = Array.concat(GoodPos,""+i);
			GoodPosx = Array.concat(GoodPosx,""+CurxPos);
			GoodPosy = Array.concat(GoodPosy,""+CuryPos);
			GoodPosz = Array.concat(GoodPosz,""+CurzPos);
		}
	
		if(UserResp2){
			i=1000;
		}
	}

	Table.create("Output");
	Table.setColumn("X", GoodPosx);
	Table.setColumn("Y", GoodPosy);
	Table.setColumn("Z", GoodPosz);
	
	Table.update;

	Table.save(imagePar+File.separator+title+"_best.csv");
}

function fullStop(){
	setBatchMode("exit and display");
	exit();
}