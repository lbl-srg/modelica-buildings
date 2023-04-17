within Buildings.Controls.OBC.ASHRAE.G36.ThermalZones;
block ControlLoops "Heating and cooling control loops"

  parameter Real kCooCon=0.1
    "Gain of controller for cooling control loop"
    annotation (__cdl(ValueInReference=False), Dialog(group="Cooling control"));
  parameter Real TiCooCon(unit="s")=900
    "Time constant of integrator block for cooling control loop"
    annotation (__cdl(ValueInReference=False), Dialog(group="Cooling control"));
  parameter Real kHeaCon=0.1
    "Gain of controller for heating control loop"
    annotation (__cdl(ValueInReference=False), Dialog(group="Heating control"));
  parameter Real TiHeaCon(unit="s")=900
    "Time constant of integrator block for heating control loop"
    annotation (__cdl(ValueInReference=False), Dialog(group="Heating control"));
  parameter Real timChe(unit="s")=30
    "Threshold time to check the zone temperature status"
    annotation (__cdl(ValueInReference=True), Dialog(tab="Advanced"));
  parameter Real dTHys(unit="K")=0.25
    "Delta between the temperature hysteresis high and low limit"
    annotation (__cdl(ValueInReference=False), Dialog(tab="Advanced"));
  parameter Real looHys(unit="1")=0.01
    "Threshold value to check if the controller output is near zero"
    annotation (__cdl(ValueInReference=False), Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCooSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Zone cooling setpoint"
    annotation (Placement(transformation(extent={{-200,60},{-160,100}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Measured zone temperature"
    annotation (Placement(transformation(extent={{-200,-20},{-160,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Zone heating setpoint"
    annotation (Placement(transformation(extent={{-200,-100},{-160,-60}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCoo(
    final min=0,
    final max=1,
    final unit="1") "Cooling control signal"
    annotation (Placement(transformation(extent={{160,50},{200,90}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHea(
    final min=0,
    final max=1,
    final unit="1") "Heating control signal"
    annotation (Placement(transformation(extent={{160,-90},{200,-50}}),
      iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset conCoo(
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final k=kCooCon,
    final Ti=TiCooCon,
    final reverseActing=false)
    "Cooling controller"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset conHea(
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final k=kHeaCon,
    final Ti=TiHeaCon)
    "Heating controller"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Less enaHeaLoo(
    final h=dTHys)
    "Check if heating control loop should be enabled"
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Less enaCooLoo(
    final h=dTHys)
    "Check if cooling control loop should be enabled"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay disCoo(
    final delayTime=timChe)
    "Check if the controller output has been near zero for a threshold time"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Buildings.Controls.OBC.CDL.Logical.Not colZon
    "Check if the zone temperature is lower than the cooling setpoint"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal zerCoo(
    final realTrue=0,
    final realFalse=1)
    "Output zero control signal when the cooling loop should be disabled"
    annotation (Placement(transformation(extent={{80,50},{100,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply cooConSig
    "Cooling control loop signal"
    annotation (Placement(transformation(extent={{120,60},{140,80}})));
  Buildings.Controls.OBC.CDL.Logical.Not holZon
    "Check if the zone temperature is higher than the heating setpoint"
    annotation (Placement(transformation(extent={{-40,-130},{-20,-110}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay disHea(
    final delayTime=timChe)
    "Check if the controller output has been near zero for a threshold time"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal zerHea(
    final realTrue=0,
    final realFalse=1)
    "Output zero control signal when the heating loop should be disabled"
    annotation (Placement(transformation(extent={{80,-90},{100,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply heaConSig
    "Heating control loop signal"
    annotation (Placement(transformation(extent={{120,-80},{140,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold zerCon(
    final t=looHys, final h=0.8*looHys)
    "Check if the controller output is near zero"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold zerCon1(
    final t=looHys, final h=0.8*looHys)
    "Check if the controller output is near zero"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Buildings.Controls.OBC.CDL.Logical.And disCooCon
    "Check if disable cooling control loop"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Buildings.Controls.OBC.CDL.Logical.And disHeaCon
    "Check if disable heating control loop"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));

equation
  connect(TZon, enaHeaLoo.u1) annotation (Line(points={{-180,0},{-140,0},{-140,-120},
          {-122,-120}}, color={0,0,127}));
  connect(THeaSet, enaHeaLoo.u2) annotation (Line(points={{-180,-80},{-150,-80},
          {-150,-128},{-122,-128}}, color={0,0,127}));
  connect(TZon, enaCooLoo.u2) annotation (Line(points={{-180,0},{-140,0},{-140,12},
          {-122,12}}, color={0,0,127}));
  connect(TCooSet, enaCooLoo.u1) annotation (Line(points={{-180,80},{-140,80},{-140,
          20},{-122,20}}, color={0,0,127}));
  connect(TCooSet,conCoo. u_s) annotation (Line(points={{-180,80},{-140,80},{-140,
          100},{-82,100}}, color={0,0,127}));
  connect(TZon,conCoo. u_m)
    annotation (Line(points={{-180,0},{-70,0},{-70,88}}, color={0,0,127}));
  connect(enaCooLoo.y,conCoo. trigger)
    annotation (Line(points={{-98,20},{-76,20},{-76,88}}, color={255,0,255}));
  connect(enaCooLoo.y, colZon.u)
    annotation (Line(points={{-98,20},{-42,20}}, color={255,0,255}));
  connect(conCoo.y, cooConSig.u1) annotation (Line(points={{-58,100},{110,100},{
          110,76},{118,76}}, color={0,0,127}));
  connect(THeaSet,conHea. u_s) annotation (Line(points={{-180,-80},{-150,-80},{-150,
          -40},{-82,-40}}, color={0,0,127}));
  connect(TZon,conHea. u_m) annotation (Line(points={{-180,0},{-140,0},{-140,-60},
          {-70,-60},{-70,-52}}, color={0,0,127}));
  connect(enaHeaLoo.y, holZon.u)
    annotation (Line(points={{-98,-120},{-42,-120}}, color={255,0,255}));
  connect(enaHeaLoo.y,conHea. trigger) annotation (Line(points={{-98,-120},{-76,
          -120},{-76,-52}}, color={255,0,255}));
  connect(conHea.y, heaConSig.u1) annotation (Line(points={{-58,-40},{110,-40},{
          110,-64},{118,-64}}, color={0,0,127}));
  connect(zerCon.y, disCoo.u)
    annotation (Line(points={{-18,60},{-2,60}}, color={255,0,255}));
  connect(conCoo.y, zerCon.u) annotation (Line(points={{-58,100},{-50,100},{-50,
          60},{-42,60}}, color={0,0,127}));
  connect(conHea.y, zerCon1.u) annotation (Line(points={{-58,-40},{-50,-40},{-50,
          -80},{-42,-80}}, color={0,0,127}));
  connect(zerCon1.y, disHea.u)
    annotation (Line(points={{-18,-80},{-2,-80}}, color={255,0,255}));
  connect(disCoo.y, disCooCon.u1)
    annotation (Line(points={{22,60},{38,60}}, color={255,0,255}));
  connect(disCooCon.y, zerCoo.u)
    annotation (Line(points={{62,60},{78,60}}, color={255,0,255}));
  connect(colZon.y, disCooCon.u2) annotation (Line(points={{-18,20},{30,20},{30,
          52},{38,52}}, color={255,0,255}));
  connect(zerCoo.y, cooConSig.u2) annotation (Line(points={{102,60},{110,60},{110,
          64},{118,64}}, color={0,0,127}));
  connect(disHea.y, disHeaCon.u1)
    annotation (Line(points={{22,-80},{38,-80}}, color={255,0,255}));
  connect(holZon.y, disHeaCon.u2) annotation (Line(points={{-18,-120},{30,-120},
          {30,-88},{38,-88}}, color={255,0,255}));
  connect(disHeaCon.y, zerHea.u)
    annotation (Line(points={{62,-80},{78,-80}}, color={255,0,255}));
  connect(zerHea.y, heaConSig.u2) annotation (Line(points={{102,-80},{110,-80},{
          110,-76},{118,-76}}, color={0,0,127}));
  connect(cooConSig.y, yCoo)
    annotation (Line(points={{142,70},{180,70}}, color={0,0,127}));
  connect(heaConSig.y, yHea)
    annotation (Line(points={{142,-70},{180,-70}}, color={0,0,127}));

annotation (defaultComponentName="conLoo",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
       graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
        extent={{-100,140},{100,100}},
        textString="%name",
        textColor={0,0,255}),
        Text(
          extent={{-96,68},{-52,52}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TCooSet"),
        Text(
          extent={{-96,-52},{-52,-68}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="THeaSet"),
        Text(
          extent={{-98,6},{-72,-8}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          extent={{74,66},{98,56}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yCoo"),
        Text(
          extent={{76,-54},{100,-64}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yHea")}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-160,-140},{160,140}})),
Documentation(info="<html>
<p>
This block outputs the heating and cooling control loop signal. The implementation
is according to the ASHRAE Guideline 36, Section 5.3.4.
</p>
<ol>
<li>
Two separate control loops, the cooling loop and the heating loop, shall operate to
maintain space temperature at set point.
<ul>
<li>
The heating loop shall be enabled whenever the space temperature <code>TZon</code>
is below the current zone heating setpoint temperature <code>THeaSet</code> and
disabled when space temperature is above the current zone heating setpoint temperature
and the loop output is zero for 30 seconds. The loop may remain active at all times
if provisions are made to minimize integral windup.
</li>
<li>
The cooling loop shall be enabled whenever the space temperature <code>TZon</code>
is above the current zone cooling setpoint temperature <code>TCooSet</code> and
disabled when space temperature is below the current zone cooling setpoint temperature
and the loop output is zero for 30 seconds. The loop may remain active at all times
if provisions are made to minimize integral windup.
</li>
</ul>
</li>
<li>
The cooling loop shall maintain the space temperature at the cooling setpoint. The
output of the loop shall be a software point ranging from 0% (no cooling) to 100%
(full cooling).
</li>
<li>
The heating loop shall maintain the space temperature at the heating setpoint. The
output of the loop shall be a software point ranging from 0% (no heating) to 100%
(full heating).
</li>
<li>
Loops shall use proportional plus integral logic or other technology with similar
performance. Proportional-only control is not acceptable, although the integral
gain shall be small relative to the proportional gain. P and I gains shall be adjustable
by the operator.
</li>
</ol>
</html>",revisions="<html>
<ul>
<li>
August 1, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ControlLoops;
