within Buildings.Fluid.HeatExchangers.BaseClasses.Examples;
model HANaturalCylinder "Test model for natural convection outside of a coil"
  extends Modelica.Icons.Example;
  Buildings.Fluid.HeatExchangers.BaseClasses.HANaturalCylinder hANatCyl(redeclare
      package Medium =
               Buildings.Media.Water,                       ChaLen=0.1,
    hA_nominal=10,
    TFlu_nominal=293.15,
    TSur_nominal=313.15)
    "Calculates an hA value for natural convection around a cylinder"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Modelica.Blocks.Sources.Ramp TSur(
    duration=100,
    height=50,
    offset=293.15) "Temperature of the pipe surface"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.Ramp TFlu(
    duration=100,
    startTime=150,
    height=50,
    offset=293.15) "Temperature of the surrounding fluid"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
equation
  connect(TSur.y, hANatCyl.TSur) annotation (Line(
      points={{-59,30},{-32,30},{-32,14},{-2,14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TFlu.y, hANatCyl.TFlu) annotation (Line(
      points={{-59,-20},{-32,-20},{-32,6},{-2,6}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation ( __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/BaseClasses/Examples/HANaturalCylinder.mos"
        "Simulate and plot"),
        experiment(Tolerance=1e-6, StopTime=250),
        Documentation(info="<html>
        <p>
        Test model for <a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.HANaturalCylinder\">
        Buildings.Fluid.HeatExchangers.BaseClasses.HANaturalCylinder</a>.
        </p>
        </html>"));
end HANaturalCylinder;
