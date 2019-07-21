within Buildings.ThermalZones.Detailed.BaseClasses;
block ISATExchange "Block that exchanges data with the ISAT code"
  extends Buildings.ThermalZones.Detailed.BaseClasses.PartialExchange;

  ///////////////////////////////////////////////////////////////////////////
  // Function that sends the parameters of the model from Modelica to ISAT
  function sendParameters
    input String cfdFilNam "ISAT input file name";
    input String[nSur] name "Surface names";
    input Modelica.SIunits.Area[nSur] A "Surface areas";
    input Modelica.SIunits.Angle[nSur] til "Surface tilt";
    input Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions[nSur] bouCon
      "Type of boundary condition";
    input Integer nPorts(min=0)
      "Number of fluid ports for the HVAC inlet and outlets";
    input String portName[nPorts]
      "Names of fluid ports as declared in the ISAT input file";
    input Boolean haveSensor "Flag, true if the model has at least one sensor";
    input String sensorName[nSen]
      "Names of sensors as declared in the ISAT input file";
    input Boolean haveShade "Flag, true if the windows have a shade";
    input Integer nSur(min=2) "Number of surfaces";
    input Integer nSen(min=0)
      "Number of sensors that are connected to ISAT output";
    input Integer nConExtWin(min=0)
      "number of exterior construction with window";
    input Boolean verbose "Set to true for verbose output";
    input Integer nXi
      "Number of independent species concentration of the inflowing medium";
    input Integer nC "Number of trace substances of the inflowing medium";
    input Boolean haveSource
      "Flag, true if the model has at least one source";
    input Integer nSou(min=0)
      "Number of sources that are connected to ISAT output";
    input String sourceName[nSou]
      "Names of sources as declared in the ISAT input file";
    input Modelica.SIunits.Density rho_start "Density at initial state";
  protected
    Integer coSimFlag=0;
  algorithm
    if verbose then
      Modelica.Utilities.Streams.print("ISATExchange:sendParameter");
    end if;

    for i in 1:nSur loop
      assert(A[i] > 0, "Surface must be bigger than zero.");
    end for;

    Modelica.Utilities.Streams.print(string="Start cosimulation");
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

  ///////////////////////////////////////////////////////////////////////////
  // Function that exchanges data during the time stepping between
  // Modelica and ISAT.
  function exchange
    input Integer flag "Communication flag to write to ISAT";
    input Modelica.SIunits.Time t "Current simulation time in seconds to write";
    input Modelica.SIunits.Time dt(min=100*Modelica.Constants.eps)
      "Requested time step length";
    input Real[nU] u "Input for ISAT";
    input Integer nU "Number of inputs for ISAT";
    input Real[nY] yFixed "Fixed values (used for debugging only)";
    input Integer nY "Number of outputs from ISAT";
    output Modelica.SIunits.Time modTimRea
      "Current model time in seconds read from ISAT";
    input Boolean verbose "Set to true for verbose output";
    output Real[nY] y "Output computed by ISAT";
    output Integer retVal
      "The exit value, which is negative if an error occurred";
  algorithm
    if verbose then
      Modelica.Utilities.Streams.print("ISATExchange:exchange at t=" + String(t));
    end if;

    (modTimRea,y,retVal) := isatExchangeData(
        flag,
        t,
        dt,
        u,
        nU,
        nY);
  end exchange;

initial equation

  // Send parameters to the ISAT interface
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

equation

algorithm
  when sampleTrigger then
    // Exchange data
    if activateInterface then
      (modTimRea,y,retVal) := exchange(
        flag=0,
        t=time,
        dt=samplePeriod,
        u=uWri,
        nU=size(u, 1),
        yFixed=yFixed,
        nY=size(y, 1),
        verbose=verbose);
    else
      modTimRea := time;
      y := yFixed;
      retVal := 0;
    end if;

    // Check for valid return flags
    assert(retVal >= 0,
      "Obtained negative return value during data transfer with ISAT.\n" +
      "   Aborting simulation. Check ISAT log file.\n" +
      "   Received: retVal = " + String(retVal));
  end when;

  annotation (Documentation(info="<html>
<p>
Block derived from <code>CFDExchange</code> to exchange data between Modelica and ISAT.
</html>",   revisions="<html>
<ul>
<li>
July 21, 2019, by Xu Han and Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end ISATExchange;
