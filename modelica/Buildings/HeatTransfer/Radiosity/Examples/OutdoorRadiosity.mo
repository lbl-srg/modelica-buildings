within Buildings.HeatTransfer.Radiosity.Examples;
model OutdoorRadiosity "Test model for outdoor radiosity"
  import Buildings;
  Buildings.HeatTransfer.Radiosity.OpaqueSurface sur(A=A, epsLW=1)
    "Receiving surface"
    annotation (Placement(transformation(extent={{76,-20},{56,0}})));
  Buildings.HeatTransfer.Radiosity.OutdoorRadiosity outRad(A=A, F_sky=0.5)
    "Outdoor radiosity model"
    annotation (Placement(transformation(extent={{-40,-22},{-20,-2}})));
  parameter Modelica.SIunits.Area A=1 "Area of receiving surface";
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TAirOut(T=293.15)
    "Outside air temperature"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Modelica.Blocks.Sources.Ramp f_clr(duration=1)
    "Fraction of sky that is clear"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
equation
  connect(outRad.JOut, sur.JIn)           annotation (Line(
      points={{-19,-12},{18,-12},{18,-14},{55,-14}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(f_clr.y, outRad.f_clr) annotation (Line(
      points={{-59,-30},{-50,-30},{-50,-12},{-42,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TAirOut.port, outRad.heatPort) annotation (Line(
      points={{-60,10},{-50,10},{-50,-6},{-40,-6}},
      color={191,0,0},
      smooth=Smooth.None));
    annotation(Commands(file="OutdoorRadiosity.mos" "run"),
              Diagram(graphics));
end OutdoorRadiosity;
