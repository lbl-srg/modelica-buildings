within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.EnabledWSE.Subsequences;
block WSEOperation
  "Tower fan speed control when the waterside economizer is running alone"

  parameter Real fanSpeMin=0.1 "Minimum tower fan speed";
  parameter Real fanSpeMax=1 "Maximum tower fan speed";
  parameter Real fanSpeChe = 0.05 "Lower threshold value to check fan speed";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController chiWatCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="Chilled water controller"));
  parameter Real k=1 "Gain of controller"
    annotation (Dialog(group="Chilled water controller"));
  parameter Real Ti(final quantity="Time", final unit="s")=0.5
    "Time constant of integrator block"
    annotation (Dialog(group="Chilled water controller",
                       enable=chiWatCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                              chiWatCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real Td(final quantity="Time", final unit="s")=0.1
    "Time constant of derivative block"
    annotation (Dialog(group="Chilled water controller",
                       enable=chiWatCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
                              chiWatCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real yMax=1
    "Upper limit of chilled water controller output"
    annotation (Dialog(group="Chilled water controller"));
  parameter Real yMin=0
    "Lower limit of chilled water controller output"
    annotation (Dialog(group="Chilled water controller"));
  parameter Real cheCycOffTim(final quantity="Time", final unit="s")=300
    "Threshold time for checking if fan should cycle off"
    annotation (Dialog(tab="Advanced"));
  parameter Real minCycOffTim(final quantity="Time", final unit="s")=180
    "Minimum time of fan cycling off"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uFanSpe(
    final unit="1") "Measured tower fan speed"
    annotation (Placement(transformation(extent={{-180,86},{-140,126}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-180,-60},{-140,-20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-180,-140},{-140,-100}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySpeSet(
    final min=0,
    final max=1,
    final unit="1")
    "Tower fan speed setpoint when WSE is enabled and there is any chiller running"
    annotation (Placement(transformation(extent={{140,40},{180,80}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{40,130},{60,150}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=cheCycOffTim)
    "Count the time when fan is at minimum speed and the chilled water supply temperature drops below setpoint"
    annotation (Placement(transformation(extent={{80,130},{100,150}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minTowSpe(
    final k=fanSpeMin) "Minimum tower speed"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dFanSpe
    "Different between measured fan speed and the minimum fan speed"
    annotation (Placement(transformation(extent={{-90,90},{-70,110}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys2(
    final uLow=fanSpeChe,
    final uHigh=fanSpeChe + 0.005)
    "Check if tower fan speed is greater than minimum speed"
    annotation (Placement(transformation(extent={{-40,90},{-20,110}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dTChiSup
    "Difference between chilled water supply temperature and its setpoint"
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys1(
    final uLow=-0.1,
    final uHigh=0.1)
    "Check if chilled water supply temperature is greater than setpoint"
    annotation (Placement(transformation(extent={{-40,130},{-20,150}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{0,130},{20,150}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Output true at the moment when input becomes true"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi "Logical switch"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys3(
    final uLow=0.5*5/9,
    final uHigh=1.5*5/9)
    "Check if chilled water supply temperature is greater than setpoint by a threshold delta"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset chiWatTemCon(
    final controllerType=chiWatCon,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=yMax,
    final yMin=yMin,
    final reverseActing=false,
    final y_reset=0)
    "Controller to maintain chilled water supply temperature at setpoint"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(
    final k=yMin)
    "Minimum output from chilled water supply temperature control loop, default to be zero"
    annotation (Placement(transformation(extent={{40,-110},{60,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one(
    final k=yMax)
    "Maximum output from chilled water supply temperature control loop"
    annotation (Placement(transformation(extent={{-20,-150},{0,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant maxTowSpe(
    final k=fanSpeMax)
    "Maximum tower fan speed"
    annotation (Placement(transformation(extent={{40,-150},{60,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Line lin
    "Output the value of the input x along a line specified by two points"
    annotation (Placement(transformation(extent={{100,-130},{120,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg1
    "Output true at the moment when input becomes true"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=minCycOffTim)
    "Minimum time of fan cycling off"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical and"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat1
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre
    "Breaks algebraic loops by an infinitesimal small time delay"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));

equation
  connect(uFanSpe, dFanSpe.u1)
    annotation (Line(points={{-160,106},{-92,106}}, color={0,0,127}));
  connect(dFanSpe.y, hys2.u)
    annotation (Line(points={{-68,100},{-42,100}}, color={0,0,127}));
  connect(hys2.y, not2.u)
    annotation (Line(points={{-18,100},{-2,100}}, color={255,0,255}));
  connect(TChiWatSup, dTChiSup.u1)
    annotation (Line(points={{-160,-40},{-130,-40},{-130,-34},{-112,-34}},
                                                     color={0,0,127}));
  connect(hys1.y, not1.u)
    annotation (Line(points={{-18,140},{-2,140}}, color={255,0,255}));
  connect(dTChiSup.y, hys1.u)
    annotation (Line(points={{-88,-40},{-60,-40},{-60,140},{-42,140}},
      color={0,0,127}));
  connect(not1.y, and2.u1)
    annotation (Line(points={{22,140},{38,140}}, color={255,0,255}));
  connect(not2.y, and2.u2)
    annotation (Line(points={{22,100},{30,100},{30,132},{38,132}}, color={255,0,255}));
  connect(and2.y, tim.u)
    annotation (Line(points={{62,140},{78,140}}, color={255,0,255}));
  connect(edg.y, lat.u)
    annotation (Line(points={{-18,60},{38,60}}, color={255,0,255}));
  connect(lat.y, swi.u2)
    annotation (Line(points={{62,60},{98,60}}, color={255,0,255}));
  connect(dTChiSup.y, hys3.u)
    annotation (Line(points={{-88,-40},{-42,-40}}, color={0,0,127}));
  connect(lat.y, chiWatTemCon.trigger)
    annotation (Line(points={{62,60},{74,60},{74,-80},{-70,-80},{-70,-140},
      {-56,-140},{-56,-132}},  color={255,0,255}));
  connect(zer.y, lin.x1)
    annotation (Line(points={{62,-100},{80,-100},{80,-112},{98,-112}}, color={0,0,127}));
  connect(chiWatTemCon.y, lin.u)
    annotation (Line(points={{-38,-120},{98,-120}}, color={0,0,127}));
  connect(one.y, lin.x2)
    annotation (Line(points={{2,-140},{20,-140},{20,-124},{98,-124}}, color={0,0,127}));
  connect(maxTowSpe.y, lin.f2)
    annotation (Line(points={{62,-140},{80,-140},{80,-128},{98,-128}}, color={0,0,127}));
  connect(lin.y, swi.u3)
    annotation (Line(points={{122,-120},{130,-120},{130,-60},{86,-60},{86,52},
      {98,52}}, color={0,0,127}));
  connect(swi.y,ySpeSet)
    annotation (Line(points={{122,60},{160,60}}, color={0,0,127}));
  connect(minTowSpe.y, dFanSpe.u2)
    annotation (Line(points={{-98,20},{-92,20},{-92,94}}, color={0,0,127}));
  connect(minTowSpe.y, lin.f1)
    annotation (Line(points={{-98,20},{-80,20},{-80,-100},{20,-100},{20,-116},
      {98,-116}},color={0,0,127}));
  connect(hys3.y, and1.u2)
    annotation (Line(points={{-18,-40},{-10,-40},{-10,-28},{-2,-28}},
      color={255,0,255}));
  connect(and1.y, edg1.u)
    annotation (Line(points={{22,-20},{38,-20}}, color={255,0,255}));
  connect(edg1.y, lat.clr)
    annotation (Line(points={{62,-20},{68,-20},{68,40},{30,40},{30,54},{38,54}},
      color={255,0,255}));
  connect(zer.y, swi.u1)
    annotation (Line(points={{62,-100},{80,-100},{80,68},{98,68}}, color={0,0,127}));
  connect(edg.y, lat1.u)
    annotation (Line(points={{-18,60},{0,60},{0,40},{-50,40},{-50,20},{-42,20}},
      color={255,0,255}));
  connect(lat1.y, truDel.u)
    annotation (Line(points={{-18,20},{-2,20}}, color={255,0,255}));
  connect(and1.y, pre.u)
    annotation (Line(points={{22,-20},{30,-20},{30,-50},{38,-50}}, color={255,0,255}));
  connect(pre.y, lat1.clr)
    annotation (Line(points={{62,-50},{68,-50},{68,-70},{-50,-70},{-50,14},
      {-42,14}}, color={255,0,255}));
  connect(truDel.y, and1.u1)
    annotation (Line(points={{22,20},{30,20},{30,0},{-10,0},{-10,-20},{-2,-20}},
      color={255,0,255}));
  connect(tim.passed, edg.u)
    annotation (Line(points={{102,132},{120,132},{120,80},{-50,80},{-50,60},
      {-42,60}}, color={255,0,255}));
  connect(TChiWatSupSet, chiWatTemCon.u_s)
    annotation (Line(points={{-160,-120},{-62,-120}}, color={0,0,127}));
  connect(TChiWatSup, chiWatTemCon.u_m) annotation (Line(points={{-160,-40},{
          -130,-40},{-130,-152},{-50,-152},{-50,-132}}, color={0,0,127}));
  connect(TChiWatSupSet, dTChiSup.u2) annotation (Line(points={{-160,-120},{
          -120,-120},{-120,-46},{-112,-46}}, color={0,0,127}));
annotation (
  defaultComponentName="wseTowSpeWSEOpe",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                         graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          textColor={0,0,255},
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
          extent={{-140,-160},{140,160}})),
Documentation(info="<html>
<p>
Block that output cooling tower fan speed <code>yTowSpe</code> when only waterside 
economizer is running. This is implemented 
according to ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II – 
Central Plants and Hydronic Systems (Draft on March 23, 2020), section 5.2.12.2, 
item 4.b.
</p>
<ol>
<li>
Fan speed shall be modulated to maintain chilled water supply temperature 
<code>TChiWatSup</code> at setpoint <code>TChiWatSupSet</code> by a direct acting 
PID loop that resets fan speed from minimum <code>fanSpeMin</code> at 0% loop output to
maximum <code>fanSpeMax</code> at 100% loop output.
</li>
<li>
If chilled water supply temperature <code>TChiWatSup</code> drops below setpoint
and fans have been at minimum speed <code>fanSpeMin</code> for 5 minutes (<code>cheCycOffTim</code>), 
fans shall cycle off for at lease 3 minutes (<code>minCycOffTim</code>) and until 
<code>TChiWatSup</code> rises above setpoint by 1 &deg;F.
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
