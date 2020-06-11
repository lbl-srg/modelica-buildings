within Buildings.Controls.OBC.Utilities.Examples;
model OptimalStartG36
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
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Controller controller(
    controllerTypeCoo=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    kCoo=1,
    yHeaMax=0.2,
    AFlo=48,
    VOutMin_flow=0.0144,
    VOutDes_flow=0.025,
    yMin=0.1,
    kHea=4,
    kMod=4,
    have_occSen=false,
    TZonHeaOff=288.15,
    TZonCooOn=298.15,
    TSupSetMax=323.15,
    TSupSetMin=285.15)
    "VAV controller"
    annotation (Placement(transformation(extent={{-60,-8},{-20,40}})));
  Controls.OBC.CDL.Continuous.Hysteresis hysChiPla(
    uLow=-1,
    uHigh=0)
    "Hysteresis with delay to switch on cooling"
    annotation (Placement(transformation(extent={{-52,-90},{-32,-70}})));
  Modelica.Blocks.Math.Feedback errTRooCoo
    "Control error on room temperature for cooling"
    annotation (Placement(transformation(extent={{-78,-90},{-58,-70}})));
  Controls.SetPoints.OccupancySchedule occSch(occupancy=3600*{8,18})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{-180,60},{-160,80}})));
  Modelica.Blocks.Sources.BooleanConstant uWin(k=false) "Window opening signal"
    annotation (Placement(transformation(extent={{-132,-60},{-112,-40}})));
  Buildings.ThermalZones.Detailed.Validation.BaseClasses.SingleZoneFloor singleZoneFloor(
    redeclare package Medium = MediumA, lat=lat)
    annotation (Placement(transformation(extent={{104,4},{144,44}})));
  Air.Systems.SingleZone.VAV.ChillerDXHeatingEconomizer hvac(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    mAir_flow_nominal=mAir_flow_nominal,
    etaHea_nominal=0.99,
    QHea_flow_nominal=QHea_flow_nominal,
    QCoo_flow_nominal=QCoo_flow_nominal,
    TSupChi_nominal=TSupChi_nominal)
    annotation (Placement(transformation(extent={{20,0},{60,40}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{-10,48},{30,88}}),   iconTransformation(extent=
            {{-250,-2},{-230,18}})));
  Buildings.Controls.OBC.Utilities.OptimalStart optStaCoo(computeCooling=true)
    annotation (Placement(transformation(extent={{-132,-20},{-112,0}})));
  Buildings.Controls.OBC.Utilities.OptimalStart optStaHea(computeHeating=true)
    annotation (Placement(transformation(extent={{-132,20},{-112,40}})));
  Modelica.Blocks.Sources.Constant TSetHeaOn(k=20 + 273.15)
    "Zone heating setpoint during occupied period"
    annotation (Placement(transformation(extent={{-180,28},{-160,48}})));
  Modelica.Blocks.Sources.Constant TSetCooOn(k=24 + 273.15)
    "Zone cooling setpoint during occupied time"
    annotation (Placement(transformation(extent={{-180,-20},{-160,0}})));
protected
  Modelica.Blocks.Sources.Constant TSetSupChiConst(final k=TSupChi_nominal)
    "Set point for chiller temperature"
    annotation (Placement(transformation(extent={{-52,-50},{-32,-30}})));
equation
  connect(controller.yFan, hvac.uFan) annotation (Line(points={{-18,27.0769},{
          -4,27.0769},{-4,38},{18,38}},
                              color={0,0,127}));
  connect(controller.yHeaCoi, hvac.uHea) annotation (Line(points={{-18,10.4615},
          {0,10.4615},{0,32},{18,32}},
                              color={0,0,127}));
  connect(controller.yOutDamPos, hvac.uEco) annotation (Line(points={{-18,0.3077},
          {4,0.3077},{4,18},{18,18}},
                                 color={0,0,127}));
  connect(TSetSupChiConst.y, hvac.TSetChi) annotation (Line(points={{-31,-40},{14,
          -40},{14,4},{18,4},{18,5}},color={0,0,127}));
  connect(errTRooCoo.y, hysChiPla.u)
    annotation (Line(points={{-59,-80},{-54,-80}},   color={0,0,127}));
  connect(hysChiPla.y, hvac.chiOn) annotation (Line(points={{-30,-80},{8,-80},{8,
          10},{18,10}},               color={255,0,255}));
  connect(weaBus.TDryBul, controller.TOut) annotation (Line(
      points={{10,68},{10,52},{-82,52},{-82,38.1538},{-62,38.1538}},
      color={255,204,51},
      thickness=0.5), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(hvac.TSup, controller.TSup) annotation (Line(points={{61,12},{70,12},{
          70,-20},{-70,-20},{-70,19.6923},{-62,19.6923}},
                                                 color={0,0,127}));
  connect(hvac.TMix, controller.TMix) annotation (Line(points={{61,16},{74,16},{
          74,-16},{-68,-16},{-68,16},{-62,16}},    color={0,0,127}));
  connect(occSch.tNexOcc, controller.tNexOcc) annotation (Line(points={{-159,76},
          {-90,76},{-90,34.4615},{-62,34.4615}},
                                          color={0,0,127}));
  connect(controller.uOcc, occSch.occupied) annotation (Line(points={{-62,
          27.0769},{-98,27.0769},{-98,64},{-159,64}},
                                        color={255,0,255}));
  connect(uWin.y, controller.uWin) annotation (Line(points={{-111,-50},{-98,-50},
          {-98,8.61538},{-62,8.61538}},color={255,0,255}));
  connect(controller.TZonCooSet, errTRooCoo.u2) annotation (Line(points={{-18,16},
          {-12,16},{-12,-100},{-68,-100},{-68,-88}},
        color={0,0,127}));
  connect(hvac.TRet, controller.TCut) annotation (Line(points={{61,14},{72,14},
          {72,-18},{-72,-18},{-72,23.3846},{-62,23.3846}},
                                                 color={0,0,127}));

  connect(hvac.supplyAir, singleZoneFloor.supplyAir)
    annotation (Line(points={{60,28},{90,28},{90,15.4},{111.6,15.4}},
                                                                   color={0,127,
          255}));
  connect(hvac.returnAir, singleZoneFloor.returnAir)
    annotation (Line(points={{60,20},{80,20},{80,11.4},{111.6,11.4}},
                                                                   color={0,127,
          255}));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-40,80},{-18,80},{-18,68},{10,68}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(weaBus, singleZoneFloor.weaBus) annotation (Line(
      points={{10,68},{110.8,68},{110.8,41}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(controller.yCooCoi, hvac.uCooVal) annotation (Line(points={{-18,4.92308},
          {-8,4.92308},{-8,25},{18,25}}, color={0,0,127}));
  connect(singleZoneFloor.TRooAir, errTRooCoo.u1) annotation (Line(points={{141,
          34.2},{148,34.2},{148,-110},{-86,-110},{-86,-80},{-76,-80}}, color={0,
          0,127}));
  connect(singleZoneFloor.TRooAir, optStaHea.TZon) annotation (Line(points={{141,
          34.2},{148,34.2},{148,-110},{-152,-110},{-152,27},{-134,27}}, color={0,
          0,127}));
  connect(singleZoneFloor.TRooAir, optStaCoo.TZon) annotation (Line(points={{141,
          34.2},{148,34.2},{148,-110},{-152,-110},{-152,-13},{-134,-13}}, color=
         {0,0,127}));
  connect(TSetHeaOn.y, optStaHea.TSetZonHea) annotation (Line(points={{-159,38},
          {-134,38}},                     color={0,0,127}));
  connect(TSetCooOn.y, optStaCoo.TSetZonCoo) annotation (Line(points={{-159,-10},
          {-142,-10},{-142,-7},{-134,-7}},   color={0,0,127}));
  connect(weaBus, hvac.weaBus) annotation (Line(
      points={{10,68},{10,52},{24,52},{24,37.8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(singleZoneFloor.TRooAir, controller.TZon) annotation (Line(points={{141,
          34.2},{148,34.2},{148,-110},{-86,-110},{-86,30.7692},{-62,30.7692}},
                                                                     color={0,0,
          127}));
  connect(occSch.tNexOcc, optStaHea.tNexOcc) annotation (Line(points={{-159,76},
          {-146,76},{-146,22},{-134,22}}, color={0,0,127}));
  connect(occSch.tNexOcc, optStaCoo.tNexOcc) annotation (Line(points={{-159,76},
          {-146,76},{-146,-18},{-134,-18}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-220,-120},{180,100}})),
    experiment(
      StopTime=31536000,
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
end OptimalStartG36;
