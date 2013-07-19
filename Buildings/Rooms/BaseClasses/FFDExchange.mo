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
  parameter Real yFixed[nRea] = zeros(nRea)
    "Fixed output, used if activateInterface=false"
    annotation(Evaluate = true,
                Dialog(enable = not activateInterface));

  Modelica.Blocks.Interfaces.RealInput u[nWri] "Inputs to FFD"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y[nRea] "Outputs received from FFD"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  output Real uInt[nWri] "Value of integral";
  output Real uIntPre[nWri] "Value of integral at previous sampling instance";
  output Real uWri[nWri] "Value to be sent to the FFD interface";

protected
  final parameter Real _uStart[nWri] = {if (flaWri[i] <= 1) then uStart[i] else uStart[i]*samplePeriod for i in 1:nWri}
    "Initial input signal, used during first data transfer with FFD";
  output Integer flaRea "Flag received from FFD";
  output Modelica.SIunits.Time simTimRea
    "Current simulation time received from FFD";

  output Integer retVal "Return value from FFD";

  function exchangeFFD
    input Integer flag "Communication flag to write to FFD";
    input Modelica.SIunits.Time t "Current simulation time in seconds to write";
    input Modelica.SIunits.Time dt(min=100*Modelica.Constants.eps)
      "Requested time step length";
    input Real[nT] T "Surface temperatures to write to FFD";
    input Integer nT "Number of surface temperatures to write to FFD";
    input Integer nQ_flow "Number of heat flow rates to read";
    output Integer flaRea "Communication flag read from FFD";
    output Modelica.SIunits.Time simTimRea
      "Current simulation time in seconds read from FFD";
    output Real[nQ_flow] Q_flow "Surface heat flow rates computed by FFD";
    output Integer retVal
      "The exit value, which is negative if an error occured";

  algorithm
      Q_flow :=zeros(nQ_flow);
  end exchangeFFD;

initial algorithm
   flaRea   := 0;
   uInt    := zeros(nWri);
   uIntPre := zeros(nWri);
   for i in 1:nWri loop
     assert(flaWri[i]>=0 and flaWri[i]<=2,
        "Parameter flaWri out of range for " + String(i) + "-th component.");
   end for;
   // Exchange initial values
    if activateInterface then
      (flaRea, simTimRea, y, retVal) :=
        exchangeFFD(
        flag=0,
        t=time,
        dt=samplePeriod,
        T=_uStart,
        nT=size(u, 1),
        nQ_flow=size(y, 1));
    else
      flaRea := 0;
      simTimRea := time;
      y := yFixed;
      retVal := 0;
      end if;
algorithm
  when sampleTrigger then
     // Compute value that will be sent to the FFD interface
     for i in 1:nWri loop
       if (flaWri[i] == 0) then
         uWri[i] :=pre(u[i]);  // Send the current value.
                                 // Without the pre(), Dymola 7.2 crashes during translation of Examples.MoistAir
       else
         uWri[i] :=uInt[i] - uIntPre[i]; // Integral over the sampling interval
         if (flaWri[i] == 1) then
            uWri[i] := uWri[i]/samplePeriod;   // Average value over the sampling interval
         end if;
       end if;
      end for;
     // Exchange data
if activateInterface then
      (flaRea, simTimRea, y, retVal) :=exchangeFFD(
        flag=0,
        t=time,
        dt=samplePeriod,
        T=u,
        nT=size(u, 1),
        nQ_flow=size(y, 1));
    else
      flaRea :=0;
      simTimRea :=time;
      y :=yFixed;
      retVal :=0;
      end if;
    // Check for valid return flags
    assert(flaRea >= 0, "FFD sent a negative flag to Modelica during data transfer.\n" +
                        "   Aborting simulation. Check file 'fixme: enter name of FFD log file'.\n" +
                        "   Received: flaRea = " + String(flaRea));
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
