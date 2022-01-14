within Buildings.ThermalZones.Detailed.BaseClasses;
block ISATExchange "Block that exchanges data with the ISAT code"
  extends Buildings.ThermalZones.Detailed.BaseClasses.PartialExchange;

  ISATThread CFDThre = ISATThread()
   "Allocate memory for cosimulation variables via constructor and send stop command to FFD via destructor";

  ///////////////////////////////////////////////////////////////////////////
  // Function that sends the parameters of the model from Modelica to CFD
protected
  function sendParameters
    "Send model parameters from Modelica to CFD"
    input String cfdFilNam "CFD input file name";
    input String[nSur] name "Surface names";
    input Modelica.Units.SI.Area[nSur] A "Surface areas";
    input Modelica.Units.SI.Angle[nSur] til "Surface tilt";
    input Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions[nSur] bouCon
      "Type of boundary condition";
    input Integer nPorts(min=0)
      "Number of fluid ports for the HVAC inlet and outlets";
    input String portName[nPorts]
      "Names of fluid ports as declared in the CFD input file";
    input Boolean haveSensor "Flag, true if the model has at least one sensor";
    input String sensorName[nSen]
      "Names of sensors as declared in the CFD input file";
    input Boolean haveShade "Flag, true if the windows have a shade";
    input Integer nSur(min=2) "Number of surfaces";
    input Integer nSen(min=0)
      "Number of sensors that are connected to CFD output";
    input Integer nConExtWin(min=0)
      "number of exterior construction with window";
    input Boolean verbose "Set to true for verbose output";
    input Integer nXi
      "Number of independent species concentration of the inflowing medium";
    input Integer nC "Number of trace substances of the inflowing medium";
    input Boolean haveSource
      "Flag, true if the model has at least one source";
    input Integer nSou(min=0)
      "Number of sources that are connected to CFD output";
    input String sourceName[nSou]
      "Names of sources as declared in the CFD input file";
    input Modelica.Units.SI.Density rho_start "Density at initial state";
  protected
    Integer coSimFlag=0;
  algorithm
  if verbose then
    Modelica.Utilities.Streams.print("ISATExchange:sendParameter");
  end if;

  for i in 1:nSur loop
    assert(A[i] > 0, "Surface must be bigger than zero.");
  end for;

  coSimFlag := isatStartCosimulation(
      cfdFilNam,
      name,
      A,
      til,
      bouCon,
      nPorts,
      portName,
      haveSensor,
      sensorName,
      haveShade,
      nSur,
      nSen,
      nConExtWin,
      nXi,
      nC,
      haveSource,
      nSou,
      sourceName,
      rho_start);
  assert(coSimFlag < 0.5, "Could not start the cosimulation.");

  end sendParameters;


  function isatStartCosimulation
    "Start the coupled simulation with ISAT"
    input String cfdFilNam "CFD input file name";
    input String[nSur] name "Surface names";
    input Modelica.Units.SI.Area[nSur] A "Surface areas";
    input Modelica.Units.SI.Angle[nSur] til "Surface tilt";
    input Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions[nSur] bouCon
      "Type of boundary condition";
    input Integer nPorts(min=0)
      "Number of fluid ports for the HVAC inlet and outlets";
    input String portName[nPorts]
      "Names of fluid ports as declared in the CFD input file";
    input Boolean haveSensor "Flag, true if the model has at least one sensor";
    input String sensorName[nSen]
      "Names of sensors as declared in the CFD input file";
    input Boolean haveShade "Flag, true if the windows have a shade";
    input Integer nSur "Number of surfaces";
    input Integer nSen(min=0)
      "Number of sensors that are connected to CFD output";
    input Integer nConExtWin(min=0) "number of exterior construction with window";
    input Integer nXi(min=0) "Number of independent species";
    input Integer nC(min=0) "Number of trace substances";
    input Boolean haveSource
      "Flag, true if the model has at least one source";
    input Integer nSou(min=0)
      "Number of sources that are connected to CFD output";
    input String sourceName[nSou]
      "Names of sources as declared in the CFD input file";
    input Modelica.Units.SI.Density rho_start "Density at initial state";
    output Integer retVal
      "Return value of the function (0 indicates CFD successfully started.)";

  external "C" retVal = isatStartCosimulation(
    cfdFilNam,
    name,
    A,
    til,
    bouCon,
    nPorts,
    portName,
    haveSensor,
    sensorName,
    haveShade,
    nSur,
    nSen,
    nConExtWin,
    nXi,
    nC,
    haveSource,
    nSou,
    sourceName,
    rho_start)
    annotation (
      Include="#include <isatStartCosimulation.c>",
      IncludeDirectory="modelica://Buildings/Resources/C-Sources",
      LibraryDirectory="modelica://Buildings/Resources/Library", Library="isat");

  annotation (Documentation(info="<html>
<p>
This function calls a C function to start the coupled simulation with ISAT.
</p>
</html>",
        revisions="<html>
<ul>
<li>
November 1, 2019, by Xu Han, Wangda Zuo and Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));

  end isatStartCosimulation;

  function isatExchangeData "Exchange data with the C implementation"
    input Integer flag "Communication flag to CFD";
    input Modelica.Units.SI.Time t "Current Modelica simulation time to CFD";
    input Modelica.Units.SI.Time dt(min=100*Modelica.Constants.eps)
      "Requested synchronization time step size";
    input Real[nU] u "Input to CFD";
    input Integer nU "Number of inputs to CFD";
    input Integer nY "Number of outputs from CFD";
    output Modelica.Units.SI.Time modTimRea "Current model time from CFD";
    output Real[nY] y "Output computed by CFD";
    output Integer retVal "Return value for CFD simulation status";

    external"C" retVal = isatExchangeData(
      t,
      dt,
      u,
      nU,
      nY,
      modTimRea,
      y) annotation (
      Include="#include <isatExchangeData.c>",
      IncludeDirectory="modelica://Buildings/Resources/C-Sources");

  annotation (Documentation(info="<html>
<p>
This function calls a C function to conduct the data exchange between Modelica and ISAT program during the coupled simulation.
</p>
</html>", revisions="<html>
<ul>
<li>
November 1, 2019, by Xu Han, Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));

  end isatExchangeData;


initial equation
  if verbose then
    Modelica.Utilities.Streams.print(getInstanceName() + ": Starting CFD.\n");
  end if;

  // Send parameters to the CFD interface
  sendParameters(
    cfdFilNam=cfdFilNam,
    name=surIde[:].name,
    A=surIde[:].A,
    til=surIde[:].til,
    bouCon=surIde[:].bouCon,
    haveSensor=haveSensor,
    portName=portName,
    sensorName=sensorName,
    haveShade=haveShade,
    nSur=nSur,
    nSen=nSen,
    nConExtWin=nConExtWin,
    nPorts=nPorts,
    nXi=nXi,
    nC=nC,
    haveSource=haveSource,
    nSou=nSou,
    sourceName=sourceName,
    rho_start=rho_start,
    verbose=verbose);

algorithm
  when sampleTrigger then
    // Exchange data
    if activateInterface then
      (modTimRea,y,retVal) := isatExchangeData(
        flag=0,
        t=time,
        dt=samplePeriod,
        u=uWri,
        nU=size(u, 1),
        nY=size(y, 1));
    else
      modTimRea := time;
      y := yFixed;
      retVal := 0;
    end if;

    // Check for valid return flags
    assert(retVal >= 0,
      "Obtained negative return value during data transfer with CFD.\n" +
      "   Aborting simulation. Check CFD log file.\n" +
      "   Received: retVal = " + String(retVal));
  end when;

  annotation (Documentation(info="<html>
<p>
Block to exchange data between Modelica and ISAT.
</html>",   revisions="<html>
<ul>
<li>
April 5, 2020, by Xu Han, Wangda Zuo and Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ISATExchange;
