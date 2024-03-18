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
    annotation (Placement(transformation(extent={{0,150},{20,170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minTowSpe(
    final k=fanSpeMin) "Minimum tower speed"
    annotation (Placement(transformation(extent={{-220,30},{-200,50}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dFanSpe
    "Different between measured fan speed and the minimum fan speed"
    annotation (Placement(transformation(extent={{-140,110},{-120,130}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys2(
    final uLow=fanSpeChe,
    final uHigh=fanSpeChe + 0.005)
    "Check if tower fan speed is greater than minimum speed"
    annotation (Placement(transformation(extent={{-100,110},{-80,130}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-60,110},{-40,130}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dTChiSup
    "Difference between chilled water supply temperature and its setpoint"
    annotation (Placement(transformation(extent={{-200,-50},{-180,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys1(
    final uLow=-0.1,
    final uHigh=0.1)
    "Check if chilled water supply temperature is greater than setpoint"
    annotation (Placement(transformation(extent={{-100,150},{-80,170}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-60,150},{-40,170}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi "Logical switch"
    annotation (Placement(transformation(extent={{200,150},{220,170}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys3(
    final uLow=0.5*5/9,
    final uHigh=1.5*5/9)
    "Check if chilled water supply temperature is greater than setpoint by a threshold delta"
    annotation (Placement(transformation(extent={{-160,-50},{-140,-30}})));
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
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Buildings.Controls.OBC.CDL.Logical.Not fanOff
    "Check if the fan cycles off"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Buildings.Controls.OBC.CDL.Logical.And cycOn
    "Check if the fan should be turned on"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=cheCycOffTim)
    "Check if the fan should cycle off"
    annotation (Placement(transformation(extent={{40,150},{60,170}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay cycOffTim(
    final delayTime=minCycOffTim)
    "Check if the fan has been cycled off for threshold time"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));

equation
  connect(uFanSpe, dFanSpe.u1)
    annotation (Line(points={{-260,126},{-142,126}},color={0,0,127}));
  connect(dFanSpe.y, hys2.u)
    annotation (Line(points={{-118,120},{-102,120}}, color={0,0,127}));
  connect(hys2.y, not2.u)
    annotation (Line(points={{-78,120},{-62,120}},color={255,0,255}));
  connect(TChiWatSup, dTChiSup.u1)
    annotation (Line(points={{-260,-34},{-202,-34}}, color={0,0,127}));
  connect(hys1.y, not1.u)
    annotation (Line(points={{-78,160},{-62,160}},color={255,0,255}));
  connect(dTChiSup.y, hys1.u)
    annotation (Line(points={{-178,-40},{-170,-40},{-170,160},{-102,160}},
      color={0,0,127}));
  connect(not1.y, and2.u1)
    annotation (Line(points={{-38,160},{-2,160}},color={255,0,255}));
  connect(not2.y, and2.u2)
    annotation (Line(points={{-38,120},{-20,120},{-20,152},{-2,152}},
      color={255,0,255}));
  connect(fanCycOff.y, swi.u2)
    annotation (Line(points={{122,160},{198,160}}, color={255,0,255}));
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
    annotation (Line(points={{-198,40},{-160,40},{-160,114},{-142,114}},
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
  connect(and2.y, truDel.u)
    annotation (Line(points={{22,160},{38,160}}, color={255,0,255}));
  connect(truDel.y, fanCycOff.u)
    annotation (Line(points={{62,160},{98,160}}, color={255,0,255}));
  connect(hys4.y, fanOff.u)
    annotation (Line(points={{-78,70},{-62,70}}, color={255,0,255}));
  connect(hys3.y, cycOn.u2)
    annotation (Line(points={{-138,-40},{20,-40},{20,62},{38,62}}, color={255,0,255}));
  connect(uFanSpe, hys4.u)
    annotation (Line(points={{-260,126},{-190,126},{-190,70},{-102,70}},
      color={0,0,127}));
  connect(cycOn.y, fanCycOff.clr) annotation (Line(points={{62,70},{80,70},{80,
          154},{98,154}}, color={255,0,255}));
  connect(fanOff.y, cycOffTim.u)
    annotation (Line(points={{-38,70},{-22,70}}, color={255,0,255}));
  connect(cycOffTim.y, cycOn.u1)
    annotation (Line(points={{2,70},{38,70}}, color={255,0,255}));
  connect(cycOn.y, chiWatTemCon.trigger)
    annotation (Line(points={{62,70},{80,70},{80,-80},{-160,-80},{-160,-160},
      {-136,-160},{-136,-152}}, color={255,0,255}));

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
