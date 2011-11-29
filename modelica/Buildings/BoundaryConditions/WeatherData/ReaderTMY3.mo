within Buildings.BoundaryConditions.WeatherData;
block ReaderTMY3 "Reader for TMY3 weather data "
  //--------------------------------------------------------------
  // Atmospheric pressure
  parameter Buildings.BoundaryConditions.Types.DataSource pAtmSou=Buildings.BoundaryConditions.Types.DataSource.Parameter
    "Atmospheric pressure"
    annotation (Evaluate=true, Dialog(group="Data source"));
  parameter Modelica.SIunits.Pressure pAtm=101325
    "Atmospheric pressure (used if pAtmSou=Parameter)"
    annotation (Evaluate=true, Dialog(group="Data source"));
  Modelica.Blocks.Interfaces.RealInput pAtm_in(
    final quantity="Pressure",
    final unit="Pa",
    displayUnit="Pa") if (pAtmSou == Buildings.BoundaryConditions.Types.DataSource.Input)
    "Input pressure"
    annotation (Placement(transformation(extent={{-240,180},{-200,220}}),
        iconTransformation(extent={{-240,180},{-200,220}})));
  //--------------------------------------------------------------
  // Dry bulb temperature
  parameter Buildings.BoundaryConditions.Types.DataSource TDryBulSou=Buildings.BoundaryConditions.Types.DataSource.File
    "Dry bulb temperature"
    annotation (Evaluate=true, Dialog(group="Data source"));
  parameter Modelica.SIunits.Temperature TDryBul(displayUnit="degC") = 293.15
    "Dry bulb temperature (used if TDryBul=Parameter)"
    annotation (Evaluate=true, Dialog(group="Data source"));
  Modelica.Blocks.Interfaces.RealInput TDryBul_in(
    final quantity="Temperature",
    final unit="K",
    displayUnit="degC") if (TDryBulSou == Buildings.BoundaryConditions.Types.DataSource.Input)
    "Input dry bulb temperature"
    annotation (Placement(transformation(extent={{-240,120},{-200,160}})));
  //--------------------------------------------------------------
  // Relative humidity
  parameter Buildings.BoundaryConditions.Types.DataSource relHumSou=Buildings.BoundaryConditions.Types.DataSource.File
    "Relative humidity" annotation (Evaluate=true, Dialog(group="Data source"));
  parameter Real relHum(
    min=0,
    max=1,
    unit="1") = 0.5 "Relative humidity (used if relHum=Parameter)"
    annotation (Evaluate=true, Dialog(group="Data source"));
  Modelica.Blocks.Interfaces.RealInput relHum_in(
    min=0,
    max=1,
    unit="1") if (relHumSou == Buildings.BoundaryConditions.Types.DataSource.Input)
    "Input relative humidity"
    annotation (Placement(transformation(extent={{-240,60},{-200,100}}),
        iconTransformation(extent={{-240,60},{-200,100}})));
  //--------------------------------------------------------------
  // Wind speed
  parameter Buildings.BoundaryConditions.Types.DataSource winSpeSou=Buildings.BoundaryConditions.Types.DataSource.File
    "Wind speed" annotation (Evaluate=true, Dialog(group="Data source"));
  parameter Modelica.SIunits.Velocity winSpe(min=0) = 1
    "Wind speed (used if winSpe=Parameter)"
    annotation (Evaluate=true, Dialog(group="Data source"));
  Modelica.Blocks.Interfaces.RealInput winSpe_in(
    final quantity="Velocity",
    final unit="m/s",
    min=0,
    displayUnit="m/s") if (winSpeSou == Buildings.BoundaryConditions.Types.DataSource.Input)
    "Input wind speed"
    annotation (Placement(transformation(extent={{-240,0},{-200,40}}),
        iconTransformation(extent={{-240,0},{-200,40}})));
  //--------------------------------------------------------------
  // Wind direction
  parameter Buildings.BoundaryConditions.Types.DataSource winDirSou=Buildings.BoundaryConditions.Types.DataSource.File
    "Wind direction" annotation (Evaluate=true, Dialog(group="Data source"));
  parameter Modelica.SIunits.Angle winDir=1.0
    "Wind direction (used if winDir=Parameter)"
    annotation (Evaluate=true, Dialog(group="Data source"));
  Modelica.Blocks.Interfaces.RealInput winDir_in(
    final quantity="Angle",
    final unit="rad",
    displayUnit="deg") if (winDirSou == Buildings.BoundaryConditions.Types.DataSource.Input)
    "Input wind direction"
    annotation (Placement(transformation(extent={{-240,-60},{-200,-20}}),
        iconTransformation(extent={{-240,-60},{-200,-20}})));
  //--------------------------------------------------------------
  // Global horizontal radiation
  parameter Buildings.BoundaryConditions.Types.DataSource HGloHorSou=Buildings.BoundaryConditions.Types.DataSource.File
    "Global horizontal radiation"
    annotation (Evaluate=true, Dialog(group="Data source"));
  parameter Modelica.SIunits.RadiantEnergyFluenceRate HGloHor=100
    "Global horizontal radiation (used if HGloHor=Parameter)"
    annotation (Evaluate=true, Dialog(group="Data source"));
  Modelica.Blocks.Interfaces.RealInput HGloHor_in(
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2",
    displayUnit="W/m2") = 100 if (HGloHorSou == Buildings.BoundaryConditions.Types.DataSource.Input)
    "Input global horizontal radiation"
    annotation (Placement(transformation(extent={{-240,-120},{-200,-80}}),
        iconTransformation(extent={{-240,-120},{-200,-80}})));
  //--------------------------------------------------------------
  // Diffuse horizontal radiation
  parameter Buildings.BoundaryConditions.Types.DataSource HDifHorSou=Buildings.BoundaryConditions.Types.DataSource.File
    "Diffuse horizontal radiation"
    annotation (Evaluate=true, Dialog(group="Data source"));
  parameter Modelica.SIunits.RadiantEnergyFluenceRate HDifHor=50
    "Diffuse horizontal radiation (used if HDifHor=Parameter)"
    annotation (Evaluate=true, Dialog(group="Data source"));
  Modelica.Blocks.Interfaces.RealInput HDifHor_in(
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2",
    displayUnit="W/m2") if (HDifHorSou == Buildings.BoundaryConditions.Types.DataSource.Input)
    "Input diffuse horizontal radiation"
    annotation (Placement(transformation(extent={{-240,-180},{-200,-140}}),
        iconTransformation(extent={{-240,-180},{-200,-140}})));
  parameter String filNam "Name of weather data file" annotation (Dialog(
        __Dymola_loadSelector(filter="Weather files (*.mos)", caption=
            "Select weather file")));
  final parameter Modelica.SIunits.Angle lon(displayUnit="deg")=
    Buildings.BoundaryConditions.WeatherData.BaseClasses.getLongitudeTMY3(
    filNam) "Longitude";
  final parameter Modelica.SIunits.Time timZon(displayUnit="h")=
    Buildings.BoundaryConditions.WeatherData.BaseClasses.getTimeZoneTMY3(filNam)
    "Time zone";
  Bus weaBus "Weather Data Bus" annotation (Placement(transformation(extent={{
            294,-10},{314,10}}), iconTransformation(extent={{190,-10},{210,10}})));
  parameter Buildings.BoundaryConditions.Types.SkyTemperatureCalculation
    calTSky=Buildings.BoundaryConditions.Types.SkyTemperatureCalculation.TemperaturesAndSkyCover
    "Computation of black-body sky temperature" annotation (
    choicesAllMatching=true,
    Evaluate=true,
    Dialog(group="Sky temperature"));
protected
  Modelica.Blocks.Tables.CombiTable1Ds datRea(
    final tableOnFile=true,
    final tableName="tab1",
    final fileName=filNam,
    final smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    final columns={2,3,4,5,6,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,
        28,29,30}) "Data reader"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.CheckTemperature
    cheTemDryBul "Check dry bulb temperature "
    annotation (Placement(transformation(extent={{160,-200},{180,-180}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.CheckTemperature
    cheTemDewPoi "Check dew point temperature"
    annotation (Placement(transformation(extent={{160,-240},{180,-220}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.ConvertRelativeHumidity
    conRelHum "Convert the relative humidity from percentage to [0, 1] "
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
  Utilities.SimulationTime simTim "Simulation time"
    annotation (Placement(transformation(extent={{-180,-10},{-160,10}})));
  Modelica.Blocks.Math.Add add
    "Add 30 minutes to time to shift weather data reader"
    annotation (Placement(transformation(extent={{-140,160},{-120,180}})));
  Modelica.Blocks.Sources.Constant con30mins(final k=1800)
    "Constant used to shift weather data reader"
    annotation (Placement(transformation(extent={{-180,192},{-160,212}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.LocalCivilTime locTim(
      final lon=lon, final timZon=timZon) "Local civil time"
    annotation (Placement(transformation(extent={{-120,-160},{-100,-140}})));
  Modelica.Blocks.Tables.CombiTable1Ds datRea1(
    final tableOnFile=true,
    final tableName="tab1",
    final fileName=filNam,
    final smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    final columns=8:11) "Data reader"
    annotation (Placement(transformation(extent={{-80,160},{-60,180}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.ConvertTime conTim1
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
    final unit="m/s",
    displayUnit="m/s") "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput winDir_in_internal(
    final quantity="Angle",
    final unit="rad",
    displayUnit="deg") "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput HGloHor_in_internal(
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2",
    displayUnit="W/m2") "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput HDifHor_in_internal(
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2",
    displayUnit="W/m2") "Needed to connect to conditional connector";
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
equation
  //---------------------------------------------------------------------------
  // Select atmospheric pressure connector
  if pAtmSou == Buildings.BoundaryConditions.Types.DataSource.Parameter then
    pAtm_in_internal = pAtm;
  elseif pAtmSou == Buildings.BoundaryConditions.Types.DataSource.File then
    connect(datRea.y[4], pAtm_in_internal);
  else
    connect(pAtm_in, pAtm_in_internal);
  end if;
  connect(pAtm_in_internal, chePre.PIn);
  //---------------------------------------------------------------------------
  // Select dry bulb temperature connector
  if TDryBulSou == Buildings.BoundaryConditions.Types.DataSource.Parameter then
    TDryBul_in_internal = TDryBul;
  elseif TDryBulSou == Buildings.BoundaryConditions.Types.DataSource.Input then
    connect(TDryBul_in, TDryBul_in_internal);
  else
    connect(conTDryBul.y, TDryBul_in_internal);
  end if;
  connect(TDryBul_in_internal, cheTemDryBul.TIn);
  //---------------------------------------------------------------------------
  // Select relative humidity connector
  if relHumSou == Buildings.BoundaryConditions.Types.DataSource.Parameter then
    relHum_in_internal = relHum;
  elseif relHumSou == Buildings.BoundaryConditions.Types.DataSource.Input then
    connect(relHum_in, relHum_in_internal);
  else
    connect(conRelHum.relHumOut, relHum_in_internal);
  end if;
  connect(relHum_in_internal, cheRelHum.relHumIn);
  //---------------------------------------------------------------------------
  // Select wind speed connector
  if winSpeSou == Buildings.BoundaryConditions.Types.DataSource.Parameter then
    winSpe_in_internal = winSpe;
  elseif winSpeSou == Buildings.BoundaryConditions.Types.DataSource.Input then
    connect(winSpe_in, winSpe_in_internal);
  else
    connect(datRea.y[12], winSpe_in_internal);
  end if;
  connect(winSpe_in_internal, cheWinSpe.winSpeIn);
  //---------------------------------------------------------------------------
  // Select wind direction connector
  if winDirSou == Buildings.BoundaryConditions.Types.DataSource.Parameter then
    winDir_in_internal = winDir;
  elseif winDirSou == Buildings.BoundaryConditions.Types.DataSource.Input then
    connect(winDir_in, winDir_in_internal);
  else
    connect(conWinDir.y, winDir_in_internal);
  end if;
  connect(winDir_in_internal, cheWinDir.nIn);
  //---------------------------------------------------------------------------
  // Select global horizontal radiation connector
  if HGloHorSou == Buildings.BoundaryConditions.Types.DataSource.Parameter then
    HGloHor_in_internal = HGloHor;
  elseif HGloHorSou == Buildings.BoundaryConditions.Types.DataSource.Input then
    connect(HGloHor_in, HGloHor_in_internal);
  else
    connect(conGloHorRad.HOut, HGloHor_in_internal);
  end if;
  connect(HGloHor_in_internal, cheGloHorRad.HIn);
  //---------------------------------------------------------------------------
  // Select diffuse horizontal radiation connector
  if HDifHorSou == Buildings.BoundaryConditions.Types.DataSource.Parameter then
    HDifHor_in_internal = HDifHor;
  elseif HDifHorSou == Buildings.BoundaryConditions.Types.DataSource.Input then
    connect(HDifHor_in, HDifHor_in_internal);
  else
    connect(conDifHorRad.HOut, HDifHor_in_internal);
  end if;
  connect(HDifHor_in_internal, cheDifHorRad.HIn);
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
  connect(cheHorRad.HOut, weaBus.radHor) annotation (Line(
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
  connect(cheHorRad.HOut, TBlaSky.radHor) annotation (Line(
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
  connect(conDirNorRad.HOut, cheDirNorRad.HIn) annotation (Line(
      points={{141,210},{158,210}},
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
  annotation (
    defaultComponentName="weaDat",
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-200,-200},{200,200}},
        initialScale=0.05), graphics={
        Rectangle(
          extent={{-200,-200},{200,200}},
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
          visible=(pAtmSou == Buildings.BoundaryConditions.Types.DataSource.Input),
          extent={{-190,216},{-164,184}},
          lineColor={0,0,127},
          textString="p"),
        Text(
          visible=(TDryBulSou == Buildings.BoundaryConditions.Types.DataSource.Input),
          extent={{-194,162},{-118,118}},
          lineColor={0,0,127},
          textString="TDryBul"),
        Text(
          visible=(relHumSou == Buildings.BoundaryConditions.Types.DataSource.Input),
          extent={{-190,92},{-104,66}},
          lineColor={0,0,127},
          textString="relHum"),
        Text(
          visible=(winSpeSou == Buildings.BoundaryConditions.Types.DataSource.Input),
          extent={{-196,44},{-110,2}},
          lineColor={0,0,127},
          textString="winSpe"),
        Text(
          visible=(winDirSou == Buildings.BoundaryConditions.Types.DataSource.Input),
          extent={{-192,-18},{-106,-60}},
          lineColor={0,0,127},
          textString="winDir"),
        Text(
          visible=(HGloHorSou == Buildings.BoundaryConditions.Types.DataSource.Input),
          extent={{-188,-82},{-98,-122}},
          lineColor={0,0,127},
          textString="HGloHor"),
        Text(
          visible=(HDifHorSou == Buildings.BoundaryConditions.Types.DataSource.Input),
          extent={{-192,-148},{-98,-172}},
          lineColor={0,0,127},
          textString="HDifHor")}),
    Documentation(info="<html>
<p>
This component reads TMY3 weather data (Wilcox and Marion, 2008) or user specified weather data. 
The parameter 
<code>lon</code> is the longitude of the weather station, and 
the parameter <code>timZone</code> is the time zone
relative to Greenwich Mean Time. 
By default, the reader obtains values for these parameters 
by scanning the TMY3 weather data file except the atmospheric pressure which use 101325 Pascals as default value.
</p>
This model has the option of using a constant value, using the data from the weather file, 
or from an input connector for the following variables: 
atmospheric pressure, relative humidity, dry bulb temperature, 
global horizontal radiation, diffuse horizontal radiation, wind direction and wind speed.
<p>
For instance, the atmospheric pressure is set to the parameter <code>pAtm = 101325</code> Pascals.
The parameter <code>pAtmSou</code> can be used to change the source that is used as the atmospheric pressure.
The input connector will be enabled if 
<code>pAtmSou = Buildings.BoundaryConditions.Types.DataSource.Input</code>.
The the weather file will be read if
<code>pAtmSou = Buildings.BoundaryConditions.Types.DataSource.File</code>.
</p>
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
<b>Note:</b>The data units of user specified input files should be SI units consistent with Modelica standard. 
For instance, the unit for the solar radiation should be <code>W/m2</code> and that for the wind direction should be <code>rad</code>.
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
November 29, 2011, by Michael Wetter:<br>
Fixed wrong display unit for <code>pAtm_in_internal</code> and 
made propagation of parameter final.
</li>
<li>
October 27, 2011, by Wangda Zuo:<br>
1. Added optional connectors for dry bulb temperature, relative humidity, wind speed, wind direction, global horizontal radiation, diffuse horizontal radiation.<br>
2. Separate the unit convertion for TMY3 data and data validity check. 
</li>
<li>
October 3, 2011, by Michael Wetter:<br>
Propagated value for sky temperature calculation to make it accessible as a parameter.
</li>
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
    Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-200,-300},{300,
            300}}), graphics));
end ReaderTMY3;
