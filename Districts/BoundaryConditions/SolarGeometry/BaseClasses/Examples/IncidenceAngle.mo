within Districts.BoundaryConditions.SolarGeometry.BaseClasses.Examples;
model IncidenceAngle "Test model for incidence angle"
  extends Modelica.Icons.Example;
  import Districts;
  Districts.BoundaryConditions.SolarGeometry.BaseClasses.Declination decAng
    "Declination angle"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Districts.BoundaryConditions.SolarGeometry.BaseClasses.SolarHourAngle
    solHouAng "Solar hour angle" annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Districts.BoundaryConditions.SolarGeometry.BaseClasses.IncidenceAngle incAng(
    azi=0,
    til=90,
    lat=0.73268921998722) "incidence angle"
                              annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Districts.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam="modelica://Districts/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    "Weather data"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Districts.BoundaryConditions.WeatherData.Bus weaBus "Weather bus"
    annotation (Placement(transformation(extent={{-46,-10},{-26,10}})));
equation
  connect(decAng.decAng, incAng.decAng) annotation (Line(
      points={{21,30},{30,30},{30,5.4},{37.8,5.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solHouAng.solHouAng, incAng.solHouAng) annotation (Line(
      points={{21,-30},{28,-30},{28,-4.8},{38,-4.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-60,5.82867e-16},{-54,5.82867e-16},{-54,1.13798e-15},{-48,
          1.13798e-15},{-48,5.55112e-16},{-36,5.55112e-16}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus.cloTim, decAng.nDay) annotation (Line(
      points={{-36,5.55112e-16},{-20,5.55112e-16},{-20,30},{-2,30}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.solTim, solHouAng.solTim) annotation (Line(
      points={{-36,5.55112e-16},{-20,5.55112e-16},{-20,-30},{-2,-30}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  annotation (Diagram(graphics), __Dymola_Commands(file="modelica://Districts/Resources/Scripts/Dymola/BoundaryConditions/SolarGeometry/BaseClasses/Examples/IncidenceAngle.mos"
        "Simulate and plot"));
end IncidenceAngle;
