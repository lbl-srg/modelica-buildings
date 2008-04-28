model printer "Model that prints values to a file" 
  extends Buildings.BaseClasses.BaseIcon;
  parameter String header="" "Header to be printed";
  parameter String fileName="" 
    "File where to print (empty string is the terminal)";
  parameter Integer nin=1 "Number of inputs";
  Modelica.Blocks.Interfaces.RealInput x[nin] "Value to be printed" 
    annotation (extent=[-140,-20; -100,20]);
  parameter Modelica.SIunits.Time samplePeriod(min=100*Modelica.Constants.eps) = 0.1 
    "Sample period of component";
  parameter Modelica.SIunits.Time startTime=0 "First sample time instant";
protected 
  output Boolean sampleTrigger "True, if sample time instant";
  output Boolean firstTrigger "Rising edge signals first sample instant";
initial algorithm 
  assert(fileName <> "", "Filename must not be empty string");
  Modelica.Utilities.Files.removeFile(fileName);
  Modelica.Utilities.Streams.print(fileName=fileName, string=header);
equation 
  sampleTrigger = sample(startTime, samplePeriod);
  when sampleTrigger then
    firstTrigger = time <= startTime + samplePeriod/2;
  end when;
algorithm 
  
  when {sampleTrigger, initial()} then
     printRealArray(x=x, fileName=fileName);
  end when;
  annotation (Icon(Text(
        extent=[-58,-46; 62,-84],
        style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=3,
          rgbfillColor={0,0,255},
          fillPattern=1),
        string="%fileName"), Rectangle(extent=[-44,88; 42,-32], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=3,
          rgbfillColor={0,0,255},
          fillPattern=1))));
end printer;
