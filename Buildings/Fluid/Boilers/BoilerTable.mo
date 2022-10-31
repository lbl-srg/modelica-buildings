within Buildings.Fluid.Boilers;
model BoilerTable
  "Boiler with efficiency described by a table with control signal and inlet temperature"
  extends Buildings.Fluid.Boilers.BaseClasses.PartialBoiler(
    final eta=effTab.y,
    final Q_flow_nominal = per.Q_flow_nominal,
    final eta_nominal= per.eta_nominal,
    final fue=per.fue,
    final UA=per.UA,
    final VWat = per.VWat,
    final mDry = per.mDry,
    final m_flow_nominal = per.m_flow_nominal,
    final dp_nominal = per.dp_nominal);

  parameter Buildings.Fluid.Boilers.Data.Generic per
    "Records of efficiency curves"
    annotation(choicesAllMatching=true,
               Placement(transformation(extent={{-40,74},{-20,94}})));

  Modelica.Blocks.Tables.CombiTable2Ds effTab(final table=per.effCur, final
      smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative)
    "Look-up table that represents a set of efficiency curves varying with both the firing rate (control signal) and the inlet water temperature"
    annotation (Placement(transformation(extent={{-70,64},{-50,84}})));

  Modelica.Blocks.Sources.RealExpression TIn(
    y=Medium.temperature(state=Medium.setState_phX(
        p=port_a.p, h=inStream(port_a.h_outflow), X=inStream(port_a.Xi_outflow))))
    "Water inlet temperature"
    annotation (Placement(transformation(extent={{-98,58},{-78,78}})));

initial equation
  assert(abs(per.effCur[end,1] - 1) < 1E-6,
    "Efficiency curve at full load (y = 1) must be provided.");

equation
  connect(effTab.u1, y) annotation (Line(points={{-72,80},{-120,80}},
                color={0,0,127}));
  connect(TIn.y, effTab.u2)
    annotation (Line(points={{-77,68},{-72,68}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This is a model of a boiler whose efficiency is described
by a table with control signal and inlet temperature.
See <a href=\"Modelica://Buildings.Fluid.Boilers.UsersGuide\">
Buildings.Fluid.Boilers.UsersGuide</a> for details.
</p>
<p>
The efficiency tables are supplied via
<a href=\"Buildings.Fluid.Boilers.Data\">
Buildings.Fluid.Boilers.Data</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 7, 2022, by Michael Wetter:<br/>
Set <code>final massDynamics=energyDynamics</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1542\">#1542</a>.
</li>
<li>
October 13, 2021 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2651\">#2651</a>.
</li>
</ul>
</html>"), Icon(graphics={
        Rectangle(
          origin={-48,37},
          lineColor={64,64,64},
          fillColor={255,215,136},
          fillPattern=FillPattern.Solid,
          extent={{-12,-11},{12,11}},
          radius=5.0),
        Line(
          points={{-48,48},{-48,26}}),
        Line(
          points={{-60,40},{-36,40}}),
        Line(
          points={{-60,32},{-36,32}})}));
end BoilerTable;
