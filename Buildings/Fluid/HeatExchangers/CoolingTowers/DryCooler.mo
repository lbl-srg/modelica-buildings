within Buildings.Fluid.HeatExchangers.CoolingTowers;
model DryCooler "Cooling tower model based on epsilon-NTU relation"
  extends Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.CoolingTowerVariableSpeed(
    final PFan_nominal=dat.PFan_nominal,
    final m_flow_nominal = dat.Q_flow_nominal / cp_default / (dat.TCooOut_nominal - dat.TCooIn_nominal),
    final dp_nominal = dat.dp_nominal,
    final fanRelPow = dat.fanRelPow);
  parameter Buildings.Fluid.HeatExchangers.CoolingTowers.Data.DryCooler.Generic
    dat "Performance data record"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));

  final parameter Modelica.Units.SI.ThermalConductance UA_nominal = per.UA_nominal
    "Thermal conductance at nominal flow, used to compute heat capacity";
  final parameter Real eps_nominal = per.eps_nominal
    "Nominal heat transfer effectiveness";
  final parameter Real NTU_nominal(min = 0) = per.NTU_nominal "Nominal number of transfer units";

  Modelica.Blocks.Interfaces.RealInput TDryBul(
    final min=0,
    final unit="K",
    displayUnit="degC") "Entering air dry bulb temperature"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));

protected
  Modelica.Blocks.Sources.RealExpression TCooIn(
    final y = Medium.temperature(
      Medium.setState_phX(
        p = port_a.p,
        h = inStream(port_a.h_outflow),
        X = inStream(port_a.Xi_outflow)))) "Cooling loop fluid inlet temperature" annotation(
    Placement(transformation(extent = {{-70, 36}, {-50, 54}})));
  Modelica.Blocks.Sources.RealExpression mCoo_flow(final y = port_a.m_flow) "Cooling fluid mass flow rate" annotation(
    Placement(transformation(extent = {{-70, 20}, {-50, 38}})));
  Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.DryCooler per(
    redeclare final package Medium = Medium,
    final dat = dat,
    final m_flow_nominal = m_flow_nominal,
    final yMin = yMin) "Model for thermal performance" annotation(
    Placement(transformation(extent = {{-20, 40}, {0, 60}})));
equation
  connect(per.y, y) annotation(
    Line(points = {{-22, 58}, {-40, 58}, {-40, 80}, {-120, 80}}, color = {0, 0, 127}));
  connect(per.TDryBul, TDryBul) annotation (Line(points={{-22,54},{-80,54},{-80,
          40},{-120,40}}, color={0,0,127}));
  connect(per.Q_flow, preHea.Q_flow) annotation(
    Line(points = {{1, 50}, {12, 50}, {12, 12}, {-80, 12}, {-80, -60}, {-40, -60}}, color = {0, 0, 127}));
  connect(per.m_flow, mCoo_flow.y) annotation(
    Line(points = {{-22, 42}, {-34, 42}, {-34, 29}, {-49, 29}}, color = {0, 0, 127}));
  connect(TCooIn.y, per.TCooIn) annotation(
    Line(points = {{-49, 45}, {-40, 45}, {-40, 46}, {-22, 46}}, color = {0, 0, 127}));
  annotation(
    Icon(coordinateSystem(preserveAspectRatio = false),
      graphics = {
        Text(textColor = {0, 0, 127}, extent = {{-98, 100}, {-86, 84}}, textString = "y"),
        Text(textColor = {0, 0, 127}, extent = {{-104, 70}, {-70, 32}}, textString = "TDryBul"),
        Rectangle(lineColor = {0, 0, 255}, fillColor = {0, 0, 127}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-100, 81}, {-70, 78}}),
        Text(origin = {-2, 0},textColor = {255, 255, 255}, extent = {{-54, 6}, {58, -114}}, textString = "DryCooler"),
        Ellipse(lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-54, 62}, {0, 50}}),
        Ellipse(lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{0, 62}, {54, 50}}),
        Rectangle(lineColor = {0, 0, 255}, fillColor = {0, 0, 127}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{78, 82}, {100, 78}}),
        Rectangle(lineColor = {0, 0, 255}, fillColor = {0, 0, 127}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{70, 56}, {82, 52}}),
        Rectangle(lineColor = {0, 0, 255}, fillColor = {0, 0, 127}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{78, 54}, {82, 80}}),
        Text(textColor = {0, 0, 127}, extent = {{64, 114}, {98, 76}}, textString = "PFan")}),
    Diagram(coordinateSystem(preserveAspectRatio = false)),
    Documentation(info="<html>
<p>
Model for a steady-state or dynamic dry cooling tower with a variable speed fan
using epsilon-NTU method for heat transfer.
</p>
<h4>Thermal performance</h4>
<p>
To compute the thermal performance, this model takes as parameters
the nominal cooling capacity, air dry-bulb temperature, and
cooling fluid (water or glycol) inlet and outlet temperatures
as specified in the data record
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.Data.DryCooler.Generic\">
Buildings.Fluid.HeatExchangers.CoolingTowers.Data.DryCooler.Generic</a>.
The cooling tower performance is
modeled using the effectiveness-NTU relationship for
a crossflow configuration.
</p>
<p>
Changes in convective heat transfer coefficient on the coolant-side and
the air-side due to change in flow rate and temperature are taken into account
using the model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.HADryCoil\">
Buildings.Fluid.HeatExchangers.BaseClasses.HADryCoil</a>.
This correction can be configured in the data record
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.Data.DryCooler.Generic\">
Buildings.Fluid.HeatExchangers.CoolingTowers.Data.DryCooler.Generic</a>.
</p>
</html>", revisions = "<html>
<ul>
<li>
April 21, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end DryCooler;
