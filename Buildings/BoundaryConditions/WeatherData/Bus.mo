within Buildings.BoundaryConditions.WeatherData;
expandable connector Bus "Data bus that stores weather data"
  extends Modelica.Icons.SignalBus;

  output Modelica.Units.SI.Temperature TDryBul(displayUnit="degC")
    "Dry bulb temperature";
  output Modelica.Units.SI.Temperature TWetBul(displayUnit="degC")
    "Wet bulb temperature";
  output Modelica.Units.SI.Temperature TDewPoi(displayUnit="degC")
    "Dew point temperature";
  output Modelica.Units.SI.Temperature TBlaSky(displayUnit="degC")
    "Black-body sky temperature";

  output Real relHum(final unit="1") "Relative humidity";

  output Real HDirNor(final unit="W/m2") "Direct normal solar irradiation";
  output Real HGloHor(final unit="W/m2") "Global horizontal solar irradiation";
  output Real HDifHor(final unit="W/m2") "Diffuse horizontal solar irradiation";

  output Real HHorIR(final unit="W/m2") "Horizontal infrared irradiation";

  output Modelica.Units.SI.Angle winDir "Wind direction";
  output Modelica.Units.SI.Velocity winSpe "Wind speed";

  output Modelica.Units.SI.Height ceiHei "Cloud cover ceiling height";
  output Real nOpa(final unit="1") "Opaque sky cover";
  output Real nTot(final unit="1") "Total sky cover";

  output Modelica.Units.SI.Angle lat "Latitude of the location";
  output Modelica.Units.SI.Angle lon "Longitude of the location";
  output Modelica.Units.SI.Height alt "Location altitude above sea level";

  output Modelica.Units.SI.AbsolutePressure pAtm "Atmospheric pressure";

  output Modelica.Units.SI.Angle solAlt "Solar altitude angle";
  output Modelica.Units.SI.Angle solDec "Solar declination angle";
  output Modelica.Units.SI.Angle solHouAng "Solar hour angle";
  output Modelica.Units.SI.Angle solZen "Solar zenith angle";

  output Modelica.Units.SI.Time solTim "Solar time";
  output Modelica.Units.SI.Time cloTim "Model time";

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
Declared the variables that are on the bus as <code>output</code> to this expandable connector.<br/>
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1798\">IBPSA, #1798</a>.
</li>
<li>
June 25, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end Bus;
