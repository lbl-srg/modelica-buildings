within Buildings.Examples.ChillerPlant.BaseClasses;
block WeatherData
  "Modified WeatherData by adding wet bulb temperature for output"
  extends Buildings.BoundaryConditions.WeatherData.ReaderTMY3;
  Utilities.Psychrometrics.TWetBul_TDryBulPhi          tWetBul_TDryBulXi(
      redeclare package Medium = Buildings.Media.PerfectGases.MoistAir, TDryBul(
        displayUnit="degC"))
    annotation (Placement(transformation(extent={{244,-66},{264,-46}})));
equation
  connect(chePre.POut, tWetBul_TDryBulXi.p) annotation (Line(
      points={{181,70},{220,70},{220,-64},{243,-64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tWetBul_TDryBulXi.TWetBul, weaBus.TWetBul) annotation (Line(
      points={{265,-56},{280,-56},{280,0},{292,0},{292,5.55112e-16},{304,
          5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheTemDryBul.TOut, tWetBul_TDryBulXi.TDryBul) annotation (Line(
      points={{181,-190},{220,-190},{220,-48},{243,-48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cheRelHum.relHumOut, tWetBul_TDryBulXi.phi) annotation (Line(
      points={{181,30},{208,30},{208,-56},{243,-56}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-200,-300},{300,
            300}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-200,-200},{200,
            200}},
        initialScale=0.05)),
    Documentation(info="<html>
<p>
This is a modified model of the weather data reader <a href=\"modelica://Buildings.BoundaryConditions.WeatherData.ReaderTMY3\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3</a>. It outputs the wet bulb temperature in addition to the other data.
</p></html>", revisions="<html>
<ul>
<li>
October 1, 2012 by Michael Wetter:<br>
Fixed error in weather data. The previous model used the relative humidity as an input
to the wet bulb temperature calculation. However, in the previous version,
the web bulb temperature was computed based on the water vapor mass fraction.
In this version, the wet bulb temperature computation has been changed to take
as an input the relative humidity.
</li>
<li>
October 27, 2011 by Wangda Zuo:<br>
Update it due to the change of ReaderTMY3.
</li>
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
