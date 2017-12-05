within Buildings.Air.Systems.SingleZone.VAV.Examples;
model ChillerDXHeatingEconomizer
  "Example for SingleZoneVAV with a dry cooling coil, air-cooled chiller, electric heating coil, variable speed fan, and mixing box with economizer."
  extends Modelica.Icons.Example;

  package MediumA = Buildings.Media.Air "Buildings library air media package";
  package MediumW = Buildings.Media.Water "Buildings library air media package";

  parameter Modelica.SIunits.Temperature TSupChi_nominal=279.15
    "Design value for chiller leaving water temperature";

  ChillerDXHeatingEconomizerController con(
    minOAFra=0.2,
    kFan=4,
    kEco=4,
    kHea=4,
    TSupChi_nominal=TSupChi_nominal,
    TSetSupAir=286.15)
   "Controller"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Air.Systems.SingleZone.VAV.ChillerDXHeatingEconomizer hvac(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    mAir_flow_nominal=0.75,
    etaHea_nominal=0.99,
    QHea_flow_nominal=7000,
    QCoo_flow_nominal=-7000,
    TSupChi_nominal=TSupChi_nominal)   "Single zone VAV system"
    annotation (Placement(transformation(extent={{-40,-20},{0,20}})));
  Buildings.Air.Systems.SingleZone.VAV.Examples.BaseClasses.Room zon(
      mAir_flow_nominal=0.75,
      lat=weaDat.lat) "Thermal envelope of single zone"
    annotation (Placement(transformation(extent={{40,-20},{80,20}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
      computeWetBulbTemperature=false,
      filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/DRYCOLD.mos"))
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.Blocks.Continuous.Integrator EFan "Total fan energy"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  Modelica.Blocks.Continuous.Integrator EHea "Total heating energy"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  Modelica.Blocks.Continuous.Integrator ECoo "Total cooling energy"
    annotation (Placement(transformation(extent={{40,-110},{60,-90}})));
  Modelica.Blocks.Math.MultiSum EHVAC(nu=4)  "Total HVAC energy"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));
  Modelica.Blocks.Continuous.Integrator EPum "Total pump energy"
    annotation (Placement(transformation(extent={{40,-140},{60,-120}})));

  Modelica.Blocks.Sources.CombiTimeTable TSetRooHea(
    table=[
      0,       15 + 273.15;
      8*3600,  20 + 273.15;
      18*3600, 15 + 273.15;
      24*3600, 15 + 273.15],
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Heating setpoint for room temperature"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));
  Modelica.Blocks.Sources.CombiTimeTable TSetRooCoo(
    table=[
      0,       30 + 273.15;
      8*3600,  25 + 273.15;
      18*3600, 30 + 273.15;
      24*3600, 30 + 273.15],
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Cooling setpoint for room temperature"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));

  BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-46,70},{-26,90}})));

equation
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-60,80},{-36,80}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));

  connect(con.yFan, hvac.uFan) annotation (Line(points={{-79,9},{-60,9},{-60,18},
          {-42,18}},               color={0,0,127}));
  connect(con.yHea, hvac.uHea) annotation (Line(points={{-79,6},{-40,6},{-56,6},
          {-56,12},{-42,12}},        color={0,0,127}));
  connect(con.yCooCoiVal, hvac.uCooVal) annotation (Line(points={{-79,0},{-54,0},
          {-54,5},{-42,5}},             color={0,0,127}));
  connect(con.yOutAirFra, hvac.uEco) annotation (Line(points={{-79,3},{-50,3},{
          -50,-2},{-42,-2}},             color={0,0,127}));
  connect(hvac.chiOn, con.chiOn) annotation (Line(points={{-42,-10},{-60,-10},{
          -60,-4},{-79,-4}},                                color={255,0,255}));
  connect(con.TSetSupChi, hvac.TSetChi) annotation (Line(points={{-79,-8},{-70,
          -8},{-70,-15},{-42,-15}},           color={0,0,127}));
  connect(con.TMix, hvac.TMixAir) annotation (Line(points={{-102,2},{-112,2},{
          -112,-40},{10,-40},{10,-4},{1,-4}},             color={0,0,127}));

  connect(hvac.supplyAir, zon.supplyAir) annotation (Line(points={{0,8},{10,8},
          {10,2},{40,2}},          color={0,127,255}));
  connect(hvac.returnAir, zon.returnAir) annotation (Line(points={{0,0},{6,0},{
          6,-2},{10,-2},{40,-2}},  color={0,127,255}));


  connect(con.TOut, weaBus.TDryBul) annotation (Line(points={{-102,-2},{-108,-2},
          {-108,40},{-36,40},{-36,80}}, color={0,0,127}));
  connect(hvac.weaBus, weaBus) annotation (Line(
      points={{-36,17.8},{-36,80}},
      color={255,204,51},
      thickness=0.5));
  connect(zon.weaBus, weaBus) annotation (Line(
      points={{46,18},{42,18},{42,80},{-36,80}},
      color={255,204,51},
      thickness=0.5));
  connect(con.TSup, hvac.TSup) annotation (Line(points={{-102,-9},{-108,-9},{
          -108,-32},{4,-32},{4,-7},{1,-7}},
        color={0,0,127}));
  connect(con.TRoo, zon.TRooAir) annotation (Line(points={{-102,-6},{-110,-6},{
          -110,-36},{6,-36},{6,-22},{90,-22},{90,0},{81,0}},      color={0,0,
          127}));

  connect(TSetRooHea.y[1], con.TSetRooHea)
    annotation (Line(points={{-119,10},{-102,10}}, color={0,0,127}));
  connect(TSetRooCoo.y[1], con.TSetRooCoo)
    annotation (Line(points={{-119,-20},{-116,-20},{-116,6},{-102,6}}, color={0,0,127}));

  connect(hvac.PFan, EFan.u) annotation (Line(points={{1,18},{24,18},{24,-40},{
          38,-40}},  color={0,0,127}));
  connect(hvac.QHea_flow, EHea.u) annotation (Line(points={{1,16},{22,16},{22,
          -70},{38,-70}},
                     color={0,0,127}));
  connect(hvac.PCoo, ECoo.u) annotation (Line(points={{1,14},{20,14},{20,-100},
          {38,-100}},color={0,0,127}));
  connect(hvac.PPum, EPum.u) annotation (Line(points={{1,12},{18,12},{18,-130},{
          38,-130}},   color={0,0,127}));

  connect(EFan.y, EHVAC.u[1]) annotation (Line(points={{61,-40},{70,-40},{70,
          -64.75},{80,-64.75}}, color={0,0,127}));
  connect(EHea.y, EHVAC.u[2])
    annotation (Line(points={{61,-70},{80,-70},{80,-68.25}}, color={0,0,127}));
  connect(ECoo.y, EHVAC.u[3]) annotation (Line(points={{61,-100},{70,-100},{70,
          -71.75},{80,-71.75}}, color={0,0,127}));
  connect(EPum.y, EHVAC.u[4]) annotation (Line(points={{61,-130},{74,-130},{74,
          -75.25},{80,-75.25}}, color={0,0,127}));
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
    Diagram(coordinateSystem(extent={{-160,-160},{120,140}})));
end ChillerDXHeatingEconomizer;
