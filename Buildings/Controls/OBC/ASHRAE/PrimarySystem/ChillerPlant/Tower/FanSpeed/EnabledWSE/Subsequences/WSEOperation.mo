within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.EnabledWSE.Subsequences;
block WSEOperation
  "Tower fan speed control when the waterside economizer is running alone"

  parameter Real minSpe=0.1 "Minimum tower fan speed";
  parameter Real maxSpe=1 "Maximum tower fan speed";
  parameter Real fanSpeChe = 0.005 "Lower threshold value to check fan speed";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController chiWatCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PID
    "Type of controller"
    annotation (Dialog(group="Chilled water controller"));
  parameter Real k=1 "Gain of controller"
    annotation (Dialog(group="Chilled water controller"));
  parameter Modelica.SIunits.Time Ti=0.5 "Time constant of integrator block"
    annotation (Dialog(group="Chilled water controller",
                       enable=chiWatCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                              chiWatCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Modelica.SIunits.Time Td=0.1 "Time constant of derivative block"
    annotation (Dialog(group="Chilled water controller",
                       enable=chiWatCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
                              chiWatCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTowSpe(
    final min=0,
    final max=1,
    final unit="1") "Tower fan speed"
    annotation (Placement(transformation(extent={{-180,60},{-140,100}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-180,-60},{-140,-20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-180,-120},{-140,-80}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yTowSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Tower fan speed when WSE is enabled and there is any chiller running"
    annotation (Placement(transformation(extent={{140,20},{180,60}}),
      iconTransformation(extent={{100,-20},{140,20}})));

//protected
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{40,110},{60,130}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim
    "Count the time when fan is at minimum speed and the chilled water supply temperature drops below setpoint"
    annotation (Placement(transformation(extent={{80,110},{100,130}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr(
    final threshold=300)
    "Check if fan is at minimum speed and the chilled water supply temperature drops below setpoint for 5 minutes"
    annotation (Placement(transformation(extent={{80,70},{100,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTowSpe(
    final k=minSpe) "Minimum tower speed"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Feedback feedback1 "Input difference"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys2(
    final uLow=fanSpeChe,
    final uHigh=fanSpeChe + 0.005)
    "Check if tower fan speed is greater than minimum speed"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Feedback feedback2 "Input difference"
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1(
    final uLow=-0.1, final uHigh=0.1)
    "Check if chilled water supply temperature is greater than setpoint"
    annotation (Placement(transformation(extent={{-40,110},{-20,130}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{0,110},{20,130}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg "Output true at the moment when input becomes true"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi "Logical switch"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys3(
    final uLow=1*5/9,
    final uHigh=1.1*5/9)
    "Check if chilled water supply temperature is greater than setpoint by 1 degF"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID chiWatTemCon(
    final controllerType=chiWatCon,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=1,
    final yMin=0,
    final reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter,
    final y_reset=0)
    "Controller to maintain chilled water supply temperature at setpoint"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(final k=0)
    "Zero constant"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(final k=1) "One constant"
    annotation (Placement(transformation(extent={{-20,-130},{0,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTowSpe(final k=maxSpe)
    "Maximum tower fan speed"
    annotation (Placement(transformation(extent={{40,-130},{60,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Line lin
    "Output the value of the input x along a line specified by two points"
    annotation (Placement(transformation(extent={{100,-110},{120,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg1
    "Output true at the moment when input becomes true"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(delayTime=180)
    "Cycle off fan for at lease 3 minutes"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical and"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

equation
  connect(uTowSpe, feedback1.u1)
    annotation (Line(points={{-160,80},{-92,80}}, color={0,0,127}));
  connect(feedback1.y, hys2.u)
    annotation (Line(points={{-68,80},{-42,80}}, color={0,0,127}));
  connect(hys2.y, not2.u)
    annotation (Line(points={{-18,80},{-2,80}}, color={255,0,255}));
  connect(TChiWatSup, feedback2.u1)
    annotation (Line(points={{-160,-40},{-112,-40}}, color={0,0,127}));
  connect(TChiWatSupSet, feedback2.u2)
    annotation (Line(points={{-160,-100},{-100,-100},{-100,-52}}, color={0,0,127}));
  connect(hys1.y, not1.u)
    annotation (Line(points={{-18,120},{-2,120}}, color={255,0,255}));
  connect(feedback2.y, hys1.u)
    annotation (Line(points={{-88,-40},{-60,-40},{-60,120},{-42,120}},
      color={0,0,127}));
  connect(not1.y, and2.u1)
    annotation (Line(points={{22,120},{38,120}}, color={255,0,255}));
  connect(not2.y, and2.u2)
    annotation (Line(points={{22,80},{30,80},{30,112},{38,112}}, color={255,0,255}));
  connect(and2.y, tim.u)
    annotation (Line(points={{62,120},{78,120}}, color={255,0,255}));
  connect(tim.y, greEquThr.u)
    annotation (Line(points={{102,120},{110,120},{110,100},{60,100},{60,80},
      {78,80}}, color={0,0,127}));
  connect(greEquThr.y, edg.u)
    annotation (Line(points={{102,80},{110,80},{110,60},{-50,60},{-50,40},{-2,40}},
      color={255,0,255}));
  connect(edg.y, lat.u)
    annotation (Line(points={{22,40},{38,40}},color={255,0,255}));
  connect(lat.y, swi.u2)
    annotation (Line(points={{62,40},{98,40}}, color={255,0,255}));
  connect(feedback2.y, hys3.u)
    annotation (Line(points={{-88,-40},{-42,-40}}, color={0,0,127}));
  connect(TChiWatSupSet, chiWatTemCon.u_s)
    annotation (Line(points={{-160,-100},{-62,-100}}, color={0,0,127}));
  connect(TChiWatSup, chiWatTemCon.u_m)
    annotation (Line(points={{-160,-40},{-120,-40},{-120,-130},{-50,-130},{-50,-112}},
      color={0,0,127}));
  connect(lat.y, chiWatTemCon.trigger)
    annotation (Line(points={{62,40},{74,40},{74,-60},{-70,-60},{-70,-120},
      {-58,-120},{-58,-112}},  color={255,0,255}));
  connect(zer.y, lin.x1)
    annotation (Line(points={{62,-80},{80,-80},{80,-92},{98,-92}}, color={0,0,127}));
  connect(chiWatTemCon.y, lin.u)
    annotation (Line(points={{-38,-100},{98,-100}}, color={0,0,127}));
  connect(one.y, lin.x2)
    annotation (Line(points={{2,-120},{20,-120},{20,-104},{98,-104}}, color={0,0,127}));
  connect(maxTowSpe.y, lin.f2)
    annotation (Line(points={{62,-120},{80,-120},{80,-108},{98,-108}}, color={0,0,127}));
  connect(lin.y, swi.u3)
    annotation (Line(points={{122,-100},{130,-100},{130,-60},{86,-60},{86,32},
      {98,32}}, color={0,0,127}));
  connect(swi.y, yTowSpe)
    annotation (Line(points={{122,40},{160,40}}, color={0,0,127}));
  connect(minTowSpe.y, feedback1.u2)
    annotation (Line(points={{-98,0},{-80,0},{-80,68}}, color={0,0,127}));
  connect(minTowSpe.y, lin.f1)
    annotation (Line(points={{-98,0},{-80,0},{-80,-80},{20,-80},{20,-96},
      {98,-96}}, color={0,0,127}));
  connect(greEquThr.y, truDel.u)
    annotation (Line(points={{102,80},{110,80},{110,60},{-50,60},{-50,0},
      {-42,0}}, color={255,0,255}));
  connect(truDel.y, and1.u1)
    annotation (Line(points={{-18,0},{-2,0}}, color={255,0,255}));
  connect(hys3.y, and1.u2)
    annotation (Line(points={{-18,-40},{-10,-40},{-10,-8},{-2,-8}},
      color={255,0,255}));
  connect(and1.y, edg1.u)
    annotation (Line(points={{22,0},{38,0}}, color={255,0,255}));
  connect(edg1.y, lat.clr)
    annotation (Line(points={{62,0},{68,0},{68,20},{30,20},{30,34},{38,34}},
      color={255,0,255}));
  connect(zer.y, swi.u1)
    annotation (Line(points={{62,-80},{80,-80},{80,48},{98,48}}, color={0,0,127}));

annotation (
  defaultComponentName="wseTowSpeWSEOpe",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-40,10},{40,-10}},
          lineColor={28,108,200},
          fillColor={240,240,240},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-20,80},{20,80},{0,10},{-20,80}},
          lineColor={28,108,200},
          fillColor={240,240,240},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,-10},{-20,-80},{20,-80},{0,-10}},
          lineColor={28,108,200},
          fillColor={240,240,240},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{40,-80},{76,-94}},
          lineColor={200,200,200},
          fillColor={240,240,240},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{76,-78},{78,-96}},
          lineColor={200,200,200},
          fillColor={240,240,240},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{78,-78},{80,-96}},
          lineColor={200,200,200},
          fillColor={240,240,240},
          fillPattern=FillPattern.Solid)}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-140,-140},{140,140}})),
Documentation(info="<html>
<p>
Block that output cooling tower fan speed <code>yTowSpe</code> when only waterside 
economizer is running. This is implemented 
according to ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II – 
Central Plants and Hydronic Systems (Draft 6 on July 25, 2019), section 5.2.12.2, 
item 4.b.
</p>
<ol>
<li>
Fan speed shall be modulated to maintain chilled water supply temperature 
<code>TChiWatSup</code> at setpoint <code>TChiWatSupSet</code> by a direct acting 
PID loop that resets fan speed from minimum <code>minSpe</code> at 0% loop output to
maximum <code>maxSpe</code> at 100% loop output.
</li>
<li>
If chilled water supply temperature <code>TChiWatSup</code> drops below setpoint
and fans have been at minimum speed <code>minSpe</code> for 5 minutes, fans
shall cycle off for at lease 3 minutes and until <code>TChiWatSup</code> rises
above setpoint by 1 &deg;F.
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
August 9, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end WSEOperation;
