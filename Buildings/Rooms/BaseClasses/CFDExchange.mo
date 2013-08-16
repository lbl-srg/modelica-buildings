within Buildings.Rooms.BaseClasses;
block CFDExchange
  "Block that exchanges data with the Fast Fluid Flow Dynamics code"
  extends Modelica.Blocks.Interfaces.DiscreteBlock;
  parameter Boolean activateInterface=true
    "Set to false to deactivate interface and use instead yFixed as output"
    annotation (Evaluate=true);

  parameter Integer nWri(min=0)
    "Number of values to write to the FFD simulation";
  parameter Integer nRea(min=0)
    "Number of double values to be read from the FFD simulation";
  parameter Integer flaWri[nWri]=zeros(nWri)
    "Flag for double values (0: use current value, 1: use average over interval, 2: use integral over interval)";
  parameter Real uStart[nWri]
    "Initial input signal, used during first data transfer with FFD simulation";
  parameter Real yFixed[nRea] "Fixed output, used if activateInterface=false"
    annotation (Evaluate=true, Dialog(enable=not activateInterface));

  parameter Integer nSur(min=1) "Number of surfaces";
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

  Modelica.Blocks.Interfaces.RealInput u[nWri] "Inputs to FFD"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y[nRea](start=yFixed)
    "Outputs received from FFD"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  output Real uInt[nWri] "Value of integral";
  output Real uIntPre[nWri] "Value of integral at previous sampling instance";
  output Real uWri[nWri] "Value to be sent to the FFD interface";

protected
  final parameter Integer nSen(min=0) = size(sensorName, 1)
    "Number of sensors that are connected to CFD output";
  final parameter Integer nPorts=size(portName, 1)
    "Number of fluid ports for the HVAC inlet and outlets";
  final parameter Real _uStart[nWri]={if (flaWri[i] <= 1) then uStart[i] else
      uStart[i]*samplePeriod for i in 1:nWri}
    "Initial input signal, used during first data transfer with FFD";
  output Modelica.SIunits.Time simTimRea
    "Current simulation time received from FFD";

  output Integer retVal "Return value from FFD";

  parameter Boolean ideSurNam[max(0, nSur - 1)](fixed=false)
    "Flag, used to tag identical surface names";
  parameter Boolean ideSenNam[max(0, nSen - 1)](fixed=false)
    "Flag, used to tag identical sensor names";
  parameter Boolean idePorNam[max(0, nPorts - 1)](fixed=false)
    "Flag, used to tag identical port names";

  ///////////////////////////////////////////////////////////////////////////
  // Function that sends the parameters of the model from Modelica to CFD
  function sendParameters
    input String[nSur] name "Surface names";
    input Modelica.SIunits.Area[nSur] A "Surface areas";
    input Modelica.SIunits.Angle[nSur] til "Surface tilt";
    input Buildings.Rooms.Types.CFDBoundaryConditions[nSur] bouCon
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
    input Boolean verbose "Set to true for verbose output";
  protected
    Integer nConExtWin=0;
    Integer coSimFlag=0;
  algorithm
    if verbose then
      Modelica.Utilities.Streams.print("CFDExchange:sendParameter");
    end if;

    for i in 1:nSur loop
      assert(A[i] > 0, "Surface must be bigger than zero.");
    end for;

    // fixme: Send from here the input arguments of this function to the CFD interface
    // fixme: need nConExtWin

    Modelica.Utilities.Streams.print(string="Launch createSharedMemory()");
    coSimFlag := startCosimulation(
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
        0,
        0);
    assert(coSimFlag < 0.5, "Could not start the cosimulation.");

  end sendParameters;

  ///////////////////////////////////////////////////////////////////////////
  // Function that exchanges data during the time stepping between
  // Modelica and CFD.
  function exchange
    input Integer flag "Communication flag to write to FFD";
    input Modelica.SIunits.Time t "Current simulation time in seconds to write";
    input Modelica.SIunits.Time dt(min=100*Modelica.Constants.eps)
      "Requested time step length";
    input Real[nU] u "Input for FFD";
    input Integer nU "Number of inputs for FFD";
    input Real[nY] yFixed "Fixed values (used for debugging only)";
    input Integer nY "Number of outputs from FFD";
    output Modelica.SIunits.Time simTimRea
      "Current simulation time in seconds read from FFD";
    input Boolean verbose "Set to true for verbose output";
    output Real[nY] y "Output computed by FFD";
    output Integer retVal
      "The exit value, which is negative if an error occured";
  algorithm
    if verbose then
      Modelica.Utilities.Streams.print("CFDExchange:exchange at t=" + String(t));
    end if;

    (simTimRea,y,retVal) := exchangeData(
        flag,
        t,
        dt,
        u,
        nU,
        nY);
    //simTimRea := t + dt;
    //y := yFixed;
    //retVal := 0;
  end exchange;

  //   ///////////////////////////////////////////////////////////////////////////
  //   // Function that terminates the CFD simulation.
  //   function terminate
  //     input Modelica.SIunits.Time t "Current simulation time in seconds to write";
  //     input Boolean activateInterface
  //       "Set to false to deactivate interface and use instead yFixed as output";
  //     input Boolean verbose "Set to true for verbose output";
  //
  //   algorithm
  //
  //
  //
  //   end terminate;

  ///////////////////////////////////////////////////////////////////////////
  // Function that returns strings that are not unique.
  function returnNonUniqueStrings
    input Integer n "Number entries";
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

  /*
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
        ideNam[i] = Modelica.Math.BooleanVectors.anyTrue(
          {Modelica.Utilities.Strings.isEqual(names[i], names[j]) for j in i+1:n});
      end for;

      assert( not Modelica.Math.BooleanVectors.anyTrue(ideNam),
      "For the CFD interface, all " + descriptiveName +
      " must have a name that is unique within each room.
      The following "
        + descriptiveName + " names are used more than once in the room model:" +
      returnNonUniqueStrings(n, ideNam, names));
    else
      ideNam = fill(false, max(0, n - 1));
    end if;
    annotation(Inline=true);
  end assertStringsAreUnique;
*/

initial equation
  // Diagnostics output
  if verbose then
    Modelica.Utilities.Streams.print(string=
      "\nCFDExchange has the following surfaces:");
    for i in 1:nSur loop
      Modelica.Utilities.Streams.print(string="
  name = " + surIde[i].name + "
  A    = " + String(surIde[i].A) + " [m2]
  tilt = " + String(surIde[i].til*180/Modelica.Constants.pi) + " [deg]");
    end for;

    if haveSensor then
      Modelica.Utilities.Streams.print(string=
        "\nCFDExchange has the following sensors:");
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
  /*
  assertStringsAreUnique(descriptiveName="surface",
                         n=nSur,
                         names={surIde[i].name for i in 1:nSur});
  assertStringsAreUnique(descriptiveName="sensor",
                         n=nSen,
                         names=sensorName);
  assertStringsAreUnique(descriptiveName="ports",
                         n=nPorts,
                         names=portName);
*/
  if nSur > 1 then
    for i in 1:nSur - 1 loop
      ideSurNam[i] = Modelica.Math.BooleanVectors.anyTrue({
        Modelica.Utilities.Strings.isEqual(surIde[i].name, surIde[j].name) for
        j in i + 1:nSur});
    end for;
    assert(not Modelica.Math.BooleanVectors.anyTrue(ideSurNam), "For the CFD interface, all surfaces must have a name that is unique within each room.
  The following surface names are used more than once in the room model:" +
      returnNonUniqueStrings(
      nSur,
      ideSurNam,
      {surIde[i].name for i in 1:nSur}));
  else
    ideSurNam = fill(false, max(0, nSur - 1));
  end if;

  // -- Check sensors
  // Loop over all names to verify that they are unique
  if nSen > 1 then
    for i in 1:nSen - 1 loop
      ideSenNam[i] = Modelica.Math.BooleanVectors.anyTrue({
        Modelica.Utilities.Strings.isEqual(sensorName[i], sensorName[j]) for j in
            i + 1:nSen});
    end for;

    assert(not Modelica.Math.BooleanVectors.anyTrue(ideSenNam), "For the CFD interface, all sensors must have a name that is unique within each room.
 The following sensor names are used more than once in the room model:" +
      returnNonUniqueStrings(
      nSen,
      ideSenNam,
      sensorName));
  else
    ideSenNam = fill(false, max(0, nSen - 1));
  end if;

  // -- Check ports
  if nPorts > 1 then
    for i in 1:nPorts - 1 loop
      idePorNam[i] = Modelica.Math.BooleanVectors.anyTrue({
        Modelica.Utilities.Strings.isEqual(portName[i], portName[j]) for j in i
         + 1:nPorts});
    end for;

    assert(not Modelica.Math.BooleanVectors.anyTrue(idePorNam), "For the CFD interface, all ports must have a name that is unique within each room.
  The following port names are used more than once in the room model:" +
      returnNonUniqueStrings(
      nPorts,
      idePorNam,
      portName));
  else
    idePorNam = fill(false, max(0, nPorts - 1));
  end if;

  // Send parameters to the CFD interface
  sendParameters(
    name={surIde[i].name for i in 1:nSur},
    A={surIde[i].A for i in 1:nSur},
    til={surIde[i].til for i in 1:nSur},
    bouCon={surIde[i].bouCon for i in 1:nSur},
    haveSensor=haveSensor,
    portName=portName,
    sensorName=sensorName,
    haveShade=haveShade,
    nSur=nSur,
    nSen=nSen,
    nPorts=nPorts,
    verbose=verbose);

initial algorithm
  // Assignment of parameters and start values
  uInt := zeros(nWri);
  uIntPre := zeros(nWri);
  for i in 1:nWri loop
    assert(flaWri[i] >= 0 and flaWri[i] <= 2,
      "Parameter flaWri out of range for " + String(i) + "-th component.");
  end for;

  // Assign uWri. This avoids a translation warning in Dymola
  // as otherwise, not all initial values are specified.
  // However, uWri is only used below in the body of the 'when'
  // block after it has been assigned.
  uWri := fill(0, nWri);

equation
  for i in 1:nWri loop
    der(uInt[i]) = if (flaWri[i] > 0) then u[i] else 0;
  end for;
algorithm
  when sampleTrigger then
    // Compute value that will be sent to the FFD interface
    for i in 1:nWri loop
      if (flaWri[i] == 0) then
        uWri[i] := pre(u[i]);
      elseif (flaWri[i] == 1) then
        uWri[i] := (uInt[i] - uIntPre[i])/samplePeriod;
        // Average value over the sampling interval
      else
        uWri[i] := uInt[i] - uIntPre[i];
        // Integral over the sampling interval
      end if;
    end for;

    // Exchange data
    if (activateInterface and (not terminal())) then
      (simTimRea,y,retVal) := exchange(
        flag=0,
        t=time,
        dt=samplePeriod,
        u=uWri,
        nU=size(u, 1),
        yFixed=yFixed,
        nY=size(y, 1),
        verbose=verbose);

    else
      simTimRea := time;
      y := yFixed;
      retVal := 0;
    end if;

    // Check for valid return flags
    assert(retVal >= 0,
      "Obtained negative return value during data transfer with FFD.\n" +
      "   Aborting simulation. Check file 'fixme: enter name of FFD log file'.\n"
       + "   Received: retVal = " + String(retVal));

    // Store current value of integral
    uIntPre := uInt;

  end when;

  when terminal() then
    assert(rem(time-startTime,samplePeriod)<0.00001, "Warning: The simulation time is not a multiple of sampling time.",
    level=AssertionLevel.warning);
    if verbose then
      Modelica.Utilities.Streams.print("CFDExchange:terminate at t=" + String(
        time));
    end if;
    // Send the stopping singal to FFD
    sendStopComannd();

    // Last exchange of data
    if activateInterface then
      (simTimRea,y,retVal) := exchange(
        flag=0,
        t=time,
        dt=samplePeriod,
        u=uWri,
        nU=size(u, 1),
        yFixed=yFixed,
        nY=size(y, 1),
        verbose=verbose);
    else
      simTimRea := time;
      y := yFixed;
      retVal := 0;
    end if;
    // Check if CFD has successfully stopped
    assert(receiveFeedback() < 0.5, "Could not terminate the cosimulation.");

  end when;
  annotation (
    Placement(transformation(extent={{-140,-20},{-100,20}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics),
    Documentation(info="<html>
<p>
This block samples interface variables and exchanges data with the fast fluid flow dynamics
code.
</p>
<p>
For a documentation of the exchange parameters and variables, see
<a href=\"modelica://Buildings.Rooms.UsersGuide.FFD\">
Buildings.Rooms.UsersGuide.FFD</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 19, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end CFDExchange;
