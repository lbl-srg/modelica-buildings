within Districts.BoundaryConditions.WeatherData;
block ReaderTMY3 "Reader for TMY3 weather data"

  parameter Boolean computeWetBulbTemperature = true
    "If true, then this model computes the wet bulb temperature"
    annotation(Evaluate=true);
  //--------------------------------------------------------------
  // Atmospheric pressure
  parameter Districts.BoundaryConditions.Types.DataSource pAtmSou=Types.DataSource.Parameter
    "Atmospheric pressure"
    annotation (Evaluate=true, Dialog(group="Data source"));
  parameter Modelica.SIunits.Pressure pAtm=101325
    "Atmospheric pressure (used if pAtmSou=Parameter)"
    annotation (Evaluate=true, Dialog(group="Data source"));
  Modelica.Blocks.Interfaces.RealInput pAtm_in(
    final quantity="Pressure",
    final unit="Pa",
    displayUnit="Pa") if (pAtmSou == Districts.BoundaryConditions.Types.DataSource.Input)
    "Input pressure"
    annotation (Placement(transformation(extent={{-240,180},{-200,220}}),
        iconTransformation(extent={{-240,180},{-200,220}})));
  //--------------------------------------------------------------
  // Dry bulb temperature
  parameter Districts.BoundaryConditions.Types.DataSource TDryBulSou=Types.DataSource.File
    "Dry bulb temperature"
    annotation (Evaluate=true, Dialog(group="Data source"));
  parameter Modelica.SIunits.Temperature TDryBul(displayUnit="degC") = 293.15
    "Dry bulb temperature (used if TDryBul=Parameter)"
    annotation (Evaluate=true, Dialog(group="Data source"));
  Modelica.Blocks.Interfaces.RealInput TDryBul_in(
    final quantity="Temperature",
    final unit="K",
    displayUnit="degC") if (TDryBulSou == Districts.BoundaryConditions.Types.DataSource.Input)
    "Input dry bulb temperature"
    annotation (Placement(transformation(extent={{-240,120},{-200,160}})));
  //--------------------------------------------------------------
  // Relative humidity
  parameter Districts.BoundaryConditions.Types.DataSource relHumSou=Types.DataSource.File
    "Relative humidity" annotation (Evaluate=true, Dialog(group="Data source"));
  parameter Real relHum(
    min=0,
    max=1,
    unit="1") = 0.5 "Relative humidity (used if relHum=Parameter)"
    annotation (Evaluate=true, Dialog(group="Data source"));
  Modelica.Blocks.Interfaces.RealInput relHum_in(
    min=0,
    max=1,
    unit="1") if (relHumSou == Districts.BoundaryConditions.Types.DataSource.Input)
    "Input relative humidity"
    annotation (Placement(transformation(extent={{-240,60},{-200,100}}),
        iconTransformation(extent={{-240,60},{-200,100}})));
  //--------------------------------------------------------------
  // Wind speed
  parameter Districts.BoundaryConditions.Types.DataSource winSpeSou=Types.DataSource.File
    "Wind speed" annotation (Evaluate=true, Dialog(group="Data source"));
  parameter Modelica.SIunits.Velocity winSpe(min=0) = 1
    "Wind speed (used if winSpe=Parameter)"
    annotation (Evaluate=true, Dialog(group="Data source"));
  Modelica.Blocks.Interfaces.RealInput winSpe_in(
    final quantity="Velocity",
    final unit="m/s",
    min=0) if (winSpeSou == Districts.BoundaryConditions.Types.DataSource.Input)
    "Input wind speed"
    annotation (Placement(transformation(extent={{-240,0},{-200,40}}),
        iconTransformation(extent={{-240,0},{-200,40}})));
  //--------------------------------------------------------------
  // Wind direction
  parameter Districts.BoundaryConditions.Types.DataSource winDirSou=Types.DataSource.File
    "Wind direction" annotation (Evaluate=true, Dialog(group="Data source"));
  parameter Modelica.SIunits.Angle winDir=1.0
    "Wind direction (used if winDir=Parameter)"
    annotation (Evaluate=true, Dialog(group="Data source"));
  Modelica.Blocks.Interfaces.RealInput winDir_in(
    final quantity="Angle",
    final unit="rad",
    displayUnit="deg") if (winDirSou == Districts.BoundaryConditions.Types.DataSource.Input)
    "Input wind direction"
    annotation (Placement(transformation(extent={{-240,-60},{-200,-20}}),
        iconTransformation(extent={{-240,-60},{-200,-20}})));

     parameter Districts.BoundaryConditions.Types.RadiationDataSource HSou=Types.RadiationDataSource.File
    "Radiation"
     annotation (Evaluate=true, Dialog(group="Data source"));

  //--------------------------------------------------------------
  // Global horizontal radiation
  Modelica.Blocks.Interfaces.RealInput HGloHor_in(
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2") if (HSou == Districts.BoundaryConditions.Types.RadiationDataSource.Input_HGloHor_HDifHor
     or HSou == Districts.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HGloHor)
    "Input global horizontal radiation"
    annotation (Placement(transformation(extent={{-240,-120},{-200,-80}}),
        iconTransformation(extent={{-240,-120},{-200,-80}})));
  //--------------------------------------------------------------
  // Diffuse horizontal radiation
  Modelica.Blocks.Interfaces.RealInput HDifHor_in(
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2") if (HSou == Districts.BoundaryConditions.Types.RadiationDataSource.Input_HGloHor_HDifHor
     or HSou == Districts.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HDifHor)
    "Input diffuse horizontal radiation"
    annotation (Placement(transformation(extent={{-240,-180},{-200,-140}}),
        iconTransformation(extent={{-240,-172},{-200,-132}})));
  //--------------------------------------------------------------
  // Direct normal radiation
  Modelica.Blocks.Interfaces.RealInput HDirNor_in(final quantity="RadiantEnergyFluenceRate",
      final unit="W/m2") if (HSou == Districts.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HDifHor
     or HSou == Districts.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HGloHor)
    "Input direct normal radiation"
    annotation (Placement(transformation(extent={{-240,-240},{-200,-200}}),
        iconTransformation(extent={{-240,-220},{-200,-180}})));

  parameter String filNam "Name of weather data file" annotation (Dialog(
        __Dymola_loadSelector(filter="Weather files (*.mos)", caption=
            "Select weather file")));
  final parameter Modelica.SIunits.Angle lon(displayUnit="deg")=
    BaseClasses.getLongitudeTMY3(
    filNam) "Longitude";
  final parameter Modelica.SIunits.Angle lat(displayUnit="deg")=
    BaseClasses.getLatitudeTMY3(
    filNam) "Latitude";
  final parameter Modelica.SIunits.Time timZon(displayUnit="h")=
    BaseClasses.getTimeZoneTMY3(                                         filNam)
    "Time zone";
  Bus weaBus "Weather Data Bus" annotation (Placement(transformation(extent={{
            294,-10},{314,10}}), iconTransformation(extent={{190,-10},{210,10}})));
  BaseClasses.SolarSubBus solBus "Sub bus with solar position"
    annotation (Placement(transformation(visible=false,
                                         extent={{-2,-304},{18,-284}}),
        iconTransformation(extent={{-2,-200},{18,-180}})));

  parameter Districts.BoundaryConditions.Types.SkyTemperatureCalculation calTSky=Types.SkyTemperatureCalculation.TemperaturesAndSkyCover
    "Computation of black-body sky temperature" annotation (
    choicesAllMatching=true,
    Evaluate=true,
    Dialog(group="Sky temperature"));

  constant Real epsCos = 1e-6 "Small value to avoid division by 0";

protected
  Modelica.Blocks.Tables.CombiTable1Ds datRea(
    final tableOnFile=true,
    final tableName="tab1",
    final fileName=filNam,
    final smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    final columns={2,3,4,5,6,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,
        28,29,30}) "Data reader"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Districts.BoundaryConditions.WeatherData.BaseClasses.CheckTemperature cheTemDryBul
    "Check dry bulb temperature "
    annotation (Placement(transformation(extent={{160,-200},{180,-180}})));
  Districts.BoundaryConditions.WeatherData.BaseClasses.CheckTemperature cheTemDewPoi
    "Check dew point temperature"
    annotation (Placement(transformation(extent={{160,-240},{180,-220}})));
  Districts.BoundaryConditions.WeatherData.BaseClasses.ConvertRelativeHumidity conRelHum
    "Convert the relative humidity from percentage to [0, 1] "
    annotation (Placement(transformation(extent={{120,20},{140,40}})));
  BaseClasses.CheckPressure chePre "Check the air pressure"
    annotation (Placement(transformation(extent={{160,60},{180,80}})));
  BaseClasses.CheckSkyCover cheTotSkyCov "Check the total sky cover"
    annotation (Placement(transformation(extent={{160,-40},{180,-20}})));
  BaseClasses.CheckSkyCover cheOpaSkyCov "Check the opaque sky cover"
    annotation (Placement(transformation(extent={{160,-160},{180,-140}})));
  BaseClasses.CheckRadiation cheGloHorRad
    "Check the global horizontal radiation"
    annotation (Placement(transformation(extent={{160,160},{180,180}})));
  BaseClasses.CheckRadiation cheDifHorRad
    "Check the diffuse horizontal radiation"
    annotation (Placement(transformation(extent={{160,120},{180,140}})));
  BaseClasses.CheckRadiation cheDirNorRad "Check the direct normal radiation"
    annotation (Placement(transformation(extent={{160,200},{180,220}})));
  BaseClasses.CheckCeilingHeight cheCeiHei "Check the ceiling height"
    annotation (Placement(transformation(extent={{160,-120},{180,-100}})));
  BaseClasses.CheckWindSpeed cheWinSpe "Check the wind speed"
    annotation (Placement(transformation(extent={{160,-80},{180,-60}})));
  BaseClasses.CheckRadiation cheHorRad "Check the horizontal radiation"
    annotation (Placement(transformation(extent={{160,240},{180,260}})));
  BaseClasses.CheckWindDirection cheWinDir "Check the wind direction"
    annotation (Placement(transformation(extent={{160,-280},{180,-260}})));
  SkyTemperature.BlackBody TBlaSky(final calTSky=calTSky)
    "Check the sky black-body temperature"
    annotation (Placement(transformation(extent={{240,-220},{260,-200}})));
  Districts.Utilities.SimulationTime simTim "Simulation time"
    annotation (Placement(transformation(extent={{-180,-10},{-160,10}})));
  Modelica.Blocks.Math.Add add
    "Add 30 minutes to time to shift weather data reader"
    annotation (Placement(transformation(extent={{-140,160},{-120,180}})));
  Modelica.Blocks.Sources.Constant con30mins(final k=1800)
    "Constant used to shift weather data reader"
    annotation (Placement(transformation(extent={{-180,192},{-160,212}})));
  Districts.BoundaryConditions.WeatherData.BaseClasses.LocalCivilTime locTim(final lon=
       lon, final timZon=timZon) "Local civil time"
    annotation (Placement(transformation(extent={{-120,-160},{-100,-140}})));
  Modelica.Blocks.Tables.CombiTable1Ds datRea1(
    final tableOnFile=true,
    final tableName="tab1",
    final fileName=filNam,
    final smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    final columns=8:11) "Data reader"
    annotation (Placement(transformation(extent={{-80,160},{-60,180}})));
  Districts.BoundaryConditions.WeatherData.BaseClasses.ConvertTime conTim1
    "Convert simulation time to calendar time"
    annotation (Placement(transformation(extent={{-110,160},{-90,180}})));
  BaseClasses.ConvertTime conTim "Convert simulation time to calendar time"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));
  BaseClasses.EquationOfTime eqnTim "Equation of time"
    annotation (Placement(transformation(extent={{-120,-120},{-100,-100}})));
  BaseClasses.SolarTime solTim "Solar time"
    annotation (Placement(transformation(extent={{-80,-140},{-60,-120}})));
  // Conditional connectors
  Modelica.Blocks.Interfaces.RealInput pAtm_in_internal(
    final quantity="Pressure",
    final unit="Pa",
    displayUnit="bar") "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput TDryBul_in_internal(
    final quantity="Temperature",
    final unit="K",
    displayUnit="degC") "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput relHum_in_internal(
    final quantity="1",
    min=0,
    max=1) "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput winSpe_in_internal(
    final quantity="Velocity",
    final unit="m/s") "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput winDir_in_internal(
    final quantity="Angle",
    final unit="rad",
    displayUnit="deg") "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput HGloHor_in_internal(
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2") "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput HDifHor_in_internal(
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2") "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput HDirNor_in_internal(
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2") "Needed to connect to conditional connector";

  Modelica.Blocks.Math.UnitConversions.From_deg conWinDir
    "Convert the wind direction unit from [deg] to [rad]"
    annotation (Placement(transformation(extent={{120,-280},{140,-260}})));
  Modelica.Blocks.Math.UnitConversions.From_degC conTDryBul
    annotation (Placement(transformation(extent={{120,-200},{140,-180}})));
  BaseClasses.ConvertRadiation conHorRad
    annotation (Placement(transformation(extent={{120,240},{140,260}})));
  Modelica.Blocks.Math.UnitConversions.From_degC conTDewPoi
    "Convert the dew point temperature form [degC] to [K]"
    annotation (Placement(transformation(extent={{120,-240},{140,-220}})));
  BaseClasses.ConvertRadiation conDirNorRad
    annotation (Placement(transformation(extent={{120,200},{140,220}})));
  BaseClasses.ConvertRadiation conGloHorRad
    annotation (Placement(transformation(extent={{120,160},{140,180}})));
  BaseClasses.ConvertRadiation conDifHorRad
    annotation (Placement(transformation(extent={{120,120},{140,140}})));
  BaseClasses.CheckRelativeHumidity cheRelHum
    annotation (Placement(transformation(extent={{160,20},{180,40}})));
  SolarGeometry.BaseClasses.AltitudeAngle altAng "Solar altitude angle"
    annotation (Placement(transformation(extent={{-30,-280},{-10,-260}})));
   SolarGeometry.BaseClasses.ZenithAngle zenAng(
     final lat = lat) "Zenith angle"
    annotation (Placement(transformation(extent={{-80,-226},{-60,-206}})));
   SolarGeometry.BaseClasses.Declination decAng "Declination angle"
    annotation (Placement(transformation(extent={{-140,-220},{-120,-200}})));
   SolarGeometry.BaseClasses.SolarHourAngle
    solHouAng
    annotation (Placement(transformation(extent={{-140,-250},{-120,-230}})));
  Modelica.Blocks.Sources.Constant latitude(final k=lat) "Latitude"
    annotation (Placement(transformation(extent={{-180,-280},{-160,-260}})));
  Modelica.Blocks.Sources.Constant longitude(final k=lon) "Longitude"
    annotation (Placement(transformation(extent={{-140,-280},{-120,-260}})));

  //---------------------------------------------------------------------------
  // Optional instanciation of a block that computes the wet bulb temperature.
  // This block may be needed for evaporative cooling towers.
  // By default, it is enabled. This introduces a nonlinear equation, but
  // we have not observed an increase in computing time because of this equation.

equation
  //---------------------------------------------------------------------------
  // Select atmospheric pressure connector
  if pAtmSou == Districts.BoundaryConditions.Types.DataSource.Parameter then
    pAtm_in_internal = pAtm;
  elseif pAtmSou == Districts.BoundaryConditions.Types.DataSource.File then
    connect(datRea.y[4], pAtm_in_internal);
  else
    connect(pAtm_in, pAtm_in_internal);
  end if;
  connect(pAtm_in_internal, chePre.PIn);
  //---------------------------------------------------------------------------
  // Select dry bulb temperature connector
  if TDryBulSou == Districts.BoundaryConditions.Types.DataSource.Parameter then
    TDryBul_in_internal = TDryBul;
  elseif TDryBulSou == Districts.BoundaryConditions.Types.DataSource.Input then
    connect(TDryBul_in, TDryBul_in_internal);
  else
    connect(conTDryBul.y, TDryBul_in_internal);
  end if;
  connect(TDryBul_in_internal, cheTemDryBul.TIn);
  //---------------------------------------------------------------------------
  // Select relative humidity connector
  if relHumSou == Districts.BoundaryConditions.Types.DataSource.Parameter then
    relHum_in_internal = relHum;
  elseif relHumSou == Districts.BoundaryConditions.Types.DataSource.Input then
    connect(relHum_in, relHum_in_internal);
  else
    connect(conRelHum.relHumOut, relHum_in_internal);
  end if;
  connect(relHum_in_internal, cheRelHum.relHumIn);
  //---------------------------------------------------------------------------
  // Select wind speed connector
  if winSpeSou == Districts.BoundaryConditions.Types.DataSource.Parameter then
    winSpe_in_internal = winSpe;
  elseif winSpeSou == Districts.BoundaryConditions.Types.DataSource.Input then
    connect(winSpe_in, winSpe_in_internal);
  else
    connect(datRea.y[12], winSpe_in_internal);
  end if;
  connect(winSpe_in_internal, cheWinSpe.winSpeIn);
  //---------------------------------------------------------------------------
  // Select wind direction connector
  if winDirSou == Districts.BoundaryConditions.Types.DataSource.Parameter then
    winDir_in_internal = winDir;
  elseif winDirSou == Districts.BoundaryConditions.Types.DataSource.Input then
    connect(winDir_in, winDir_in_internal);
  else
    connect(conWinDir.y, winDir_in_internal);
  end if;
  connect(winDir_in_internal, cheWinDir.nIn);
  //---------------------------------------------------------------------------
  // Select global horizontal radiation connector
  if HSou == Districts.BoundaryConditions.Types.RadiationDataSource.Input_HGloHor_HDifHor
       or HSou == Districts.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HGloHor then
    connect(HGloHor_in, HGloHor_in_internal)
      "Get HGloHor using user input file";
  elseif HSou == Districts.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HDifHor then
     HDirNor_in_internal*cos(zenAng.zen)+HDifHor_in_internal = HGloHor_in_internal
      "Calculate the HGloHor using HDirNor and HDifHor according to (A.4.14) and (A.4.15)";
  else
    connect(conGloHorRad.HOut, HGloHor_in_internal)
      "Get HGloHor using weather data file";
  end if;
  connect(HGloHor_in_internal, cheGloHorRad.HIn);
  //---------------------------------------------------------------------------
  // Select diffuse horizontal radiation connector
  if HSou == Districts.BoundaryConditions.Types.RadiationDataSource.Input_HGloHor_HDifHor
       or HSou == Districts.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HDifHor then
     connect(HDifHor_in, HDifHor_in_internal)
      "Get HDifHor using user input file";
  elseif HSou == Districts.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HGloHor then
      HGloHor_in_internal - HDirNor_in_internal*cos(zenAng.zen) = HDifHor_in_internal
      "Calculate the HGloHor using HDirNor and HDifHor according to (A.4.14) and (A.4.15)";
  else
    connect(conDifHorRad.HOut, HDifHor_in_internal)
      "Get HDifHor using weather data file";
  end if;
  connect(HDifHor_in_internal, cheDifHorRad.HIn);
  //---------------------------------------------------------------------------
  // Select direct normal radiation connector
  if HSou == Districts.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HGloHor
       or HSou == Districts.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HDifHor then
     connect(HDirNor_in, HDirNor_in_internal)
      "Get HDirNor using user input file";
  elseif HSou == Districts.BoundaryConditions.Types.RadiationDataSource.Input_HGloHor_HDifHor then
      (HGloHor_in_internal -HDifHor_in_internal)/Districts.Utilities.Math.Functions.smoothMax(x1=cos(zenAng.zen), x2=epsCos, deltaX=0.1*epsCos)
       = HDirNor_in_internal
      "Calculate the HDirNor using HGloHor and HDifHor according to (A.4.14) and (A.4.15)";
  else
    connect(conDirNorRad.HOut, HDirNor_in_internal)
      "Get HDirNor using weather data file";
  end if;
  connect(HDirNor_in_internal, cheDirNorRad.HIn);

  connect(chePre.POut, weaBus.pAtm) annotation (Line(
      points={{181,70},{220,70},{220,5.55112e-16},{304,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheTotSkyCov.nOut, weaBus.nTot) annotation (Line(
      points={{181,-30},{220,-30},{220,5.55112e-16},{304,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheOpaSkyCov.nOut, weaBus.nOpa) annotation (Line(
      points={{181,-150},{220,-150},{220,5.55112e-16},{304,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheGloHorRad.HOut, weaBus.HGloHor) annotation (Line(
      points={{181,170},{220,170},{220,5.55112e-16},{304,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheDifHorRad.HOut, weaBus.HDifHor) annotation (Line(
      points={{181,130},{220,130},{220,5.55112e-16},{304,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheDirNorRad.HOut, weaBus.HDirNor) annotation (Line(
      points={{181,210},{220,210},{220,5.55112e-16},{304,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheCeiHei.ceiHeiOut, weaBus.celHei) annotation (Line(
      points={{181,-110},{220,-110},{220,5.55112e-16},{304,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheWinSpe.winSpeOut, weaBus.winSpe) annotation (Line(
      points={{181,-70},{220,-70},{220,5.55112e-16},{304,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheHorRad.HOut, weaBus.radHorIR) annotation (Line(
      points={{181,250},{220,250},{220,5.55112e-16},{304,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheWinDir.nOut, weaBus.winDir) annotation (Line(
      points={{181,-270},{280,-270},{280,5.55112e-16},{304,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheOpaSkyCov.nOut, TBlaSky.nOpa) annotation (Line(
      points={{181,-150},{220,-150},{220,-213},{238,-213}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cheHorRad.HOut, TBlaSky.radHorIR) annotation (Line(
      points={{181,250},{220,250},{220,-218},{238,-218}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TBlaSky.TBlaSky, weaBus.TBlaSky) annotation (Line(
      points={{261,-210},{280,-210},{280,0},{292,0},{292,5.55112e-16},{304,
          5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(simTim.y, weaBus.cloTim) annotation (Line(
      points={{-159,6.10623e-16},{34.75,6.10623e-16},{34.75,0},{124.5,0},{124.5,
          5.55112e-16},{304,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(simTim.y, add.u2) annotation (Line(
      points={{-159,6.10623e-16},{-150,6.10623e-16},{-150,164},{-142,164}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(con30mins.y, add.u1) annotation (Line(
      points={{-159,202},{-150,202},{-150,176},{-142,176}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, conTim1.simTim) annotation (Line(
      points={{-119,170},{-112,170}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conTim1.calTim, datRea1.u) annotation (Line(
      points={{-89,170},{-82,170}},
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
      points={{-59,-130},{-20,-130},{-20,0},{284,0},{284,5.55112e-16},{304,
          5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(datRea.y[13], cheTotSkyCov.nIn) annotation (Line(
      points={{-59,-30},{158,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[14], cheOpaSkyCov.nIn) annotation (Line(
      points={{-59,-30},{20,-30},{20,-150},{158,-150}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[16], cheCeiHei.ceiHeiIn) annotation (Line(
      points={{-59,-30},{20,-30},{20,-110},{158,-110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[11], conWinDir.u) annotation (Line(
      points={{-59,-30},{20,-30},{20,-270},{118,-270}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea1.y[1], conHorRad.HIn) annotation (Line(
      points={{-59,170},{20,170},{20,250},{118,250}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conHorRad.HOut, cheHorRad.HIn) annotation (Line(
      points={{141,250},{158,250}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cheTemDryBul.TOut, TBlaSky.TDryBul) annotation (Line(
      points={{181,-190},{220,-190},{220,-202},{238,-202}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[1], conTDryBul.u) annotation (Line(
      points={{-59,-30},{20,-30},{20,-190},{118,-190}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[2], conTDewPoi.u) annotation (Line(
      points={{-59,-30},{20,-30},{20,-230},{118,-230}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conTDewPoi.y, cheTemDewPoi.TIn) annotation (Line(
      points={{141,-230},{158,-230}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cheTemDewPoi.TOut, weaBus.TDewPoi) annotation (Line(
      points={{181,-230},{280,-230},{280,5.55112e-16},{304,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(TBlaSky.TDewPoi, cheTemDewPoi.TOut) annotation (Line(
      points={{238,-207},{220,-207},{220,-230},{181,-230}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea1.y[3], conDirNorRad.HIn) annotation (Line(
      points={{-59,170},{20,170},{20,210},{118,210}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea1.y[2], conGloHorRad.HIn) annotation (Line(
      points={{-59,170},{118,170}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea1.y[4], conDifHorRad.HIn) annotation (Line(
      points={{-59,170},{20,170},{20,130},{118,130}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conRelHum.relHumIn, datRea.y[3]) annotation (Line(
      points={{118,30},{20,30},{20,-30},{-59,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cheRelHum.relHumOut, weaBus.relHum) annotation (Line(
      points={{181,30},{280,30},{280,5.55112e-16},{304,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheTemDryBul.TOut, weaBus.TDryBul) annotation (Line(
      points={{181,-190},{280,-190},{280,5.55112e-16},{304,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(decAng.decAng, zenAng.decAng)
                                     annotation (Line(
      points={{-119,-210},{-82,-210},{-82,-210.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solHouAng.solHouAng, zenAng.solHouAng)
                                              annotation (Line(
      points={{-119,-240},{-100,-240},{-100,-220.8},{-82,-220.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solHouAng.solTim, solTim.solTim) annotation (Line(
      points={{-142,-240},{-154,-240},{-154,-172},{-20,-172},{-20,-130},{-59,-130}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(decAng.nDay, simTim.y) annotation (Line(
      points={{-142,-210},{-150,-210},{-150,-180},{0,-180},{0,6.10623e-16},{
          -159,6.10623e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zenAng.zen, altAng.zen) annotation (Line(
      points={{-59,-216},{-40,-216},{-40,-270},{-32,-270}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(altAng.alt, solBus.alt) annotation (Line(
      points={{-9,-270},{8,-270},{8,-294}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(zenAng.zen, solBus.zen) annotation (Line(
      points={{-59,-216},{-40,-216},{-40,-294},{8,-294}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(solBus, weaBus.sol) annotation (Line(
      points={{8,-294},{122,-294},{122,-292},{290,-292},{290,5.55112e-16},{304,
          5.55112e-16}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));

  connect(decAng.decAng, solBus.dec) annotation (Line(
      points={{-119,-210},{-100,-210},{-100,-294},{8,-294}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(solHouAng.solHouAng, solBus.solHouAng) annotation (Line(
      points={{-119,-240},{-100,-240},{-100,-294},{8,-294}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(longitude.y, solBus.lon) annotation (Line(
      points={{-119,-270},{-100,-270},{-100,-294},{8,-294}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(latitude.y, solBus.lat) annotation (Line(
      points={{-159,-270},{-150,-270},{-150,-294},{8,-294}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));

  // Connectors for wet bulb temperature.
  // These are removed if computeWetBulbTemperature = false

  annotation (
    defaultComponentName="weaDat",
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-200,-200},{200,200}},
        initialScale=0.05), graphics={
        Rectangle(
          extent={{-200,-198},{200,202}},
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
          thickness=1),
        Text(
          visible=(pAtmSou == Districts.BoundaryConditions.Types.DataSource.Input),
          extent={{-190,216},{-164,184}},
          lineColor={0,0,127},
          textString="p"),
        Text(
          visible=(TDryBulSou == Districts.BoundaryConditions.Types.DataSource.Input),
          extent={{-194,162},{-118,118}},
          lineColor={0,0,127},
          textString="TDryBul"),
        Text(
          visible=(relHumSou == Districts.BoundaryConditions.Types.DataSource.Input),
          extent={{-190,92},{-104,66}},
          lineColor={0,0,127},
          textString="relHum"),
        Text(
        visible=(winSpeSou == Districts.BoundaryConditions.Types.DataSource.Input),
          extent={{-196,44},{-110,2}},
          lineColor={0,0,127},
          textString="winSpe"),
        Text(
          visible=(winDirSou == Districts.BoundaryConditions.Types.DataSource.Input),
          extent={{-192,-18},{-106,-60}},
          lineColor={0,0,127},
          textString="winDir"),
        Text(
        visible=(HSou ==  Districts.BoundaryConditions.Types.RadiationDataSource.Input_HGloHor_HDifHor or HSou == Districts.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HGloHor),
        extent={{-202,-88},{-112,-108}},
          lineColor={0,0,127},
          textString="HGloHor"),
        Text(visible=(HSou == Districts.BoundaryConditions.Types.RadiationDataSource.Input_HGloHor_HDifHor or HSou == Districts.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HDifHor),
        extent={{-202,-142},{-116,-164}},
          lineColor={0,0,127},
          textString="HDifHor"),
        Text(
        visible=(HSou == Districts.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HGloHor or HSou == Districts.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HDifHor),
        extent={{-200,-186},{-126,-214}},
          lineColor={0,0,127},
          textString="HDirNor")}),
    Documentation(info="<html>
<p>
This component reads TMY3 weather data (Wilcox and Marion, 2008) or user specified weather data. 
This model does not compute the wet bulb temperature.
For a similar data reader that computes the wet bulb temperature, use
<a href=\"modelica://Districts.BoundaryConditions.WeatherData.ReaderTMY3\">
Districts.BoundaryConditions.WeatherData.ReaderTMY3</a>.
</p>
<p>
The following parameters are automatically read from the weather file:
</p>
<ul>
<li>
The latitude of the weather station, <code>lat</code>,
</li>
<li>
the longitude of the weather station, <code>lon</code>, and
</li>
<li>
the time zone relative to Greenwich Mean Time, <code>timZone</code>.
</li>
</ul>
<p>
This model has the option of using a constant value, using the data from the weather file, 
or using data from an input connector for the following variables: 
atmospheric pressure, relative humidity, dry bulb temperature, 
global horizontal radiation, diffuse horizontal radiation, wind direction and wind speed.
</p>
<p>
By default, all data are obtained from the weather data file,
except for the atmospheric pressure, which is set to the
parameter <code>pAtm=101325</code> Pascals.
</p>
<p>
The parameter <code>*Sou</code> configures the source of the data.
For the atmospheric pressure, dry bulb temperature, relative humidity, wind speed and wind direction,
the enumeration
<a href=\"modelica://Districts.BoundaryConditions.Types.DataSource\">
Districts.BoundaryConditions.Types.DataSource</a>
is used as follows:
</p>
<p>
<table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
<!-- -------------------------------- -->
<tr>
  <th>Parameter <code>*Sou</code>
  </th>
  <th>Data used to compute weather data.
  </th>
</tr>
<!-- ------- -->
<tr>
  <td>
    File
  </td>
  <td>
    Use data from file.
  </td>
</tr>
<!-- ------- -->
<tr>
  <td>
    Parameter
  </td>
  <td>
    Use value specified by the parameter.
  </td>
</tr>
<!-- ------- -->
<tr>
  <td>
    Input
  </td>
  <td>
    Use value from the input connector.
  </td>
</tr>
</table>
</p>
<p>
Because global, diffuse and direct radiation are related to each other, the parameter
<code>HSou</code> is treated differently.
It is set to a value of the enumeration
<a href=\"modelica://Districts.BoundaryConditions.Types.RadiationDataSource\">
Districts.BoundaryConditions.Types.RadiationDataSource</a>,
and allows the following configurations:
</p>
<p>
<table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
<!-- -------------------------------- -->
<tr>
  <th>Parameter <code>HSou</code>
  </th>
  <th>Data used to compute weather data.
  </th>
</tr>
<!-- ------- -->
<tr>
  <td>
    File
  </td>
  <td>
    Use data from file.
  </td>
</tr>
<!-- ------- -->
<tr>
  <td>
    Input_HGloHor_HDifHor
  </td>
  <td>
    Use global horizontal and diffuse horizontal radiation from input connector.
  </td>
</tr>
<tr>
  <td>
    Input_HDirNor_HDifHor
  </td>
  <td>
    Use direct normal and diffuse horizontal radiation from input connector.
  </td>
</tr>
<tr>
  <td>
    Input_HDirNor_HGloHor
  </td>
  <td>
    Use direct normal and global horizontal radiation from input connector.
  </td>
</tr>
</table>
</p>
<p>
<b>Notes</b>
<ol>
<li>
<p>
In HVAC systems, when the fan is off, changes in atmospheric pressure can cause small air flow rates
in the duct system due to change in pressure and hence in the mass of air that is stored
in air volumes (such as in fluid junctions or in the room model). 
This may increase computing time. Therefore, the default value for the atmospheric pressure is set to a constant.
Furthermore, if the initial pressure of air volumes are different
from the atmospheric pressure, then fast pressure transients can happen in the first few seconds of the simulation.
This can cause numerical problems for the solver. To avoid this problem, set the atmospheric pressure to the
same value as the medium default pressure, which is typically set to the parameter <code>Medium.p_default</code>.
For medium models for moist air and dry air, the default is
<code>Medium.p_default=101325</code> Pascals.
</p>
</li>
<li>
<p>
Different units apply depending on whether data are obtained from a file, or 
from a parameter or an input connector:
<ul>
<li>
When using TMY3 data from a file (e.g. <code>USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos</code>), the units must be the same as the original TMY3 file used by EnergyPlus (e.g. 
<code>USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw</code>). 
The TMY3 data used by EnergyPlus are in both SI units and non-SI units. 
If <code>Resources/bin/ConvertWeatherData.jar</code> is used to convert the <code>.epw</code> file to an <code>.mos</code> file, the units of the TMY3 data are preserved and the file can be directly
used by this data reader. 
The data reader will automatically convert units to the SI units used by Modelica.
For example, the dry bulb temperature <code>TDryBul</code> in TMY3 is in degree Celsius. 
The data reader will automatically convert the data to Kelvin. 
The wind direction <code>winDir</code> in TMY3 is degrees and will be automatically converted to radians.
</li>
<li>
When using data from a parameter or from an input connector,
the data must be in the SI units used by Modelica. 
For instance, the unit must be 
<code>Pa</code> for pressure,
<code>K</code> for temperature,
<code>W/m2</code> for solar radiations and
<code>rad</code> for wind direction.
</li>
</ul>
</p>
</li>
<li>
<p>
The ReaderTMY3 should only be used with TMY3 data. It contains a time shift for solar radiation data that is explained below. This time shift needs to be removed if the user may want to use the ReaderTMY3 for other weather data types. 
</p>
</li>
</ol>
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
<img src=\"modelica://Districts/Resources/Images/BoundaryConditions/WeatherData/RadiationTimeShift.png\" border=\"1\">
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
January 12, 2012, by Michael Wetter:<br/>
Removed computation of wet bulb temperature
to avoid dependency on medium model.
</li>
<li>
October 16, 2012, by Michael Wetter:<br/>
Added computation of the wet bulb temperature.
Computing the wet bulb temperature introduces a nonlinear
equation. As we have not observed an increase in computing time
because of computing the wet bulb temperature, it is computed
by default. By setting the parameter 
<code>computeWetBulbTemperature=false</code>, the computation of the
wet bulb temperature can be removed.
Revised documentation.
</li>
<li>
August 11, 2012, by Wangda Zuo:<br/>
Renamed <code>radHor</code> to <code>radHorIR</code> and 
improved the optional inputs for radiation data.
</li>
<li>
July 24, 2012, by Wangda Zuo:<br/>
Corrected the notes of SI unit requirements for input files.
</li>
<li>
July 13, 2012, by Michael Wetter:<br/>
Removed assignment of <code>HGloHor_in</code> in its declaration,
because this gives an overdetermined system if the input connector
is used.
Removed non-required assignments of attribute <code>displayUnit</code>.
</li>
<li>
February 25, 2012, by Michael Wetter:<br/>
Added subbus for solar position, which is needed by irradition and
shading model.
</li>
<li>
November 29, 2011, by Michael Wetter:<br/>
Fixed wrong display unit for <code>pAtm_in_internal</code> and 
made propagation of parameter final.
</li>
<li>
October 27, 2011, by Wangda Zuo:<br/>
1. Added optional connectors for dry bulb temperature, relative humidity, wind speed, wind direction, global horizontal radiation, diffuse horizontal radiation.<br/>
2. Separate the unit convertion for TMY3 data and data validity check. 
</li>
<li>
October 3, 2011, by Michael Wetter:<br/>
Propagated value for sky temperature calculation to make it accessible as a parameter.
</li>
<li>
July 20, 2011, by Michael Wetter:<br/>
Added the option to use a constant, an input signal or the weather file as the source
for the atmospheric pressure.
</li><li>
March 15, 2011, by Wangda Zuo:<br/>
Delete the wet bulb temperature since it may cause numerical problem.
</li>
<li>
March 7, 2011, by Wangda Zuo:<br/>
Added wet bulb temperature. Changed reader to read only needed columns. 
Added explanation for 30 minutes shift for radiation data.  
</li>
<li>
March 5, 2011, by Michael Wetter:<br/>
Changed implementation to obtain longitude and time zone directly
from weather file.
</li>
<li>
June 25, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-200,-300},{300,
            300}}), graphics));
end ReaderTMY3;
