within Buildings.DHC.ETS.Combined.Controls;
model Borefield
  "Borefield controller"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.Units.SI.Temperature TBorWatEntMax(displayUnit="degC")
    "Maximum value of borefield water entering temperature";
  parameter Real spePumBorMin(
    final unit="1")=0.1
    "Borefield pump minimum speed";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValIso_actual[2]
    "Isolation valves return position (fractional)"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
    iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u
    "Control signal from supervisory"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
    iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPum(
    final unit="kg/s")
    "Control signal for borefield pump"
    annotation (Placement(transformation(extent={{100,40},{140,80}}),
    iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValMix(
    final unit="1")
    "Control signal for borefield mixing valve"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}}),
    iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TBorWatEnt(
    final unit="K",
    displayUnit="degC")
    "Borefield water entering temperature"
    annotation (Placement(transformation(extent={{-140,-120},{-100,-80}}),
    iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset conMix(
    final yMin=0,
    final yMax=1,
    final reverseActing=true,
    y_reset=0,
    k=0.1,
    final controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti(
      displayUnit="s")=120)
    "Mixing valve controller"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant maxTBorWatEnt(
    y(final unit="K",
      displayUnit="degC"),
    final k=TBorWatEntMax)
    "Maximum value of borefield water entering temperature"
    annotation (Placement(transformation(extent={{-50,-90},{-30,-70}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold opeVal(
    final t=0.9,
    final h=0.1)
    "True if at least one isolation valve is open"
    annotation (Placement(transformation(extent={{-50,-58},{-30,-38}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMax multiMax1(
    final nin=2)
    "Maximum opening"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold enaSup(
    final t=0.05,
    final h=0.025)
    "Borefield enabled from supervisory"
    annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Switch runBor
    "Enable borefield system pump"
    annotation (Placement(transformation(extent={{70,50},{90,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant limVal(
    final k=0.3)
    "Control signal value for full opening of the valve"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant speMin(
    final k=spePumBorMin)
    "Minimum pump speed"
    annotation (Placement(transformation(extent={{-40,74},{-20,94}})));
  Buildings.Controls.OBC.CDL.Logical.And enaBor
    "Borefield enable signal"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Line mapSpe
    "Mapping function for pump speed"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one(
    final k=1)
    "One"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(
    final k=0)
    "Zero"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Reals.Line mapVal
    "Mapping function for valve opening"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Controls.OBC.CDL.Reals.Min min1
    "Minimum"
    annotation (Placement(transformation(extent={{70,-70},{90,-50}})));
equation
  connect(multiMax1.y,opeVal.u)
    annotation (Line(points={{-68,-40},{-60,-40},{-60,-48},{-52,-48}},color={0,0,127}));
  connect(yValIso_actual,multiMax1.u)
    annotation (Line(points={{-120,-40},{-92,-40}},color={0,0,127}));
  connect(u,enaSup.u)
    annotation (Line(points={{-120,60},{-80,60},{-80,-20},{-52,-20}},color={0,0,127}));
  connect(enaSup.y,enaBor.u1)
    annotation (Line(points={{-28,-20},{-20,-20},{-20,-30},{-12,-30}},color={255,0,255}));
  connect(opeVal.y,enaBor.u2)
    annotation (Line(points={{-28,-48},{-20,-48},{-20,-38},{-12,-38}},color={255,0,255}));
  connect(enaBor.y,conMix.trigger)
    annotation (Line(points={{12,-30},{20,-30},{20,-96},{-6,-96},{-6,-92}},color={255,0,255}));
  connect(maxTBorWatEnt.y,conMix.u_s)
    annotation (Line(points={{-28,-80},{-12,-80}},color={0,0,127}));
  connect(runBor.y,yPum)
    annotation (Line(points={{92,60},{120,60}},color={0,0,127}));
  connect(TBorWatEnt,conMix.u_m)
    annotation (Line(points={{-120,-100},{0,-100},{0,-92}},color={0,0,127}));
  connect(enaBor.y,runBor.u2)
    annotation (Line(points={{12,-30},{20,-30},{20,20},{64,20},{64,60},{68,60}},color={255,0,255}));
  connect(mapSpe.y,runBor.u1)
    annotation (Line(points={{42,80},{60,80},{60,68},{68,68}},color={0,0,127}));
  connect(u,mapSpe.u)
    annotation (Line(points={{-120,60},{0,60},{0,80},{18,80}},color={0,0,127}));
  connect(speMin.y,mapSpe.f1)
    annotation (Line(points={{-18,84},{18,84}},color={0,0,127}));
  connect(min1.y,yValMix)
    annotation (Line(points={{92,-60},{120,-60}},color={0,0,127}));
  connect(conMix.y,min1.u2)
    annotation (Line(points={{12,-80},{60,-80},{60,-66},{68,-66}},color={0,0,127}));
  connect(mapVal.y,min1.u1)
    annotation (Line(points={{42,40},{60,40},{60,-54},{68,-54}},color={0,0,127}));
  connect(one.y,mapSpe.x2)
    annotation (Line(points={{2,0},{12,0},{12,76},{18,76}},color={0,0,127}));
  connect(one.y,mapSpe.f2)
    annotation (Line(points={{2,0},{12,0},{12,72},{18,72}},color={0,0,127}));
  connect(one.y,mapVal.f2)
    annotation (Line(points={{2,0},{12,0},{12,32},{18,32}},color={0,0,127}));
  connect(zer.y,mapVal.x1)
    annotation (Line(points={{-38,40},{-10,40},{-10,48},{18,48}},color={0,0,127}));
  connect(limVal.y,mapVal.x2)
    annotation (Line(points={{-18,20},{6,20},{6,36},{18,36}},color={0,0,127}));
  connect(u,mapVal.u)
    annotation (Line(points={{-120,60},{0,60},{0,40},{18,40}},color={0,0,127}));
  connect(limVal.y,mapSpe.x1)
    annotation (Line(points={{-18,20},{6,20},{6,88},{18,88}},color={0,0,127}));
  connect(zer.y,mapVal.f1)
    annotation (Line(points={{-38,40},{-10,40},{-10,44},{18,44}},color={0,0,127}));
  connect(zer.y,runBor.u3)
    annotation (Line(points={{-38,40},{-10,40},{-10,52},{68,52}},color={0,0,127}));
  annotation (
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-120},{100,120}})),
    defaultComponentName="con",
    Documentation(
      revisions="<html>
<ul>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This block implements the control logic for the borefield system.
The main control signal <code>u</code> is yielded by the hot side
or cold side controller, see for instance
<a href=\"modelica://Buildings.DHC.ETS.Combined.Controls.SideHot\">
Buildings.DHC.ETS.Combined.Controls.SideHot</a>.
</p>
<p>
The system is enabled when
</p>
<ul>
<li>
the main control signal is greater than zero,
</li>
<li>
the return position of at least one isolation valve is greater than 90%.
</li>
</ul>
<p>
When the system is enabled,
</p>
<ul>
<li>
the input signal is mapped to modulate in sequence the mixing valve
(from full bypass to closed bypass for a control signal varying between
0% and 30%) and the pump speed (from the minimum to the maximum value
for a control signal varying between 30% and 100%),
</li>
<li>
a PI loop tracks the maximum inlet temperature, the minimum between this
loop output and the previously mapped signal being used to modulate the
valve.
</li>
</ul>
<p>
Note that the first control signal for the valve is needed to stabilize
the control of the system when the mass flow rate required to meet
the heat or cold rejection demand is below the flow rate corresponding
to the minimum pump speed.
</p>
</html>"));
end Borefield;
