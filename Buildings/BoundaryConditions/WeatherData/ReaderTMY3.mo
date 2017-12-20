within Buildings.BoundaryConditions.WeatherData;
block ReaderTMY3 "Reader for TMY3 weather data"

  parameter Boolean computeWetBulbTemperature = true
    "If true, then this model computes the wet bulb temperature"
    annotation(Evaluate=true);
  //--------------------------------------------------------------
  // Atmospheric pressure
  parameter Buildings.BoundaryConditions.Types.DataSource pAtmSou=Buildings.BoundaryConditions.Types.DataSource.Parameter
    "Atmospheric pressure"
    annotation (Evaluate=true, Dialog(group="Data source"));
  parameter Modelica.SIunits.Pressure pAtm=101325
    "Atmospheric pressure (used if pAtmSou=Parameter)"
    annotation (Dialog(group="Data source"));
  Modelica.Blocks.Interfaces.RealInput pAtm_in(
    final quantity="Pressure",
    final unit="Pa",
    displayUnit="Pa") if (pAtmSou == Buildings.BoundaryConditions.Types.DataSource.Input)
    "Input pressure"
    annotation (Placement(transformation(extent={{-240,254},{-200,294}}),
        iconTransformation(extent={{-240,254},{-200,294}})));
  //--------------------------------------------------------------
  // Ceiling height
  parameter Buildings.BoundaryConditions.Types.DataSource ceiHeiSou=Buildings.BoundaryConditions.Types.DataSource.File
    "Ceiling height" annotation (Evaluate=true, Dialog(group="Data source"));
  parameter Real ceiHei(
    final quantity="Height",
    final unit="m",
    displayUnit="m") = 20000 "Ceiling height (used if ceiHei=Parameter)"
    annotation (Dialog(group="Data source"));
  Modelica.Blocks.Interfaces.RealInput ceiHei_in(
    final quantity="Height",
    final unit="m",
    displayUnit="m") if (ceiHeiSou == Buildings.BoundaryConditions.Types.DataSource.Input)
    "Input ceiling height"
    annotation (Placement(transformation(extent={{-242,-14},{-202,26}}),
        iconTransformation(extent={{-242,-14},{-202,26}})));
  //--------------------------------------------------------------
  // Total sky cover
  parameter Buildings.BoundaryConditions.Types.DataSource totSkyCovSou=Buildings.BoundaryConditions.Types.DataSource.File
    "Total sky cover" annotation (Evaluate=true, Dialog(group="Data source"));
  parameter Real totSkyCov(
    min=0,
    max=1,
    unit="1") = 0.5
    "Total sky cover (used if totSkyCov=Parameter). Use 0 <= totSkyCov <= 1"
    annotation (Dialog(group="Data source"));
  Modelica.Blocks.Interfaces.RealInput totSkyCov_in(
    min=0,
    max=1,
    unit="1") if (totSkyCovSou == Buildings.BoundaryConditions.Types.DataSource.Input)
    "Input total sky cover"
    annotation (Placement(transformation(extent={{-240,-58},{-200,-18}}),
        iconTransformation(extent={{-240,-58},{-200,-18}})));
  // Opaque sky cover
  parameter Buildings.BoundaryConditions.Types.DataSource opaSkyCovSou=Buildings.BoundaryConditions.Types.DataSource.File
    "Opaque sky cover" annotation (Evaluate=true, Dialog(group="Data source"));
  parameter Real opaSkyCov(
    min=0,
    max=1,
    unit="1") = 0.5
    "Opaque sky cover (used if opaSkyCov=Parameter). Use 0 <= opaSkyCov <= 1"
    annotation (Dialog(group="Data source"));
  Modelica.Blocks.Interfaces.RealInput opaSkyCov_in(
    min=0,
    max=1,
    unit="1") if (opaSkyCovSou == Buildings.BoundaryConditions.Types.DataSource.Input)
    "Input opaque sky cover"
    annotation (Placement(transformation(extent={{-240,32},{-200,72}}),
        iconTransformation(extent={{-240,32},{-200,72}})));
  //--------------------------------------------------------------
  // Dry bulb temperature
  parameter Buildings.BoundaryConditions.Types.DataSource TDryBulSou=Buildings.BoundaryConditions.Types.DataSource.File
    "Dry bulb temperature"
    annotation (Evaluate=true, Dialog(group="Data source"));
  parameter Modelica.SIunits.Temperature TDryBul(displayUnit="degC") = 293.15
    "Dry bulb temperature (used if TDryBul=Parameter)"
    annotation (Dialog(group="Data source"));
  Modelica.Blocks.Interfaces.RealInput TDryBul_in(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") if (TDryBulSou == Buildings.BoundaryConditions.Types.DataSource.Input)
    "Input dry bulb temperature"
    annotation (Placement(transformation(extent={{-240,160},{-200,200}})));

  //--------------------------------------------------------------
  // Dew point temperature
  parameter Buildings.BoundaryConditions.Types.DataSource TDewPoiSou=Buildings.BoundaryConditions.Types.DataSource.File
    "Dew point temperature"
    annotation (Evaluate=true, Dialog(group="Data source"));
  parameter Modelica.SIunits.Temperature TDewPoi(displayUnit="degC") = 283.15
    "Dew point temperature (used if TDewPoi=Parameter)"
    annotation (Dialog(group="Data source"));
  Modelica.Blocks.Interfaces.RealInput TDewPoi_in(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") if (TDewPoiSou == Buildings.BoundaryConditions.Types.DataSource.Input)
    "Input dew point temperature"
    annotation (Placement(transformation(extent={{-240,204},{-200,244}})));

  //--------------------------------------------------------------
  // Black body sky temperature
  parameter Buildings.BoundaryConditions.Types.DataSource TBlaSkySou=Buildings.BoundaryConditions.Types.DataSource.File
    "Black-body sky temperature" annotation (Evaluate=true, Dialog(group="Data source"));
  parameter Modelica.SIunits.Temperature TBlaSky=273.15
    "Black-body sky temperature (used if TBlaSkySou=Parameter)"
    annotation (Dialog(group="Data source"));
  Modelica.Blocks.Interfaces.RealInput TBlaSky_in(
    final quantity="ThermodynamicTemperature",
    displayUnit="degC",
    final unit="K") if
    (TBlaSkySou == Buildings.BoundaryConditions.Types.DataSource.Input)
    "Black-body sky temperature"
    annotation (Placement(transformation(extent={{-240,120},{-200,160}}),
        iconTransformation(extent={{-240,120},{-200,160}})));
  //--------------------------------------------------------------
  // Relative humidity
  parameter Buildings.BoundaryConditions.Types.DataSource relHumSou=Buildings.BoundaryConditions.Types.DataSource.File
    "Relative humidity" annotation (Evaluate=true, Dialog(group="Data source"));
  parameter Real relHum(
    min=0,
    max=1,
    unit="1") = 0.5 "Relative humidity (used if relHum=Parameter)"
    annotation (Dialog(group="Data source"));
  Modelica.Blocks.Interfaces.RealInput relHum_in(
    min=0,
    max=1,
    unit="1") if (relHumSou == Buildings.BoundaryConditions.Types.DataSource.Input)
    "Input relative humidity"
    annotation (Placement(transformation(extent={{-240,80},{-200,120}}),
        iconTransformation(extent={{-240,80},{-200,120}})));
  //--------------------------------------------------------------
  // Wind speed
  parameter Buildings.BoundaryConditions.Types.DataSource winSpeSou=Buildings.BoundaryConditions.Types.DataSource.File
    "Wind speed" annotation (Evaluate=true, Dialog(group="Data source"));
  parameter Modelica.SIunits.Velocity winSpe(min=0) = 1
    "Wind speed (used if winSpe=Parameter)"
    annotation (Dialog(group="Data source"));
  Modelica.Blocks.Interfaces.RealInput winSpe_in(
    final quantity="Velocity",
    final unit="m/s",
    min=0) if (winSpeSou == Buildings.BoundaryConditions.Types.DataSource.Input)
    "Input wind speed"
    annotation (Placement(transformation(extent={{-240,-98},{-200,-58}}),
        iconTransformation(extent={{-240,-98},{-200,-58}})));
  //--------------------------------------------------------------
  // Wind direction
  parameter Buildings.BoundaryConditions.Types.DataSource winDirSou=Buildings.BoundaryConditions.Types.DataSource.File
    "Wind direction" annotation (Evaluate=true, Dialog(group="Data source"));
  parameter Modelica.SIunits.Angle winDir=1.0
    "Wind direction (used if winDir=Parameter)"
    annotation (Dialog(group="Data source"));
  Modelica.Blocks.Interfaces.RealInput winDir_in(
    final quantity="Angle",
    final unit="rad",
    displayUnit="deg") if (winDirSou == Buildings.BoundaryConditions.Types.DataSource.Input)
    "Input wind direction"
    annotation (Placement(transformation(extent={{-240,-140},{-200,-100}}),
        iconTransformation(extent={{-240,-140},{-200,-100}})));
  //--------------------------------------------------------------
  // Infrared horizontal radiation
  parameter Buildings.BoundaryConditions.Types.DataSource HInfHorSou=Buildings.BoundaryConditions.Types.DataSource.File
    "Infrared horizontal radiation" annotation (Evaluate=true, Dialog(group="Data source"));
  parameter Modelica.SIunits.HeatFlux HInfHor=0.0
    "Infrared horizontal radiation (used if HInfHorSou=Parameter)"
    annotation (Dialog(group="Data source"));
  Modelica.Blocks.Interfaces.RealInput HInfHor_in(
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2") if (HInfHorSou == Buildings.BoundaryConditions.Types.DataSource.Input)
    "Input infrared horizontal radiation"
    annotation (Placement(transformation(extent={{-240,-210},{-200,-170}}),
        iconTransformation(extent={{-240,-210},{-200,-170}})));

   parameter Buildings.BoundaryConditions.Types.RadiationDataSource HSou=Buildings.BoundaryConditions.Types.RadiationDataSource.File
    "Global, diffuse, and direct normal radiation"
     annotation (Evaluate=true, Dialog(group="Data source"));
  //--------------------------------------------------------------
  // Global horizontal radiation
  Modelica.Blocks.Interfaces.RealInput HGloHor_in(
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2") if (HSou == Buildings.BoundaryConditions.Types.RadiationDataSource.Input_HGloHor_HDifHor or HSou == Buildings.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HGloHor)
    "Input global horizontal radiation"
    annotation (Placement(transformation(extent={{-240,-280},{-200,-240}}),
        iconTransformation(extent={{-240,-280},{-200,-240}})));
  //--------------------------------------------------------------
  // Diffuse horizontal radiation
  Modelica.Blocks.Interfaces.RealInput HDifHor_in(
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2") if (HSou == Buildings.BoundaryConditions.Types.RadiationDataSource.Input_HGloHor_HDifHor or HSou == Buildings.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HDifHor)
    "Input diffuse horizontal radiation"
    annotation (Placement(transformation(extent={{-240,-276},{-200,-236}}),
        iconTransformation(extent={{-240,-172},{-200,-132}})));
  //--------------------------------------------------------------
  // Direct normal radiation
  Modelica.Blocks.Interfaces.RealInput HDirNor_in(final quantity="RadiantEnergyFluenceRate",
      final unit="W/m2") if
                          (HSou == Buildings.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HDifHor or HSou == Buildings.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HGloHor)
    "Input direct normal radiation"
    annotation (Placement(transformation(extent={{-240,-320},{-200,-280}}),
        iconTransformation(extent={{-240,-240},{-200,-200}})));

  //--------------------------------------------------------------
  parameter String filNam="" "Name of weather data file" annotation (
    Dialog(loadSelector(filter="Weather files (*.mos)",
                        caption="Select weather file")));
  final parameter Modelica.SIunits.Angle lon(displayUnit="deg")=
    Buildings.BoundaryConditions.WeatherData.BaseClasses.getLongitudeTMY3(
    filNam) "Longitude";
  final parameter Modelica.SIunits.Angle lat(displayUnit="deg")=
    Buildings.BoundaryConditions.WeatherData.BaseClasses.getLatitudeTMY3(
    filNam) "Latitude";
  final parameter Modelica.SIunits.Time timZon(displayUnit="h")=
    Buildings.BoundaryConditions.WeatherData.BaseClasses.getTimeZoneTMY3(filNam)
    "Time zone";
  Bus weaBus "Weather data bus" annotation (Placement(transformation(extent={{
            290,-10},{310,10}}), iconTransformation(extent={{190,-10},{210,10}})));

  parameter Buildings.BoundaryConditions.Types.SkyTemperatureCalculation
    calTSky=Buildings.BoundaryConditions.Types.SkyTemperatureCalculation.TemperaturesAndSkyCover
    "Computation of black-body sky temperature" annotation (
    choicesAllMatching=true,
    Evaluate=true,
    Dialog(group="Sky temperature"));

  constant Real epsCos = 1e-6 "Small value to avoid division by 0";
  constant Modelica.SIunits.HeatFlux solCon = 1367.7 "Solar constant";

protected
  Modelica.Blocks.Tables.CombiTable1Ds datRea(
    final tableOnFile=true,
    final tableName="tab1",
    final fileName=filNam,
    final smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    final columns={2,3,4,5,6,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,
        28,29,30,8})
                   "Data reader"
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
    annotation (Placement(transformation(extent={{160,180},{180,200}})));
  BaseClasses.CheckRadiation cheDifHorRad
    "Check the diffuse horizontal radiation"
    annotation (Placement(transformation(extent={{160,140},{180,160}})));
  BaseClasses.CheckRadiation cheDirNorRad "Check the direct normal radiation"
    annotation (Placement(transformation(extent={{160,220},{180,240}})));
  BaseClasses.CheckCeilingHeight cheCeiHei "Check the ceiling height"
    annotation (Placement(transformation(extent={{160,-120},{180,-100}})));
  BaseClasses.CheckWindSpeed cheWinSpe "Check the wind speed"
    annotation (Placement(transformation(extent={{160,-80},{180,-60}})));
  BaseClasses.CheckIRRadiation
                             cheHorRad
    "Check the horizontal infrared irradiation"
    annotation (Placement(transformation(extent={{160,100},{180,120}})));
  BaseClasses.CheckWindDirection cheWinDir "Check the wind direction"
    annotation (Placement(transformation(extent={{160,-280},{180,-260}})));
  SkyTemperature.BlackBody TBlaSkyCom(final calTSky=calTSky) if
       not (TBlaSkySou == Buildings.BoundaryConditions.Types.DataSource.Parameter or
            TBlaSkySou == Buildings.BoundaryConditions.Types.DataSource.Input)
    "Computation of the black-body sky temperature"
    annotation (Placement(transformation(extent={{240,-220},{260,-200}})));
  Utilities.Time.ModelTime modTim "Model time"
    annotation (Placement(transformation(extent={{-180,-10},{-160,10}})));
  Modelica.Blocks.Math.Add add
    "Add 30 minutes to time to shift weather data reader"
    annotation (Placement(transformation(extent={{-140,180},{-120,200}})));
  Modelica.Blocks.Sources.Constant con30mins(final k=1800)
    "Constant used to shift weather data reader"
    annotation (Placement(transformation(extent={{-180,212},{-160,232}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.LocalCivilTime locTim(
      final lon=lon, final timZon=timZon) "Local civil time"
    annotation (Placement(transformation(extent={{-120,-160},{-100,-140}})));
  Modelica.Blocks.Tables.CombiTable1Ds datRea1(
    final tableOnFile=true,
    final tableName="tab1",
    final fileName=filNam,
    final smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    final columns=9:11) "Data reader"
    annotation (Placement(transformation(extent={{-80,180},{-60,200}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.ConvertTime conTim1
    "Convert simulation time to calendar time"
    annotation (Placement(transformation(extent={{-110,180},{-90,200}})));
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
  Modelica.Blocks.Interfaces.RealInput ceiHei_in_internal(
    final quantity="Height",
    final unit="m",
    displayUnit="m") "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput totSkyCov_in_internal(
    final quantity="1",
    min=0,
    max=1) "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput opaSkyCov_in_internal(
    final quantity="1",
    min=0,
    max=1) "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput TDryBul_in_internal(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput TDewPoi_in_internal(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput TBlaSky_in_internal(
    final quantity="ThermodynamicTemperature",
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
  Modelica.Blocks.Interfaces.RealInput HInfHor_in_internal(
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2") "Needed to connect to conditional connector";

  Modelica.Blocks.Math.UnitConversions.From_deg conWinDir
    "Convert the wind direction unit from [deg] to [rad]"
    annotation (Placement(transformation(extent={{120,-280},{140,-260}})));
  Modelica.Blocks.Math.UnitConversions.From_degC conTDryBul
    annotation (Placement(transformation(extent={{120,-200},{140,-180}})));
  BaseClasses.ConvertRadiation conHorRad
    annotation (Placement(transformation(extent={{120,100},{140,120}})));
  Modelica.Blocks.Math.UnitConversions.From_degC conTDewPoi
    "Convert the dew point temperature form [degC] to [K]"
    annotation (Placement(transformation(extent={{120,-240},{140,-220}})));
  BaseClasses.ConvertRadiation conDirNorRad
    annotation (Placement(transformation(extent={{120,220},{140,240}})));
  BaseClasses.ConvertRadiation conGloHorRad
    annotation (Placement(transformation(extent={{120,180},{140,200}})));
  BaseClasses.ConvertRadiation conDifHorRad
    annotation (Placement(transformation(extent={{120,140},{140,160}})));
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
  Latitude latitude(final latitude=lat) "Latitude"
    annotation (Placement(transformation(extent={{-180,-280},{-160,-260}})));
  Longitude longitude(final longitude=lon) "Longitude"
    annotation (Placement(transformation(extent={{-140,-280},{-120,-260}})));

  //---------------------------------------------------------------------------
  // Optional instanciation of a block that computes the wet bulb temperature.
  // This block may be needed for evaporative cooling towers.
  // By default, it is enabled. This introduces a nonlinear equation, but
  // we have not observed an increase in computing time because of this equation.
  Buildings.Utilities.Psychrometrics.TWetBul_TDryBulPhi tWetBul_TDryBulXi(
      redeclare package Medium = Buildings.Media.Air,
      TDryBul(displayUnit="degC")) if computeWetBulbTemperature
    annotation (Placement(transformation(extent={{244,-66},{264,-46}})));

  //---------------------------------------------------------------------------
  // Conversion blocks for sky cover
  Modelica.Blocks.Math.Gain conTotSkyCov(final k=0.1) if
       totSkyCovSou == Buildings.BoundaryConditions.Types.DataSource.File
    "Convert sky cover from [0...10] to [0...1]"
    annotation (Placement(transformation(extent={{120,-40},{140,-20}})));
  Modelica.Blocks.Math.Gain conOpaSkyCov(final k=0.1) if
       opaSkyCovSou == Buildings.BoundaryConditions.Types.DataSource.File
    "Convert sky cover from [0...10] to [0...1]"
    annotation (Placement(transformation(extent={{120,-158},{140,-138}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.CheckBlackBodySkyTemperature cheTemBlaSky(TMin=0)
    "Check black body sky temperature"
    annotation (Placement(transformation(extent={{240,-260},{260,-240}})));

  // Blocks that are added in order to set the name of the output signal,
  // which then is displayed in the GUI of the weather data connector.
  block Latitude "Generate constant signal of type Real"
    extends Modelica.Blocks.Icons.Block;

    parameter Modelica.SIunits.Angle latitude "Latitude";

    Modelica.Blocks.Interfaces.RealOutput y(
      unit="rad",
      displayUnit="deg") "Latitude of the location"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  equation
    y = latitude;
    annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-81,32},{84,-24}},
          lineColor={0,0,0},
            textString="Latitude")}),
    Documentation(info="<html>
<p>
Block to output the latitude of the location.
This block is added so that the latitude is displayed
with a comment in the GUI of the weather bus connector.
</p>
<h4>Implementation</h4>
<p>
If
<a href=\"modelica://Modelica.Blocks.Sources.Constant\">
Modelica.Blocks.Sources.Constant</a> where used, then
the comment for the latitude would be \"Connector of Real output signal\".
As this documentation string cannot be overwritten, a new block
was implemented.
</p>
</html>", revisions="<html>
<ul>
<li>
January 4, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end Latitude;

  block Longitude "Generate constant signal of type Real"
    extends Modelica.Blocks.Icons.Block;

    parameter Modelica.SIunits.Angle longitude "Longitude";

    Modelica.Blocks.Interfaces.RealOutput y(
      unit="rad",
      displayUnit="deg") "Longitude of the location"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  equation
    y = longitude;
    annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-81,32},{84,-24}},
          lineColor={0,0,0},
            textString="Longitude")}),
    Documentation(info="<html>
<p>
Block to output the longitude of the location.
This block is added so that the longitude is displayed
with a comment in the GUI of the weather bus connector.
</p>
<h4>Implementation</h4>
<p>
If
<a href=\"modelica://Modelica.Blocks.Sources.Constant\">
Modelica.Blocks.Sources.Constant</a> where used, then
the comment for the longitude would be \"Connector of Real output signal\".
As this documentation string cannot be overwritten, a new block
was implemented.
</p>
</html>", revisions="<html>
<ul>
<li>
January 4, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end Longitude;

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
  // Select ceiling height connector
  if ceiHeiSou == Buildings.BoundaryConditions.Types.DataSource.Parameter then
    ceiHei_in_internal = ceiHei;
  elseif ceiHeiSou == Buildings.BoundaryConditions.Types.DataSource.Input then
    connect(ceiHei_in, ceiHei_in_internal);
  else
    connect(datRea.y[16], ceiHei_in_internal);
  end if;
   connect(ceiHei_in_internal, cheCeiHei.ceiHeiIn);

  //---------------------------------------------------------------------------
  // Select total sky cover connector
  if totSkyCovSou == Buildings.BoundaryConditions.Types.DataSource.Parameter then
    totSkyCov_in_internal = totSkyCov;
  elseif totSkyCovSou == Buildings.BoundaryConditions.Types.DataSource.Input then
    connect(totSkyCov_in, totSkyCov_in_internal);
  else
    connect(conTotSkyCov.u, datRea.y[13]) annotation (Line(
      points={{118,-30},{-59,-30}},
      color={0,0,127}));
    connect(conTotSkyCov.y, totSkyCov_in_internal);
  end if;
  connect(totSkyCov_in_internal, cheTotSkyCov.nIn);
  //---------------------------------------------------------------------------
  // Select opaque sky cover connector
  if opaSkyCovSou == Buildings.BoundaryConditions.Types.DataSource.Parameter then
    opaSkyCov_in_internal = opaSkyCov;
  elseif opaSkyCovSou == Buildings.BoundaryConditions.Types.DataSource.Input then
    connect(opaSkyCov_in, opaSkyCov_in_internal);
  else
    connect(conOpaSkyCov.u, datRea.y[14]) annotation (Line(
      points={{118,-148},{30,-148},{30,-30},{-59,-30}},
      color={0,0,127}));
    connect(conOpaSkyCov.y, opaSkyCov_in_internal);
  end if;
  connect(opaSkyCov_in_internal, cheOpaSkyCov.nIn);

  //---------------------------------------------------------------------------
  // Select dew point temperature connector
  if TDewPoiSou == Buildings.BoundaryConditions.Types.DataSource.Parameter then
    TDewPoi_in_internal = TDewPoi;
  elseif TDewPoiSou == Buildings.BoundaryConditions.Types.DataSource.Input then
    connect(TDewPoi_in, TDewPoi_in_internal);
  else
    connect(conTDewPoi.y, TDewPoi_in_internal);
  end if;
  connect(TDewPoi_in_internal, cheTemDewPoi.TIn);
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
  // Select sky black body temperature connector
  if TBlaSkySou == Buildings.BoundaryConditions.Types.DataSource.Parameter then
    TBlaSky_in_internal = TBlaSky;
  elseif TBlaSkySou == Buildings.BoundaryConditions.Types.DataSource.Input then
    connect(TBlaSky_in, TBlaSky_in_internal);
  else
    connect(TBlaSkyCom.TBlaSky, TBlaSky_in_internal);
  end if;
  connect(TBlaSky_in_internal, cheTemBlaSky.TIn);
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
  if HSou ==  Buildings.BoundaryConditions.Types.RadiationDataSource.Input_HGloHor_HDifHor or HSou == Buildings.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HGloHor then
    connect(HGloHor_in, HGloHor_in_internal)
      "Get HGloHor using user input file";
  elseif HSou == Buildings.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HDifHor then
     HDirNor_in_internal*cos(zenAng.zen)+HDifHor_in_internal = HGloHor_in_internal
      "Calculate the HGloHor using HDirNor and HDifHor according to (A.4.14) and (A.4.15)";
  else
    connect(conGloHorRad.HOut, HGloHor_in_internal)
      "Get HGloHor using weather data file";
  end if;
  connect(HGloHor_in_internal, cheGloHorRad.HIn);
  //---------------------------------------------------------------------------
  // Select diffuse horizontal radiation connector
  if HSou == Buildings.BoundaryConditions.Types.RadiationDataSource.Input_HGloHor_HDifHor or HSou == Buildings.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HDifHor then
     connect(HDifHor_in, HDifHor_in_internal)
      "Get HDifHor using user input file";
  elseif  HSou == Buildings.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HGloHor then
      HGloHor_in_internal - HDirNor_in_internal*cos(zenAng.zen) = HDifHor_in_internal
      "Calculate the HGloHor using HDirNor and HDifHor according to (A.4.14) and (A.4.15)";
  else
    connect(conDifHorRad.HOut, HDifHor_in_internal)
      "Get HDifHor using weather data file";
  end if;
  connect(HDifHor_in_internal, cheDifHorRad.HIn);
  //---------------------------------------------------------------------------
  // Select direct normal radiation connector
  if HSou == Buildings.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HGloHor or HSou == Buildings.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HDifHor then
     connect(HDirNor_in, HDirNor_in_internal)
      "Get HDirNor using user input file";
  elseif  HSou == Buildings.BoundaryConditions.Types.RadiationDataSource.Input_HGloHor_HDifHor then
      Buildings.Utilities.Math.Functions.smoothMin(
        solCon,
        (HGloHor_in_internal -HDifHor_in_internal)*
          Buildings.Utilities.Math.Functions.spliceFunction(
            x=cos(zenAng.zen),
            pos=Buildings.Utilities.Math.Functions.inverseXRegularized(cos(zenAng.zen),epsCos),
            neg=0,
            deltax=epsCos),
        0.1)
        = HDirNor_in_internal
      "Calculate the HDirNor using HGloHor and HDifHor according to (A.4.14) and (A.4.15)";
  else
    connect(conDirNorRad.HOut, HDirNor_in_internal)
      "Get HDirNor using weather data file";
  end if;
  connect(HDirNor_in_internal, cheDirNorRad.HIn);

  //---------------------------------------------------------------------------
  // Select infrared radiation connector
  if HInfHorSou == Buildings.BoundaryConditions.Types.DataSource.Parameter then
    HInfHor_in_internal = HInfHor;
  elseif HInfHorSou == Buildings.BoundaryConditions.Types.DataSource.Input then
    connect(HInfHor_in, HInfHor_in_internal);
  else
    connect(conHorRad.HOut, HInfHor_in_internal);
  end if;
  connect(HInfHor_in_internal, cheHorRad.HIn);

  connect(chePre.POut, weaBus.pAtm) annotation (Line(
      points={{181,70},{220,70},{220,0},{300,0}},
      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheTotSkyCov.nOut, weaBus.nTot) annotation (Line(
      points={{181,-30},{220,-30},{220,0},{300,0}},
      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheOpaSkyCov.nOut, weaBus.nOpa) annotation (Line(
      points={{181,-150},{220,-150},{220,0},{300,0}},
      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheGloHorRad.HOut, weaBus.HGloHor) annotation (Line(
      points={{181,190},{220,190},{220,0},{300,0}},
      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheDifHorRad.HOut, weaBus.HDifHor) annotation (Line(
      points={{181,150},{220,150},{220,0},{300,0}},
      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheDirNorRad.HOut, weaBus.HDirNor) annotation (Line(
      points={{181,230},{220,230},{220,0},{300,0}},
      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheCeiHei.ceiHeiOut, weaBus.celHei) annotation (Line(
      points={{181,-110},{220,-110},{220,0},{300,0}},
      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheWinSpe.winSpeOut, weaBus.winSpe) annotation (Line(
      points={{181,-70},{220,-70},{220,0},{300,0}},
      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheHorRad.HOut, weaBus.HHorIR) annotation (Line(
      points={{181,110},{220,110},{220,0},{300,0}},
      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheWinDir.nOut, weaBus.winDir) annotation (Line(
      points={{181,-270},{280,-270},{280,0},{300,0}},
      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheOpaSkyCov.nOut, TBlaSkyCom.nOpa) annotation (Line(
      points={{181,-150},{220,-150},{220,-213},{238,-213}},
      color={0,0,127}));
  connect(cheHorRad.HOut, TBlaSkyCom.HHorIR) annotation (Line(
      points={{181,110},{220,110},{220,-218},{238,-218}},
      color={0,0,127}));
  connect(modTim.y, weaBus.cloTim) annotation (Line(
      points={{-159,6.10623e-16},{34.75,6.10623e-16},{34.75,0},{124.5,0},{300,0}},
      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(modTim.y, add.u2) annotation (Line(
      points={{-159,0},{-150,0},{-150,184},{-142,184}},
      color={0,0,127}));
  connect(con30mins.y, add.u1) annotation (Line(
      points={{-159,222},{-150,222},{-150,196},{-142,196}},
      color={0,0,127}));
  connect(add.y, conTim1.modTim) annotation (Line(
      points={{-119,190},{-112,190}},
      color={0,0,127}));
  connect(conTim1.calTim, datRea1.u) annotation (Line(
      points={{-89,190},{-82,190}},
      color={0,0,127}));
  connect(modTim.y, locTim.cloTim) annotation (Line(
      points={{-159,6.10623e-16},{-150,6.10623e-16},{-150,-150},{-122,-150}},
      color={0,0,127}));
  connect(modTim.y, conTim.modTim) annotation (Line(
      points={{-159,6.10623e-16},{-150,6.10623e-16},{-150,-30},{-122,-30}},
      color={0,0,127}));
  connect(conTim.calTim, datRea.u) annotation (Line(
      points={{-99,-30},{-82,-30}},
      color={0,0,127}));
  connect(modTim.y, eqnTim.nDay) annotation (Line(
      points={{-159,6.10623e-16},{-150,6.10623e-16},{-150,-110},{-122,-110}},
      color={0,0,127}));
  connect(eqnTim.eqnTim, solTim.equTim) annotation (Line(
      points={{-99,-110},{-88,-110},{-88,-124},{-82,-124}},
      color={0,0,127}));
  connect(locTim.locTim, solTim.locTim) annotation (Line(
      points={{-99,-150},{-88,-150},{-88,-135.4},{-82,-135.4}},
      color={0,0,127}));
  connect(solTim.solTim, weaBus.solTim) annotation (Line(
      points={{-59,-130},{-20,-130},{-20,0},{284,0},{284,0},{300,
          0}},
      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(datRea.y[11], conWinDir.u) annotation (Line(
      points={{-59,-30},{20,-30},{20,-270},{118,-270}},
      color={0,0,127}));
  connect(cheTemDryBul.TOut, TBlaSkyCom.TDryBul) annotation (Line(
      points={{181,-190},{220,-190},{220,-202},{238,-202}},
      color={0,0,127}));
  connect(datRea.y[1], conTDryBul.u) annotation (Line(
      points={{-59,-30},{20,-30},{20,-190},{118,-190}},
      color={0,0,127}));
  connect(datRea.y[2], conTDewPoi.u) annotation (Line(
      points={{-59,-30},{20,-30},{20,-230},{118,-230}},
      color={0,0,127}));
  connect(cheTemDewPoi.TOut, weaBus.TDewPoi) annotation (Line(
      points={{181,-230},{280,-230},{280,0},{300,0}},
      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(TBlaSkyCom.TDewPoi, cheTemDewPoi.TOut) annotation (Line(
      points={{238,-207},{220,-207},{220,-230},{181,-230}},
      color={0,0,127}));
  connect(datRea1.y[2], conDirNorRad.HIn) annotation (Line(
      points={{-59,190},{20,190},{20,230},{118,230}},
      color={0,0,127}));
  connect(datRea1.y[1], conGloHorRad.HIn) annotation (Line(
      points={{-59,190},{-40,190},{20,190},{118,190}},
      color={0,0,127}));
  connect(datRea1.y[3], conDifHorRad.HIn) annotation (Line(
      points={{-59,190},{20,190},{20,150},{118,150}},
      color={0,0,127}));
  connect(conRelHum.relHumIn, datRea.y[3]) annotation (Line(
      points={{118,30},{20,30},{20,-30},{-59,-30}},
      color={0,0,127}));
  connect(cheRelHum.relHumOut, weaBus.relHum) annotation (Line(
      points={{181,30},{280,30},{280,0},{300,0}},
      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheTemDryBul.TOut, weaBus.TDryBul) annotation (Line(
      points={{181,-190},{280,-190},{280,0},{300,0}},
      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(decAng.decAng, zenAng.decAng)
                                  annotation (Line(
      points={{-119,-210},{-82,-210},{-82,-210.6}},
      color={0,0,127}));
  connect(solHouAng.solHouAng, zenAng.solHouAng)  annotation (Line(
      points={{-119,-240},{-100,-240},{-100,-220.8},{-82,-220.8}},
      color={0,0,127}));
  connect(solHouAng.solTim, solTim.solTim) annotation (Line(
      points={{-142,-240},{-154,-240},{-154,-172},{-20,-172},{-20,-130},{-59,-130}},
      color={0,0,127}));
  connect(decAng.nDay, modTim.y) annotation (Line(
      points={{-142,-210},{-150,-210},{-150,-180},{0,-180},{0,6.10623e-16},{
          -159,6.10623e-16}},
      color={0,0,127}));
  connect(zenAng.zen, altAng.zen) annotation (Line(
      points={{-59,-216},{-40,-216},{-40,-270},{-32,-270}},
      color={0,0,127}));

  // Connectors for wet bulb temperature.
  // These are removed if computeWetBulbTemperature = false
  connect(chePre.POut, tWetBul_TDryBulXi.p) annotation (Line(
      points={{181,70},{220,70},{220,-64},{243,-64}},
      color={0,0,127}));
  connect(tWetBul_TDryBulXi.TWetBul, weaBus.TWetBul) annotation (Line(
      points={{265,-56},{280,-56},{280,0},{292,0},{300,0}},
      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheTemDryBul.TOut, tWetBul_TDryBulXi.TDryBul) annotation (Line(
      points={{181,-190},{220,-190},{220,-48},{243,-48}},
      color={0,0,127}));
  connect(cheRelHum.relHumOut, tWetBul_TDryBulXi.phi) annotation (Line(
      points={{181,30},{208,30},{208,-56},{243,-56}},
      color={0,0,127}));

  connect(altAng.alt, weaBus.solAlt) annotation (Line(
      points={{-9,-270},{8,-270},{8,-290},{290,-290},{290,0},{300,0}},
      color={0,0,127}));
  connect(zenAng.zen, weaBus.solZen) annotation (Line(
      points={{-59,-216},{-40,-216},{-40,-290},{290,-290},{290,0},{300,0}},
      color={0,0,127}));
  connect(decAng.decAng, weaBus.solDec) annotation (Line(
      points={{-119,-210},{-110,-210},{-110,-208},{-100,-208},{-100,-290},{290,
          -290},{290,0},{300,0}},
      color={0,0,127}));
  connect(solHouAng.solHouAng, weaBus.solHouAng) annotation (Line(
      points={{-119,-240},{-108,-240},{-108,-238},{-100,-238},{-100,-290},{290,
          -290},{290,0},{300,0}},
      color={0,0,127}));
  connect(longitude.y, weaBus.lon) annotation (Line(
      points={{-119,-270},{-100,-270},{-100,-290},{290,-290},{290,0},{300,0}},
      color={0,0,127}));
  connect(latitude.y, weaBus.lat) annotation (Line(
      points={{-159,-270},{-150,-270},{-150,-290},{290,-290},{290,0},{300,0}},
      color={0,0,127}));
  connect(cheTemBlaSky.TOut, weaBus.TBlaSky) annotation (Line(points={{261,-250},
          {261,-250},{280,-250},{280,0},{300,0}}, color={0,0,127}));
  connect(datRea.y[26], conHorRad.HIn) annotation (Line(points={{-59,-30},{20,
          -30},{20,110},{118,110}}, color={0,0,127}));
  annotation (
    defaultComponentName="weaDat",
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-200,-200},{200,200}},
        initialScale=0.05), graphics={
        Rectangle(
          extent={{-200,200},{200,-200}},
          lineColor={124,142,255},
          fillColor={124,142,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-162,270},{138,230}},
          textString="%name",
          lineColor={0,0,255}),
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
        visible=(HSou ==  Buildings.BoundaryConditions.Types.RadiationDataSource.Input_HGloHor_HDifHor or HSou == Buildings.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HGloHor),
        extent={{-202,-88},{-112,-108}},
          lineColor={0,0,127},
          textString="HGloHor"),
        Text(visible=(HSou == Buildings.BoundaryConditions.Types.RadiationDataSource.Input_HGloHor_HDifHor or HSou == Buildings.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HDifHor),
        extent={{-202,-142},{-116,-164}},
          lineColor={0,0,127},
          textString="HDifHor"),
        Text(
        visible=(HSou == Buildings.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HGloHor or HSou == Buildings.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HDifHor),
        extent={{-200,-186},{-126,-214}},
          lineColor={0,0,127},
          textString="HDirNor"),
        Ellipse(
          extent={{-146,154},{28,-20}},
          lineColor={255,220,220},
          lineThickness=1,
          fillPattern=FillPattern.Sphere,
          fillColor={255,255,0}),
        Polygon(
          points={{104,76},{87.9727,12.9844},{88,12},{120,22},{148,20},{174,8},
              {192,-58},{148,-132},{20,-140},{-130,-136},{-156,-60},{-140,-6},{
              -92,-4},{-68.2109,-21.8418},{-68,-22},{-82,40},{-48,90},{44,110},
              {104,76}},
          lineColor={220,220,220},
          lineThickness=0.1,
          fillPattern=FillPattern.Sphere,
          smooth=Smooth.Bezier,
          fillColor={230,230,230})}),
    Documentation(info="<html>
<p>
This component reads TMY3 weather data (Wilcox and Marion, 2008) or user specified weather data.
The weather data format is the Typical Meteorological Year (TMY3)
as obtained from the EnergyPlus web site at
<a href=\"http://energyplus.net/weather\">
http://energyplus.net/weather</a>. These
data, which are in the EnergyPlus format, need to be converted as described
in the next paragraph.
</p>
<!-- ============================================== -->
<h4>Output to weaBus</h4>
<p>
The following variables serve as output and are accessible via <code>weaBus</code>:
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<!-- ============================================== -->
<tr>
  <th>Name
  </th>
  <th>Unit
  </th>
  <th>Description
  </th>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>HDifHor</code>
  </td>
  <td>
    W/m2
  </td>
  <td>
    Horizontal diffuse solar radiation.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>HDifNor</code>
  </td>
  <td>
    W/m2
  </td>
  <td>
    Direct normal radiation.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>HGloHor</code>
  </td>
  <td>
    W/m2
  </td>
  <td>
    Horizontal global radiation.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>HHorIR</code>
  </td>
  <td>
    W/m2
  </td>
  <td>
    Horizontal infrared irradiation.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>TBlaSky</code>
  </td>
  <td>
    K
  </td>
  <td>
    Output temperature.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>TDewPoi</code>
  </td>
  <td>
    K
  </td>
  <td>
    Dew point temperature.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>TDryBul</code>
  </td>
  <td>
    K
  </td>
  <td>
    Dry bulb temperature at ground level.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>TWetBul</code>
  </td>
  <td>
    K
  </td>
  <td>
    Wet bulb temperature.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>celHei</code>
  </td>
  <td>
    m
  </td>
  <td>
    Ceiling height.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>cloTim</code>
  </td>
  <td>
    s
  </td>
  <td>
    One-based day number in seconds.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>lat</code>
  </td>
  <td>
    rad
  </td>
  <td>
  Latitude of the location.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>lon</code>
  </td>
  <td>
    rad
  </td>
  <td>
  Longitude of the location.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>nOpa</code>
  </td>
  <td>
    1
  </td>
  <td>
  Opaque sky cover [0, 1].
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>nTot</code>
  </td>
  <td>
    1
  </td>
  <td>
   Total sky Cover [0, 1].
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>pAtm</code>
  </td>
  <td>
    Pa
  </td>
  <td>
    Atmospheric pressure.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>relHum</code>
  </td>
  <td>
    1
  </td>
  <td>
    Relative humidity.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>solAlt</code>
  </td>
  <td>
    rad
  </td>
  <td>
    Altitude angle.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>solDec</code>
  </td>
  <td>
    rad
  </td>
  <td>
    Declination angle.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>solHouAng</code>
  </td>
  <td>
    rad
  </td>
  <td>
    Solar hour angle.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>solTim</code>
  </td>
  <td>
    s
  </td>
  <td>
    Solar time.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>solZen</code>
  </td>
  <td>
    rad
  </td>
  <td>
    Zenith angle.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>winDir</code>
  </td>
  <td>
    rad
  </td>
  <td>
    Wind direction.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>winSpe</code>
  </td>
  <td>
    m/s
  </td>
  <td>
    Wind speed.
  </td>
</tr>
</table>
<!-- ============================================== -->
<h4>Adding new weather data</h4>
<p>
To add new weather data, proceed as follows:
</p>
<ol>
<li>
Download the weather data file with the <code>epw</code> extension from
<a href=\"http://energyplus.net/weather\">
http://energyplus.net/weather</a>.
</li>
<li>
Add the file to <code>Buildings/Resources/weatherdata</code> (or to any directory
for which you have write permission).
</li>
<li>
On a console window, type<pre>
  cd Buildings/Resources/weatherdata
  java -jar ../bin/ConvertWeatherData.jar inputFile.epw
</pre>
This will generate the weather data file <code>inputFile.mos</code>, which can be read
by the model
<a href=\"modelica://Buildings.BoundaryConditions.WeatherData.ReaderTMY3\">
Buildings.BoundaryConditions.WeatherData.ReaderTMY3</a>.
</li>
</ol>
<!-- ============================================== -->
<h4>Location data that are read automatically from the weather data file</h4>
<p>
The following location data are automatically read from the weather file:
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
<!-- ============================================== -->
<h4>Wet bulb temperature</h4>
<p>
By default, the data bus contains the wet bulb temperature.
This introduces a nonlinear equation.
However, we have not observed an increase in computing time because
of this equation.
To disable the computation of the wet bulb temperature, set
<code>computeWetBulbTemperature=false</code>.
</p>
<!-- ============================================== -->
<h4>Using constant or user-defined input signals for weather data</h4>
<p>
This model has the option of using a constant value, using the data from the weather file,
or using data from an input connector for the following variables:
</p>
<ul>
<li>
The atmospheric pressure,
</li>
<li>
the ceiling height,
</li>
<li>
the total sky cover pressure,
</li>
<li>
the opaque sky cover pressure,
</li>
<li>
the dry bulb temperature,
</li>
<li>
the dew point temperature,
</li>
<li>
the sky black body temperature,
</li>
<li>
the relative humidity,
</li>
<li>
the wind direction,
</li>
<li>
the wind speed,
</li>
<li>
the global horizontal radiation, direct normal and diffuse horizontal radiation,
and
</li>
<li>
the infrared horizontal radiation.
</li>
</ul>
<p>
By default, all data are obtained from the weather data file,
except for the atmospheric pressure, which is set to the
parameter <code>pAtm=101325</code> Pascals.
</p>
<p>
The parameter <code>*Sou</code> configures the source of the data.
For the atmospheric pressure, temperatures, relative humidity, wind speed and wind direction,
the enumeration
<a href=\"modelica://Buildings.BoundaryConditions.Types.DataSource\">
Buildings.BoundaryConditions.Types.DataSource</a>
is used as follows:
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<!-- ============================================== -->
<tr>
  <th>Parameter <code>*Sou</code>
  </th>
  <th>Data used to compute weather data.
  </th>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    File
  </td>
  <td>
    Use data from file.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    Parameter
  </td>
  <td>
    Use value specified by the parameter.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    Input
  </td>
  <td>
    Use value from the input connector.
  </td>
</tr>
</table>
<p>
Because global, diffuse and direct radiation are related to each other, the parameter
<code>HSou</code> is treated differently.
It is set to a value of the enumeration
<a href=\"modelica://Buildings.BoundaryConditions.Types.RadiationDataSource\">
Buildings.BoundaryConditions.Types.RadiationDataSource</a>,
and allows the following configurations:
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<!-- ============================================== -->
<tr>
  <th>Parameter <code>HSou</code>
  </th>
  <th>Data used to compute weather data.
  </th>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    File
  </td>
  <td>
    Use data from file.
  </td>
</tr>
<!-- ============================================== -->
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
<p>
<b>Notes</b>
</p>
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
</p>
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
</li>
<li>
The ReaderTMY3 should only be used with TMY3 data. It contains a time shift for solar radiation data
that is explained below. This time shift needs to be removed if the user may want to
use the ReaderTMY3 for other weather data types.
</li>
</ol>
<h4>Implementation</h4>
<h5>Start and end data for annual weather data files</h5>
<p>
The TMY3 weather data, as well as the EnergyPlus weather data, start at 1:00 AM
on January 1, and provide hourly data until midnight on December 31.
Thus, the first entry for temperatures, humidity, wind speed etc. are values
at 1:00 AM and not at midnight. Furthermore, the TMY3 weather data files can have
values at midnight of December 31 that may be significantly different from the values
at 1:00 AM on January 1.
Since annual simulations require weather data that start at 0:00 on January 1,
data need to be provided for this hour. Due to the possibly large change in
weatherdata between 1:00 AM on January 1 and midnight at December 31,
the weather data files in the Buildings library do not use the data entry from
midnight at December 31 as the value for <i>t=0</i>. Rather, the
value from 1:00 AM on January 1 is duplicated and used for 0:00 on January 1.
To maintain a data record with <i>8760</i> hours, the weather data record from
midnight at December 31 is deleted.
These changes in the weather data file are done in the Java program that converts
EnergyPlus weather data file to Modelica weather data files, and which is described
below.
</p>
<h5>Time shift for solar radiation data</h5>
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
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/BoundaryConditions/WeatherData/RadiationTimeShift.png\"
border=\"1\" />
</p>
<h4>References</h4>
<ul>
<li>
Wilcox S. and W. Marion. <i>Users Manual for TMY3 Data Sets</i>.
Technical Report, NREL/TP-581-43156, revised May 2008.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
December 4, 2017, by Michael Wetter:<br/>
Removed function call to <code>getAbsolutePath</code>, as this causes in Dymola 2018FD01
the error
\"A call of loadResource with a non-literal string remains in the generated code; it will not work for an URI.\"
when exporting <a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.ThermalZone\">
Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.ThermalZone</a>
as an FMU. Instead, if the weather file is specified as a Modelica, URI, syntax such as
<code>Modelica.Utilities.Files.loadResource(\"modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos\")</code>
should be used.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/867\">#867</a>.
</li>
<li>
February 18, 2017, by Filip Jorissen:<br/>
Infrared radiation on horizontal surface is now delayed by 30 minutes
such that the results in
<a href=\"modelica://Buildings.BoundaryConditions.SkyTemperature.Examples.BlackBody\">TBlaSky</a>
are consistent.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/648\">#648</a>.
</li>
<li>
December 06, 2016, by Thierry S. Nouidui:<br/>
Constrained the direct normal radiation to not be bigger than the solar constant when using
global and diffuse solar radiation data provided via the inputs connectors.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/608\">#608</a>.
</li>
<li>
April 21, 2016, by Michael Wetter:<br/>
Introduced <code>absFilNam</code> to avoid multiple calls to
<a href=\"modelica://Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath\">
Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath</a>.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/506\">Buildings, #506</a>.
</li>
<li>
January 6, 2016, by Moritz Lauster:<br/>
Changed output <code>radHorIR</code> to <code>HHorIR</code>.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/376\">#376</a>.
</li>
<li>
January 4, 2016, by Moritz Lauster:<br/>
Added a table in documentation with output variables accessible via <code>weaBus</code>.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/376\">#376</a>.
</li>
<li>
December 15, 2015, by Michael Wetter:<br/>
Added the block <code>cheTemBlaSky</code>. This also allows to graphically
connect the black body sky temperature to the weather bus, which is required
in Dymola 2016 for the variable <code>weaBus.TBlaSky</code> to appear
in the graphical editor.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/377\">#377</a>.
</li>
<li>
September 24, 2015, by Marcus Fuchs:<br/>
Replace Dymola specific annotation by <code>loadSelector</code>
for MSL compliancy as reported by @tbeu at
<a href=\"https://github.com/RWTH-EBC/AixLib/pull/107\">RWTH-EBC/AixLib#107</a>
</li>
<li>
June 6, 2015, by Michael Wetter:<br/>
Removed redundant but consistent
<code>connect(TBlaSkyCom.TBlaSky, weaBus.TBlaSky)</code>
statement.
This avoids a warning if
<a href=\"modelica://Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.Examples.SkyClearness\">
Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.Examples.SkyClearness</a>
is translated in pedantic mode in Dymola 2016.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/266\">#266</a>.
</li>
<li>
March 26, 2015, by Michael Wetter:<br/>
Added option to obtain the black body sky temperature
from a parameter or an input signal.
This is required for
<a href=\"modelica://Buildings.Rooms.Validation.MixedAirInitialization\">
Buildings.Rooms.Validation.MixedAirInitialization</a>.
</li>
<li>
October 17, 2014, by Michael Wetter:<br/>
Corrected error that led the total and opaque sky cover to be ten times
too low if its value was obtained from the parameter or the input connector.
For the standard configuration in which the sky cover is obtained from
the weather data file, the model was correct. This error only affected
the other two possible configurations.
</li>
<li>
September 12, 2014, by Michael Wetter:<br/>
Removed redundant connection <code>connect(conHorRad.HOut, cheHorRad.HIn);</code>.
</li>
<li>
May 30, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
May 5, 2013, by Thierry S. Nouidui:<br/>
Added the option to use a constant, an input signal or the weather file as the source
for the ceiling height, the total sky cover, the opaque sky cover, the dew point temperature,
and the infrared horizontal radiation <code>HInfHor</code>.
</li>
<li>
October 8, 2013, by Michael Wetter:<br/>
Improved the algorithm that determines the absolute path of the file.
Now weather files are searched in the path specified, and if not found, the urls
<code>file://</code>, <code>modelica://</code> and <code>modelica://Buildings</code>
are added in this order to search for the weather file.
This allows using the data reader without having to specify an absolute path,
as long as the <code>Buildings</code> library
is on the <code>MODELICAPATH</code>.
This change was implemented in
<a href=\"modelica://Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath\">
Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath</a>
and improves this weather data reader.
</li>
<li>
May 2, 2013, by Michael Wetter:<br/>
Added function call to <code>getAbsolutePath</code>.
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
<ol>
<li>
Added optional connectors for dry bulb temperature, relative humidity, wind speed, wind direction, global horizontal radiation, diffuse horizontal radiation.<br/>
</li>
<li>
Separate the unit conversion for TMY3 data and data validity check.
</li>
</ol>
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
    Diagram(coordinateSystem(preserveAspectRatio=false,
     extent={{-200,-300},{300,300}})));
end ReaderTMY3;
