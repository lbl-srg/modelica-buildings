within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints;
block ReturnFanDirectPressure
  "Return fan control with direct building pressure control"

  parameter Real dpBuiSet(
    final unit="Pa",
    final quantity="PressureDifference",
    final max=30) = 12
    "Building static pressure difference relative to ambient (positive to pressurize the building)";
  parameter Real dpDisMin(
    final unit="Pa",
    final quantity="PressureDifference",
    final min=0,
    final max=1000) = 2.4
    "Minimum return fan discharge static pressure difference setpoint";
  parameter Real dpDisMax(
    final unit="Pa",
    final quantity="PressureDifference",
    final min=0,
    final max=1000) = 40
    "Maximum return fan discharge static pressure setpoint";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController conTyp=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="Pressure controller"));
  parameter Real k(final unit="1") = 1
    "Gain, normalized using dpBuiSet"
    annotation (Dialog(group="Pressure controller"));
  parameter Real Ti(
    final unit="s",
    final quantity="Time")=0.5
    "Time constant of integrator block"
    annotation (Dialog(group="Pressure controller",
      enable=conTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or conTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real Td(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block"
    annotation (Dialog(group="Pressure controller",
      enable=conTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or conTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpBui(
    final unit="Pa",
    displayUnit="Pa")
    "Building static pressure difference, relative to ambient (positive if pressurized)"
    annotation (Placement(transformation(extent={{-180,50},{-140,90}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uMinOutAirDam
    "Minimum outdoor air damper status, true when it is open"
    annotation (Placement(transformation(extent={{-180,0},{-140,40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSupFan
    "Supply fan status"
    annotation (Placement(transformation(extent={{-180,-110},{-140,-70}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDpBui(
    final unit="Pa",
    displayUnit="Pa")
    "Averaged building static pressure"
    annotation (Placement(transformation(extent={{120,50},{160,90}}),
      iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yExhDam(
     final unit="1",
     final min=0,
     final max=1) "Exhaust damper control signal (0: closed, 1: open)"
    annotation (Placement(transformation(extent={{120,0},{160,40}}),
        iconTransformation(extent={{100,0},{140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dpDisSet(
     final unit="Pa",
     displayUnit="Pa",
     final min=0) "Return fan discharge static pressure setpoint"
    annotation (Placement(transformation(extent={{120,-110},{160,-70}}),
        iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.MovingMean movMea(
    final delta=300)
    "Average building static pressure measurement"
    annotation (Placement(transformation(extent={{-130,60},{-110,80}})));

  Buildings.Controls.OBC.CDL.Continuous.PID conP(
    final controllerType=conTyp,
    final k=k,
    final Ti=Ti,
    final Td=Td)
    "Building static pressure controller"
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Line linExhAirDam
    "Exhaust air damper position"
    annotation (Placement(transformation(extent={{60,100},{80,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Line linRetFanStaPre
    "Return fan static pressure setpoint"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi1
    "Exhaust air damper position"
    annotation (Placement(transformation(extent={{80,10},{100,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Return fan discharge static pressure setpoint"
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Division div "Normalized the control error"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpBuiSetPoi(
    final k=dpBuiSet) "Building pressure setpoint"
    annotation (Placement(transformation(extent={{-130,30},{-110,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant retFanDisPreMin(
    final k=dpDisMin) "Return fan discharge static pressure minimum setpoint"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant retFanDisPreMax(
    final k=dpDisMax) "Return fan discharge static pressure maximum setpoint"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(final k=0)
    "Zero fan control signal"
    annotation (Placement(transformation(extent={{0,-120},{20,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer1(final k=0)
    "Zero constant"
    annotation (Placement(transformation(extent={{-40,42},{-20,62}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(final k=0.5)
    "Constant 0.5"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{0,26},{20,46}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conOne(final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  Buildings.Controls.OBC.CDL.Logical.And enaDam
    "Check if the exhaust damper should be enabled"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));

equation
  connect(movMea.u, dpBui)
    annotation (Line(points={{-132,70},{-160,70}}, color={0,0,127}));
  connect(swi.u2, uSupFan)
    annotation (Line(points={{78,-90},{-160,-90}}, color={255,0,255}));
  connect(swi.u3, zer.y)
    annotation (Line(points={{78,-98},{60,-98},{60,-110},{22,-110}}, color={0,0,127}));
  connect(zer1.y, linExhAirDam.x1)
    annotation (Line(points={{-18,52},{30,52},{30,118},{58,118}},color={0,0,127}));
  connect(zer1.y, linExhAirDam.f1)
    annotation (Line(points={{-18,52},{30,52},{30,114},{58,114}},color={0,0,127}));
  connect(con.y, linExhAirDam.x2)
    annotation (Line(points={{22,90},{40,90},{40,106},{58,106}}, color={0,0,127}));
  connect(one.y, linExhAirDam.f2)
    annotation (Line(points={{22,36},{46,36},{46,102},{58,102}}, color={0,0,127}));
  connect(con.y, linRetFanStaPre.x1)
    annotation (Line(points={{22,90},{40,90},{40,-32},{58,-32}}, color={0,0,127}));
  connect(one.y, linRetFanStaPre.x2)
    annotation (Line(points={{22,36},{46,36},{46,-44},{58,-44}}, color={0,0,127}));
  connect(retFanDisPreMin.y, linRetFanStaPre.f1)
    annotation (Line(points={{22,-20},{30,-20},{30,-36},{58,-36}},
      color={0,0,127}));
  connect(retFanDisPreMax.y, linRetFanStaPre.f2)
    annotation (Line(points={{22,-70},{30,-70},{30,-48},{58,-48}},
      color={0,0,127}));
  connect(linRetFanStaPre.y, swi.u1)
    annotation (Line(points={{82,-40},{100,-40},{100,-60},{60,-60},{60,-82},{78,
          -82}}, color={0,0,127}));
  connect(linExhAirDam.y, swi1.u1)
    annotation (Line(points={{82,110},{100,110},{100,60},{60,60},{60,28},{78,28}},
      color={0,0,127}));
  connect(swi1.y, yExhDam)
    annotation (Line(points={{102,20},{140,20}},
      color={0,0,127}));
  connect(zer1.y, swi1.u3)
    annotation (Line(points={{-18,52},{30,52},{30,12},{78,12}},
      color={0,0,127}));
  connect(swi.y, dpDisSet)
    annotation (Line(points={{102,-90},{140,-90}}, color={0,0,127}));
  connect(conP.y, linExhAirDam.u)
    annotation (Line(points={{-18,110},{58,110}}, color={0,0,127}));
  connect(conP.y, linRetFanStaPre.u)
    annotation (Line(points={{-18,110},{-10,110},{-10,-40},{58,-40}}, color={0,0,127}));
  connect(dpBuiSetPoi.y, div.u2)
    annotation (Line(points={{-108,40},{-100,40},{-100,44},{-82,44}}, color={0,0,127}));
  connect(movMea.y, div.u1)
    annotation (Line(points={{-108,70},{-100,70},{-100,56},{-82,56}}, color={0,0,127}));
  connect(conOne.y, conP.u_s)
    annotation (Line(points={{-58,110},{-42,110}}, color={0,0,127}));
  connect(div.y, conP.u_m)
    annotation (Line(points={{-58,50},{-50,50},{-50,90},{-30,90},{-30,98}},
      color={0,0,127}));
  connect(movMea.y, yDpBui)
    annotation (Line(points={{-108,70},{140,70}}, color={0,0,127}));
  connect(uMinOutAirDam, enaDam.u1)
    annotation (Line(points={{-160,20},{-42,20}}, color={255,0,255}));
  connect(uSupFan, enaDam.u2)
    annotation (Line(points={{-160,-90},{-60,-90},{-60,12},{-42,12}},
      color={255,0,255}));
  connect(enaDam.y, swi1.u2)
    annotation (Line(points={{-18,20},{78,20}}, color={255,0,255}));

annotation (
  defaultComponentName="retFanDpCon",
  Icon(graphics={
        Text(extent={{-100,140},{100,100}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Line(points={{-78,52},{-78,-32},{78,-32},{78,52},{78,52}}, color={28,108,
              200}),
        Line(
          points={{-78,-32},{4,52}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{4,-32},{78,52}},
          color={0,0,0},
          pattern=LinePattern.Dash,
          thickness=0.5),
        Text(
          extent={{-50,-36},{60,-62}},
          lineColor={28,108,200},
          textString="Building pressure control loop signal")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{120,140}}),
        graphics={
        Rectangle(
          extent={{-138,138},{118,4}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-138,-4},{118,-138}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-138,140},{-62,122}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Exhaust air damper control"),
        Text(
          extent={{-136,-98},{-12,-120}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Return fan discharge static pressure setpoint")}),
  Documentation(info="<html>
<p>
Setpoint for return fan discharge pressure and exhaust air damper
for a multi zone VAV AHU according to Section 5.16.10 of ASHRAE Guideline G36, May 2020.
</p>
<ol>
<li>
<p>Return fan operates whenever associated supply fan is proven on and is
off otherwise.</p>
</li>
<li>
<p>Return fan is controlled to maintain return fan discharge static pressure
at setpoint <code>dpBuiSet</code>.</p>
</li>
<li>
<p>Exhaust damper is only enabled when the associated supply and return
fans are proven on (<code>uFan=true</code>) and the minimum outdoor air damper is open
(to be controlled in a separate sequence).
The exhaust dampers is closed when the fan is disabled.</p>
</li>
<li>
<p>The building static pressure is time averaged with a sliding 5-minute window
to dampen fluctuations. The averaged value shall be displayed and is used
for control.</p>
</li>
<li>
<p>When the exhaust damper is enabled, a control loop modulates the exhaust damper
in sequence with the return fan static pressure setpoint as shown in the figure
below to maintain the building pressure equal to <code>dpBuiSet</code>,
which is by default <i>12</i> Pa (<i>0.05</i> inches).
</p>
</li>
</ol>
<p>
The output signal of the building pressure control is as follows:
</p>
<ol>
<li>
From <i>0</i> to <i>0.5</i>, the building pressure control loop modulates the exhaust
dampers from <code>yExhDam = 0</code> (closed) to <code>yExhDam = 1</code> (open).
</li>
<li>
From <i>0.5</i> to <i>1</i>, the building pressure control loop resets the return fan
discharge static pressure setpoint from <code>dpDisMin</code>
to <code>dpDisMax</code>. The <code>dpDisMin</code> and
<code>dpDisMax</code> are specified in Section 3.2.1.4.
</li>
</ol>
<p align=\"center\">
<img alt=\"Image of return fan control for multi zone AHU\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36_PR1/AHUs/MultiZone/ReturnFanControlWithPressure.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
October 16, 2017, by Michael Wetter:<br/>
Revised implementation, normalized control input
and updated documentation.
</li>
<li>
October 16, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ReturnFanDirectPressure;
