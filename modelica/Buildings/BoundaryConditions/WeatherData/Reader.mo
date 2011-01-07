within Buildings.BoundaryConditions.WeatherData;
block Reader "Read the requested weather data "
public
  parameter String filNam "Name of weather data file" annotation (Dialog(
        __Dymola_loadSelector(filter="Weather files (*.mos)", caption=
            "Open weather file for reading")));
  Bus weaBus "Weather Data Bus" annotation (Placement(transformation(
          extent={{190,-10},{210,10}}), iconTransformation(extent={{190,-10},{
            210,10}})));
protected
  Modelica.Blocks.Tables.CombiTable1Ds datRea(
    tableOnFile=true,
    tableName="tab1",
    fileName=filNam,
    columns=2:30,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative)
    "Data reader"
    annotation (Placement(transformation(extent={{-88,-40},{-68,-20}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.ConvertTime timCon
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.ConvertTemperature
    conTemDryBul "Convert unit for dry bulb temperature "
    annotation (Placement(transformation(extent={{-30,100},{-10,120}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.ConvertTemperature
    conTemDewPoi "Convert unit for dew point temperature"
    annotation (Placement(transformation(extent={{30,80},{50,100}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.ConvertRelativeHumidity
    conHum annotation (Placement(transformation(extent={{-30,60},{-10,80}})));
  BaseClasses.CheckPressure chePre
    annotation (Placement(transformation(extent={{30,40},{50,60}})));
  BaseClasses.CheckSkyCover cheTotSkyCov "Check total sky cover"
    annotation (Placement(transformation(extent={{-30,-40},{-10,-20}})));
  BaseClasses.CheckSkyCover cheOpaSkyCov "Check opaque sky cover"
    annotation (Placement(transformation(extent={{30,-60},{50,-40}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.ConvertRadiation
    cheGloHorRad "Check global horizontal radiation"
    annotation (Placement(transformation(extent={{-30,-80},{-10,-60}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.ConvertRadiation
    cheDifHorRad "Check diffuse horizontal radiation"
    annotation (Placement(transformation(extent={{30,-100},{50,-80}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.ConvertRadiation
    cheDirNorRad "Check direct normal radiation"
    annotation (Placement(transformation(extent={{-30,20},{-10,40}})));
  BaseClasses.CheckCeilingHeight cheCeiHei
    annotation (Placement(transformation(extent={{-30,-120},{-10,-100}})));
public
  BaseClasses.CheckWindSpeed cheWinSpe
    annotation (Placement(transformation(extent={{30,-140},{50,-120}})));
  BaseClasses.ConvertRadiation cheRadHor "check horizontal radiation"
    annotation (Placement(transformation(extent={{30,120},{50,140}})));
  BaseClasses.CheckWindDirection cheWinDir
    annotation (Placement(transformation(extent={{-30,140},{-10,160}})));
  SkyTemperature.BlackBody TBlaSky
    annotation (Placement(transformation(extent={{140,60},{160,80}})));
  Utilities.SimulationTime simTim
    annotation (Placement(transformation(extent={{-180,-10},{-160,10}})));
equation
  connect(timCon.calTim, datRea.u) annotation (Line(
      points={{-99,-30},{-90,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[1], conTemDryBul.TemC) annotation (Line(
      points={{-67,-30},{-52,-30},{-52,110},{-32,110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[2], conTemDewPoi.TemC) annotation (Line(
      points={{-67,-30},{-52,-30},{-52,90},{28,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conTemDryBul.TemK, weaBus.TDryBul) annotation (Line(
      points={{-9,110},{110,110},{110,5.55112e-16},{200,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(conTemDewPoi.TemK, weaBus.TDewPoi) annotation (Line(
      points={{51,90},{110,90},{110,5.55112e-16},{200,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(datRea.y[3], conHum.relHumIn) annotation (Line(
      points={{-67,-30},{-52,-30},{-52,70},{-32,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conHum.relHumOut, weaBus.relHum) annotation (Line(
      points={{-9,70},{110,70},{110,5.55112e-16},{200,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(datRea.y[4], chePre.PIn) annotation (Line(
      points={{-67,-30},{-52,-30},{-52,50},{28,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(chePre.POut, weaBus.pAtm) annotation (Line(
      points={{51,50},{110,50},{110,5.55112e-16},{200,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(datRea.y[17], cheTotSkyCov.nIn) annotation (Line(
      points={{-67,-30},{-32,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cheTotSkyCov.nOut, weaBus.nTot) annotation (Line(
      points={{-9,-30},{110,-30},{110,5.55112e-16},{200,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(datRea.y[18], cheOpaSkyCov.nIn) annotation (Line(
      points={{-67,-30},{-52,-30},{-52,-50},{28,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cheOpaSkyCov.nOut, weaBus.nOpa) annotation (Line(
      points={{51,-50},{110,-50},{110,5.55112e-16},{200,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(datRea.y[8], cheGloHorRad.HIn) annotation (Line(
      points={{-67,-30},{-52,-30},{-52,-70},{-32,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cheGloHorRad.HOut, weaBus.HGloHor) annotation (Line(
      points={{-9,-70},{110,-70},{110,5.55112e-16},{200,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(datRea.y[10], cheDifHorRad.HIn) annotation (Line(
      points={{-67,-30},{-52,-30},{-52,-90},{28,-90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cheDifHorRad.HOut, weaBus.HDifHor) annotation (Line(
      points={{51,-90},{110,-90},{110,5.55112e-16},{200,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(datRea.y[9], cheDirNorRad.HIn) annotation (Line(
      points={{-67,-30},{-52,-30},{-52,30},{-32,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cheDirNorRad.HOut, weaBus.HDirNor) annotation (Line(
      points={{-9,30},{110,30},{110,5.55112e-16},{200,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(datRea.y[20], cheCeiHei.ceiHeiIn) annotation (Line(
      points={{-67,-30},{-52,-30},{-52,-110},{-32,-110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cheCeiHei.ceiHeiOut, weaBus.celHei) annotation (Line(
      points={{-9,-110},{110,-110},{110,5.55112e-16},{200,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(datRea.y[16], cheWinSpe.winSpeIn) annotation (Line(
      points={{-67,-30},{-52,-30},{-52,-130},{28,-130}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cheWinSpe.winSpeOut, weaBus.winSpe) annotation (Line(
      points={{51,-130},{110,-130},{110,5.55112e-16},{200,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(datRea.y[7], cheRadHor.HIn) annotation (Line(
      points={{-67,-30},{-52,-30},{-52,130},{28,130}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cheRadHor.HOut, weaBus.radHor) annotation (Line(
      points={{51,130},{110,130},{110,5.55112e-16},{200,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(datRea.y[15], cheWinDir.nIn) annotation (Line(
      points={{-67,-30},{-52,-30},{-52,150},{-32,150}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cheWinDir.nOut, weaBus.winDir) annotation (Line(
      points={{-9,150},{110,150},{110,5.55112e-16},{200,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(conTemDryBul.TemK, TBlaSky.TDryBul) annotation (Line(
      points={{-9,110},{128,110},{128,78},{138,78}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conTemDewPoi.TemK, TBlaSky.TDewPoi) annotation (Line(
      points={{51,90},{116,90},{116,73},{138,73}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cheOpaSkyCov.nOut, TBlaSky.nOpa) annotation (Line(
      points={{51,-50},{120,-50},{120,67},{138,67}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cheRadHor.HOut, TBlaSky.radHor) annotation (Line(
      points={{51,130},{124,130},{124,62},{138,62}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TBlaSky.TBlaSky, weaBus.TBlaSky) annotation (Line(
      points={{161,70},{180,70},{180,5.55112e-16},{200,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(simTim.y, weaBus.cloTim) annotation (Line(
      points={{-159,6.10623e-16},{-150,6.10623e-16},{-150,0},{-144,0},{-144,
          5.55112e-16},{200,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(simTim.y, timCon.simTim) annotation (Line(
      points={{-159,6.10623e-16},{-150,6.10623e-16},{-150,-30},{-122,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    defaultComponentName="weaDat",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-200,-200},{200,
            200}}), graphics={
        Rectangle(
          extent={{-200,-202},{200,200}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-162,270},{138,230}},
          textString="%name",
          lineColor={0,0,255}),
        Ellipse(
          extent={{-64,72},{80,-66}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          lineThickness=1),
        Line(
          points={{6,116},{6,78}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{10,-78},{10,-116}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{0,19},{0,-19}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1,
          origin={110,1},
          rotation=90),
        Line(
          points={{0,19},{0,-19}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1,
          origin={-96,-1},
          rotation=90),
        Line(
          points={{25,10},{0,-19}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1,
          origin={-76,55},
          rotation=90),
        Line(
          points={{25,10},{0,-19}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1,
          origin={80,-83},
          rotation=90),
        Line(
          points={{102,82},{72,56}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{-58,-62},{-88,-88}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1)}),
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
    Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-200,-200},{200,
            200}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-200,-200},{200,
            200}}), graphics={Ellipse(
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
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{200,
            200}}), graphics={Ellipse(
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
end Reader;
