within Buildings.Controls.OBC.Utilities.Examples;
model OptimalStartSZ
  extends Modelica.Icons.Example;
  package MediumA = Buildings.Media.Air "Buildings library air media package";
  package MediumW = Buildings.Media.Water "Buildings library air media package";

  parameter Modelica.SIunits.Temperature TSupChi_nominal=279.15
    "Design value for chiller leaving water temperature";
  parameter Modelica.SIunits.Angle lat=41.98*3.14159/180;
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
    Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{-60,74},{-40,94}})));
  BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{8,50},{48,90}}),     iconTransformation(extent=
            {{-250,-2},{-230,18}})));
  Modelica.Blocks.Sources.CombiTimeTable TSetRooHea(
    table=[0,15 + 273.15; 8*3600,20 + 273.15; 18*3600,15 + 273.15; 24*3600,15 +
        273.15],
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Heating setpoint for room temperature"
    annotation (Placement(transformation(extent={{-188,60},{-168,80}})));
  Modelica.Blocks.Sources.CombiTimeTable TSetRooCoo(
    table=[0,30 + 273.15; 8*3600,25 + 273.15; 18*3600,30 + 273.15; 24*3600,30 +
        273.15],
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Cooling setpoint for room temperature"
    annotation (Placement(transformation(extent={{-188,20},{-168,40}})));
  Air.Systems.SingleZone.VAV.ChillerDXHeatingEconomizer hvac(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    mAir_flow_nominal=0.75,
    etaHea_nominal=0.99,
    QHea_flow_nominal=7000,
    QCoo_flow_nominal=-7000,
    TSupChi_nominal=TSupChi_nominal)   "Single zone VAV system"
    annotation (Placement(transformation(extent={{0,20},{40,60}})));
  Buildings.Controls.OBC.Utilities.Examples.BaseClasses.ChillerDXHeatingEconomizerController
    con(
    minOAFra=0.2,
    kFan=4,
    kEco=4,
    kHea=4,
    TSupChi_nominal=TSupChi_nominal,
    TSetSupAir=286.15) "Controller"
    annotation (Placement(transformation(extent={{-56,30},{-36,50}})));
  Buildings.Controls.OBC.Utilities.Examples.BaseClasses.SingleZoneFloor
    singleZoneFloor(redeclare package Medium = MediumA, lat=lat)
    annotation (Placement(transformation(extent={{56,24},{96,64}})));
  Buildings.Controls.OBC.Utilities.OptimalStart optStaHea(heating_only=true,
      cooling_only=false) "Heating only case"
    annotation (Placement(transformation(extent={{-148,-50},{-128,-30}})));
  CDL.Continuous.Add add1(final k1=+1, final k2=-1)
    "Calculate differential between time-to-next-occupancy and the cool-down time"
    annotation (Placement(transformation(extent={{-114,-70},{-94,-50}})));
  CDL.Continuous.Hysteresis hysHea(
    pre_y_start=false,
    uHigh=0,
    uLow=-60) "Hysteresis to activate the preheat mode"
    annotation (Placement(transformation(extent={{-84,-70},{-64,-50}})));
  SetPoints.OccupancySchedule occSch(occupancy=3600*{8,18})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{-148,-80},{-128,-60}})));
  Buildings.Controls.OBC.Utilities.OptimalStart optStaCoo(cooling_only=true)
    annotation (Placement(transformation(extent={{-148,-10},{-128,10}})));
  CDL.Continuous.Add add2(final k1=+1, final k2=-1)
    "Calculate differential between time-to-next-occupancy and the cool-down time"
    annotation (Placement(transformation(extent={{-114,-30},{-94,-10}})));
  CDL.Continuous.Hysteresis hysCoo(
    pre_y_start=false,
    uHigh=0,
    uLow=-60) "Hysteresis to activate the cool-down mode"
    annotation (Placement(transformation(extent={{-84,-30},{-64,-10}})));
  Modelica.Blocks.Sources.Constant TSetHeaOn(k=20 + 273.15)
    "Zone heating setpoint during occupied period"
    annotation (Placement(transformation(extent={{-196,-60},{-176,-40}})));
  Modelica.Blocks.Sources.Constant TSetCooOn(k=24 + 273.15)
    "Zone cooling setpoint during occupied time"
    annotation (Placement(transformation(extent={{-196,-20},{-176,0}})));
equation
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-40,84},{28,84},{28,70}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(con.yCooCoiVal,hvac. uCooVal) annotation (Line(points={{-35,40},{-10,
          40},{-10,45},{-2,45}},
                            color={0,0,127}));
  connect(hvac.uEco,con. yOutAirFra) annotation (Line(points={{-2,38},{-14,38},
          {-14,43},{-35,43}},
                            color={0,0,127}));
  connect(con.chiOn,hvac. chiOn) annotation (Line(points={{-35,36},{-16,36},{
          -16,30},{-2,30}},color={255,0,255}));
  connect(hvac.TSetChi,con. TSetSupChi) annotation (Line(points={{-2,25},{-2,24},
          {-20,24},{-20,32},{-35,32}},                 color={0,0,127}));
  connect(con.yFan, hvac.uFan) annotation (Line(points={{-35,49},{-26,49},{-26,
          58},{-2,58}},
                     color={0,0,127}));
  connect(con.yHea, hvac.uHea) annotation (Line(points={{-35,46},{-20,46},{-20,
          52},{-2,52}},
                     color={0,0,127}));
  connect(TSetRooHea.y[1], con.TSetRooHea) annotation (Line(points={{-167,70},{
          -120,70},{-120,50},{-58,50}},
                                    color={0,0,127}));
  connect(TSetRooCoo.y[1], con.TSetRooCoo) annotation (Line(points={{-167,30},{
          -120,30},{-120,46},{-58,46}},
                                    color={0,0,127}));
  connect(weaBus.TDryBul, con.TOut) annotation (Line(
      points={{28,70},{-80,70},{-80,38},{-58,38}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(hvac.TMix, con.TMix) annotation (Line(points={{41,36},{48,36},{48,14},
          {-68,14},{-68,42},{-58,42}},    color={0,0,127}));
  connect(hvac.TSup, con.TSup) annotation (Line(points={{41,32},{46,32},{46,16},
          {-64,16},{-64,31},{-58,31}},    color={0,0,127}));
  connect(weaDat.weaBus, hvac.weaBus) annotation (Line(
      points={{-40,84},{4,84},{4,57.8}},
      color={255,204,51},
      thickness=0.5));
  connect(singleZoneFloor.TRooAir, con.TRoo) annotation (Line(points={{93,54},{
          110,54},{110,12},{-80,12},{-80,34},{-58,34}}, color={0,0,127}));
  connect(hvac.returnAir, singleZoneFloor.returnAir) annotation (Line(points={{40,40},
          {52,40},{52,31},{63.2,31}},      color={0,127,255}));
  connect(weaBus, singleZoneFloor.weaBus) annotation (Line(
      points={{28,70},{63,70},{63,60.8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(add1.y, hysHea.u)
    annotation (Line(points={{-92,-60},{-86,-60}}, color={0,0,127}));
  connect(optStaHea.tOpt, add1.u1) annotation (Line(points={{-126,-40},{-118,
          -40},{-118,-54},{-116,-54}}, color={0,0,127}));
  connect(occSch.tNexOcc, add1.u2) annotation (Line(points={{-127,-64},{-120,
          -64},{-120,-66},{-116,-66}}, color={0,0,127}));
  connect(singleZoneFloor.TRooAir, optStaHea.TZon) annotation (Line(points={{93,54},
          {110,54},{110,-88},{-160,-88},{-160,-40},{-150,-40}},     color={0,0,
          127}));
  connect(optStaCoo.TZon, optStaHea.TZon) annotation (Line(points={{-150,0},{
          -160,0},{-160,-40},{-150,-40}}, color={0,0,127}));
  connect(occSch.tNexOcc, add2.u2) annotation (Line(points={{-127,-64},{-120,
          -64},{-120,-26},{-116,-26}}, color={0,0,127}));
  connect(optStaCoo.tOpt, add2.u1) annotation (Line(points={{-126,0},{-120,0},{
          -120,-14},{-116,-14}}, color={0,0,127}));
  connect(add2.y, hysCoo.u)
    annotation (Line(points={{-92,-20},{-86,-20}}, color={0,0,127}));
  connect(hysCoo.y, con.u3) annotation (Line(points={{-62,-20},{-50,-20},{-50,
          28}}, color={255,0,255}));
  connect(hysHea.y, con.u2) annotation (Line(points={{-62,-60},{-54,-60},{-54,
          28}}, color={255,0,255}));
  connect(hvac.supplyAir, singleZoneFloor.supplyAir) annotation (Line(points={{
          40,48},{56,48},{56,34},{63.2,34}}, color={0,127,255}));
  connect(TSetHeaOn.y, optStaHea.TSetZonHea) annotation (Line(points={{-175,-50},
          {-168,-50},{-168,-32},{-150,-32}}, color={0,0,127}));
  connect(TSetCooOn.y, optStaCoo.TSetZonCoo) annotation (Line(points={{-175,-10},
          {-156,-10},{-156,-8},{-150,-8}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-100},{120,100}})),
    experiment(
      StopTime=604800,
      Interval=3600.00288,
      Tolerance=1e-06),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Air/Systems/SingleZone/VAV/Examples/Guideline36.mos"
        "Simulate and plot"),
      Documentation(info="<html>
<p>
Implementation of <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Examples.BaseClasses.PartialOpenLoop\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Examples.BaseClasses.PartialOpenLoop</a>
with ASHRAE Guideline 36 control sequence.
</p>
</html>", revisions="<html>
<ul>
<li>
July 29, 2019, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
end OptimalStartSZ;
