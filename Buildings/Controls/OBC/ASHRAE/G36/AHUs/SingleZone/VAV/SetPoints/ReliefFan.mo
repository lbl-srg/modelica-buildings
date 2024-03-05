within Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints;
block ReliefFan "Sequence for control of relief fan in AHU"

  parameter Real relFanSpe_min(
    final min=0,
    final max=1)= 0.1
    "Relief fan minimum speed";
  parameter Real dpBuiSet(
    final unit="Pa",
    final quantity="PressureDifference",
    final max=30) = 12
    "Building static pressure difference relative to ambient (positive to pressurize the building)";
  parameter Real k(
    final unit="1") = 1
    "Gain, normalized using dpBuiSet"
    annotation (Dialog(group="Pressure controller"));
  parameter Real hys = 0.005
    "Hysteresis for checking the controller output value"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpBui(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference")
    "Building static pressure difference, relative to ambient (positive if pressurized)"
    annotation (Placement(transformation(extent={{-280,120},{-240,160}}),
      iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1SupFan
    "AHU supply fan proven on status"
    annotation (Placement(transformation(extent={{-280,12},{-240,52}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDpBui(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference")
    "Building static pressure difference, relative to ambient (positive if pressurized)"
    annotation (Placement(transformation(extent={{220,120},{260,160}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDam(
    final unit="1",
    final min=0,
    final max=1)
    "Damper commanded position"
    annotation (Placement(transformation(extent={{220,20},{260,60}}),
        iconTransformation(extent={{100,10},{140,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRelFan(
    final unit="1",
    final max=1)
    "Relief fan commanded speed"
    annotation (Placement(transformation(extent={{220,-60},{260,-20}}),
        iconTransformation(extent={{100,-50},{140,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1RelFan
    "Relief fan commanded on"
    annotation (Placement(transformation(extent={{220,-120},{260,-80}}),
        iconTransformation(extent={{100,-100},{140,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.MovingAverage movMea(
    final delta=300)
    "Average building static pressure measurement"
    annotation (Placement(transformation(extent={{-220,130},{-200,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpBuiSetPoi(
    final k=dpBuiSet)
    "Building pressure setpoint"
    annotation (Placement(transformation(extent={{-220,70},{-200,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide div1
    "Normalized the control error"
    annotation (Placement(transformation(extent={{-180,100},{-160,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conOne(
    final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-180,160},{-160,180}})));
  Buildings.Controls.OBC.CDL.Continuous.PID conP(
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final k=k,
    final reverseActing=false)
    "Building static pressure controller"
    annotation (Placement(transformation(extent={{-140,160},{-120,180}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=0.05,
    final h=hys)
    "Check if the controller output is greater than threshold"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr(
    final t=0.005,
    final h=hys)
    "Check if the controller output is near zero"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=300)
    "Check if the controller output has been near zero for threshold time"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Check if the controller output is greater than threshold and the relief system has been enabled"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Enable damper"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr2(
    final t=relFanSpe_min + 0.15,
    final h=hys)
    "Check if the controller output is greater than minimum speed plus threshold"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Timer upTim(
    final t=420)
    "Check if the controller output has been greater than threshold for sufficient long time"
    annotation (Placement(transformation(extent={{-40,-110},{-20,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr3(
    final t=relFanSpe_min,
    final h=hys)
    "Check if the controller output is less than minimum speed"
    annotation (Placement(transformation(extent={{-80,-170},{-60,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Timer dowTim(
    final t=300)
    "Check if the controller output has been less than threshold for sufficient long time"
    annotation (Placement(transformation(extent={{-40,-170},{-20,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat1
    "Stage down lag fan"
    annotation (Placement(transformation(extent={{0,-118},{20,-98}})));
  Buildings.Controls.OBC.CDL.Logical.Or relDam
    "Open relief damper"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Buildings.Controls.OBC.CDL.Logical.And relFan
    "Turn on relief fan"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea2
    "Convert boolean to real"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply pro1 "Relief fan speed"
    annotation (Placement(transformation(extent={{160,-50},{180,-30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
    "Convert boolean to real"
    annotation (Placement(transformation(extent={{160,30},{180,50}})));

equation
  connect(dpBui, movMea.u)
    annotation (Line(points={{-260,140},{-222,140}}, color={0,0,127}));
  connect(dpBuiSetPoi.y, div1.u2) annotation (Line(points={{-198,80},{-190,80},{
          -190,104},{-182,104}},  color={0,0,127}));
  connect(movMea.y, div1.u1) annotation (Line(points={{-198,140},{-190,140},{-190,
          116},{-182,116}}, color={0,0,127}));
  connect(div1.y, conP.u_m) annotation (Line(points={{-158,110},{-130,110},{-130,
          158}}, color={0,0,127}));
  connect(conOne.y, conP.u_s)
    annotation (Line(points={{-158,170},{-142,170}}, color={0,0,127}));
  connect(conP.y, greThr.u) annotation (Line(points={{-118,170},{-100,170},{-100,
          60},{-82,60}}, color={0,0,127}));
  connect(greThr.y, and2.u1) annotation (Line(points={{-58,60},{-40,60},{-40,40},
          {-22,40}}, color={255,0,255}));
  connect(conP.y, lesThr.u) annotation (Line(points={{-118,170},{-100,170},{-100,
          0},{-82,0}},   color={0,0,127}));
  connect(lesThr.y, tim.u)
    annotation (Line(points={{-58,0},{-22,0}},   color={255,0,255}));
  connect(tim.passed, lat.clr) annotation (Line(points={{2,-8},{20,-8},{20,34},{
          38,34}}, color={255,0,255}));
  connect(and2.y, lat.u)
    annotation (Line(points={{2,40},{38,40}}, color={255,0,255}));
  connect(u1SupFan, and2.u2)
    annotation (Line(points={{-260,32},{-22,32}}, color={255,0,255}));
  connect(conP.y, greThr2.u) annotation (Line(points={{-118,170},{-100,170},{-100,
          -100},{-82,-100}}, color={0,0,127}));
  connect(greThr2.y, upTim.u)
    annotation (Line(points={{-58,-100},{-42,-100}}, color={255,0,255}));
  connect(conP.y, lesThr3.u) annotation (Line(points={{-118,170},{-100,170},{-100,
          -160},{-82,-160}}, color={0,0,127}));
  connect(lesThr3.y, dowTim.u)
    annotation (Line(points={{-58,-160},{-42,-160}}, color={255,0,255}));
  connect(upTim.passed, lat1.u)
    annotation (Line(points={{-18,-108},{-2,-108}}, color={255,0,255}));
  connect(dowTim.passed, lat1.clr) annotation (Line(points={{-18,-168},{-10,-168},
          {-10,-114},{-2,-114}}, color={255,0,255}));
  connect(lat.y, relDam.u1)
    annotation (Line(points={{62,40},{98,40}}, color={255,0,255}));
  connect(u1SupFan, relFan.u1) annotation (Line(points={{-260,32},{-220,32},{-220,
          -60},{38,-60}}, color={255,0,255}));
  connect(lat1.y, relFan.u2) annotation (Line(points={{22,-108},{30,-108},{30,-68},
          {38,-68}}, color={255,0,255}));
  connect(relFan.y, relDam.u2) annotation (Line(points={{62,-60},{80,-60},{80,32},
          {98,32}}, color={255,0,255}));
  connect(relFan.y, booToRea2.u)
    annotation (Line(points={{62,-60},{98,-60}}, color={255,0,255}));
  connect(booToRea2.y, pro1.u2) annotation (Line(points={{122,-60},{140,-60},{140,
          -46},{158,-46}}, color={0,0,127}));
  connect(conP.y, pro1.u1) annotation (Line(points={{-118,170},{-100,170},{-100,
          -34},{158,-34}}, color={0,0,127}));
  connect(movMea.y, yDpBui)
    annotation (Line(points={{-198,140},{240,140}}, color={0,0,127}));
  connect(relDam.y, booToRea1.u)
    annotation (Line(points={{122,40},{158,40}}, color={255,0,255}));
  connect(booToRea1.y, yDam)
    annotation (Line(points={{182,40},{240,40}}, color={0,0,127}));
  connect(pro1.y, yRelFan)
    annotation (Line(points={{182,-40},{240,-40}}, color={0,0,127}));
  connect(relFan.y, y1RelFan) annotation (Line(points={{62,-60},{80,-60},{80,-100},
          {240,-100}},color={255,0,255}));
annotation (defaultComponentName="relFanCon",
 Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                         graphics={
        Text(extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name"),
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,-18},{-56,-38}},
          textColor={255,0,255},
          textString="u1SupFan"),
        Text(
          extent={{-100,40},{-58,20}},
          textColor={0,0,127},
          textString="dpBui"),
        Text(
          extent={{48,-20},{98,-38}},
          textColor={0,0,127},
          textString="yRelFan"),
        Text(
          extent={{56,88},{96,72}},
          textColor={0,0,127},
          textString="yDpBui"),
        Text(
          extent={{60,38},{100,22}},
          textColor={0,0,127},
          textString="yDam"),
        Text(
          extent={{56,-70},{98,-90}},
          textColor={255,0,255},
          textString="y1RelFan")}),
 Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-240,-220},{220,220}})),
Documentation(info="<html>
<p>
Sequence for controling relief fan that is part of AHU. It is developed based on
Section 5.16.9 of ASHRAE Guideline 36, May 2020, with the modification to accommodate
the single relief fan control.
</p>
<ol>
<li>
The relief fan shall be enabled when the AHU supply fan is proven ON
(<code>u1SupFan=true</code>), and shall be disabled otherwise.
</li>
<li>
Building static pressure (<code>dpBui</code>) shall be time averaged with a sliding
5-minute window and 15 second sampling rate (to dampen fluctuations). The average
value shall be that displayed and used for control.
</li>
<li>
A P-only control loop maintains the building pressure at a set point (<code>dpBuiSet</code>)
of 12 Pa (0.05 in. of water) with an output ranging from 0% to 100%. The loop is disabled
and output set to zero when the relief fan is disabled.
</li>
<li>
Fan speed shall be equal to the PID signal but no less than the minimum speed.
<ol type=\"a\">
<li>
When relief system is enabled, and the control loop
output is above 5%, open the motorized dampers to the relief fans;
close the dampers when the loop output drops to 0% for 5 minutes.
</li>
<li>
When the control loop output is above minimum speed (<code>relFanSpe_min</code>) plus 15%
by 7 minutes, start the relief fan.
</li>
<li>
When the control loop output is below minimum speed (<code>relFanSpe_min</code>)
by 5 minutes, shut off the relief fan.
</li>
</ol>
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
March 5, 2024, by Michael Wetter:<br/>
Corrected wrong use of <code>displayUnit</code>.
</li>
<li>
September 20, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ReliefFan;
