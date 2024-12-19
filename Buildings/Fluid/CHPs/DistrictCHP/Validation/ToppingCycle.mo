within Buildings.Fluid.CHPs.DistrictCHP.Validation;
model ToppingCycle
  extends Modelica.Icons.Example;

  // Choose differernt gas turbine
  replaceable parameter Buildings.Fluid.CHPs.DistrictCHP.Data.SolarTurbines.NaturalGas.Taurus70_11101S_NG per
     "Performance curve for the selected gas turbine";

  // Part load parameters for different load levels
  Modelica.Blocks.Sources.Constant parLoa60(
    k=0.6)
    "Gas turbine generator part load ratio is 0.6"
    annotation (Placement(transformation(extent={{-12,70},{8,90}})));
  Buildings.Fluid.CHPs.DistrictCHP.ToppingCycle topCycTab60(
    final per=per)
    annotation (Placement(transformation(extent={{68,66},{88,86}})));

  Modelica.Blocks.Sources.Constant parLoa70(
    k=0.7)
    "Gas turbine generator part load ratio is 0.7"
    annotation (Placement(transformation(extent={{-12,30},{8,50}})));
  Buildings.Fluid.CHPs.DistrictCHP.ToppingCycle topCycTab70(
    final per=per)
    annotation (Placement(transformation(extent={{68,26},{88,46}})));

  Modelica.Blocks.Sources.Constant parLoa80(
    k=0.8)
    "Gas turbine generator part load ratio is 0.8"
    annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
  Buildings.Fluid.CHPs.DistrictCHP.ToppingCycle topCycTab80(
    final per=per)
    annotation (Placement(transformation(extent={{68,-14},{88,6}})));

  Modelica.Blocks.Sources.Constant parLoa90(
    k=0.9)
    "Gas turbine generator part load ratio is 0.9"
    annotation (Placement(transformation(extent={{-12,-50},{8,-30}})));
  Buildings.Fluid.CHPs.DistrictCHP.ToppingCycle topCycTab90(
    final per=per)
    annotation (Placement(transformation(extent={{68,-54},{88,-34}})));

  Modelica.Blocks.Sources.Constant parLoa100(
    k=1.0)
    "Gas turbine generator part load ratio is 1.0"
    annotation (Placement(transformation(extent={{-12,-90},{8,-70}})));
  Buildings.Fluid.CHPs.DistrictCHP.ToppingCycle topCycTab100(
    final per=per)
    annotation (Placement(transformation(extent={{68,-94},{88,-74}})));
  Modelica.Blocks.Sources.Ramp TAmb(
    height=30,
    duration=3600,
    offset=5)
    "Ramps for ambient temperature from 5°C to 35°C"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
equation
  // Connections for part load and turbine performance tables
  connect(topCycTab60.y, parLoa60.y)
    annotation (Line(points={{66,80},{9,80}}, color={0,0,127}));

  connect(topCycTab70.y, parLoa70.y)
    annotation (Line(points={{66,40},{9,40}}, color={0,0,127}));

  connect(topCycTab80.y, parLoa80.y)
    annotation (Line(points={{66,0},{9,0}}, color={0,0,127}));

  connect(topCycTab90.y, parLoa90.y)
    annotation (Line(points={{66,-40},{9,-40}}, color={0,0,127}));

  connect(topCycTab100.y, parLoa100.y)
    annotation (Line(points={{66,-80},{9,-80}}, color={0,0,127}));

  // Ambient temperature connection
  connect(TAmb.y, topCycTab60.TSet)
    annotation (Line(points={{-59,0},{-40,0},{-40,60},{60,60},{60,72},{66,72}},
              color={0,0,127}));

  connect(topCycTab70.TSet, TAmb.y)
    annotation (Line(points={{66,32},{60,32},{60,20},{-40,20},{-40,0},{-59,0}},
              color={0,0,127}));

  connect(topCycTab80.TSet, TAmb.y)
    annotation (Line(points={{66,-8},{60,-8},{60,-20},{-40,-20},{-40,0},{-59,0}},
              color={0,0,127}));

  connect(topCycTab100.TSet, TAmb.y)
    annotation (Line(points={{66,-88},{60,-88},{60,-100},{-40,-100},{-40,0},{-59,0}},
              color={0,0,127}));

  connect(TAmb.y, topCycTab90.TSet) annotation (Line(points={{-59,0},{-40,0},{
          -40,-60},{60,-60},{60,-48},{66,-48}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This validation model tests the performance of the topping cycle subsystem model in the combined Heat and Power (CHP) system using the model
<a href=\"modelica://CHP/Validation/ToppingCycle\">
CHP.Validation.ToppingCycle</a>
at gas turbine load factors of 0.6, 0.7, 0.8, 0.9, and 1.0, with ambient air temperature changes from 5°C to 35°C.
</p>
<p>
The models are configured to compute the following outputs for both nominal and part-load conditions: fuel mass flow rate, electricity output, exhaust mass flow rate, and exhaust temperature, for 10 gas turbines with capacities ranging from 4 MW to 35 MW.
<p align=\"center\">
<img alt=\"Image of efficiency curves\"
src=\"modelica://CHP/Resources/Images/Validation/ToppingCycleEfficiencyCurves.png\"/>
</p>
</html>
", revisions="<html>
<ul>
<li>
October 8, 2024, by Zhanwei He:<br/>
First implementation.
</li>
</ul>
</html>"));
end ToppingCycle;
