within Buildings.Utilities.IO.SignalExchange;
model WeatherStation
  "Implements typical weather measurements with signal exchange blocks"
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data"
    annotation (Placement(
        transformation(extent={{-110,-10},{-90,10}}), iconTransformation(extent={{-112,
            -14},{-86,12}})));
  Buildings.Utilities.IO.SignalExchange.Read reaWeaTDryBul(
    description="Outside drybulb temperature measurement",
    y(final unit="K"))
    "Outside drybulb temperature measurement"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Buildings.Utilities.IO.SignalExchange.Read reaWeaRelHum(
    description="Outside relative humidity measurement",
    y(final unit="1"))
    "Outside relative humidity measurement"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Utilities.IO.SignalExchange.Read reaWeaWinSpe(
    description="Wind speed measurement",
    y(final unit="m/s"))
    "Wind speed measurement"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Utilities.IO.SignalExchange.Read reaWeaWinDir(
    description="Wind direction measurement",
    y(final unit="rad"))
    "Wind direction measurement"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Utilities.IO.SignalExchange.Read reaWeaHGloHor(
    description="Global horizontal solar irradiation measurement",
    y(final unit="W/m2"))
    "Global horizontal solar irradiation measurement"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Buildings.Utilities.IO.SignalExchange.Read reaWeaNTot(
    description="Sky cover measurement",
    y(final unit="1"))
    "Sky cover measurement"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Utilities.IO.SignalExchange.Read reaWeaPAtm(
    description="Atmospheric pressure measurement",
    y(final unit="Pa"))
    "Atmospheric pressure measurement"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  Buildings.Utilities.IO.SignalExchange.Read reaWeaHDifHor(
    description="Horizontal diffuse solar radiation measurement",
    y(final unit="W/m2"))
    "Horizontal diffuse solar radiation measurement"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
  Buildings.Utilities.IO.SignalExchange.Read reaWeaCeiHei(
    description="Cloud cover ceiling height measurement",
    y(final unit="m"))
    "Cloud cover ceiling height measurement"
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
  Buildings.Utilities.IO.SignalExchange.Read reaWeaTWetBul(
    description="Wet bulb temperature measurement",
    y(final unit="K"))
    "Wet bulb temperature measurement"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Buildings.Utilities.IO.SignalExchange.Read reaWeaTDewPoi(
    description="Dew point temperature measurement",
    y(final unit="K"))
    "Dew point temperature measurement"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Buildings.Utilities.IO.SignalExchange.Read reaWeaTBlaSky(
    description="Black-body sky temperature measurement",
    y(final unit="K"))
    "Black-body sky temperature measurement"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Utilities.IO.SignalExchange.Read reaWeaHHorIR(
    description="Horizontal infrared irradiation measurement",
    y(final unit="W/m2"))
    "Horizontal infrared irradiation measurement"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Utilities.IO.SignalExchange.Read reaWeaHDirNor(
    description="Direct normal radiation measurement",
    y(final unit="W/m2"))
    "Direct normal radiation measurement"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Buildings.Utilities.IO.SignalExchange.Read reaWeaCloTim(
    description="Day number with units of seconds",
    y(final unit="s"))
    "Day number with units of seconds"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Buildings.Utilities.IO.SignalExchange.Read reaWeaSolAlt(
    description="Solar altitude angle measurement",
    y(final unit="rad"))
    "Solar altitude angle measurement"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.Utilities.IO.SignalExchange.Read reaWeaNOpa(
    description="Opaque sky cover measurement",
    y(final unit="1"))
    "Opaque sky cover measurement"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Utilities.IO.SignalExchange.Read reaWeaLat(
    description="Latitude of the location",
    y(final unit="rad"))
    "Latitude of the location"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Buildings.Utilities.IO.SignalExchange.Read reaWeaLon(
    description="Longitude of the location",
    y(final unit="rad"))
    "Longitude of the location"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Buildings.Utilities.IO.SignalExchange.Read reaWeaSolDec(
    description="Solar declination angle measurement",
    y(final unit="rad"))
    "Solar declination angle measurement"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Buildings.Utilities.IO.SignalExchange.Read reaWeaSolHouAng(
    description="Solar hour angle measurement",
    y(final unit="rad"))
    "Solar hour angle measurement"
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
  Buildings.Utilities.IO.SignalExchange.Read reaWeaSolTim(
    description="Solar time",
    y(final unit="s"))
    "Solar time"
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Buildings.Utilities.IO.SignalExchange.Read reaWeaSolZen(
    description="Solar zenith angle measurement",
    y(final unit="rad"))
    "Solar zenith angle measurement"
    annotation (Placement(transformation(extent={{80,50},{100,70}})));
equation
  connect(weaBus.TDryBul, reaWeaTDryBul.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,90},{-42,90}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.relHum, reaWeaRelHum.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,60},{-42,60}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.winSpe, reaWeaWinSpe.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,30},{-42,30}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.winDir, reaWeaWinDir.u) annotation (Line(
      points={{-100,0},{-42,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.HGloHor, reaWeaHGloHor.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,-30},{-42,-30}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.nTot, reaWeaNTot.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,-60},{-42,-60}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.pAtm, reaWeaPAtm.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,-90},{-42,-90}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.HDifHor, reaWeaHDifHor.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,76},{-10,76},{-10,90},{-2,90}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.HDirNor, reaWeaHDirNor.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,46},{-10,46},{-10,60},{-2,60}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.HHorIR, reaWeaHHorIR.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,16},{-12,16},{-12,30},{-2,30}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.TBlaSky, reaWeaTBlaSky.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,-14},{-12,-14},{-12,0},{-2,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.TDewPoi, reaWeaTDewPoi.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,-44},{-10,-44},{-10,-30},{-2,-30}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.TWetBul, reaWeaTWetBul.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,-74},{-10,-74},{-10,-60},{-2,-60}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.ceiHei, reaWeaCeiHei.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,-100},{-10,-100},{-10,-90},{-2,-90}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.cloTim, reaWeaCloTim.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,76},{30,76},{30,90},{38,90}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.lat, reaWeaLat.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,46},{30,46},{30,60},{38,60}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.lon, reaWeaLon.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,16},{30,16},{30,30},{38,30}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.nOpa, reaWeaNOpa.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,-14},{30,-14},{30,0},{38,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.solAlt, reaWeaSolAlt.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,-44},{30,-44},{30,-30},{38,-30}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.solDec, reaWeaSolDec.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,-74},{30,-74},{30,-60},{38,-60}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.solHouAng, reaWeaSolHouAng.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,-100},{30,-100},{30,-90},{38,-90}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.solTim, reaWeaSolTim.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,76},{70,76},{70,90},{78,90}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.solZen, reaWeaSolZen.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,46},{70,46},{70,60},{78,60}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Documentation(info="<html>
<p>
This block enables the reading of weather measurements and their meta-data by an external
program without the need to explicitly propagate the signal to a top-level model.
This block utilizes a number of pre-configured instances of
<a href=\"modelica://Buildings.Utilities.IO.SignalExchange.Read\">
Buildings.Utilities.IO.SignalExchange.Read</a>
</p>
<h4>Typical use and important parameters</h4>
<p>
This block is typically used by the BOPTEST framework
(see <a href=\"https://github.com/ibpsa/project1-boptest\">BOPTEST</a>)
to identify and read weather measurements by test
controllers. It is used in combination with a dedicated parser to perform
this task (see <a href=\"https://github.com/ibpsa/project1-boptest/tree/master/parsing\">Parser Code</a>).
</p>
</html>",
revisions="<html>
<ul>
<li>
October 2, 2020 by David Blum:<br/>
First implementation.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1402\">#1402</a>.
</li>
</ul>
</html>"), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),                                     graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,159},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-52,28},{-48,-80}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-52,82},{-54,26},{22,20},{40,14},{62,-6},{70,-4},{74,4},{48,
              32},{20,58},{-52,82}},
          lineColor={0,0,0},
          fillColor={255,170,85},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-64,82},{-42,26}},
          lineColor={0,0,0},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{120,120}})));
end WeatherStation;
