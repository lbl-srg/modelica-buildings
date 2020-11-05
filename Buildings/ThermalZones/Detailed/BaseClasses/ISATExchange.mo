within Buildings.ThermalZones.Detailed.BaseClasses;
block ISATExchange "Block that exchanges data with the ISAT code"
  extends Buildings.ThermalZones.Detailed.BaseClasses.PartialExchange;

  ISATThread CFDThre = ISATThread()
   "Allocate memory for cosimulation variables via constructor and send stop command to FFD via destructor";

  ///////////////////////////////////////////////////////////////////////////
  // Function that sends the parameters of the model from Modelica to CFD
  function sendParameters
    extends Buildings.ThermalZones.Detailed.BaseClasses.PartialsendParameters;

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
  // Modelica and CFD.
  function exchange
    extends Buildings.ThermalZones.Detailed.BaseClasses.Partialexchange;
  algorithm
    if verbose then
      Modelica.Utilities.Streams.print("CFDExchange:exchange at t=" + String(t));
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
      "Obtained negative return value during data transfer with CFD.\n" +
      "   Aborting simulation. Check CFD log file.\n" +
      "   Received: retVal = " + String(retVal));
  end when;

  annotation (Documentation(info="<html>
<p>
Block derived from <code>CFDExchange</code> to exchange data between Modelica and ISAT.
</html>",   revisions="<html>
<ul>
<li>
April 5, 2020, by Xu Han, Wangda Zuo and Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ISATExchange;
