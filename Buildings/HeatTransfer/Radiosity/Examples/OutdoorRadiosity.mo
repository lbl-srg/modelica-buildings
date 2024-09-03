within Buildings.HeatTransfer.Radiosity.Examples;
model OutdoorRadiosity "Test model for outdoor radiosity"
  extends Modelica.Icons.Example;
  Buildings.HeatTransfer.Radiosity.OpaqueSurface sur(A=A, absIR=1)
    "Receiving surface"
    annotation (Placement(transformation(extent={{76,-20},{56,0}})));
  Buildings.HeatTransfer.Radiosity.OutdoorRadiosity outRad(A=A, vieFacSky=0.5)
    "Outdoor radiosity model"
    annotation (Placement(transformation(extent={{-40,-22},{-20,-2}})));
  parameter Modelica.Units.SI.Area A=1 "Area of receiving surface";
  Modelica.Blocks.Sources.Ramp TSky(
    duration=1,
    height=30,
    offset=273.15) "Sky blackbody temperature"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Blocks.Sources.Constant TAir(k=273.15 + 20)
    "Outside air temperature"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
equation
  connect(outRad.JOut, sur.JIn)           annotation (Line(
      points={{-19,-12},{18,-12},{18,-14},{55,-14}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(TAir.y, outRad.TBlaSky) annotation (Line(
      points={{-59,10},{-52,10},{-52,-8},{-42,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSky.y, outRad.TOut) annotation (Line(
      points={{-59,-30},{-50,-30},{-50,-16},{-42,-16}},
      color={0,0,127},
      smooth=Smooth.None));
    annotation (
experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/HeatTransfer/Radiosity/Examples/OutdoorRadiosity.mos"
        "Simulate and plot"));
end OutdoorRadiosity;
