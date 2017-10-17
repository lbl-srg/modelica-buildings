within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints;
block ReturnFanDirectPressure
  "Return fan control with direct building pressure control"

  parameter Modelica.SIunits.PressureDifference pBuiSet(displayUnit="Pa") = 12
    "Building static pressure difference relative to ambient (positive to pressurize the building)";
  parameter Modelica.SIunits.PressureDifference RFDSPmin(displayUnit="Pa") = 10
    "Minimum return fan discharge static pressure setpoint";
  parameter Modelica.SIunits.PressureDifference RFDSPmax(displayUnit="Pa") = 40
    "Maximum return fan discharge static pressure setpoint";
  parameter Real kP = 1 "Proportional gain";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uBuiPre
    "Building static pressure difference, relative to ambient (positive if pressurized)"
    annotation (Placement(transformation(extent={{-180,70},{-140,110}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uFan
    "Set to true to enable the fan on"
    annotation (Placement(transformation(extent={{-180,-110},{-140,-70}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dP_RetFan
    "Return fan discharge static pressure setpoint"
    annotation (Placement(transformation(extent={{120,-100},{140,-80}}),
      iconTransformation(extent={{100,20},{120,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yExhDam
    "Exhaust damper control signal (0: closed, 1: open)"
    annotation (Placement(transformation(extent={{120,80},{140,100}}),
      iconTransformation(extent={{100,-40},{120,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.MovingMean movMea(delta=300)
    "Average building static pressure measurement"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID limPID(
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final k=kP,
    yMax=1,
    yMin=0) "Building static pressure controller"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Line linExhAirDam
    "Exhaust air damper position"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Line linRetFanStaPre
    "Return fan static pressure setpoint"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    "Exhaust air damper position"
    annotation (Placement(transformation(extent={{80,10},{100,30}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    "Return fan discharge static pressure setpoint"
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant pBui(
    final k=pBuiSet) "Building pressure setpoint"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant retFanDisPreMin(
    final k=RFDSPmin) "Return fan discharge static pressure minimum setpoint"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant retFanDisPreMax(
    final k=RFDSPmax) "Return fan discharge static pressure maximum setpoint"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(final k=0)
    "Zero fan control signal"
    annotation (Placement(transformation(extent={{0,-120},{20,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer1(final k=0)
    "Zero constant"
    annotation (Placement(transformation(extent={{0,110},{20,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(final k=0.5)
    "Constant 0.5"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));

equation
  connect(movMea.u, uBuiPre)
    annotation (Line(points={{-122,90},{-160,90}}, color={0,0,127}));
  connect(swi.u2, uFan)
    annotation (Line(points={{78,-90},{-160,-90}}, color={255,0,255}));
  connect(swi.u3, zer.y)
    annotation (Line(points={{78,-98},{60,-98},{60,-110},{21,-110}}, color={0,0,127}));
  connect(zer1.y, linExhAirDam.x1)
    annotation (Line(points={{21,120},{30,120},{30,98},{58,98}}, color={0,0,127}));
  connect(zer1.y, linExhAirDam.f1)
    annotation (Line(points={{21,120},{30,120},{30,94},{58,94}}, color={0,0,127}));
  connect(con.y, linExhAirDam.x2)
    annotation (Line(points={{21,70},{40,70},{40,86},{58,86}}, color={0,0,127}));
  connect(one.y, linExhAirDam.f2)
    annotation (Line(points={{21,40},{46,40},{46,82},{58,82}}, color={0,0,127}));
  connect(con.y, linRetFanStaPre.x1)
    annotation (Line(points={{21,70},{40,70},{40,-32},{58,-32}}, color={0,0,127}));
  connect(one.y, linRetFanStaPre.x2)
    annotation (Line(points={{21,40},{46,40},{46,-44},{58,-44}}, color={0,0,127}));
  connect(retFanDisPreMin.y, linRetFanStaPre.f1)
    annotation (Line(points={{21,-20},{30,-20},{30,-36},{58,-36}},
      color={0,0,127}));
  connect(retFanDisPreMax.y, linRetFanStaPre.f2)
    annotation (Line(points={{21,-70},{30,-70},{30,-48},{58,-48}},
      color={0,0,127}));
  connect(linRetFanStaPre.y, swi.u1)
    annotation (Line(points={{81,-40},{100,-40},{100,-60},{60,-60},{60,-82},
      {78,-82}}, color={0,0,127}));
  connect(uFan, swi1.u2)
    annotation (Line(points={{-160,-90},{-100,-90},{-100,20},{78,20}},
      color={255,0,255}));
  connect(linExhAirDam.y, swi1.u1)
    annotation (Line(points={{81,90},{100,90},{100,70},{60,70},{60,28},{78,28}},
      color={0,0,127}));
  connect(swi1.y, yExhDam)
    annotation (Line(points={{101,20},{108,20},{108,90},{130,90}},
      color={0,0,127}));
  connect(zer1.y, swi1.u3)
    annotation (Line(points={{21,120},{30,120},{30,12},{78,12}},
      color={0,0,127}));
  connect(swi.y, dP_RetFan)
    annotation (Line(points={{101,-90},{130,-90}}, color={0,0,127}));
  connect(pBui.y, limPID.u_m)
    annotation (Line(points={{-99,60},{-70,60},{-70,78}}, color={0,0,127}));
  connect(movMea.y, limPID.u_s)
    annotation (Line(points={{-99,90},{-82,90}}, color={0,0,127}));
  connect(limPID.y, linExhAirDam.u)
    annotation (Line(points={{-59,90},{58,90}}, color={0,0,127}));
  connect(limPID.y, linRetFanStaPre.u)
    annotation (Line(points={{-59,90},{-40,90},{-40,-40},{58,-40}},
      color={0,0,127}));

annotation (
  defaultComponentName="retFanPre",
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
          extent={{-44,-32},{40,-48}},
          lineColor={28,108,200},
          textString="Building pressure control loop signal"),
        Text(
          extent={{-52,-6},{-8,-16}},
          lineColor={28,108,200},
          textString="Exhaust air damper"),
        Text(
          extent={{28,-6},{62,-16}},
          lineColor={28,108,200},
          textString="RF DP setpoint"),
        Text(
          extent={{-10,-28},{18,-32}},
          lineColor={28,108,200},
          textString="0.5")}),
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
          extent={{-134,132},{-58,114}},
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
Return fan control for a multi zone VAV AHU according to ASHRAE guideline G36, 
PART5.N.10 (return fan control with direct building pressure)
</p>
<ol>
<li>
<p>Return fan operates whenever associated supply fan is proven on and shall be
off otherwise.</p>
</li>
<li>
<p>Return fans shall be controlled to maintain return fan discharge static pressure
at setpoint.</p>
</li>
<li>
<p>Exhaust dampers shall only be enabled when the associated supply and return 
fans are proven on and the minimum outdoor air damper is open. The exhaust
dampers shall be closed when disabled.</p>
</li>
<li>
<p>Building static pressure shall be time averaged with a sliding 5-minute window
to damper fluctuations. The averaged value shall be that displayed and used
for control.</p>
</li>
<li>
<p>When exhaust dampers are enabled, a control loop shall modulate exhaust dampers
in sequence with the return fan static pressure setpoint as shown in the figure 
below to maintain the building pressure at a setpoint of 12 Pa (0.05 inches).</p>
<ul>
<li>
From 0% to 50%, the building pressure control loop shall modulate the exhaust
dampers from 0% to 100% open.
</li>
<li>
From 50% to 100%, the building pressure control loop shall reset the return fan
discharge static pressure setpoint from <code>RFDSPmin</code> at 50% loop output
to <code>RFDSPmax</code> at 100% of loop output. The <code>RFDSPmin</code> and
<code>RFDSPmax</code> are specified in Section G36 PART 3.2A.3.b.
</li>
</ul>
</ol>
<p align=\"center\">
<img alt=\"Image of return fan control for multi zone AHU\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36_PR1/AHUs/ReturnFanControlWithPressure.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
October 16, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ReturnFanDirectPressure;
