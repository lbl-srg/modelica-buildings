within Buildings.BoundaryConditions.WeatherData;
block ReaderTMY3 "Reader for TMY3 weather data "
  import Buildings.BoundaryConditions.Types.DataSource;
  parameter Buildings.BoundaryConditions.Types.DataSource pAtmSou=Buildings.BoundaryConditions.Types.DataSource.Parameter
    "Atmosheric pressure"
    annotation (Evaluate=true, Dialog(group="Data source"));
  parameter Modelica.SIunits.Pressure pAtm = 101325
    "Atmospheric pressure (used if pAtmSou=Parameter)"
      annotation (Evaluate=true, Dialog(group="Data source"));

  parameter String filNam "Name of weather data file" annotation (Dialog(
        __Dymola_loadSelector(filter="Weather files (*.mos)", caption=
            "Select weather file")));
  final parameter Modelica.SIunits.Angle lon(displayUnit="deg")=
    Buildings.BoundaryConditions.WeatherData.BaseClasses.getLongitudeTMY3(filNam)
    "Longitude";
  final parameter Modelica.SIunits.Time timZon(displayUnit="h")=
    Buildings.BoundaryConditions.WeatherData.BaseClasses.getTimeZoneTMY3(filNam)
    "Time zone";
  Bus weaBus "Weather Data Bus" annotation (Placement(transformation(extent={{
            190,-10},{210,10}}), iconTransformation(extent={{190,-10},{210,10}})));

  Modelica.Blocks.Interfaces.RealInput pAtm_in if
         (pAtmSou == Buildings.BoundaryConditions.Types.DataSource.Input)
    "Input pressure"
    annotation (Placement(transformation(extent={{-240,160},{-200,200}})));
protected
  Modelica.Blocks.Tables.CombiTable1Ds datRea(
    final tableOnFile=true,
    final tableName="tab1",
    final fileName=filNam,
    final smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    final columns={2,3,4,5,6,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,
        30}) "Data reader"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.ConvertTemperature
    conTemDryBul "Converts unit for dry bulb temperature "
    annotation (Placement(transformation(extent={{0,100},{20,120}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.ConvertTemperature
    conTemDewPoi "Converts unit for dew point temperature"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.ConvertRelativeHumidity
    conHum
    "Converts the relative humidity from percentage to [0, 1] and constrains it to [0, 1]"
     annotation (Placement(transformation(extent={{0,60},{20,80}})));
  BaseClasses.CheckPressure chePre "Checks the air pressure"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  BaseClasses.CheckSkyCover cheTotSkyCov "Checks the total sky cover"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  BaseClasses.CheckSkyCover cheOpaSkyCov "Checks the opaque sky cover"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.ConvertRadiation
    cheGloHorRad "Checks the global horizontal radiation"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.ConvertRadiation
    cheDifHorRad "Checks the diffuse horizontal radiation"
    annotation (Placement(transformation(extent={{60,-100},{80,-80}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.ConvertRadiation
    cheDirNorRad "Checks the direct normal radiation"
    annotation (Placement(transformation(extent={{30,20},{50,40}})));
  BaseClasses.CheckCeilingHeight cheCeiHei "Checks the ceiling height"
    annotation (Placement(transformation(extent={{0,-120},{20,-100}})));
  BaseClasses.CheckWindSpeed cheWinSpe "Checks the wind speed"
    annotation (Placement(transformation(extent={{60,-140},{80,-120}})));
  BaseClasses.ConvertRadiation cheRadHor "Checks the horizontal radiation"
    annotation (Placement(transformation(extent={{60,120},{80,140}})));
  BaseClasses.CheckWindDirection cheWinDir "Checks the wind direction"
    annotation (Placement(transformation(extent={{0,140},{20,160}})));
  SkyTemperature.BlackBody TBlaSky(calTSky=0)
    "Checks the sky black-body temperature"
    annotation (Placement(transformation(extent={{140,50},{160,70}})));
  Utilities.SimulationTime simTim "Simulation time"
    annotation (Placement(transformation(extent={{-180,-10},{-160,10}})));
  Modelica.Blocks.Math.Add add
    "Adds 30 minutes to time to shift weather data reader"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));
  Modelica.Blocks.Sources.Constant con30mins(k=1800)
    "Constant used to shift weather data reader"
    annotation (Placement(transformation(extent={{-180,60},{-160,80}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.LocalCivilTime locTim(
      lon=lon, timZon=timZon) "Local civil time"
    annotation (Placement(transformation(extent={{-120,-160},{-100,-140}})));

  Modelica.Blocks.Tables.CombiTable1Ds datRea1(
    final tableOnFile=true,
    final tableName="tab1",
    final fileName=filNam,
    final smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    final columns=8:11) "Data reader"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  Buildings.BoundaryConditions.WeatherData.BaseClasses.ConvertTime conTim1
    "Converts simulation time to calendar time"
    annotation (Placement(transformation(extent={{-110,20},{-90,40}})));
  BaseClasses.ConvertTime conTim "Converts simulation time to calendar time"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));
  BaseClasses.EquationOfTime eqnTim "Equation of time"
    annotation (Placement(transformation(extent={{-120,-120},{-100,-100}})));
  BaseClasses.SolarTime solTim "Solar time"
    annotation (Placement(transformation(extent={{-80,-140},{-60,-120}})));
  // Conditional connectors

  Modelica.Blocks.Interfaces.RealInput pAtm_in_internal
    "Needed to connect to conditional connector";
equation

  if pAtmSou == Buildings.BoundaryConditions.Types.DataSource.Parameter then
    pAtm_in_internal = pAtm;
  elseif pAtmSou == Buildings.BoundaryConditions.Types.DataSource.File then
    connect(pAtm_in_internal, datRea.y[4]);
  else
    connect(pAtm_in, pAtm_in_internal);
  end if;
  connect(pAtm_in_internal, chePre.PIn);

  connect(conTemDryBul.TemK, weaBus.TDryBul) annotation (Line(
      points={{21,110},{116,110},{116,5.55112e-16},{200,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(conTemDewPoi.TemK, weaBus.TDewPoi) annotation (Line(
      points={{81,90},{116,90},{116,5.55112e-16},{200,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(conHum.relHumOut, weaBus.relHum) annotation (Line(
      points={{21,70},{116,70},{116,5.55112e-16},{200,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(chePre.POut, weaBus.pAtm) annotation (Line(
      points={{81,50},{116,50},{116,5.55112e-16},{200,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheTotSkyCov.nOut, weaBus.nTot) annotation (Line(
      points={{21,-30},{116,-30},{116,5.55112e-16},{200,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheOpaSkyCov.nOut, weaBus.nOpa) annotation (Line(
      points={{81,-50},{116,-50},{116,5.55112e-16},{200,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheGloHorRad.HOut, weaBus.HGloHor) annotation (Line(
      points={{21,-70},{116,-70},{116,5.55112e-16},{200,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheDifHorRad.HOut, weaBus.HDifHor) annotation (Line(
      points={{81,-90},{116,-90},{116,5.55112e-16},{200,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheDirNorRad.HOut, weaBus.HDirNor) annotation (Line(
      points={{51,30},{116,30},{116,5.55112e-16},{200,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheCeiHei.ceiHeiOut, weaBus.celHei) annotation (Line(
      points={{21,-110},{116,-110},{116,5.55112e-16},{200,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheWinSpe.winSpeOut, weaBus.winSpe) annotation (Line(
      points={{81,-130},{116,-130},{116,5.55112e-16},{200,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheRadHor.HOut, weaBus.radHor) annotation (Line(
      points={{81,130},{116,130},{116,5.55112e-16},{200,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheWinDir.nOut, weaBus.winDir) annotation (Line(
      points={{21,150},{116,150},{116,5.55112e-16},{200,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(conTemDryBul.TemK, TBlaSky.TDryBul) annotation (Line(
      points={{21,110},{116,110},{116,68},{138,68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conTemDewPoi.TemK, TBlaSky.TDewPoi) annotation (Line(
      points={{81,90},{116,90},{116,63},{138,63}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cheOpaSkyCov.nOut, TBlaSky.nOpa) annotation (Line(
      points={{81,-50},{116,-50},{116,56},{138,56},{138,57}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cheRadHor.HOut, TBlaSky.radHor) annotation (Line(
      points={{81,130},{116,130},{116,52},{138,52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TBlaSky.TBlaSky, weaBus.TBlaSky) annotation (Line(
      points={{161,60},{180,60},{180,5.55112e-16},{200,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(simTim.y, weaBus.cloTim) annotation (Line(
      points={{-159,6.10623e-16},{-69.25,6.10623e-16},{-69.25,1.16573e-15},{
          20.5,1.16573e-15},{20.5,5.55112e-16},{200,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(simTim.y, add.u2) annotation (Line(
      points={{-159,6.10623e-16},{-150,6.10623e-16},{-150,24},{-142,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(con30mins.y, add.u1) annotation (Line(
      points={{-159,70},{-150,70},{-150,36},{-142,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea1.y[1], cheRadHor.HIn) annotation (Line(
      points={{-59,30},{-28,30},{-28,130},{58,130}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea1.y[3], cheDirNorRad.HIn) annotation (Line(
      points={{-59,30},{28,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea1.y[2], cheGloHorRad.HIn) annotation (Line(
      points={{-59,30},{-28,30},{-28,-70},{-2,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea1.y[4], cheDifHorRad.HIn) annotation (Line(
      points={{-59,30},{-28,30},{-28,-90},{58,-90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y,conTim1. simTim) annotation (Line(
      points={{-119,30},{-112,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conTim1.calTim, datRea1.u) annotation (Line(
      points={{-89,30},{-82,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(simTim.y, locTim.cloTim) annotation (Line(
      points={{-159,6.10623e-16},{-150,6.10623e-16},{-150,-150},{-122,-150}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(simTim.y, conTim.simTim) annotation (Line(
      points={{-159,6.10623e-16},{-150,6.10623e-16},{-150,-30},{-122,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conTim.calTim, datRea.u) annotation (Line(
      points={{-99,-30},{-82,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(simTim.y, eqnTim.nDay) annotation (Line(
      points={{-159,6.10623e-16},{-150,6.10623e-16},{-150,-110},{-122,-110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(eqnTim.eqnTim, solTim.equTim) annotation (Line(
      points={{-99,-110},{-88,-110},{-88,-124},{-82,-124}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(locTim.locTim, solTim.locTim) annotation (Line(
      points={{-99,-150},{-88,-150},{-88,-135.4},{-82,-135.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solTim.solTim, weaBus.solTim) annotation (Line(
      points={{-59,-130},{-48,-130},{-48,-152},{180,-152},{180,5.55112e-16},{
          200,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(datRea.y[11], cheWinDir.nIn) annotation (Line(
      points={{-59,-30},{-12,-30},{-12,150},{-2,150}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[1], conTemDryBul.TemC) annotation (Line(
      points={{-59,-30},{-12,-30},{-12,110},{-2,110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[2], conTemDewPoi.TemC) annotation (Line(
      points={{-59,-30},{-12,-30},{-12,90},{58,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[3], conHum.relHumIn) annotation (Line(
      points={{-59,-30},{-12,-30},{-12,70},{-2,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[13], cheTotSkyCov.nIn) annotation (Line(
      points={{-59,-30},{-2,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[14], cheOpaSkyCov.nIn) annotation (Line(
      points={{-59,-30},{-12,-30},{-12,-50},{58,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[12], cheWinSpe.winSpeIn) annotation (Line(
      points={{-59,-30},{-12,-30},{-12,-130},{58,-130}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[16], cheCeiHei.ceiHeiIn) annotation (Line(
      points={{-59,-30},{-12,-30},{-12,-110},{-2,-110}},
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
    Documentation(info="<html>
<p>
This component reads TMY3 weather data (Wilcox and Marion, 2008). 
The parameter 
<code>lon</code> is the longitude of the weather station, and 
the parameter <code>timZone</code> is the time zone
relative to Greenwich Mean Time. 
By default, the reader obtains values for these parameters 
by scanning the TMY3 weather data file.
</p>
<p>
By default, the atmospheric pressure is set to the parameter <code>pAtm = 101325</code> Pascals.
The parameter <code>pAtmSou</code> can be used to change the source that is used as the atmospheric pressure.
The available options are to use the atmospheric pressure from the parameter (default), from the weather file, or 
from an input connector. The input connector will be enabled if 
<code>pAtmSou = Buildings.BoundaryConditions.Types.DataSource.Input</code>.
</p>
<p>
<b>Note:</b> In HVAC systems, when the fan is off, changes in atmospheric pressure can cause small air flow rates
in the duct system due to change in pressure and hence in the mass of air that is stored
in air volumes (such as in fluid junctions or in the room model). 
This may increase computing time. Therefore, the default value for the atmospheric pressure
is set to a constant.
Furthermore, if the initial pressure of air volumes are different
from the atmospheric pressure, then fast pressure transients can happen in the first few seconds of the simulation.
This can cause numerical problems for the solver. To avoid this problem, set the atmospheric pressure to the
same value as the medium default pressure, which is typically set to the parameter <code>Medium.p_default</code>.
</p>
<h4>Implementation</h4>
<p>
To read weather data from the TMY3 weather data file, there are
two data readers in this model. One data reader obtains all data
except solar radiation, and the other data reader reads only the
solar radiation data, shifted by <i>30</i> minutes.
The reason for this time shift is as follows:
The TMY3 weather data file contains for solar radiation the 
\"...radiation received
on a horizontal surface during
the 60-minute period ending at
the timestamp.\"

Thus, as the figure below shows, a more accurate interpolation is obtained if 
time is shifted by <i>30</i> minutes prior to reading the weather data.   
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/BoundaryConditions/WeatherData/RadiationTimeShift.png\" border=\"1\">
</p>
<h4>References</h4>
<p>
<ul>
<li>
Wilcox S. and W. Marion. <i>Users Manual for TMY3 Data Sets</i>. 
Technical Report, NREL/TP-581-43156, revised May 2008.
</li>
</ul>
</p>
</html>
", revisions="<html>
<ul>
<li>
July 20, 2011, by Michael Wetter:<br>
Added the option to use a constant, an input signal or the weather file as the source
for the atmospheric pressure.
</li><li>
March 15, 2011, by Wangda Zuo:<br>
Delete the wet bulb temperature since it may cause numerical problem.
</li>
<li>
March 7, 2011, by Wangda Zuo:<br>
Added wet bulb temperature. Changed reader to read only needed columns. 
Added explanation for 30 minutes shift for radiation data.  
</li>
<li>
March 5, 2011, by Michael Wetter:<br>
Changed implementation to obtain longitude and time zone directly
from weather file.
</li>
<li>
June 25, 2010, by Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-200,-200},{200,200}}),
                    graphics),
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
    Documentation(info="<html>
<p>
This component reads the weather data.
</p>
</html>
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
end ReaderTMY3;
