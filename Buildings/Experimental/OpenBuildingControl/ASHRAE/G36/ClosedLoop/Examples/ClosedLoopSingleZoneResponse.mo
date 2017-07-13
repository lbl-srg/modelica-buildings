within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.ClosedLoop.Examples;
model ClosedLoopSingleZoneResponse
  "Example for SingleZoneVAV with a dry cooling coil, air-cooled chiller, electric heating coil, variable speed fan, and mixing box with G36 economizer."
  extends Modelica.Icons.Example;

  package MediumA = Buildings.Media.Air "Buildings library air media package";
  package MediumW = Buildings.Media.Water "Buildings library air media package";

  parameter Modelica.SIunits.Temperature TSupChi_nominal=279.15
    "Design value for chiller leaving water temperature";
  parameter Modelica.SIunits.Density meanAirDensity=1.204
    "Air density at t = 20C";
  parameter Integer numOcupants=10 "Number of occupants";

  Buildings.Air.Systems.SingleZone.VAV.ChillerDXHeatingEconomizer hvac(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    mAir_flow_nominal=0.75,
    etaHea_nominal=0.99,
    QHea_flow_nominal=7000,
    QCoo_flow_nominal=-7000,
    TSupChi_nominal=TSupChi_nominal)   "Single zone VAV system"
    annotation (Placement(transformation(extent={{0,-20},{40,20}})));
  Buildings.Air.Systems.SingleZone.VAV.Examples.BaseClasses.Room zon(
      mAir_flow_nominal=0.75,
      lat=weaDat.lat) "Thermal envelope of single zone"
    annotation (Placement(transformation(extent={{80,-20},{120,20}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
      computeWetBulbTemperature=false,
      filNam="modelica://Buildings/Resources/weatherdata/DRYCOLD.mos")
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Modelica.Blocks.Continuous.Integrator EFan "Total fan energy"
    annotation (Placement(transformation(extent={{80,-50},{100,-30}})));
  Modelica.Blocks.Continuous.Integrator EHea "Total heating energy"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));
  Modelica.Blocks.Continuous.Integrator ECoo "Total cooling energy"
    annotation (Placement(transformation(extent={{80,-110},{100,-90}})));
  Modelica.Blocks.Math.MultiSum EHVAC(nu=4)  "Total HVAC energy"
    annotation (Placement(transformation(extent={{120,-80},{140,-60}})));
  Modelica.Blocks.Continuous.Integrator EPum "Total pump energy"
    annotation (Placement(transformation(extent={{80,-140},{100,-120}})));

  Modelica.Blocks.Sources.CombiTimeTable TSetRooHea(
    table=[
      0,       15 + 273.15;
      8*3600,  20 + 273.15;
      18*3600, 15 + 273.15;
      24*3600, 15 + 273.15],
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Heating setpoint for room temperature"
    annotation (Placement(transformation(extent={{-200,0},{-180,20}})));
  Modelica.Blocks.Sources.CombiTimeTable TSetRooCoo(
    table=[
      0,       30 + 273.15;
      8*3600,  25 + 273.15;
      18*3600, 30 + 273.15;
      24*3600, 30 + 273.15],
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Cooling setpoint for room temperature"
    annotation (Placement(transformation(extent={{-200,-30},{-180,-10}})));

  BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-6,70},{14,90}})));

  CDL.Continuous.Constant airDensity(k=meanAirDensity) "Air density at 20C"
    annotation (Placement(transformation(extent={{-200,-120},{-180,-100}})));
  CDL.Continuous.Product massToVolume annotation (Placement(transformation(extent={{-160,-100},{-140,-80}})));
  Composite.EconomizerSingleZone economizer annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Atomic.HeatingCoolingControlLoops conLoo annotation (Placement(transformation(extent={{-140,60},{-120,80}})));
  Atomic.VAVSingleZoneTSupSet setPoiVAV annotation (Placement(transformation(extent={{-120,0},{-100,20}})));
  Atomic.OutdoorAirFlowSetpoint_SingleZone OutAirSetPoi_SinZon
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  CDL.Continuous.Constant numberOcupants(k=numOcupants) "Number of occupants"
    annotation (Placement(transformation(extent={{-120,-140},{-100,-120}})));
equation
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-20,80},{4,80}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));

  connect(hvac.supplyAir, zon.supplyAir) annotation (Line(points={{40,8},{50,8},{50,2},{80,2}},
                                   color={0,127,255}));
  connect(hvac.returnAir, zon.returnAir) annotation (Line(points={{40,0},{46,0},{46,-2},{50,-2},{80,-2}},
                                   color={0,127,255}));

  connect(hvac.weaBus, weaBus) annotation (Line(
      points={{4,17.8},{4,80}},
      color={255,204,51},
      thickness=0.5));
  connect(zon.weaBus, weaBus) annotation (Line(
      points={{86,18},{82,18},{82,80},{4,80}},
      color={255,204,51},
      thickness=0.5));

  connect(hvac.PFan, EFan.u) annotation (Line(points={{41,18},{64,18},{64,-40},{78,-40}},
                     color={0,0,127}));
  connect(hvac.QHea_flow, EHea.u) annotation (Line(points={{41,16},{62,16},{62,-70},{78,-70}},
                     color={0,0,127}));
  connect(hvac.PCoo, ECoo.u) annotation (Line(points={{41,14},{60,14},{60,-100},{78,-100}},
                     color={0,0,127}));
  connect(hvac.PPum, EPum.u) annotation (Line(points={{41,12},{58,12},{58,-130},{78,-130}},
                       color={0,0,127}));

  connect(EFan.y, EHVAC.u[1]) annotation (Line(points={{101,-40},{110,-40},{110,-64.75},{120,-64.75}},
                                color={0,0,127}));
  connect(EHea.y, EHVAC.u[2])
    annotation (Line(points={{101,-70},{120,-70},{120,-68.25}},
                                                             color={0,0,127}));
  connect(ECoo.y, EHVAC.u[3]) annotation (Line(points={{101,-100},{110,-100},{110,-71.75},{120,-71.75}},
                                color={0,0,127}));
  connect(EPum.y, EHVAC.u[4]) annotation (Line(points={{101,-130},{114,-130},{114,-75.25},{120,-75.25}},
                                color={0,0,127}));
  annotation (
    experiment(
      StopTime=504800,
      Interval=3600,
      Tolerance=1e-06),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Air/Systems/SingleZone/VAV/Examples/ChillerDXHeatingEconomizer.mos"
        "Simulate and plot"),
     Documentation(info="<html>
<p>
The thermal zone is based on the BESTEST Case 600 envelope, while the HVAC
system is based on a conventional VAV system with air cooled chiller and
economizer.  See documentation for the specific models for more information.
</p>
</html>", revisions="<html>
<ul>
<li>
June 21, 2017, by Michael Wetter:<br/>
Refactored implementation.
</li>
<li>
June 1, 2017, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-220,-160},{160,160}})));
end ClosedLoopSingleZoneResponse;
