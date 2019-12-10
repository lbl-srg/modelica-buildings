within Buildings.Controls.OBC.Utilities.Examples;
model OptimalStartSZ
  extends Modelica.Icons.Example;
  package MediumA = Buildings.Media.Air "Buildings library air media package";
  package MediumW = Buildings.Media.Water "Buildings library air media package";
  parameter Modelica.SIunits.Temperature TSupChi_nominal=279.15
    "Design value for chiller leaving water temperature";
  parameter Modelica.SIunits.Angle lat=41.98*3.14159/180 "Latitude of the site location";
  parameter Modelica.SIunits.Volume VRoo = 4555.7 "Space volume of the floor";
  parameter Modelica.SIunits.MassFlowRate mAir_flow_nominal = VRoo*4.2*1.2/3600
    "Design air flow rate";
  parameter Modelica.SIunits.HeatFlowRate QHea_flow_nominal = mAir_flow_nominal*1006*(16.7 - 8.5)
    "Design heating flow rate";
  parameter Modelica.SIunits.HeatFlowRate QCoo_flow_nominal = -QHea_flow_nominal
    "Design cooling flow rate";
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
    Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{136,30},{176,70}}),  iconTransformation(extent=
            {{-250,-2},{-230,18}})));
  Modelica.Blocks.Sources.CombiTimeTable TSetRooHea(
    table=[0,15 + 273.15; 8*3600,20 + 273.15; 18*3600,15 + 273.15; 24*3600,15 +
        273.15],
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Heating setpoint for room temperature"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.CombiTimeTable TSetRooCoo(
    table=[0,30 + 273.15; 8*3600,24 + 273.15; 18*3600,30 + 273.15; 24*3600,30 +
        273.15],
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Cooling setpoint for room temperature"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Air.Systems.SingleZone.VAV.ChillerDXHeatingEconomizer hvac(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    mAir_flow_nominal=mAir_flow_nominal,
    etaHea_nominal=0.99,
    QHea_flow_nominal=QHea_flow_nominal,
    QCoo_flow_nominal=QCoo_flow_nominal,
    TSupChi_nominal=TSupChi_nominal)   "Single zone VAV system"
    annotation (Placement(transformation(extent={{128,0},{168,40}})));
  Air.Systems.SingleZone.VAV.ChillerDXHeatingEconomizerController
    con(
    minOAFra=0.2,
    kFan=4,
    kEco=4,
    kHea=4,
    TSupChi_nominal=TSupChi_nominal,
    TSetSupAir=286.15) "Controller"
    annotation (Placement(transformation(extent={{72,10},{92,30}})));
  Buildings.Controls.OBC.Utilities.Examples.BaseClasses.SingleZoneFloor
    singleZoneFloor(redeclare package Medium = MediumA, lat=lat)
    annotation (Placement(transformation(extent={{184,4},{224,44}})));
  Buildings.Controls.OBC.Utilities.OptimalStart optStaHea(heating_only=true,
      cooling_only=false) "Heating only case"
    annotation (Placement(transformation(extent={{-180,20},{-160,40}})));
  CDL.Continuous.Add add1(final k1=+1, final k2=-1)
    "Calculate differential between time-to-next-occupancy and the cool-down time"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));
  CDL.Continuous.Hysteresis hysHea(
    pre_y_start=false,
    uHigh=0,
    uLow=-60) "Hysteresis to activate the preheat mode"
    annotation (Placement(transformation(extent={{-110,20},{-90,40}})));
  SetPoints.OccupancySchedule occSch(occupancy=3600*{8,18})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{-180,-60},{-160,-40}})));
  Buildings.Controls.OBC.Utilities.OptimalStart optStaCoo(cooling_only=true)
    annotation (Placement(transformation(extent={{-180,-20},{-160,0}})));
  CDL.Continuous.Add add2(final k1=+1, final k2=-1)
    "Calculate differential between time-to-next-occupancy and the cool-down time"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
  CDL.Continuous.Hysteresis hysCoo(
    pre_y_start=false,
    uHigh=0,
    uLow=-60) "Hysteresis to activate the cool-down mode"
    annotation (Placement(transformation(extent={{-110,-20},{-90,0}})));
  Modelica.Blocks.Sources.Constant TSetHeaOn(k=20 + 273.15)
    "Zone heating setpoint during occupied period"
    annotation (Placement(transformation(extent={{-220,22},{-200,42}})));
  Modelica.Blocks.Sources.Constant TSetCooOn(k=24 + 273.15)
    "Zone cooling setpoint during occupied time"
    annotation (Placement(transformation(extent={{-220,-20},{-200,0}})));
  CDL.Continuous.Gain gai(k=-6)
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  CDL.Conversions.BooleanToReal booToRea
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  CDL.Conversions.BooleanToReal booToRea1
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  CDL.Continuous.Gain gai1(k=5)
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  CDL.Continuous.Add add3(final k1=+1, final k2=+1)
    "Calculate differential between time-to-next-occupancy and the cool-down time"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  CDL.Continuous.Add add4(final k1=+1, final k2=+1)
    "Calculate differential between time-to-next-occupancy and the cool-down time"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
equation
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{80,70},{156,70},{156,50}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(con.yCooCoiVal,hvac. uCooVal) annotation (Line(points={{93,20},{118,20},
          {118,25},{126,25}},
                            color={0,0,127}));
  connect(hvac.uEco,con. yOutAirFra) annotation (Line(points={{126,18},{114,18},
          {114,23},{93,23}},color={0,0,127}));
  connect(con.chiOn,hvac. chiOn) annotation (Line(points={{93,16},{112,16},{112,
          10},{126,10}},   color={255,0,255}));
  connect(hvac.TSetChi,con. TSetSupChi) annotation (Line(points={{126,5},{126,4},
          {108,4},{108,12},{93,12}},                   color={0,0,127}));
  connect(con.yFan, hvac.uFan) annotation (Line(points={{93,29},{102,29},{102,38},
          {126,38}}, color={0,0,127}));
  connect(con.yHea, hvac.uHea) annotation (Line(points={{93,26},{108,26},{108,32},
          {126,32}}, color={0,0,127}));
  connect(weaBus.TDryBul, con.TOut) annotation (Line(
      points={{156,50},{48,50},{48,18},{70,18}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(hvac.TMix, con.TMix) annotation (Line(points={{169,16},{176,16},{176,-6},
          {60,-6},{60,22},{70,22}},       color={0,0,127}));
  connect(hvac.TSup, con.TSup) annotation (Line(points={{169,12},{174,12},{174,-4},
          {64,-4},{64,11},{70,11}},       color={0,0,127}));
  connect(weaDat.weaBus, hvac.weaBus) annotation (Line(
      points={{80,70},{132,70},{132,37.8}},
      color={255,204,51},
      thickness=0.5));
  connect(hvac.returnAir, singleZoneFloor.returnAir) annotation (Line(points={{168,20},
          {180,20},{180,11.4},{191.6,11.4}},
                                           color={0,127,255}));
  connect(weaBus, singleZoneFloor.weaBus) annotation (Line(
      points={{156,50},{195,50},{195,41}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(add1.y, hysHea.u)
    annotation (Line(points={{-118,30},{-112,30}}, color={0,0,127}));
  connect(optStaCoo.tOpt, add2.u1) annotation (Line(points={{-158,-10},{-146,-10},
          {-146,-4},{-142,-4}},  color={0,0,127}));
  connect(add2.y, hysCoo.u)
    annotation (Line(points={{-118,-10},{-112,-10}},
                                                   color={0,0,127}));
  connect(hvac.supplyAir, singleZoneFloor.supplyAir) annotation (Line(points={{168,28},
          {184,28},{184,15.4},{191.6,15.4}}, color={0,127,255}));
  connect(TSetHeaOn.y, optStaHea.TSetZonHea) annotation (Line(points={{-199,32},
          {-194,32},{-194,38},{-182,38}},    color={0,0,127}));
  connect(TSetCooOn.y, optStaCoo.TSetZonCoo) annotation (Line(points={{-199,-10},
          {-192,-10},{-192,-18},{-182,-18}},
                                           color={0,0,127}));
  connect(hysCoo.y, booToRea.u)
    annotation (Line(points={{-88,-10},{-82,-10}},
                                                 color={255,0,255}));
  connect(booToRea.y, gai.u)
    annotation (Line(points={{-58,-10},{-42,-10}},
                                                 color={0,0,127}));
  connect(hysHea.y, booToRea1.u)
    annotation (Line(points={{-88,30},{-82,30}}, color={255,0,255}));
  connect(booToRea1.y, gai1.u)
    annotation (Line(points={{-58,30},{-42,30}}, color={0,0,127}));
  connect(optStaHea.tOpt, add1.u1) annotation (Line(points={{-158,30},{-154,30},
          {-154,36},{-142,36}}, color={0,0,127}));
  connect(gai1.y, add4.u2) annotation (Line(points={{-18,30},{-12,30},{-12,24},{
          -2,24}},  color={0,0,127}));
  connect(TSetRooHea.y[1], add4.u1) annotation (Line(points={{-59,70},{-16,70},{
          -16,36},{-2,36}},  color={0,0,127}));
  connect(gai.y, add3.u1) annotation (Line(points={{-18,-10},{-16,-10},{-16,-4},
          {-2,-4}},color={0,0,127}));
  connect(TSetRooCoo.y[1], add3.u2) annotation (Line(points={{-59,-50},{-14,-50},
          {-14,-16},{-2,-16}},
                           color={0,0,127}));
  connect(occSch.tNexOcc, add1.u2) annotation (Line(points={{-159,-44},{-152,-44},
          {-152,24},{-142,24}},      color={0,0,127}));
  connect(occSch.tNexOcc, add2.u2) annotation (Line(points={{-159,-44},{-152,-44},
          {-152,-16},{-142,-16}},  color={0,0,127}));
  connect(add4.y, con.TSetRooHea)
    annotation (Line(points={{22,30},{70,30}}, color={0,0,127}));
  connect(add3.y, con.TSetRooCoo) annotation (Line(points={{22,-10},{32,-10},{32,
          26},{70,26}}, color={0,0,127}));
  connect(singleZoneFloor.TRooAir, con.TRoo) annotation (Line(points={{221,34.2},
          {230,34.2},{230,-20},{52,-20},{52,14},{70,14}},
                                                      color={0,0,127}));
  connect(singleZoneFloor.TRooAir, optStaHea.TZon) annotation (Line(points={{221,
          34.2},{230,34.2},{230,-76},{-188,-76},{-188,30},{-182,30}},     color=
         {0,0,127}));
  connect(singleZoneFloor.TRooAir, optStaCoo.TZon) annotation (Line(points={{221,
          34.2},{230,34.2},{230,-76},{-188,-76},{-188,-10},{-182,-10}},   color=
         {0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-240,-100},{240,
            100}})),
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
