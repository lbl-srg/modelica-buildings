within Buildings.Utilities.Psychrometrics.Examples;
model TotalAirDryAir
  "Unit test for conversion of humidity per total air and dry air mass"
  extends Modelica.Icons.Example;
   package Medium = Buildings.Media.Air "Medium model"
           annotation (choicesAllMatching = true);
    Modelica.Blocks.Sources.Ramp XHum(
    duration=1,
    height=(0.01 - 0.1),
    offset=0.1) "Humidity concentration"
                 annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  ToTotalAir toTotalAir
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  ToDryAir toDryAir
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Diagnostics.AssertEquality assertEquality(threShold=1E-5)
    "Checks that model and its inverse implementation are correct"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
equation
  connect(toTotalAir.XiDry, XHum.y) annotation (Line(
      points={{-41,10},{-59,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(toTotalAir.XiTotalAir, toDryAir.XiTotalAir) annotation (Line(
      points={{-19,10},{-1,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(toDryAir.XiDry, assertEquality.u1) annotation (Line(
      points={{21,10},{28,10},{28,-4},{38,-4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(assertEquality.u2, XHum.y) annotation (Line(
      points={{38,-16},{-50,-16},{-50,10},{-59,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Psychrometrics/Examples/TotalAirDryAir.mos"
        "Simulate and plot"));
end TotalAirDryAir;
