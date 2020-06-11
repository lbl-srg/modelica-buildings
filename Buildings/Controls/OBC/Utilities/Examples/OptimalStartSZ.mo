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
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
    Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{30,60},{50,80}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather bus" annotation (Placement(
        transformation(extent={{106,28},{146,68}}),  iconTransformation(extent=
            {{-250,-2},{-230,18}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable TSetRooHea(
    table=[0,15 + 273.15; 8*3600,20 + 273.15; 18*3600,15 + 273.15; 24*3600,15 +
        273.15],
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Heating setpoint for room temperature"
    annotation (Placement(transformation(extent={{-110,60},{-90,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable TSetRooCoo(
    table=[0,30 + 273.15; 8*3600,24 + 273.15; 18*3600,30 + 273.15; 24*3600,30 +
        273.15],
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Cooling setpoint for room temperature"
    annotation (Placement(transformation(extent={{-110,-60},{-90,-40}})));
  Buildings.Air.Systems.SingleZone.VAV.ChillerDXHeatingEconomizer hvac(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    mAir_flow_nominal=mAir_flow_nominal,
    etaHea_nominal=0.99,
    QHea_flow_nominal=QHea_flow_nominal,
    QCoo_flow_nominal=QCoo_flow_nominal,
    TSupChi_nominal=TSupChi_nominal)   "Single zone VAV system"
    annotation (Placement(transformation(extent={{98,0},{138,40}})));
  Buildings.Air.Systems.SingleZone.VAV.ChillerDXHeatingEconomizerController
    con(
    minOAFra=0.2,
    kFan=4,
    kEco=4,
    kHea=4,
    TSupChi_nominal=TSupChi_nominal,
    TSetSupAir=286.15) "Controller"
    annotation (Placement(transformation(extent={{40,8},{60,28}})));
  Buildings.ThermalZones.Detailed.Validation.BaseClasses.SingleZoneFloor
    sinZonFlo(redeclare package Medium = MediumA, lat=lat)
    annotation (Placement(transformation(extent={{154,4},{194,44}})));
  Buildings.Controls.OBC.Utilities.OptimalStart optStaHea(
    computeHeating=true) "Optimal start for heating system "
    annotation (Placement(transformation(extent={{-150,18},{-130,38}})));
  Buildings.Controls.SetPoints.OccupancySchedule occSch(occupancy=3600*{8,18})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{-200,-60},{-180,-40}})));
  Buildings.Controls.OBC.Utilities.OptimalStart optStaCoo(computeCooling=true)
    "Optimal start for cooling system "
    annotation (Placement(transformation(extent={{-150,-22},{-130,-2}})));
  Modelica.Blocks.Sources.Constant TSetHeaOn(k=20 + 273.15)
    "Zone heating setpoint during occupied period"
    annotation (Placement(transformation(extent={{-200,20},{-180,40}})));
  Modelica.Blocks.Sources.Constant TSetCooOn(k=24 + 273.15)
    "Zone cooling setpoint during occupied time"
    annotation (Placement(transformation(extent={{-200,-20},{-180,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai(k=-6)
    "Deduct temperature differential to setup setpoint"
    annotation (Placement(transformation(extent={{-70,-20},{-50,0}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Boolean to Real"
    annotation (Placement(transformation(extent={{-110,-20},{-90,0}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
    "Boolean to Real"
    annotation (Placement(transformation(extent={{-110,20},{-90,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai1(k=5)
    "Add temperature differential to setback setpoint"
    annotation (Placement(transformation(extent={{-70,20},{-50,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add3(final k1=+1, final k2=+1)
    "New cooling setpoint schedule for room"
    annotation (Placement(transformation(extent={{-30,-20},{-10,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add4(final k1=+1, final k2=+1)
    "New heating setpoint schedule for room"
    annotation (Placement(transformation(extent={{-30,20},{-10,40}})));
equation
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{50,70},{126,70},{126,48}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(con.yCooCoiVal,hvac. uCooVal) annotation (Line(points={{61,18},{88,18},
          {88,25},{96,25}}, color={0,0,127}));
  connect(hvac.uEco,con. yOutAirFra) annotation (Line(points={{96,18},{84,18},{
          84,21},{61,21}},  color={0,0,127}));
  connect(con.chiOn,hvac. chiOn) annotation (Line(points={{61,14},{82,14},{82,
          10},{96,10}},    color={255,0,255}));
  connect(hvac.TSetChi,con. TSetSupChi) annotation (Line(points={{96,5},{96,2},
          {78,2},{78,10},{61,10}},                     color={0,0,127}));
  connect(con.yFan, hvac.uFan) annotation (Line(points={{61,27},{72,27},{72,38},
          {96,38}},  color={0,0,127}));
  connect(con.yHea, hvac.uHea) annotation (Line(points={{61,24},{78,24},{78,32},
          {96,32}},  color={0,0,127}));
  connect(weaBus.TDryBul, con.TOut) annotation (Line(
      points={{126,48},{18,48},{18,16},{38,16}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(hvac.TMix, con.TMix) annotation (Line(points={{139,16},{146,16},{146,
          -8},{30,-8},{30,20},{38,20}},   color={0,0,127}));
  connect(hvac.TSup, con.TSup) annotation (Line(points={{139,12},{144,12},{144,
          -6},{34,-6},{34,9},{38,9}},     color={0,0,127}));
  connect(weaDat.weaBus, hvac.weaBus) annotation (Line(
      points={{50,70},{102,70},{102,37.8}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus, sinZonFlo.weaBus) annotation (Line(
      points={{126,48},{160.8,48},{160.8,41}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(TSetHeaOn.y, optStaHea.TSetZonHea) annotation (Line(points={{-179,30},
          {-174,30},{-174,36},{-152,36}},    color={0,0,127}));
  connect(TSetCooOn.y, optStaCoo.TSetZonCoo) annotation (Line(points={{-179,-10},
          {-172,-10},{-172,-9},{-152,-9}}, color={0,0,127}));
  connect(booToRea.y, gai.u)  annotation (Line(points={{-88,-10},{-72,-10}},
                                                 color={0,0,127}));
  connect(booToRea1.y, gai1.u)   annotation (Line(points={{-88,30},{-72,30}}, color={0,0,127}));
  connect(gai1.y, add4.u2) annotation (Line(points={{-48,30},{-42,30},{-42,24},
          {-32,24}},color={0,0,127}));
  connect(TSetRooHea.y[1], add4.u1) annotation (Line(points={{-88,70},{-46,70},
          {-46,36},{-32,36}},color={0,0,127}));
  connect(gai.y, add3.u1) annotation (Line(points={{-48,-10},{-46,-10},{-46,-4},
          {-32,-4}},
                   color={0,0,127}));
  connect(TSetRooCoo.y[1], add3.u2) annotation (Line(points={{-88,-50},{-44,-50},
          {-44,-16},{-32,-16}},
                           color={0,0,127}));
  connect(add4.y, con.TSetRooHea)   annotation (Line(points={{-8,30},{16,30},{
          16,28},{38,28}},                                                     color={0,0,127}));
  connect(add3.y, con.TSetRooCoo) annotation (Line(points={{-8,-10},{2,-10},{2,
          24},{38,24}}, color={0,0,127}));
  connect(sinZonFlo.TRooAir, con.TRoo) annotation (Line(points={{191,34.2},{200,
          34.2},{200,-22},{22,-22},{22,12},{38,12}},  color={0,0,127}));
  connect(hvac.supplyAir, sinZonFlo.ports[1]) annotation (Line(points={{138,28},
          {152,28},{152,12},{161.8,12}}, color={0,127,255}));
  connect(hvac.returnAir, sinZonFlo.ports[2]) annotation (Line(points={{138,20},
          {150,20},{150,12},{163.8,12}}, color={0,127,255}));
  connect(occSch.tNexOcc, optStaHea.tNexOcc) annotation (Line(points={{-179,-44},
          {-168,-44},{-168,20},{-152,20}}, color={0,0,127}));
  connect(occSch.tNexOcc, optStaCoo.tNexOcc) annotation (Line(points={{-179,-44},
          {-168,-44},{-168,-20},{-152,-20}}, color={0,0,127}));
  connect(optStaHea.start, booToRea1.u) annotation (Line(points={{-128,24},{
          -120,24},{-120,30},{-112,30}}, color={255,0,255}));
  connect(optStaCoo.start, booToRea.u) annotation (Line(points={{-128,-16},{
          -122,-16},{-122,-10},{-112,-10}}, color={255,0,255}));
  connect(sinZonFlo.TRooAir, optStaHea.TZon) annotation (Line(points={{191,34.2},
          {200,34.2},{200,-74},{-162,-74},{-162,25},{-152,25}}, color={0,0,127}));
  connect(sinZonFlo.TRooAir, optStaCoo.TZon) annotation (Line(points={{191,34.2},
          {200,34.2},{200,-74},{-162,-74},{-162,-15},{-152,-15}}, color={0,0,
          127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-220,-100},{220,
            100}})),
    experiment(
      StopTime=604800,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Air/Systems/SingleZone/VAV/Examples/Guideline36.mos"
        "Simulate and plot"),
      Documentation(info="<html>
<p>
This model shows an example on how to use the block <a href=\"modelica://Buildings.Controls.OBC.Utilities.OptimalStart\">
Buildings.Controls.OBC.Utilities.OptimalStart</a>
with a simple HVAC system and a single-zone floor building.
</p>
</html>", revisions="<html>
<ul>
<li>
December 9, 2019, by Kun Zhang:<br/>
First implementation.
</li>
</ul>
</html>"));
end OptimalStartSZ;
