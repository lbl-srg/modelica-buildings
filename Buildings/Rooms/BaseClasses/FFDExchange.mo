within Buildings.Rooms.BaseClasses;
block FFDExchange
  "Block that exchanges data with the Fast Fluid Flow Dynamics code"
  extends Modelica.Blocks.Interfaces.DiscreteBlock;
  parameter Boolean activateInterface = true
    "Set to false to deactivate interface and use instead yFixed as output"
    annotation(Evaluate = true);

  parameter Integer nWri(min=0)
    "Number of values to write to the FFD simulation";
  parameter Integer nRea(min=0)
    "Number of double values to be read from the FFD simulation";
  parameter Integer flaWri[nWri] = zeros(nWri)
    "Flag for double values (0: use current value, 1: use average over interval, 2: use integral over interval)";
  parameter Real uStart[nWri]
    "Initial input signal, used during first data transfer with FFD simulation";
  parameter Real yFixed[nRea] "Fixed output, used if activateInterface=false"
    annotation(Evaluate = true,
                Dialog(enable = not activateInterface));

  parameter Integer nSur(min=1) "Number of surfaces";
  parameter FFDSurfaceIdentifier surIde[nSur] "Surface identifiers";
  parameter Boolean haveShade
    "Set to true if at least one window in the room has a shade";
  parameter Boolean verbose = true "Set to true for verbose output";

  Modelica.Blocks.Interfaces.RealInput u[nWri] "Inputs to FFD"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y[nRea](start=yFixed)
    "Outputs received from FFD"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  output Real uInt[nWri] "Value of integral";
  output Real uIntPre[nWri] "Value of integral at previous sampling instance";
  output Real uWri[nWri] "Value to be sent to the FFD interface";

protected
  final parameter Real _uStart[nWri]=
     {if (flaWri[i] <= 1) then uStart[i] else uStart[i]*samplePeriod for i in 1:nWri}
    "Initial input signal, used during first data transfer with FFD";
  output Modelica.SIunits.Time simTimRea
    "Current simulation time received from FFD";

  output Integer retVal "Return value from FFD";

  parameter Boolean ideNam[nSur-1](fixed=false)
    "Flag that is set to true if the surface name is used more than once";

  function exchangeFFD
    input Integer flag "Communication flag to write to FFD";
    input Modelica.SIunits.Time t "Current simulation time in seconds to write";
    input Modelica.SIunits.Time dt(min=100*Modelica.Constants.eps)
      "Requested time step length";
    input Real[nU] u "Input for FFD";
    input Integer nU "Number of inputs for FFD";
    input Integer nY "Number of outputs from FFD";
    output Modelica.SIunits.Time simTimRea
      "Current simulation time in seconds read from FFD";
    output Real[nY] y "Output computed by FFD";
    output Integer retVal
      "The exit value, which is negative if an error occured";

  algorithm
      simTimRea := t+dt;
      y         := zeros(nY);
      retVal    := 0;
  end exchangeFFD;

  function returnNonUniqueStrings
    input Integer nSur "Number of surfaces";
    input Boolean ideNam[nSur-1]
      "Flag that is set to true if the surface name is used more than once";
    input FFDSurfaceIdentifier surIde[nSur] "Surface identifiers";
    output String s "String with non-unique surface names";
  algorithm
    s := "";
    for i in 1:nSur-1 loop
      s := s + "\n  '" + surIde[i].name + "'";
    end for;
  end returnNonUniqueStrings;

  function sendSurfaceIdentifiers
    input String[nSur] name "Surface names";
    input Modelica.SIunits.Area[nSur] A "Surface areas";
    input Modelica.SIunits.Angle[nSur] til "Surface tilt";
    input Buildings.Rooms.Types.CFDBoundaryConditions[nSur] bouCon
      "Type of boundary condition";
    input Boolean haveShade "Flag, true if the windows have a shade";
    input Integer nSur "Number of surfaces";

  algorithm
    for i in 1:nSur loop
      assert(A[i] > 0, "Surface must be bigger than zero.");
    end for;
    // fixme: Send from here the input arguments of this function to the CFD interface
  end sendSurfaceIdentifiers;

initial equation
  // Diagnostics output
  if verbose then
    Modelica.Utilities.Streams.print(string="FFDExchange has the following surfaces:\n");
    for i in 1:nSur loop
      Modelica.Utilities.Streams.print(string=  String(i) + ":
  name = " + surIde[i].name + "
  A    = " + String(surIde[i].A)   + " [m2]
  tilt = " + String(surIde[i].til*180/Modelica.Constants.pi) + " [deg]");
    end for;
  end if;

  for i in 1:nSur loop
    assert(Modelica.Utilities.Strings.length(surIde[i].name) > 0,
    "The surface number + " + String(i) + " has no name.
  To use the FFD interface, all surfaces must have a name.");
  end for;

  // Loop over all surfaces to verify that their names are unique
  for i in 1:nSur-1 loop
    ideNam[i] = Modelica.Math.BooleanVectors.anyTrue(
      {Modelica.Utilities.Strings.isEqual(surIde[i].name, surIde[j].name) for j in i+1:nSur});
  end for;

  assert( not Modelica.Math.BooleanVectors.anyTrue(ideNam),
  "For the CFD interface, all surfaces must have a name that is unique within each room.
  The following surface names are used in the room model:" +
  returnNonUniqueStrings(nSur, ideNam, surIde));

  // Send parameters to the CFD interface
  sendSurfaceIdentifiers(name=    {surIde[i].name for i in 1:nSur},
                         A=       {surIde[i].A for i in 1:nSur},
                         til=     {surIde[i].til for i in 1:nSur},
                         bouCon=  {surIde[i].bouCon for i in 1:nSur},
                         haveShade=  haveShade,
                         nSur=nSur);

initial algorithm
  // Assignment of parameters and start values
  uInt    := zeros(nWri);
  uIntPre := zeros(nWri);
  for i in 1:nWri loop
    assert(flaWri[i]>=0 and flaWri[i]<=2,
       "Parameter flaWri out of range for " + String(i) + "-th component.");
  end for;
  // Exchange initial values
   if activateInterface then
     (simTimRea, y, retVal) :=
       exchangeFFD(
       flag=0,
       t=time,
       dt=samplePeriod,
       u=_uStart,
       nU=size(u, 1),
       nY=size(y, 1));
   else
     simTimRea := time;
     y         := yFixed;
     retVal    := 0;
   end if;
equation
   for i in 1:nWri loop
      der(uInt[i]) = if (flaWri[i] > 0) then u[i] else 0;
   end for;

algorithm
  when sampleTrigger then
     // Compute value that will be sent to the FFD interface
     for i in 1:nWri loop
       if (flaWri[i] == 0) then
         uWri[i] :=pre(u[i]);  // Send the current value.
                               // Without the pre(), Dymola 7.2 crashes during translation of Examples.MoistAir
       else
         if (flaWri[i] == 1) then
            uWri[i] := (uInt[i] - uIntPre[i])/samplePeriod;   // Average value over the sampling interval
         else
            uWri[i] :=uInt[i] - uIntPre[i]; // Integral over the sampling interval
         end if;
       end if;
      end for;
     // Exchange data
    if activateInterface then
      (simTimRea, y, retVal) :=exchangeFFD(
        flag=0,
        t=time,
        dt=samplePeriod,
        u=u,
        nU=size(u, 1),
        nY=size(y, 1));
    else
      simTimRea := time;
      y         := yFixed;
      retVal    := 0;
      end if;
    // Check for valid return flags
    assert(retVal >= 0, "Obtained negative return value during data transfer with FFD.\n" +
                        "   Aborting simulation. Check file 'fixme: enter name of FFD log file'.\n" +
                        "   Received: retVal = " + String(retVal));

    // Store current value of integral
    uIntPre:=uInt;
  end when;
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics),
    Documentation(info="<html>
<p>
This block samples interface variables and exchanges data with the fast fluid flow dynamics
code.
</p>
</html>", revisions="<html>
<ul>
<li>
July 19, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end FFDExchange;
