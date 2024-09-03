within Buildings.Fluid.HeatPumps.Compressors.BaseClasses.Validation;
model TemperatureProtection
  "Validation of temperature protection model"
  extends Modelica.Icons.Example;

  Buildings.Fluid.HeatPumps.Compressors.BaseClasses.TemperatureProtection
    temPro(TConMax=313.15, TEvaMin=278.15) "Temperature protection block"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Modelica.Blocks.Sources.Cosine TEva(
    f=1,
    amplitude=10,
    offset=283.15) "Evaporator temperature"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Blocks.Sources.Cosine TCon(
    f=1.2,
    offset=303.15,
    amplitude=20) "Condenser temperature"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.Constant one(k=1) "Control signal"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
equation
  connect(TEva.y, temPro.TEva) annotation (Line(points={{-59,-30},{-40,-30},{
          -40,2},{-22,2}}, color={0,0,127}));
  connect(temPro.TCon, TCon.y) annotation (Line(points={{-22,18},{-40,18},{-40,
          50},{-59,50}}, color={0,0,127}));
  connect(one.y, temPro.u)
    annotation (Line(points={{-59,10},{-40,10},{-22,10}}, color={0,0,127}));
  annotation (
    Documentation(info="<html>
<p>
Model that tests temperature protection functionality.
</p>
</html>", revisions="<html>
<ul>
<li>
May 31, 2017, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/Compressors/BaseClasses/Validation/TemperatureProtection.mos"
        "Simulate and plot"),
    experiment(StopTime=5, Tolerance=1e-06));
end TemperatureProtection;
