within Buildings.Fluid.Boilers;
model BoilerTable
  "Boiler with efficiency described by a table with control signal and inlet temperature"
  extends Buildings.Fluid.Boilers.BaseClasses.PartialBoiler(
    eta=effTab.y);
  parameter Modelica.SIunits.Temperature TIn_nominal = 323.15
    "Norminal inlet temperature";
  parameter Buildings.Fluid.Boilers.Data.Generic effCur
    "Records of efficiency curves"
    annotation(choicesAllMatching=true);

  Modelica.Blocks.Tables.CombiTable2D effTab(
    final table=effCur.effCur,
    final smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative)
    "Look-up table that represents a set of efficiency curves varying with both the firing rate (control signal) and the inlet water temperature"
    annotation (Placement(transformation(extent={{-42,64},{-22,84}})));

  Modelica.Blocks.Sources.RealExpression TIn(
    y=Medium.temperature(state=Medium.setState_phX(
        p=port_a.p, h=inStream(port_a.h_outflow), X=inStream(port_a.Xi_outflow))))
    "Water inlet temperature"
    annotation (Placement(transformation(extent={{-94,58},{-74,78}})));
initial equation
  eta_nominal = Buildings.Utilities.Math.Functions.smoothInterpolation(
    x=TIn_nominal, xSup=effCur.effCur[1,2:end], ySup=effCur.effCur[end,2:end]);
  assert(abs(effCur.effCur[end,1] - 1) < 1E-6,
    "Efficiency curve at full load (y = 1) must be provided.");

equation
  connect(effTab.u1, y) annotation (Line(points={{-44,80},{-120,80}},
                color={0,0,127}));
  connect(TIn.y, effTab.u2)
    annotation (Line(points={{-73,68},{-44,68}}, color={0,0,127}));
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
October 13, 2021 by Hongxiang Fu:<br/>
First implementation. This is for 
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2651\">#2651</a>.
</li>
</ul>
</html>"), Icon(graphics={
        Rectangle(
          origin={-80,-79},
          lineColor={64,64,64},
          fillColor={255,215,136},
          fillPattern=FillPattern.Solid,
          extent={{-12,-11},{12,11}},
          radius=5.0),
        Line(
          points={{-80,-68},{-80,-90}}),
        Line(
          points={{-92,-76},{-68,-76}}),
        Line(
          points={{-92,-84},{-68,-84}})}));
end BoilerTable;
