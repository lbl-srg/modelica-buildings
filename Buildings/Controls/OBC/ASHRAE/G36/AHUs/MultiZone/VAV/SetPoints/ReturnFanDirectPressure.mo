within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints;
block ReturnFanDirectPressure
  "Return fan control with direct building pressure control"

  parameter Real dpBuiSet(
    final unit="Pa",
    final quantity="PressureDifference",
    final max=30) = 12
    "Building static pressure difference relative to ambient (positive to pressurize the building)"
    annotation (__cdl(ValueInReference=True));
  parameter Real p_rel_RetFan_min(
    final unit="Pa",
    final quantity="PressureDifference",
    final min=0,
    final max=1000) = 2.4
    "Return fan discharge static pressure difference minimum setpoint,no less than 2.4 Pa"
    annotation (__cdl(ValueInReference=False));
  parameter Real p_rel_RetFan_max(
    final unit="Pa",
    final quantity="PressureDifference",
    final min=0,
    final max=1000) = 40
    "Return fan discharge static pressure maximum setpoint"
    annotation (__cdl(ValueInReference=False));
  parameter Real disSpe_min(
    final unit="1",
    final min=0,
    final max=1)
    "Return fan speed when providing the minimum return fan discharge static pressure difference";
  parameter Real disSpe_max(
    final unit="1",
    final min=0,
    final max=1)
    "Return fan speed when providing the maximum return fan discharge static pressure difference";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController conTyp=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (__cdl(ValueInReference=False),
                Dialog(group="Pressure controller"));
  parameter Real k(final unit="1") = 1
    "Gain, normalized using dpBuiSet"
    annotation (__cdl(ValueInReference=False),
                Dialog(group="Pressure controller"));
  parameter Real Ti(
    final unit="s",
    final quantity="Time")=0.5
    "Time constant of integrator block"
    annotation (__cdl(ValueInReference=False),
                Dialog(group="Pressure controller",
      enable=conTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or conTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real Td(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block"
    annotation (__cdl(ValueInReference=False),
                Dialog(group="Pressure controller",
      enable=conTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or conTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpBui(
    final unit="Pa",
    displayUnit="Pa")
    "Building static pressure difference, relative to ambient (positive if pressurized)"
    annotation (Placement(transformation(extent={{-180,120},{-140,160}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1MinOutAirDam
    "Minimum outdoor air damper status, true when it is open"
    annotation (Placement(transformation(extent={{-180,70},{-140,110}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1SupFan
    "Supply fan status"
    annotation (Placement(transformation(extent={{-180,-40},{-140,0}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDpBui(
    final unit="Pa",
    displayUnit="Pa")
    "Averaged building static pressure"
    annotation (Placement(transformation(extent={{120,120},{160,160}}),
      iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRelDam(
    final unit="1",
    final min=0,
    final max=1)
    "Relief damper commanded position"
    annotation (Placement(transformation(extent={{120,70},{160,110}}),
        iconTransformation(extent={{100,0},{140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dpDisSet(
     final unit="Pa",
     displayUnit="Pa",
     final min=0) "Return fan discharge static pressure setpoint"
    annotation (Placement(transformation(extent={{120,-40},{160,0}}),
        iconTransformation(extent={{100,-40},{140,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetFan(
    final unit="1",
    final min=0,
    final max=1)
    "Return fan commanded speed"
    annotation (Placement(transformation(extent={{120,-170},{160,-130}}),
        iconTransformation(extent={{100,-90},{140,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1RetFan
    "Return fan commanded on"
    annotation (Placement(transformation(extent={{120,-220},{160,-180}}),
        iconTransformation(extent={{100,-110},{140,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.MovingAverage movMea(
    final delta=300)
    "Average building static pressure measurement"
    annotation (Placement(transformation(extent={{-130,130},{-110,150}})));
  Buildings.Controls.OBC.CDL.Continuous.PID conP(
    final controllerType=conTyp,
    final k=k,
    final Ti=Ti,
    final Td=Td)
    "Building static pressure controller"
    annotation (Placement(transformation(extent={{-60,170},{-40,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Line linExhAirDam
    "Exhaust air damper position"
    annotation (Placement(transformation(extent={{60,170},{80,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Line linRetFanStaPre
    "Return fan static pressure setpoint"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi1
    "Relief air damper position"
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Return fan discharge static pressure setpoint"
    annotation (Placement(transformation(extent={{80,-30},{100,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide div "Normalized the control error"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Line linRetFanSpe "Return fan speed"
    annotation (Placement(transformation(extent={{60,-110},{80,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi2
    "Return fan speed setpoint"
    annotation (Placement(transformation(extent={{80,-160},{100,-140}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpBuiSetPoi(
    final k=dpBuiSet) "Building pressure setpoint"
    annotation (Placement(transformation(extent={{-130,100},{-110,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant retFanDisPreMin(
    final k=p_rel_RetFan_min) "Return fan discharge static pressure minimum setpoint"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant retFanDisPreMax(
    final k=p_rel_RetFan_max) "Return fan discharge static pressure maximum setpoint"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(final k=0)
    "Zero fan control signal"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer1(final k=0)
    "Zero constant"
    annotation (Placement(transformation(extent={{-40,112},{-20,132}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(final k=0.5)
    "Constant 0.5"
    annotation (Placement(transformation(extent={{0,150},{20,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{0,96},{20,116}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conOne(final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-100,170},{-80,190}})));
  Buildings.Controls.OBC.CDL.Logical.And enaDam
    "Check if the relief damper should be enabled"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant retFanSpeMin(
    final k=disSpe_min)
    "Return fan speed when discharge static pressure minimum setpoint"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant retFanSpeMax(
    final k=disSpe_max)
    "Return fan speed when discharge static pressure maximum setpoint"
    annotation (Placement(transformation(extent={{-40,-130},{-20,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer2(
    final k=0)
    "Zero fan control signal"
    annotation (Placement(transformation(extent={{0,-180},{20,-160}})));

equation
  connect(movMea.u, dpBui)
    annotation (Line(points={{-132,140},{-160,140}}, color={0,0,127}));
  connect(swi.u2, u1SupFan)
    annotation (Line(points={{78,-20},{-160,-20}}, color={255,0,255}));
  connect(swi.u3, zer.y)
    annotation (Line(points={{78,-28},{60,-28},{60,-40},{22,-40}},   color={0,0,127}));
  connect(zer1.y, linExhAirDam.x1)
    annotation (Line(points={{-18,122},{30,122},{30,188},{58,188}}, color={0,0,127}));
  connect(zer1.y, linExhAirDam.f1)
    annotation (Line(points={{-18,122},{30,122},{30,184},{58,184}}, color={0,0,127}));
  connect(con.y, linExhAirDam.x2)
    annotation (Line(points={{22,160},{40,160},{40,176},{58,176}}, color={0,0,127}));
  connect(one.y, linExhAirDam.f2)
    annotation (Line(points={{22,106},{46,106},{46,172},{58,172}}, color={0,0,127}));
  connect(con.y, linRetFanStaPre.x1)
    annotation (Line(points={{22,160},{40,160},{40,38},{58,38}}, color={0,0,127}));
  connect(one.y, linRetFanStaPre.x2)
    annotation (Line(points={{22,106},{46,106},{46,26},{58,26}}, color={0,0,127}));
  connect(retFanDisPreMin.y, linRetFanStaPre.f1)
    annotation (Line(points={{22,50},{30,50},{30,34},{58,34}},
      color={0,0,127}));
  connect(retFanDisPreMax.y, linRetFanStaPre.f2)
    annotation (Line(points={{-18,0},{-10,0},{-10,22},{58,22}},
      color={0,0,127}));
  connect(linRetFanStaPre.y, swi.u1)
    annotation (Line(points={{82,30},{100,30},{100,10},{60,10},{60,-12},{78,-12}},
                 color={0,0,127}));
  connect(linExhAirDam.y, swi1.u1)
    annotation (Line(points={{82,180},{100,180},{100,130},{60,130},{60,98},{78,98}},
      color={0,0,127}));
  connect(swi1.y,yRelDam)
    annotation (Line(points={{102,90},{140,90}},
      color={0,0,127}));
  connect(zer1.y, swi1.u3)
    annotation (Line(points={{-18,122},{30,122},{30,82},{78,82}},
      color={0,0,127}));
  connect(swi.y, dpDisSet)
    annotation (Line(points={{102,-20},{140,-20}}, color={0,0,127}));
  connect(conP.y, linExhAirDam.u)
    annotation (Line(points={{-38,180},{58,180}}, color={0,0,127}));
  connect(conP.y, linRetFanStaPre.u)
    annotation (Line(points={{-38,180},{-10,180},{-10,30},{58,30}},   color={0,0,127}));
  connect(dpBuiSetPoi.y, div.u2)
    annotation (Line(points={{-108,110},{-100,110},{-100,114},{-82,114}}, color={0,0,127}));
  connect(movMea.y, div.u1)
    annotation (Line(points={{-108,140},{-100,140},{-100,126},{-82,126}}, color={0,0,127}));
  connect(conOne.y, conP.u_s)
    annotation (Line(points={{-78,180},{-62,180}}, color={0,0,127}));
  connect(div.y, conP.u_m)
    annotation (Line(points={{-58,120},{-50,120},{-50,168}},
      color={0,0,127}));
  connect(movMea.y, yDpBui)
    annotation (Line(points={{-108,140},{140,140}}, color={0,0,127}));
  connect(u1MinOutAirDam, enaDam.u1)
    annotation (Line(points={{-160,90},{-42,90}}, color={255,0,255}));
  connect(u1SupFan, enaDam.u2) annotation (Line(points={{-160,-20},{-60,-20},{-60,
          82},{-42,82}}, color={255,0,255}));
  connect(enaDam.y, swi1.u2)
    annotation (Line(points={{-18,90},{78,90}}, color={255,0,255}));
  connect(linRetFanStaPre.y, linRetFanSpe.u) annotation (Line(points={{82,30},{100,
          30},{100,10},{40,10},{40,-100},{58,-100}}, color={0,0,127}));
  connect(retFanDisPreMin.y, linRetFanSpe.x1) annotation (Line(points={{22,50},{
          30,50},{30,-92},{58,-92}}, color={0,0,127}));
  connect(retFanSpeMin.y, linRetFanSpe.f1) annotation (Line(points={{-18,-80},{20,
          -80},{20,-96},{58,-96}}, color={0,0,127}));
  connect(retFanDisPreMax.y, linRetFanSpe.x2) annotation (Line(points={{-18,0},{
          -10,0},{-10,-104},{58,-104}}, color={0,0,127}));
  connect(retFanSpeMax.y, linRetFanSpe.f2) annotation (Line(points={{-18,-120},{
          20,-120},{20,-108},{58,-108}}, color={0,0,127}));
  connect(linRetFanSpe.y, swi2.u1) annotation (Line(points={{82,-100},{100,-100},
          {100,-130},{60,-130},{60,-142},{78,-142}}, color={0,0,127}));
  connect(zer2.y, swi2.u3) annotation (Line(points={{22,-170},{60,-170},{60,-158},
          {78,-158}}, color={0,0,127}));
  connect(u1SupFan, swi2.u2) annotation (Line(points={{-160,-20},{-60,-20},{-60,
          -150},{78,-150}}, color={255,0,255}));
  connect(swi2.y, yRetFan)
    annotation (Line(points={{102,-150},{140,-150}}, color={0,0,127}));
  connect(u1SupFan, y1RetFan) annotation (Line(points={{-160,-20},{-60,-20},{-60,
          -200},{140,-200}}, color={255,0,255}));
annotation (
  defaultComponentName="retFanDpCon",
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
       graphics={
        Text(extent={{-100,140},{100,100}},
          textColor={0,0,255},
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
          textColor={28,108,200},
          textString="Building pressure control loop signal")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-220},{120,220}}),
        graphics={
        Rectangle(
          extent={{-138,218},{118,84}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-138,58},{118,-58}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-138,210},{-62,192}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Exhaust air damper control"),
        Text(
          extent={{-136,-28},{-12,-50}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Return fan discharge static pressure setpoint"),
        Rectangle(
          extent={{-138,-84},{118,-218}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-136,-176},{-60,-194}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Return fan speed")}),
  Documentation(info="<html>
<p>
Setpoint for return fan discharge pressure and relief air damper
for a multi zone VAV AHU according to Section 5.16.10 of ASHRAE Guideline G36, May 2020.
</p>
<p>
Note that this sequence assumes that the AHU units with return fan having the
return fan with direct building pressure control have the minimum outdoor air damper.
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
<p>Relief damper is only enabled when the associated supply and return
fans are proven on (<code>u1SupFan=true</code>) and the minimum outdoor air damper is open
(to be controlled in a separate sequence).
The relief dampers is closed when the fan is disabled.</p>
</li>
<li>
<p>The building static pressure is time averaged with a sliding 5-minute window
to dampen fluctuations. The averaged value shall be displayed and is used
for control.</p>
</li>
<li>
<p>When the relief damper is enabled, a control loop modulates the relief damper
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
dampers from <code>yRelDam = 0</code> (closed) to <code>yRelDam = 1</code> (open).
</li>
<li>
From <i>0.5</i> to <i>1</i>, the building pressure control loop resets the return fan
discharge static pressure setpoint from <code>p_rel_RetFan_min</code>
to <code>p_rel_RetFan_max</code>. The <code>p_rel_RetFan_min</code> and
<code>p_rel_RetFan_max</code> are specified in Section 3.2.1.4.
</li>
</ol>
<p align=\"center\">
<img alt=\"Image of return fan control for multi zone AHU\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/AHUs/MultiZone/VAV/SetPoints/ReturnFanControlWithPressure.png\"/>
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
