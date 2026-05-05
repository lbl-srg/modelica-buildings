within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Towers.FanSpeed.EnabledWSE.Subsequences;
block WSEOperation
  "Tower fan speed control when the waterside economizer is running alone"

  parameter Real fanSpeMin(unit="1")=0.1 "Minimum tower fan speed";
  parameter Real fanSpeMax(unit="1")=1 "Maximum tower fan speed";
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
  parameter Real fanSpeChe(unit="1") = 0.05 "Lower threshold value to check fan speed"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-280,110},{-240,150}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla
    "True: plant is enabled"
    annotation (Placement(transformation(extent={{-280,10},{-240,50}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uFanSpe(
    final unit="1") "Measured tower fan speed"
    annotation (Placement(transformation(extent={{-280,-74},{-240,-34}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-280,-194},{-240,-154}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySpeSet(
    final min=0,
    final max=1,
    final unit="1")
    "Tower fan speed setpoint when WSE is enabled and there is any chiller running"
    annotation (Placement(transformation(extent={{240,10},{280,50}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Logical.Latch fanCycOff "Cycle off fan"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

protected
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Check if the fan is at minimum speed and the chiller water supply temperature is lower than the setpoint"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minTowSpe(
    final k=fanSpeMin) "Minimum tower speed"
    annotation (Placement(transformation(extent={{-200,-130},{-180,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dFanSpe
    "Different between measured fan speed and the minimum fan speed"
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys2(
    final uLow=fanSpeChe,
    final uHigh=fanSpeChe + 0.005)
    "Check if tower fan speed is greater than minimum speed"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dTChiSup
    "Difference between chilled water supply temperature and its setpoint"
    annotation (Placement(transformation(extent={{-180,-190},{-160,-170}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys1(
    final uLow=-0.1,
    final uHigh=0.1)
    "Check if chilled water supply temperature is greater than setpoint"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi "Logical switch"
    annotation (Placement(transformation(extent={{200,20},{220,40}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys3(
    final uLow=0.5*5/9,
    final uHigh=1.5*5/9)
    "Check if chilled water supply temperature is greater than setpoint by a threshold delta"
    annotation (Placement(transformation(extent={{-120,-190},{-100,-170}})));
  Buildings.Controls.OBC.Utilities.PIDWithEnable chiWatTemCon(
    final controllerType=chiWatCon,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=1,
    final yMin=0,
    final reverseActing=false,
    final y_reset=0)
    "Controller to maintain chilled water supply temperature at setpoint"
    annotation (Placement(transformation(extent={{-200,120},{-180,140}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(
    final k=yMin)
    "Minimum output from chilled water supply temperature control loop, default to be zero"
    annotation (Placement(transformation(extent={{60,160},{80,180}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one(
    final k=yMax)
    "Maximum output from chilled water supply temperature control loop"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant maxTowSpe(
    final k=fanSpeMax)
    "Maximum tower fan speed"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Buildings.Controls.OBC.CDL.Reals.Line lin
    "Output the value of the input x along a line specified by two points"
    annotation (Placement(transformation(extent={{120,120},{140,140}})));
  Buildings.Controls.OBC.CDL.Logical.And cycOn
    "Check if the fan should be turned on"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=cheCycOffTim)
    "Check if the fan should cycle off"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay cycOffTim(
    final delayTime=minCycOffTim)
    "Check if the fan has been cycled off for threshold time"
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre
    "Break loop"
    annotation (Placement(transformation(extent={{-20,-130},{0,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre1
    "Break loop"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Logical.And enaFan
    "Check if the fan should be enabled"
    annotation (Placement(transformation(extent={{140,20},{160,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zerSpe(
    final k=0) "Zero speed"
    annotation (Placement(transformation(extent={{140,-90},{160,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3 "Fan should not off"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  connect(uFanSpe, dFanSpe.u1)
    annotation (Line(points={{-260,-54},{-142,-54}},color={0,0,127}));
  connect(dFanSpe.y, hys2.u)
    annotation (Line(points={{-118,-60},{-102,-60}}, color={0,0,127}));
  connect(hys2.y, not2.u)
    annotation (Line(points={{-78,-60},{-62,-60}},color={255,0,255}));
  connect(TChiWatSup, dTChiSup.u1)
    annotation (Line(points={{-260,-174},{-182,-174}}, color={0,0,127}));
  connect(hys1.y, not1.u)
    annotation (Line(points={{-118,0},{-102,0}},  color={255,0,255}));
  connect(dTChiSup.y, hys1.u)
    annotation (Line(points={{-158,-180},{-150,-180},{-150,0},{-142,0}},
      color={0,0,127}));
  connect(not1.y, and2.u1)
    annotation (Line(points={{-78,0},{-62,0}}, color={255,0,255}));
  connect(dTChiSup.y, hys3.u)
    annotation (Line(points={{-158,-180},{-122,-180}}, color={0,0,127}));
  connect(zer.y, lin.x1)
    annotation (Line(points={{82,170},{100,170},{100,138},{118,138}},
      color={0,0,127}));
  connect(chiWatTemCon.y, lin.u)
    annotation (Line(points={{-178,130},{118,130}},   color={0,0,127}));
  connect(one.y, lin.x2)
    annotation (Line(points={{-38,90},{-20,90},{-20,126},{118,126}},
      color={0,0,127}));
  connect(maxTowSpe.y, lin.f2)
    annotation (Line(points={{62,90},{100,90},{100,122},{118,122}},
      color={0,0,127}));
  connect(swi.y,ySpeSet)
    annotation (Line(points={{222,30},{260,30}},   color={0,0,127}));
  connect(minTowSpe.y, dFanSpe.u2)
    annotation (Line(points={{-178,-120},{-170,-120},{-170,-66},{-142,-66}},
      color={0,0,127}));
  connect(minTowSpe.y, lin.f1)
    annotation (Line(points={{-178,-120},{-170,-120},{-170,134},{118,134}},
      color={0,0,127}));
  connect(TChiWatSupSet, chiWatTemCon.u_s)
    annotation (Line(points={{-260,130},{-202,130}},  color={0,0,127}));
  connect(TChiWatSup, chiWatTemCon.u_m)
    annotation (Line(points={{-260,-174},{-210,-174},{-210,80},{-190,80},{-190,118}},
      color={0,0,127}));
  connect(TChiWatSupSet, dTChiSup.u2)
    annotation (Line(points={{-260,130},{-220,130},{-220,-186},{-182,-186}},
      color={0,0,127}));
  connect(truDel.y, fanCycOff.u)
    annotation (Line(points={{42,0},{58,0}}, color={255,0,255}));
  connect(hys3.y, cycOn.u2)
    annotation (Line(points={{-98,-180},{-80,-180},{-80,-128},{-62,-128}}, color={255,0,255}));
  connect(cycOffTim.y, cycOn.u1)
    annotation (Line(points={{-98,-120},{-62,-120}}, color={255,0,255}));
  connect(pre.y, fanCycOff.clr) annotation (Line(points={{2,-120},{50,-120},{50,
          -6},{58,-6}},   color={255,0,255}));
  connect(and2.y, pre1.u)
    annotation (Line(points={{-38,0},{-22,0}},  color={255,0,255}));
  connect(pre1.y, truDel.u)
    annotation (Line(points={{2,0},{18,0}},      color={255,0,255}));
  connect(fanCycOff.y, cycOffTim.u) annotation (Line(points={{82,0},{90,0},{90,-90},
          {-140,-90},{-140,-120},{-122,-120}},       color={255,0,255}));
  connect(cycOn.y, pre.u)
    annotation (Line(points={{-38,-120},{-22,-120}}, color={255,0,255}));
  connect(uPla, enaFan.u1)
    annotation (Line(points={{-260,30},{138,30}}, color={255,0,255}));
  connect(enaFan.y, swi.u2)
    annotation (Line(points={{162,30},{198,30}}, color={255,0,255}));
  connect(enaFan.y, chiWatTemCon.uEna) annotation (Line(points={{162,30},{170,30},
          {170,60},{-194,60},{-194,118}}, color={255,0,255}));
  connect(lin.y, swi.u1) annotation (Line(points={{142,130},{180,130},{180,38},{
          198,38}}, color={0,0,127}));
  connect(zerSpe.y, swi.u3) annotation (Line(points={{162,-80},{180,-80},{180,22},
          {198,22}}, color={0,0,127}));
  connect(not2.y, and2.u2) annotation (Line(points={{-38,-60},{-30,-60},{-30,-30},
          {-70,-30},{-70,-8},{-62,-8}}, color={255,0,255}));
  connect(fanCycOff.y, not3.u)
    annotation (Line(points={{82,0},{98,0}}, color={255,0,255}));
  connect(not3.y, enaFan.u2) annotation (Line(points={{122,0},{130,0},{130,22},{
          138,22}}, color={255,0,255}));
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
          extent={{-240,-200},{240,200}})),
Documentation(info="<html>
<p>
Block that output cooling tower fan speed <code>yTowSpe</code> when only the
waterside economizer is running. This is implemented
according to ASHRAE Guideline 36-2021, section 5.20.12.2, item c.2.
</p>
<ol>
<li>
Fan speed shall be modulated to maintain chilled water supply temperature 
<code>TChiWatSup</code> at setpoint <code>TChiWatSupSet</code> by a direct acting 
PID loop that resets fan speed from minimum <code>fanSpeMin</code> at 0% loop output to
maximum at 100% loop output.
</li>
<li>
If chilled water supply temperature <code>TChiWatSup</code> drops below setpoint
and fans have been at minimum speed <code>fanSpeMin</code> for 5 minutes (<code>cheCycOffTim</code>), 
fans shall cycle off for at least 3 minutes (<code>minCycOffTim</code>) and until 
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
