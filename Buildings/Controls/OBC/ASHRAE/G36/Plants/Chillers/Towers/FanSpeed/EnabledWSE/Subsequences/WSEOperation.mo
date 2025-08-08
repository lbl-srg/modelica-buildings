within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Towers.FanSpeed.EnabledWSE.Subsequences;
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
    annotation (Placement(transformation(extent={{-280,106},{-240,146}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-280,-54},{-240,-14}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
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
    annotation (Placement(transformation(extent={{240,140},{280,180}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Logical.Latch fanCycOff "Cycle off fan"
    annotation (Placement(transformation(extent={{100,150},{120,170}})));

protected
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Check if the fan is at minimum speed and the chiller water supply temperature is lower than the setpoint"
    annotation (Placement(transformation(extent={{-20,150},{0,170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minTowSpe(
    final k=fanSpeMin) "Minimum tower speed"
    annotation (Placement(transformation(extent={{-220,30},{-200,50}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dFanSpe
    "Different between measured fan speed and the minimum fan speed"
    annotation (Placement(transformation(extent={{-160,110},{-140,130}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys2(
    final uLow=fanSpeChe,
    final uHigh=fanSpeChe + 0.005)
    "Check if tower fan speed is greater than minimum speed"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dTChiSup
    "Difference between chilled water supply temperature and its setpoint"
    annotation (Placement(transformation(extent={{-200,-50},{-180,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys1(
    final uLow=-0.1,
    final uHigh=0.1)
    "Check if chilled water supply temperature is greater than setpoint"
    annotation (Placement(transformation(extent={{-120,150},{-100,170}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-80,150},{-60,170}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi "Logical switch"
    annotation (Placement(transformation(extent={{200,150},{220,170}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys3(
    final uLow=0.5*5/9,
    final uHigh=1.5*5/9)
    "Check if chilled water supply temperature is greater than setpoint by a threshold delta"
    annotation (Placement(transformation(extent={{-160,-50},{-140,-30}})));
  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Generic.PIDWithEnable chiWatTemCon(
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
    annotation (Placement(transformation(extent={{80,-110},{100,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one(
    final k=yMax)
    "Maximum output from chilled water supply temperature control loop"
    annotation (Placement(transformation(extent={{-20,-190},{0,-170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant maxTowSpe(
    final k=fanSpeMax)
    "Maximum tower fan speed"
    annotation (Placement(transformation(extent={{80,-190},{100,-170}})));
  Buildings.Controls.OBC.CDL.Reals.Line lin
    "Output the value of the input x along a line specified by two points"
    annotation (Placement(transformation(extent={{160,-150},{180,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys4(
    final uLow=fanSpeChe,
    final uHigh=fanSpeChe + 0.005)
    "Check if tower fan speed is greater than zero"
    annotation (Placement(transformation(extent={{-160,60},{-140,80}})));
  Buildings.Controls.OBC.CDL.Logical.Not fanOff
    "Check if the fan cycles off"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  Buildings.Controls.OBC.CDL.Logical.And cycOn
    "Check if the fan should be turned on"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=cheCycOffTim)
    "Check if the fan should cycle off"
    annotation (Placement(transformation(extent={{60,150},{80,170}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay cycOffTim(
    final delayTime=minCycOffTim)
    "Check if the fan has been cycled off for threshold time"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre
    "Break loop"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre1
    "Break loop"
    annotation (Placement(transformation(extent={{20,150},{40,170}})));
equation
  connect(uFanSpe, dFanSpe.u1)
    annotation (Line(points={{-260,126},{-162,126}},color={0,0,127}));
  connect(dFanSpe.y, hys2.u)
    annotation (Line(points={{-138,120},{-122,120}}, color={0,0,127}));
  connect(hys2.y, not2.u)
    annotation (Line(points={{-98,120},{-82,120}},color={255,0,255}));
  connect(TChiWatSup, dTChiSup.u1)
    annotation (Line(points={{-260,-34},{-202,-34}}, color={0,0,127}));
  connect(hys1.y, not1.u)
    annotation (Line(points={{-98,160},{-82,160}},color={255,0,255}));
  connect(dTChiSup.y, hys1.u)
    annotation (Line(points={{-178,-40},{-170,-40},{-170,160},{-122,160}},
      color={0,0,127}));
  connect(not1.y, and2.u1)
    annotation (Line(points={{-58,160},{-22,160}}, color={255,0,255}));
  connect(not2.y, and2.u2)
    annotation (Line(points={{-58,120},{-40,120},{-40,152},{-22,152}},
      color={255,0,255}));
  connect(dTChiSup.y, hys3.u)
    annotation (Line(points={{-178,-40},{-162,-40}}, color={0,0,127}));
  connect(zer.y, lin.x1)
    annotation (Line(points={{102,-100},{140,-100},{140,-132},{158,-132}},
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
    annotation (Line(points={{182,-140},{190,-140},{190,152},{198,152}},
      color={0,0,127}));
  connect(swi.y,ySpeSet)
    annotation (Line(points={{222,160},{260,160}}, color={0,0,127}));
  connect(minTowSpe.y, dFanSpe.u2)
    annotation (Line(points={{-198,40},{-180,40},{-180,114},{-162,114}},
      color={0,0,127}));
  connect(minTowSpe.y, lin.f1)
    annotation (Line(points={{-198,40},{-100,40},{-100,-136},{158,-136}},
      color={0,0,127}));
  connect(zer.y, swi.u1)
    annotation (Line(points={{102,-100},{140,-100},{140,168},{198,168}},
      color={0,0,127}));
  connect(TChiWatSupSet, chiWatTemCon.u_s)
    annotation (Line(points={{-260,-140},{-142,-140}},color={0,0,127}));
  connect(TChiWatSup, chiWatTemCon.u_m)
    annotation (Line(points={{-260,-34},{-230,-34},{-230,-172},{-130,-172},
      {-130,-152}}, color={0,0,127}));
  connect(TChiWatSupSet, dTChiSup.u2)
    annotation (Line(points={{-260,-140},{-220,-140},{-220,-46},{-202,-46}},
      color={0,0,127}));
  connect(truDel.y, fanCycOff.u)
    annotation (Line(points={{82,160},{98,160}}, color={255,0,255}));
  connect(hys4.y, fanOff.u)
    annotation (Line(points={{-138,70},{-122,70}}, color={255,0,255}));
  connect(hys3.y, cycOn.u2)
    annotation (Line(points={{-138,-40},{-50,-40},{-50,62},{-22,62}}, color={255,0,255}));
  connect(uFanSpe, hys4.u)
    annotation (Line(points={{-260,126},{-210,126},{-210,70},{-162,70}},
      color={0,0,127}));
  connect(fanOff.y, cycOffTim.u)
    annotation (Line(points={{-98,70},{-82,70}}, color={255,0,255}));
  connect(cycOffTim.y, cycOn.u1)
    annotation (Line(points={{-58,70},{-22,70}}, color={255,0,255}));
  connect(cycOn.y, pre.u)
    annotation (Line(points={{2,70},{38,70}}, color={255,0,255}));
  connect(pre.y, fanCycOff.clr) annotation (Line(points={{62,70},{90,70},{90,
          154},{98,154}}, color={255,0,255}));
  connect(pre.y, chiWatTemCon.uEna) annotation (Line(points={{62,70},{90,70},{
          90,-80},{-160,-80},{-160,-160},{-134,-160},{-134,-152}}, color={255,0,
          255}));
  connect(fanCycOff.y, swi.u2)
    annotation (Line(points={{122,160},{198,160}}, color={255,0,255}));
  connect(and2.y, pre1.u)
    annotation (Line(points={{2,160},{18,160}}, color={255,0,255}));
  connect(pre1.y, truDel.u)
    annotation (Line(points={{42,160},{58,160}}, color={255,0,255}));
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
Block that output cooling tower fan speed <code>yTowSpe</code> when only waterside 
economizer is running. This is implemented 
according to ASHRAE Guideline36-2021, section 5.20.12.2, item c.2.
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
