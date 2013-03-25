within Buildings.Fluid.HeatExchangers.BaseClasses.Examples;
model hNatCyl
  import Buildings;
  extends Modelica.Icons.Example;
  Buildings.Fluid.HeatExchangers.BaseClasses.hNatCyl hNatCyl(redeclare package
      Medium = Modelica.Media.Water.WaterIF97_pT, ChaLen=0.01905)
    annotation (Placement(transformation(extent={{36,-4},{56,16}})));
  Modelica.Blocks.Sources.Ramp TSur(
    duration=100,
    height=50,
    offset=283.15)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.Ramp TFlu(
    duration=100,
    startTime=150,
    offset=283.15,
    height=50)
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Fluid.HeatExchangers.BaseClasses.RayleighNumber rayleighNumber(
      redeclare package Medium = Modelica.Media.Water.WaterIF97_pT)
    annotation (Placement(transformation(extent={{-12,-32},{8,-12}})));
equation
  connect(TSur.y, hNatCyl.TSur) annotation (Line(
      points={{-59,30},{-32,30},{-32,14},{34,14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TFlu.y, hNatCyl.TFlu) annotation (Line(
      points={{-59,-20},{-32,-20},{-32,10},{34,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSur.y, rayleighNumber.TSur) annotation (Line(
      points={{-59,30},{-24,30},{-24,-18},{-14,-18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TFlu.y, rayleighNumber.TFlu) annotation (Line(
      points={{-59,-20},{-32,-20},{-32,-26},{-14,-26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(rayleighNumber.Ra, hNatCyl.Ra) annotation (Line(
      points={{9,-22},{20,-22},{20,2},{34,2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(rayleighNumber.Pr, hNatCyl.Pr) annotation (Line(
      points={{9,-26},{24,-26},{24,-2},{34,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end hNatCyl;
