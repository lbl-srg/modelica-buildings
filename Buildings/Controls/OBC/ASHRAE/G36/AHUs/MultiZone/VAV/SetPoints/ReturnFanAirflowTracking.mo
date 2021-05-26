within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints;
block ReturnFanAirflowTracking
  "Return fan control for AHUs using return fan with airflow tracking"
  parameter Real dpBuiSet(
    final unit="Pa",
    final quantity="PressureDifference",
    max=30) = 12
    "Building static pressure difference relative to ambient (positive to pressurize the building)";
  parameter Real k(min=0, unit="1") = 0.5
    "Gain, applied to building pressure control error normalized with dpBuiSet";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VSup_flow(
    final unit="m3/s",
    final min = 0,
    final quantity="VolumeFlowRate") "Measured AHU supply airflow rate"
                                                                   annotation (
      Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSupFan "Supply fan status"
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRelDam(
    final unit="1",
    final min=0,
    final max=1)
    "Relief damper position setpoint"
    annotation (Placement(transformation(extent={{100,-50},{140,-10}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  CDL.Interfaces.RealInput VRet_flow(
    final unit="m3/s",
    final min=0,
    final quantity="VolumeFlowRate") "Measured AHU return airflow rate"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
protected
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    "Check if relief damper should be enabled"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Feedback conErr(
    u1(final unit="Pa", displayUnit="Pa"),
    u2(final unit="Pa", displayUnit="Pa"),
    y(final unit="Pa", displayUnit="Pa"))
    "Control error"
    annotation (Placement(transformation(extent={{-30,20},{-10,40}})));
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
  connect(uSupFan, swi.u2)
    annotation (Line(points={{-120,-30},{58,-30}}, color={255,0,255}));
  connect(zer.y, conP.u_s)
    annotation (Line(points={{-8,70},{8,70}}, color={0,0,127}));
  connect(zerDam.y, swi.u3)
    annotation (Line(points={{-58,-60},{50,-60},{50,-38},{58,-38}}, color={0,0,127}));
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
          lineColor={0,0,255},
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
(<code>uSupFan = true</code>), and disabled otherwise.
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
end ReturnFanAirflowTracking;
