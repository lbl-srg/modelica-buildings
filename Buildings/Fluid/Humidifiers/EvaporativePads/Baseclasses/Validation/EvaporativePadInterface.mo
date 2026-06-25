within Buildings.Fluid.Humidifiers.EvaporativePads.Baseclasses.Validation;
model EvaporativePadInterface
  "Simple model to validate EvaporativePadInterface"
  extends Modelica.Icons.Example;
  Buildings.Fluid.Humidifiers.EvaporativePads.Baseclasses.EvaporativePadInterface
    evaPadInt(redeclare
      Buildings.Fluid.Humidifiers.EvaporativePads.Data.Generic per)
    "Model for the evaporative pad interface"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Modelica.Blocks.Sources.Ramp v(
    height=12.5,
    duration=1,
    offset=-5)
    "Air velocity"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
equation
  connect(v.y, evaPadInt.v)
    annotation (Line(points={{-19,10},{18,10}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
Simple validation model for the evaporative pad interface model.
</p>
</html>", revisions="<html>
<ul>
<li>
June 15, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StopTime=1,
      Interval=60,
      Tolerance=1e-6),
    __Dymola_Commands(file=
      "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Humidifiers/EvaporativePads/Baseclasses/Validation/EvaporativePadInterface.mos"
      "Simulate and plot"));
end EvaporativePadInterface;
