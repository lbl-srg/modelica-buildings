within Buildings.ThermalZones.Detailed.BaseClasses;
block CFDExchange "Block that exchanges data with the CFD code"
extends Buildings.ThermalZones.Detailed.BaseClasses.PartialExchange;

  replaceable CFDThread CFDThre = CFDThread()
   "Allocate memory for cosimulation variables via constructor and send stop command to FFD via destructor";


  ///////////////////////////////////////////////////////////////////////////
  // Function that sends the parameters of the model from Modelica to CFD
  replaceable function sendParameters
    extends Buildings.ThermalZones.Detailed.BaseClasses.PartialsendParameters;

  algorithm
  if verbose then
    Modelica.Utilities.Streams.print("CFDExchange:sendParameter");
  end if;

  for i in 1:nSur loop
    assert(A[i] > 0, "Surface must be bigger than zero.");
  end for;

  coSimFlag := cfdStartCosimulation(
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
  replaceable function exchange
    extends Buildings.ThermalZones.Detailed.BaseClasses.Partialexchange;

  algorithm
    if verbose then
      Modelica.Utilities.Streams.print("CFDExchange:exchange at t=" + String(t));
    end if;

  (modTimRea,y,retVal) := cfdExchangeData(
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
  annotation (
    Documentation(info="<html>
<p>
This block samples interface variables and exchanges data with the CFD code.
</p>
<p>
For a documentation of the exchange parameters and variables, see
<a href=\"modelica://Buildings.ThermalZones.Detailed.UsersGuide.CFD\">
Buildings.ThermalZones.Detailed.UsersGuide.CFD</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 5, 2020, by Xu Han, Wangda Zuo and Michael Wetter:<br/>
Changed structure.
</li>
<li>
January 12, 2019, by Michael Wetter:<br/>
Removed <code>Evaluate</code> statement as the model is used with
<code>fixed=false</code> which causes a warning in JModelica.
</li>
<li>
July 27, 2018, by Wei Tian and Xu Han:<br/>
To fix the issue FFD fails in JModelica tests due to unsupported OS #612 at
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/612\">issue 612</a>.
November 17, 2016, by Michael Wetter:<br/>
Removed public parameter <code>uStart</code>, which is not needed and
refactored model.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/579\">issue 579</a>.
</li>
<li>
April 21, 2016, by Michael Wetter:<br/>
Movded call to
<a href=\"modelica://Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath\">
Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath</a>
from this model to
<a href=\"modelica://Buildings.ThermalZones.Detailed.CFD\">Buildings.ThermalZones.Detailed.CFD</a>.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/506\">Buildings, #506</a>.
</li>
<li>
September 28, 2015, by Michael Wetter:<br/>
Provided start value for all variables to avoid warning
in the pedantic Modelica check in Dymola 2016 about unspecified initial conditions.
This closes
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/459\">issue 459</a>.
</li>
<li>
June 4, 2015, by Michael Wetter:<br/>
Set <code>start</code> and <code>fixed</code>
attributes in
<code>u[nWri](start=_uStart, each fixed=true)</code>
to avoid a warning in Dymola 2016 about unspecified initial conditions.
This closes
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/422\">issue 422</a>.
</li>
<li>
February 6, 2015, by Michael Wetter:<br/>
Changed <code>initial algorithm</code> to <code>initial equation</code>.
</li>
<li>
January 24, 2014, by Wangda Zuo:<br/>
Enabled the transfer of Xi and X to CFD.
</li>
<li>
July 19, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end CFDExchange;
