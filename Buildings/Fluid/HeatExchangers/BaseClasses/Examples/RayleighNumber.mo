within Buildings.Fluid.HeatExchangers.BaseClasses.Examples;
model RayleighNumber
  import Buildings;
  extends Modelica.Icons.Example;
  Buildings.Fluid.HeatExchangers.BaseClasses.RayleighNumber rayleighNumber(
      redeclare package Medium = Buildings.Media.ConstantPropertyLiquidWater)
    annotation (Placement(transformation(extent={{-10,0},{14,24}})));
  Modelica.Blocks.Sources.Constant const(k=273.15 + 60)
    annotation (Placement(transformation(extent={{-74,10},{-54,30}})));
  Modelica.Blocks.Sources.Constant const1(k=273.15 + 30)
    annotation (Placement(transformation(extent={{-74,-28},{-54,-8}})));
equation
  connect(const.y, rayleighNumber.TSur) annotation (Line(
      points={{-53,20},{-32,20},{-32,16.8},{-12.4,16.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const1.y, rayleighNumber.TFlu) annotation (Line(
      points={{-53,-18},{-32,-18},{-32,7.2},{-12.4,7.2}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Commands(file=
          "Resources/Scripts/Dymola/Fluid/HeatExchangers/BaseClasses/Examples/RayleighNumber.mos"
        "Simulate and Plot"));
end RayleighNumber;
