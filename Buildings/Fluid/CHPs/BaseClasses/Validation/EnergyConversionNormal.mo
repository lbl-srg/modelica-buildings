within Buildings.Fluid.CHPs.BaseClasses.Validation;
model EnergyConversionNormal "Validate model EnergyConversionNormal"
  extends Modelica.Icons.Example;

  parameter Buildings.Fluid.CHPs.Data.ValidationData1 per
    "CHP performance data"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  Buildings.Fluid.CHPs.BaseClasses.EnergyConversionNormal opeModBas(
    final per=per) "Energy conversion for a typical CHP operation"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp PEle(
    final height=5000,
    final duration=360,
    final offset=0,
    final startTime=600) "Electric power"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant mWat_flow(
    final k=0.05) "Water mass flow rate"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TWatIn(
    y(final unit="K", displayUnit="degC"),
    final k=273.15 + 15)
    "Water inlet temperature"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));

equation
  connect(TWatIn.y, opeModBas.TWatIn) annotation (Line(points={{-38,-30},{0,-30},
          {0,4},{38,4}}, color={0,0,127}));
  connect(mWat_flow.y, opeModBas.mWat_flow) annotation (Line(points={{-38,10},
          {38,10}}, color={0,0,127}));
  connect(PEle.y, opeModBas.PEle) annotation (Line(points={{-38,50},{0,50},{0,
          16},{38,16}}, color={0,0,127}));

annotation (
  experiment(StopTime=1500, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/BaseClasses/Validation/EnergyConversionNormal.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Fluid.CHPs.BaseClasses.EnergyConversionNormal\">
Buildings.Fluid.CHPs.BaseClasses.EnergyConversionNormal</a>
for defining energy conversion for a typical CHP operation.
</p>
</html>", revisions="<html>
<ul>
<li>
October 31, 2019, by Jianjun Hu:<br/>
Refactored implementation.
</li>
<li>
July 01 2019, by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end EnergyConversionNormal;
