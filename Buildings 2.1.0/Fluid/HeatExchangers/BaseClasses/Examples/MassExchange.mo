within Buildings.Fluid.HeatExchangers.BaseClasses.Examples;
model MassExchange "Test model for latent heat exchange"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air;
  Buildings.Fluid.HeatExchangers.BaseClasses.MassExchange masExc(redeclare
      package Medium =
               Medium) "Model for mass exchange"
                                     annotation (Placement(transformation(
          extent={{20,0},{40,20}})));
  Modelica.Blocks.Sources.Ramp TSur(
    duration=1,
    height=20,
    offset=273.15 + 5) "Surface temperature"
                   annotation (Placement(transformation(extent={{-80,60},{-60,
            80}})));
    Modelica.Blocks.Sources.Constant X_w(k=0.01)
    "Humidity mass fraction in medium"
      annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
    Modelica.Blocks.Sources.Constant Gc(k=1)
    "Sensible convective thermal conductance"
      annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
equation
  connect(TSur.y, masExc.TSur)    annotation (Line(points={{-59,70},{8,70},{8,
          18},{18,18}}, color={0,0,127}));
  connect(Gc.y, masExc.Gc)    annotation (Line(points={{-59,-70},{8,-70},{8,2},
          {18,2}}, color={0,0,127}));
  connect(X_w.y, masExc.XInf) annotation (Line(points={{-59,10},{-20,10},{18,
          10}},         color={0,0,127}));
  annotation(Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{180,100}})),
experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/BaseClasses/Examples/MassExchange.mos"
        "Simulate and plot"));
end MassExchange;
