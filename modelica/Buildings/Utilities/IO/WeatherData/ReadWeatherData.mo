within Buildings.Utilities.IO.WeatherData;
block ReadWeatherData "Read the requested weather data "
  extends Modelica.Blocks.Interfaces.BlockIcon;
public
  parameter String filNam "Name of weather data file" annotation (Dialog(
        __Dymola_loadSelector(filter="Weather files (*.mos)", caption=
            "Open weather file for reading")));

  Modelica.Blocks.Interfaces.RealInput cloTim "Clock time"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  WeatherBus weaBus "Weather Data Bus"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
protected
  Modelica.Blocks.Tables.CombiTable1Ds datRea(
    tableOnFile=true,
    tableName="tab1",
    fileName=filNam,
    columns=2:30,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative)
    "Data reader"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));

  Buildings.Utilities.IO.WeatherData.BaseClasses.ConvertTime timCon
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Utilities.IO.WeatherData.BaseClasses.ConvertTemperature
    conTemDryBul "Convert unit for dry bulb temperature "
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
  Buildings.Utilities.IO.WeatherData.BaseClasses.ConvertTemperature conTemDew
    "Convert unit for dew point temperature"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Buildings.Utilities.IO.WeatherData.BaseClasses.ConvertRelativeHumidity conHum
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  BaseClasses.CheckPressure chePre
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  BaseClasses.CheckSkyCover cheTotSkyCov "Check total sky cover"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  BaseClasses.CheckSkyCover cheOpaSkyCov "Check opaque sky cover"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Buildings.Utilities.IO.WeatherData.BaseClasses.ConvertRadiation cheGloHorRad
    "Check global horizontal radiation"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Buildings.Utilities.IO.WeatherData.BaseClasses.ConvertRadiation cheDifHorRad
    "CHeck diffuse horizontal radiation"
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));

equation
  connect(cloTim, timCon.simTim) annotation (Line(
      points={{-120,1.11022e-15},{-90,1.11022e-15},{-90,-10},{-82,-10}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(timCon.calTim, datRea.u) annotation (Line(
      points={{-59,-10},{-42,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[1], conTemDryBul.TemC) annotation (Line(
      points={{-19,-10},{-10,-10},{-10,90},{-2,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[2], conTemDew.TemC) annotation (Line(
      points={{-19,-10},{-10,-10},{-10,70},{38,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conTemDryBul.TemK, weaBus.TDryBul) annotation (Line(
      points={{21,90},{80,90},{80,5.55112e-16},{100,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(conTemDew.TemK, weaBus.TDew) annotation (Line(
      points={{61,70},{80,70},{80,0},{90,0},{90,5.55112e-16},{100,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));

  connect(datRea.y[3], conHum.relHumIn) annotation (Line(
      points={{-19,-10},{-10,-10},{-10,50},{-2,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conHum.relHumOut, weaBus.relHum) annotation (Line(
      points={{21,50},{80,50},{80,5.55112e-16},{100,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(datRea.y[4], chePre.PIn) annotation (Line(
      points={{-19,-10},{-10,-10},{-10,30},{38,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(chePre.POut, weaBus.pAtm) annotation (Line(
      points={{61,30},{80,30},{80,0},{90,0},{90,5.55112e-16},{100,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));

  connect(datRea.y[17], cheTotSkyCov.nIn) annotation (Line(
      points={{-19,-10},{-10,-10},{-10,-30},{-2,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cheTotSkyCov.nOut, weaBus.nTol) annotation (Line(
      points={{21,-30},{80,-30},{80,5.55112e-16},{100,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(datRea.y[18], cheOpaSkyCov.nIn) annotation (Line(
      points={{-19,-10},{-10,-10},{-10,-50},{38,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cheOpaSkyCov.nOut, weaBus.nOpa) annotation (Line(
      points={{61,-50},{80,-50},{80,5.55112e-16},{100,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(datRea.y[8], cheGloHorRad.HIn) annotation (Line(
      points={{-19,-10},{-10,-10},{-10,-70},{-2,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cheGloHorRad.HOut, weaBus.HGloHor) annotation (Line(
      points={{21,-70},{80,-70},{80,5.55112e-16},{100,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(datRea.y[10], cheDifHorRad.HIn) annotation (Line(
      points={{-19,-10},{-10,-10},{-10,-90},{38,-90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cheDifHorRad.HOut, weaBus.HDifHor) annotation (Line(
      points={{61,-90},{80,-90},{80,5.55112e-16},{100,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(datRea.y[20], weaBus.celHei) annotation (Line(
      points={{-19,-10},{80,-10},{80,0},{90,0},{90,5.55112e-16},{100,
          5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));

  connect(cloTim, weaBus.cloTim) annotation (Line(
      points={{-120,1.11022e-15},{-90,1.11022e-15},{-90,10},{80,10},{80,
          5.55112e-16},{100,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    defaultComponentName="weaDat",
    Documentation(info="<HTML>
<p>
This component reads the weather data.
</p>
</HTML>
", revisions="<html>
<ul>
<li>
June 25, 2010, by Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,
            100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Ellipse(
          extent={{-24,34},{42,-30}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-30,42},{-18,28}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{32,-28},{44,-42}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{46,0},{64,0}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{-48,2},{-30,2}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{36,28},{50,40}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{-34,-36},{-20,-24}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{8,-36},{8,-52}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{8,54},{8,38}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1)}),
    defaultComponentName="weaDat",
    Documentation(info="<HTML>
<p>
This component reads the weather data.
</p>
</HTML>
", revisions="<html>
<ul>
<li>
June 25, 2010, by Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,
            100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Ellipse(
          extent={{-24,34},{42,-30}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),Line(
          points={{-30,42},{-18,28}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1),Line(
          points={{32,-28},{44,-42}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1),Line(
          points={{46,0},{64,0}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1),Line(
          points={{-48,2},{-30,2}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1),Line(
          points={{36,28},{50,40}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1),Line(
          points={{-34,-36},{-20,-24}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1),Line(
          points={{8,-36},{8,-52}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1),Line(
          points={{8,54},{8,38}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1)}));
end ReadWeatherData;
