within Buildings.Fluid.DXSystems.Heating.AirSource.Validation.BaseClasses;
block PLRToPulse
  "Converts an input for part load ratio value into an enable signal"

  parameter Real tPer = 15*60
    "Time period for PLR sampling";

  parameter Real tDel = 1e-6
    "Delay time of the enable signal";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uPLR
    "Part load ratio input"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEna
    "Component enable signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(
    final k=tPer)
    "Calculate runtime from PLR signal"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam
    "Sample the part load ratio signal"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim
    "Check component runtime"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=tDel/tPer,
    final period=tPer)
    "Outputs true signals for 1e-6 second duration at required timestep interval"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));

  Buildings.Controls.OBC.CDL.Reals.Less les
    "Check if component runtime has exceeded required runtime from PLR"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Output a true signal from start of currrent time period, until the required 
    run-time is achieved"
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1
    "Pre block for looping back latch reset signal"
    annotation (Placement(transformation(extent={{50,20},{70,40}})));

  Buildings.Controls.OBC.CDL.Logical.And andRes
    "Lets true signal pass only when latch is not being reset"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Not notRes
    "Check if the latch signal is being reset"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=tDel)
    "Delay the enable signal by 1e-6 seconds, which is also the duration for 
    which the pulse signal is held. Required when PLR input is zero"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));

equation
  connect(triSam.y, gai.u)
    annotation (Line(points={{-38,70},{-22,70}}, color={0,0,127}));
  connect(uPLR, triSam.u)
    annotation (Line(points={{-120,0},{-90,0},{-90,70},{-62,70}},color={0,0,127}));
  connect(gai.y, les.u1)
    annotation (Line(points={{2,70},{14,70},{14,50},{18,50}}, color={0,0,127}));
  connect(tim.y, les.u2)
    annotation (Line(points={{2,40},{10,40},{10,42},{18,42}}, color={0,0,127}));
  connect(lat.y, tim.u)
    annotation (Line(points={{-28,40},{-22,40}}, color={255,0,255}));
  connect(les.y, pre1.u) annotation (Line(points={{42,50},{46,50},{46,30},{48,
          30}}, color={255,0,255}));
  connect(pre1.y, lat.clr) annotation (Line(points={{72,30},{76,30},{76,10},{-60,
          10},{-60,34},{-52,34}}, color={255,0,255}));
  connect(booPul.y, andRes.u1)
    annotation (Line(points={{-38,-40},{-22,-40}}, color={255,0,255}));
  connect(andRes.y, triSam.trigger)
    annotation (Line(points={{2,-40},{10,-40},{10,-20},{-70,-20},{-70,54},{-50,54},{-50,58}},
      color={255,0,255}));
  connect(andRes.y, lat.u)
    annotation (Line(points={{2,-40},{10,-40},{10,-20},{-70,-20},{-70,40},{-52,40}},
      color={255,0,255}));
  connect(notRes.y, andRes.u2)
    annotation (Line(points={{-38,-70},{-30,-70},{-30,-48},{-22,-48}},
      color={255,0,255}));
  connect(pre1.y, notRes.u) annotation (Line(points={{72,30},{76,30},{76,-90},{
          -70,-90},{-70,-70},{-62,-70}}, color={255,0,255}));
  connect(lat.y, truDel.u)
    annotation (Line(points={{-28,40},{-26,40},{-26,-10},{38,-10}},
      color={255,0,255}));
  connect(truDel.y, yEna)
    annotation (Line(points={{62,-10},{92,-10},{92,0},{120,0}},
      color={255,0,255}));

annotation (Icon(
    coordinateSystem(preserveAspectRatio=false),
    graphics={Rectangle(extent={{-100,100},{100,-100}},lineColor={0,0,0},
      fillColor={255,255,255},fillPattern = FillPattern.Solid),
                                        Text(
        extent={{-160,140},{160,100}},
        textString="%name",
        textColor={0,0,255})}),
  Diagram(defaultComponentName="plrToPul",
  coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>
<p>
This block calculates the time duration for which the DX coil needs to be kept enabled
based on the part-load ratio input signal <code>uPLR</code> for the constant simulation
run period <code>tPer</code>, and then generates an output enable signal
<code>yEna</code> for that duration. Once the component has been kept enabled for
the calculated duration, the component is kept disabled until the start of the next period.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 03, 2023 by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end PLRToPulse;
