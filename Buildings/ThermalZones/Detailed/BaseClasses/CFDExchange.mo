within Buildings.ThermalZones.Detailed.BaseClasses;
block CFDExchange "Block that exchanges data with the CFD code"
  extends Modelica.Blocks.Interfaces.DiscreteBlock(
    firstTrigger(start=false,
                 fixed=true));
  parameter String cfdFilNam "CFD input file name" annotation (Dialog(
        loadSelector(caption=
            "Select CFD input file")));
  parameter Boolean activateInterface=true
    "Set to false to deactivate interface and use instead yFixed as output"
    annotation (Evaluate=true);
  parameter Integer nXi
    "Number of independent species concentration of the inflowing medium";
  parameter Integer nC "Number of trace substances of the inflowing medium";
  parameter Integer nWri(min=0)
    "Number of values to write to the CFD simulation";
  parameter Integer nRea(min=0)
    "Number of double values to be read from the CFD simulation";
  parameter Integer flaWri[nWri] = ones(nWri)
    "Flag for double values (0: use current value, 1: use average over interval, 2: use integral over interval)"
    annotation(Evaluate=true);
  parameter Real yFixed[nRea] "Fixed output, used if activateInterface=false"
    annotation (Evaluate=true, Dialog(enable=not activateInterface));
  parameter Integer nSur(min=2) "Number of surfaces";
  parameter Integer nConExtWin(min=0)
    "number of exterior construction with window";
  parameter CFDSurfaceIdentifier surIde[nSur] "Surface identifiers";
  parameter Boolean haveShade
    "Set to true if at least one window in the room has a shade";
  parameter Boolean haveSensor
    "Flag, true if the model has at least one sensor";
  parameter String sensorName[:]
    "Names of sensors as declared in the CFD input file";
  parameter String portName[:]
    "Names of fluid ports as declared in the CFD input file";
  parameter Boolean verbose=false "Set to true for verbose output";
  parameter Modelica.SIunits.Density rho_start "Density at initial state";

  Modelica.Blocks.Interfaces.RealInput u[nWri] "Inputs to CFD"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  discrete Modelica.Blocks.Interfaces.RealOutput y[nRea] "Outputs received from CFD"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Real uInt[nWri] "Value of integral";
  discrete Real uIntPre[nWri] "Value of integral at previous sampling instance";
  discrete Real uWri[nWri] "Value to be sent to the CFD interface";

protected
  final parameter Integer nSen(min=0) = size(sensorName, 1)
    "Number of sensors that are connected to CFD output";
  final parameter Integer nPorts=size(portName, 1)
    "Number of fluid ports for the HVAC inlet and outlets";
  discrete Modelica.SIunits.Time modTimRea(fixed=false)
    "Current model time received from CFD";

  discrete Integer retVal(start=0, fixed=true) "Return value from CFD";

  ///////////////////////////////////////////////////////////////////////////
  // Function that sends the parameters of the model from Modelica to CFD
  function sendParameters
    input String cfdFilNam "CFD input file name";
    input String[nSur] name "Surface names";
    input Modelica.SIunits.Area[nSur] A "Surface areas";
    input Modelica.SIunits.Angle[nSur] til "Surface tilt";
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
    input Modelica.SIunits.Density rho_start "Density at initial state";
  protected
    Integer coSimFlag=0;
  algorithm
    if verbose then
      Modelica.Utilities.Streams.print("CFDExchange:sendParameter");
    end if;

    for i in 1:nSur loop
      assert(A[i] > 0, "Surface must be bigger than zero.");
    end for;

    Modelica.Utilities.Streams.print(string="Start cosimulation");
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
        rho_start);
    assert(coSimFlag < 0.5, "Could not start the cosimulation.");

  end sendParameters;

  ///////////////////////////////////////////////////////////////////////////
  // Function that exchanges data during the time stepping between
  // Modelica and CFD.
  function exchange
    input Integer flag "Communication flag to write to CFD";
    input Modelica.SIunits.Time t "Current simulation time in seconds to write";
    input Modelica.SIunits.Time dt(min=100*Modelica.Constants.eps)
      "Requested time step length";
    input Real[nU] u "Input for CFD";
    input Integer nU "Number of inputs for CFD";
    input Real[nY] yFixed "Fixed values (used for debugging only)";
    input Integer nY "Number of outputs from CFD";
    output Modelica.SIunits.Time modTimRea
      "Current model time in seconds read from CFD";
    input Boolean verbose "Set to true for verbose output";
    output Real[nY] y "Output computed by CFD";
    output Integer retVal
      "The exit value, which is negative if an error occurred";
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

  ///////////////////////////////////////////////////////////////////////////
  // Function that returns strings that are not unique.
  function returnNonUniqueStrings
    input Integer n(min=2) "Number entries";
    input Boolean ideNam[n - 1]
      "Flag that is set to true if the name is used more than once";
    input String names[n] "Names";
    output String s "String with non-unique names";
  algorithm
    s := "";
    for i in 1:n - 1 loop
      if ideNam[i] then
        s := s + "\n  '" + names[i] + "'";
      end if;
    end for;
  end returnNonUniqueStrings;

  // This function does not work because Dymola 2014 has problems with
  // handling strings in an algorithm section
  function assertStringsAreUnique
    input String descriptiveName
      "Descriptive name of what is tested, such as 'sensor' or 'ports'";
    input Integer n(min=2) "Number of strings";
    input String names[n] "Names";
  protected
    Boolean ideNam[n-1]
      "Flag that is set to true if the name is used more than once";

  algorithm
      // Loop over all names to verify that they are unique
    if n > 1 then
      for i in 1:n-1 loop
        for j in i+1:n loop
          ideNam[i] := Modelica.Utilities.Strings.isEqual(names[i], names[j]);
          if ideNam[i] then
            break;
          end if;
        end for; // j
      end for; // i

      assert( not Modelica.Math.BooleanVectors.anyTrue(ideNam),
      "For the CFD interface, all " + descriptiveName +
      " must have a name that is unique within each room.
      The following "
        + descriptiveName + " names are used more than once in the room model:" +
      returnNonUniqueStrings(n, ideNam, names));
    else
      ideNam :=fill(false, max(0, n - 1));
    end if;
   annotation(Inline=true);
  end assertStringsAreUnique;

initial equation
  // Diagnostics output
  if verbose then
   Modelica.Utilities.Streams.print(string="
CFDExchange has the following surfaces:");
    for i in 1:nSur loop
      Modelica.Utilities.Streams.print(string="
  name = " + surIde[i].name + "
  A    = " + String(surIde[i].A) + " [m2]
  tilt = " + String(surIde[i].til*180/Modelica.Constants.pi) + " [deg]");
  end for;

    if haveSensor then
      Modelica.Utilities.Streams.print(string="
CFDExchange has the following sensors:");
      for i in 1:nSen loop
        Modelica.Utilities.Streams.print(string="  " + sensorName[i]);
      end for;
    else
      Modelica.Utilities.Streams.print(string="CFDExchange has no sensors.");
    end if;
end if;

  // Assert that the surface, sensor and ports have a name,
  // and that that name is unique.
  // Otherwise, stop with an error.

  assertStringsAreUnique(descriptiveName="surface",
                         n=nSur,
                         names={surIde[i].name for i in 1:nSur});
  assertStringsAreUnique(descriptiveName="sensor",
                         n=nSen,
                         names=sensorName);
  assertStringsAreUnique(descriptiveName="ports",
                         n=nPorts,
                         names=portName);

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
    rho_start=rho_start,
    verbose=verbose);

  // Assignment of parameters and start values
  uInt = zeros(nWri);
  uIntPre = zeros(nWri);
  for i in 1:nWri loop
    assert(flaWri[i] >= 0 and flaWri[i] <= 2,
      "Parameter flaWri out of range for " + String(i) + "-th component.");
  end for;

  // Assign uWri and y. This avoids a translation warning in Dymola
  // as otherwise, not all initial values are specified.
  // However, uWri and y are only used below in the body of the 'when'
  // block after they have been assigned.
  uWri = u;
  y=yFixed;

  modTimRea = time;
equation
  for i in 1:nWri loop
    der(uInt[i]) = if (flaWri[i] > 0) then u[i] else 0;
  end for;

  when sampleTrigger then
    // Compute value that will be sent to the CFD interface
    for i in 1:nWri loop
      if (flaWri[i] == 0) then
        uWri[i] =  pre(u[i]);
      elseif (flaWri[i] == 1) then
        if (time<startTime+0.1*samplePeriod) then
           uWri[i] =  pre(u[i]);
           // Set the correct initial data
        else
           uWri[i] =  (uInt[i] - pre(uIntPre[i]))/samplePeriod;
        // Average value over the sampling interval
        end if;
      else
        uWri[i] =  uInt[i] - pre(uIntPre[i]);
        // Integral over the sampling interval
      end if;
    end for;

    // Store current value of integral
    uIntPre = uInt;
  end when;

algorithm

  when sampleTrigger then
    // Exchange data
    if (activateInterface and (not terminal())) then
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

  when terminal() then
    assert(
      rem(time - startTime, samplePeriod) < 0.00001,
      "Warning: The simulation time is not a multiple of sampling time.",
      level=AssertionLevel.warning);
    if verbose then
      Modelica.Utilities.Streams.print("CFDExchange:terminate at t=" + String(
        time));
    end if;
    // Send the stopping singal to CFD
    cfdSendStopCommand();

    // Last exchange of data
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
    // Check if CFD has successfully stopped
    assert(cfdReceiveFeedback() == 0, "Could not terminate the cosimulation.");

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
