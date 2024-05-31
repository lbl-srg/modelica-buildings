within Buildings.BoundaryConditions.WeatherData;
expandable connector Bus "Data bus that stores weather data"
  extends Modelica.Icons.SignalBus;

  Modelica.Units.SI.Temperature TDryBul(start=293.15) "Dry bulb temperature";
  Modelica.Units.SI.Temperature TWetBul(start=293.15) "Wet bulb temperature";
  Modelica.Units.SI.Temperature TDewPoi "Dew point temperature";
  Modelica.Units.SI.Temperature TBlaSky "Black-body sky temperature";

  Real relHum(final unit="1") "Relative humidity";

  Real HDirNor(final unit="W/m2") "Direct normal solar irradiation";
  Real HGloHor(final unit="W/m2") "Global horizontal solar irradiation";
  Real HDifHor(final unit="W/m2") "Diffuse horizontal solar irradiation";

  Real HHorIR(final unit="W/m2") "Horizontal infrared irradiation";

  Modelica.Units.SI.Angle winDir "Wind direction";
  Modelica.Units.SI.Velocity winSpe "Wind speed";

  Modelica.Units.SI.Height ceiHei "Cloud cover ceiling height";
  Real nOpa(final unit="1") "Opaque sky cover";
  Real nTot(final unit="1") "Total sky cover";

  Modelica.Units.SI.Angle lat "Latitude of the location";
  Modelica.Units.SI.Angle lon "Longitude of the location";
  Modelica.Units.SI.Height alt "Location altitude above sea level";

  Modelica.Units.SI.AbsolutePressure pAtm "Atmospheric pressure";

  Modelica.Units.SI.Angle solAlt "Solar altitude angle";
  Modelica.Units.SI.Angle solDec "Solar declination angle";
  Modelica.Units.SI.Angle solHouAng "Solar hour angle";
  Modelica.Units.SI.Angle solZen "Solar zenith angle";

  Modelica.Units.SI.Time solTim "Solar time";
  Modelica.Units.SI.Time cloTim "Model time";

  annotation (
    defaultComponentName="weaBus",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Rectangle(
          extent={{-20,2},{22,-2}},
          lineColor={255,204,51},
          lineThickness=0.5)}),
    Documentation(info="<html>
<p>
This component is an expandable connector that is used to implement a bus that contains the weather data.
</p>
</html>", revisions="<html>
<ul>
<li>
September 22, 2023, by Michael Wetter:<br/>
Declared the variables that are on the bus.<br/>
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1798\">IBPSA, #1798</a>.
</li>
<li>
June 25, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end Bus;
