within Buildings.Examples.ChillerPlant.BaseClasses;
block WeatherData
  "Modified WeatherData by adding wet bulb temperature for output"
  extends Buildings.BoundaryConditions.WeatherData.ReaderTMY3;
  Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi tWetBul_TDryBulXi(
      redeclare package Medium = Buildings.Media.PerfectGases.MoistAir, TDryBul(
        displayUnit="degC"))
    annotation (Placement(transformation(extent={{140,22},{160,42}})));
equation
  connect(conTemDryBul.TemK, tWetBul_TDryBulXi.TDryBul) annotation (Line(
      points={{21,110},{110,110},{110,40},{139,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conHum.relHumOut, tWetBul_TDryBulXi.Xi[1]) annotation (Line(
      points={{21,70},{110,70},{110,32},{139,32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(chePre.POut, tWetBul_TDryBulXi.p) annotation (Line(
      points={{81,50},{110,50},{110,24},{139,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tWetBul_TDryBulXi.TWetBul, weaBus.TWetBul) annotation (Line(
      points={{161,32},{180,32},{180,5.55112e-16},{200,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-200,-200},{200,
            200}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-200,-200},{200,
            200}},
        initialScale=0.05)),
    Documentation(info="<html>
<p>
This is a modified model of the weather data reader <a href=\"modelica://Buildings.BoundaryConditions.WeatherData.ReaderTMY3\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3</a>. It outputs the wet bulb temperature in addition to the other data.
</p></html>", revisions="<html>
<ul>
<li>
July 21, 2011 by Wangda Zuo:<br>
Merge to library.
</li>
<li>
December 10, 2010 by Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"));
end WeatherData;
