within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints;
block ReliefDamper
  "Relief damper control for AHUs using actuated dampers without fan"
  parameter Real dpBuiSet(
    final unit="Pa",
    final quantity="PressureDifference",
    max=30) = 12
    "Building static pressure difference relative to ambient (positive to pressurize the building)"
    annotation (__cdl(ValueInReference=True));
  parameter Real k(min=0, unit="1") = 0.5
    "Gain, applied to building pressure control error normalized with dpBuiSet"
    annotation (__cdl(ValueInReference=False));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpBui(
    final unit="Pa",
    displayUnit="Pa")
    "Building static pressure difference, relative to ambient (positive if pressurized)"
    annotation (Placement(transformation(extent={{-140,10},{-100,50}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1SupFan
    "Supply fan status"
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRelDam(
    final unit="1",
    final min=0,
    final max=1) "Relief damper commanded position"
    annotation (Placement(transformation(extent={{100,-50},{140,-10}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Check if relief damper should be enabled"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract conErr(
    u1(final unit="Pa", displayUnit="Pa"),
    u2(final unit="Pa", displayUnit="Pa"),
    y(final unit="Pa", displayUnit="Pa"))
    "Control error"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Buildings.Controls.OBC.CDL.Continuous.PID conP(
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final k=k,
    final reverseActing=false)
    "Building static pressure controller"
    annotation (Placement(transformation(extent={{10,60},{30,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerDam(
    final k=0)
    "Close damper when disabled"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpBuiSetPoi(
    final k=dpBuiSet) "Building pressure setpoint"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(
    final k=0)
    "Zero constant"
    annotation (Placement(transformation(extent={{-30,60},{-10,80}})));

equation
  connect(u1SupFan, swi.u2)
    annotation (Line(points={{-120,-30},{58,-30}}, color={255,0,255}));
  connect(dpBuiSetPoi.y, conErr.u2)
    annotation (Line(points={{-58,0},{-40,0},{-40,24},{-22,24}}, color={0,0,127}));
  connect(conErr.y, conP.u_m)
    annotation (Line(points={{2,30},{20,30},{20,58}},  color={0,0,127}));
  connect(zer.y, conP.u_s)
    annotation (Line(points={{-8,70},{8,70}}, color={0,0,127}));
  connect(conP.y, swi.u1)
    annotation (Line(points={{32,70},{50,70},{50,-22},{58,-22}}, color={0,0,127}));
  connect(zerDam.y, swi.u3)
    annotation (Line(points={{-58,-60},{50,-60},{50,-38},{58,-38}}, color={0,0,127}));
  connect(dpBui, conErr.u1)
    annotation (Line(points={{-120,30},{-60,30},{-60,36},{-22,36}}, color={0,0,127}));
  connect(swi.y, yRelDam)
    annotation (Line(points={{82,-30},{120,-30}}, color={0,0,127}));

annotation (
  defaultComponentName = "relDam",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
    graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
 Documentation(info="<html>
<p>
Sequence for controlling actuated relief damper <code>yRelDam</code> for AHUs using
actuated relief damper without a fan.
It is implemented according to Section 5.16.8 of ASHRAE Guideline G36, May 2020.
</p>
<ul>
<li>
Relief dampers shall be enabled when the associated supply fan is proven on
(<code>u1SupFan = true</code>), and disabled otherwise.
</li>
<li>
When enabled, use a P-only control loop to modulate relief dampers to maintain building
static pressure <code>dpBui</code> at its setpoint, which is by defaul
<i>12</i> Pa (<i>0.05</i> inchWC).
</li>
<li>
Close damper when disabled.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
May 20, 2021, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ReliefDamper;
