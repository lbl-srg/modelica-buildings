within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Towers.FanSpeed.EnabledWSE.Subsequences;
block WSEOperation
  "Tower fan speed control when the waterside economizer is running alone"

  parameter Real fanSpeMin=0.1 "Minimum tower fan speed";
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
    annotation (Placement(transformation(extent={{-280,126},{-240,166}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWse
    "Waterside economizer enabling status: true=ON"
    annotation (Placement(transformation(extent={{-280,0},{-240,40}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEnaPla
    "True: plant is just enabled"
    annotation(Placement(transformation(extent={{-280,-40},{-240,0}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-280,-74},{-240,-34}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-280,-160},{-240,-120}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySpeSet(
    final min=0,
    final max=1,
    final unit="1")
    "Tower fan speed setpoint when WSE is enabled and there is any chiller running"
    annotation (Placement(transformation(extent={{240,160},{280,200}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Logical.Latch fanCycOff "Cycle off fan"
    annotation (Placement(transformation(extent={{100,170},{120,190}})));

protected
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Check if the fan is at minimum speed and the chiller water supply temperature is lower than the setpoint"
    annotation (Placement(transformation(extent={{-20,170},{0,190}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minTowSpe(
    final k=fanSpeMin) "Minimum tower speed"
    annotation (Placement(transformation(extent={{-220,50},{-200,70}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dFanSpe
    "Different between measured fan speed and the minimum fan speed"
    annotation (Placement(transformation(extent={{-160,130},{-140,150}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys2(
    final uLow=fanSpeChe,
    final uHigh=fanSpeChe + 0.005)
    "Check if tower fan speed is greater than minimum speed"
    annotation (Placement(transformation(extent={{-120,130},{-100,150}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-80,130},{-60,150}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dTChiSup
    "Difference between chilled water supply temperature and its setpoint"
    annotation (Placement(transformation(extent={{-200,-70},{-180,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys1(
    final uLow=-0.1,
    final uHigh=0.1)
    "Check if chilled water supply temperature is greater than setpoint"
    annotation (Placement(transformation(extent={{-120,170},{-100,190}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-80,170},{-60,190}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi "Logical switch"
    annotation (Placement(transformation(extent={{200,170},{220,190}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys3(
    final uLow=0.5*5/9,
    final uHigh=1.5*5/9)
    "Check if chilled water supply temperature is greater than setpoint by a threshold delta"
    annotation (Placement(transformation(extent={{-160,-70},{-140,-50}})));
  Buildings.Controls.OBC.Utilities.PIDWithEnable chiWatTemCon(
    final controllerType=chiWatCon,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=yMax,
    final yMin=yMin,
    final reverseActing=false,
    final y_reset=0)
    "Controller to maintain chilled water supply temperature at setpoint"
    annotation (Placement(transformation(extent={{-140,-150},{-120,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(
    final k=yMin)
    "Minimum output from chilled water supply temperature control loop, default to be zero"
    annotation (Placement(transformation(extent={{100,-110},{120,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one(
    final k=yMax)
    "Maximum output from chilled water supply temperature control loop"
    annotation (Placement(transformation(extent={{-20,-190},{0,-170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant maxTowSpe(final k=1)
    "Maximum tower fan speed"
    annotation (Placement(transformation(extent={{80,-190},{100,-170}})));
  Buildings.Controls.OBC.CDL.Reals.Line lin
    "Output the value of the input x along a line specified by two points"
    annotation (Placement(transformation(extent={{160,-150},{180,-130}})));
  Buildings.Controls.OBC.CDL.Logical.And cycOn
    "Check if the fan should be turned on"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=cheCycOffTim)
    "Check if the fan should cycle off"
    annotation (Placement(transformation(extent={{60,170},{80,190}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay cycOffTim(
    final delayTime=minCycOffTim)
    "Check if the fan has been cycled off for threshold time"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre
    "Break loop"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre1
    "Break loop"
    annotation (Placement(transformation(extent={{20,170},{40,190}})));
  Buildings.Controls.OBC.CDL.Logical.And enaInWse
    "Plant enabled in WSE mode"
    annotation (Placement(transformation(extent={{-200,10},{-180,30}})));
  Buildings.Controls.OBC.CDL.Logical.Or cycOn1
    "Cycle fan on"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));

equation
  connect(uFanSpe, dFanSpe.u1)
    annotation (Line(points={{-260,146},{-162,146}},color={0,0,127}));
  connect(dFanSpe.y, hys2.u)
    annotation (Line(points={{-138,140},{-122,140}}, color={0,0,127}));
  connect(hys2.y, not2.u)
    annotation (Line(points={{-98,140},{-82,140}},color={255,0,255}));
  connect(TChiWatSup, dTChiSup.u1)
    annotation (Line(points={{-260,-54},{-202,-54}}, color={0,0,127}));
  connect(hys1.y, not1.u)
    annotation (Line(points={{-98,180},{-82,180}},color={255,0,255}));
  connect(dTChiSup.y, hys1.u)
    annotation (Line(points={{-178,-60},{-170,-60},{-170,180},{-122,180}},
      color={0,0,127}));
  connect(not1.y, and2.u1)
    annotation (Line(points={{-58,180},{-22,180}}, color={255,0,255}));
  connect(not2.y, and2.u2)
    annotation (Line(points={{-58,140},{-40,140},{-40,172},{-22,172}},
      color={255,0,255}));
  connect(dTChiSup.y, hys3.u)
    annotation (Line(points={{-178,-60},{-162,-60}}, color={0,0,127}));
  connect(zer.y, lin.x1)
    annotation (Line(points={{122,-100},{140,-100},{140,-132},{158,-132}},
      color={0,0,127}));
  connect(chiWatTemCon.y, lin.u)
    annotation (Line(points={{-118,-140},{158,-140}}, color={0,0,127}));
  connect(one.y, lin.x2)
    annotation (Line(points={{2,-180},{20,-180},{20,-144},{158,-144}},
      color={0,0,127}));
  connect(maxTowSpe.y, lin.f2)
    annotation (Line(points={{102,-180},{140,-180},{140,-148},{158,-148}},
      color={0,0,127}));
  connect(lin.y, swi.u3)
    annotation (Line(points={{182,-140},{190,-140},{190,172},{198,172}},
      color={0,0,127}));
  connect(swi.y,ySpeSet)
    annotation (Line(points={{222,180},{260,180}}, color={0,0,127}));
  connect(minTowSpe.y, dFanSpe.u2)
    annotation (Line(points={{-198,60},{-180,60},{-180,134},{-162,134}},
      color={0,0,127}));
  connect(minTowSpe.y, lin.f1)
    annotation (Line(points={{-198,60},{-100,60},{-100,-136},{158,-136}},
      color={0,0,127}));
  connect(zer.y, swi.u1)
    annotation (Line(points={{122,-100},{160,-100},{160,188},{198,188}},
      color={0,0,127}));
  connect(TChiWatSupSet, chiWatTemCon.u_s)
    annotation (Line(points={{-260,-140},{-142,-140}},color={0,0,127}));
  connect(TChiWatSup, chiWatTemCon.u_m)
    annotation (Line(points={{-260,-54},{-230,-54},{-230,-172},{-130,-172},{-130,
          -152}},   color={0,0,127}));
  connect(TChiWatSupSet, dTChiSup.u2)
    annotation (Line(points={{-260,-140},{-220,-140},{-220,-66},{-202,-66}},
      color={0,0,127}));
  connect(truDel.y, fanCycOff.u)
    annotation (Line(points={{82,180},{98,180}}, color={255,0,255}));
  connect(hys3.y, cycOn.u2)
    annotation (Line(points={{-138,-60},{-80,-60},{-80,82},{-62,82}}, color={255,0,255}));
  connect(cycOffTim.y, cycOn.u1)
    annotation (Line(points={{-98,90},{-62,90}}, color={255,0,255}));
  connect(pre.y, fanCycOff.clr) annotation (Line(points={{62,90},{90,90},{90,174},
          {98,174}},      color={255,0,255}));
  connect(fanCycOff.y, swi.u2)
    annotation (Line(points={{122,180},{198,180}}, color={255,0,255}));
  connect(and2.y, pre1.u)
    annotation (Line(points={{2,180},{18,180}}, color={255,0,255}));
  connect(pre1.y, truDel.u)
    annotation (Line(points={{42,180},{58,180}}, color={255,0,255}));
  connect(pre.y, chiWatTemCon.uEna) annotation (Line(points={{62,90},{90,90},{90,
          -100},{-160,-100},{-160,-160},{-134,-160},{-134,-152}}, color={255,0,255}));
  connect(uWse, enaInWse.u1)
    annotation (Line(points={{-260,20},{-202,20}}, color={255,0,255}));
  connect(uEnaPla, enaInWse.u2) annotation (Line(points={{-260,-20},{-220,-20},{
          -220,12},{-202,12}}, color={255,0,255}));
  connect(cycOn.y, cycOn1.u1)
    annotation (Line(points={{-38,90},{-2,90}}, color={255,0,255}));
  connect(cycOn1.y, pre.u)
    annotation (Line(points={{22,90},{38,90}}, color={255,0,255}));
  connect(enaInWse.y, cycOn1.u2) annotation (Line(points={{-178,20},{-20,20},{-20,
          82},{-2,82}}, color={255,0,255}));
  connect(fanCycOff.y, cycOffTim.u) annotation (Line(points={{122,180},{140,180},
          {140,120},{-140,120},{-140,90},{-122,90}}, color={255,0,255}));
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
