within Buildings.Fluid.CHPs.BaseClasses.Validation;
model EnergyConversionWarmUp "Validate model EnergyConversionWarmUp"
  extends Modelica.Icons.Example;

  parameter Buildings.Fluid.CHPs.Data.ValidationData2 per
    "CHP performance data"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));

  Buildings.Fluid.CHPs.BaseClasses.EnergyConversionWarmUp opeModWarUpEngTem(
    final per=per) "Energy conversion during warm-up by engine temperature"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TEng(
    y(final unit="K", displayUnit="degC"),
    final height=90,
    final duration=360,
    final offset=273.15 + 15,
    final startTime=600) "Engine temperature"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant mWat_flow(
    final k=0.05)
    "Water mass flow rate"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TWatIn(
    y(final unit="K", displayUnit="degC"),
    final k=273.15 + 15)
    "Water inlet temperature"
    annotation (Placement(transformation(extent={{-60,2},{-40,22}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TRoo(
    y(final unit="K", displayUnit="degC"),
    final k=273.15 + 15)
    "Room temperature"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));

equation
  connect(TWatIn.y, opeModWarUpEngTem.TWatIn) annotation (Line(points={{-38,12},
          {0,12},{0,13},{38,13}},  color={0,0,127}));
  connect(mWat_flow.y, opeModWarUpEngTem.mWat_flow) annotation (Line(points={{-38,50},
          {0,50},{0,18},{38,18}},  color={0,0,127}));
  connect(TRoo.y, opeModWarUpEngTem.TRoo) annotation (Line(points={{-38,-30},{0,
          -30},{0,7},{38,7}},   color={0,0,127}));
  connect(TEng.y, opeModWarUpEngTem.TEng) annotation (Line(points={{-38,-70},{
          20,-70},{20,2},{38,2}}, color={0,0,127}));

annotation (
  experiment(StopTime=1500, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/BaseClasses/Validation/EnergyConversionWarmUp.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Fluid.CHPs.BaseClasses.EnergyConversionWarmUp\">
Buildings.Fluid.CHPs.BaseClasses.EnergyConversionWarmUp</a>
for defining energy conversion during the warm-up mode dependent on the engine temperature.
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
end EnergyConversionWarmUp;
