within Buildings.Controls.OBC.Utilities.Examples;
model OptimalStartGuideline36
  "Example model using optimal start with Guideline 36 controller for a single-zone system"
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
    AFlo=1663,
    VOutMin_flow=0.5,
    VOutDes_flow=0.71,
    yMin=0.1,
    kHea=4,
    kMod=4,
    have_occSen=false,
    TZonHeaOff=288.15,
    TZonCooOn=297.15,
    TSupSetMax=323.15,
    TSupSetMin=285.15)
    "VAV controller"
    annotation (Placement(transformation(extent={{-60,46},{-20,94}})));
  Controls.OBC.CDL.Continuous.Hysteresis hysChiPla(
    uLow=-1,
    uHigh=0)
    "Hysteresis with delay to switch on cooling"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Modelica.Blocks.Math.Feedback errTRooCoo
    "Control error on room temperature for cooling"
    annotation (Placement(transformation(extent={{-70,10},{-50,30}})));
  Controls.SetPoints.OccupancySchedule occSch(occupancy=3600*{8,18})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{-180,-80},{-160,-60}})));
  Modelica.Blocks.Sources.BooleanConstant uWin(k=false) "Window opening signal"
    annotation (Placement(transformation(extent={{-180,-50},{-160,-30}})));
  Buildings.ThermalZones.Detailed.Validation.BaseClasses.SingleZoneFloor singleZoneFloor(
    redeclare package Medium = MediumA, lat=lat)
    annotation (Placement(transformation(extent={{104,58},{144,98}})));
  Air.Systems.SingleZone.VAV.ChillerDXHeatingEconomizer hvac(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    mAir_flow_nominal=mAir_flow_nominal,
    etaHea_nominal=0.99,
    QHea_flow_nominal=QHea_flow_nominal,
    QCoo_flow_nominal=QCoo_flow_nominal,
    TSupChi_nominal=TSupChi_nominal)
    annotation (Placement(transformation(extent={{20,54},{60,94}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{68,-50},{92,-30}}),  iconTransformation(extent=
            {{-250,-2},{-230,18}})));
  Buildings.Controls.OBC.Utilities.OptimalStart optStaHea(computeHeating=true,
    computeCooling=false,
    thrOptOn(displayUnit="s"))
    annotation (Placement(transformation(extent={{-140,66},{-120,86}})));
  Modelica.Blocks.Sources.Constant TSetHeaOn(k=20 + 273.15)
    "Zone heating setpoint during occupied period"
    annotation (Placement(transformation(extent={{-180,74},{-160,94}})));
  Modelica.Blocks.Sources.Constant TSetCooOn(k=24 + 273.15)
    "Zone cooling setpoint during occupied time"
    annotation (Placement(transformation(extent={{-180,114},{-160,134}})));
  OptimalStart optStaCoo(
    computeHeating=false,
    computeCooling=true,
    thrOptOn(displayUnit="s"))
    annotation (Placement(transformation(extent={{-140,114},{-120,134}})));
  ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Controller                        controller1(
    controllerTypeCoo=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    kCoo=1,
    yHeaMax=0.2,
    AFlo=1663,
    VOutMin_flow=0.5,
    VOutDes_flow=0.71,
    yMin=0.1,
    kHea=4,
    kMod=4,
    have_occSen=false,
    TZonHeaOff=288.15,
    TZonCooOn=297.15,
    TSupSetMax=323.15,
    TSupSetMin=285.15)
    "VAV controller"
    annotation (Placement(transformation(extent={{-60,-144},{-20,-96}})));
  ThermalZones.Detailed.Validation.BaseClasses.SingleZoneFloor           singleZoneFloor1(
      redeclare package Medium = MediumA, lat=lat)
    annotation (Placement(transformation(extent={{104,-132},{144,-92}})));
  Air.Systems.SingleZone.VAV.ChillerDXHeatingEconomizer hvac1(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    mAir_flow_nominal=mAir_flow_nominal,
    etaHea_nominal=0.99,
    QHea_flow_nominal=QHea_flow_nominal,
    QCoo_flow_nominal=QCoo_flow_nominal,
    TSupChi_nominal=TSupChi_nominal)
    annotation (Placement(transformation(extent={{20,-136},{60,-96}})));
  CDL.Continuous.Hysteresis              hysChiPla1(uLow=-1, uHigh=0)
    "Hysteresis with delay to switch on cooling"
    annotation (Placement(transformation(extent={{-38,-188},{-18,-168}})));
  Modelica.Blocks.Math.Feedback errTRooCoo1
    "Control error on room temperature for cooling"
    annotation (Placement(transformation(extent={{-70,-188},{-50,-168}})));
  CDL.Continuous.Sources.Constant con(k=0)
    annotation (Placement(transformation(extent={{-180,-120},{-160,-100}})));
protected
  Modelica.Blocks.Sources.Constant TSetSupChiConst(final k=TSupChi_nominal)
    "Set point for chiller temperature"
    annotation (Placement(transformation(extent={{-180,-20},{-160,0}})));
equation
  connect(controller.yFan, hvac.uFan) annotation (Line(points={{-18,81.0769},{
          -4,81.0769},{-4,92},{18,92}},
                              color={0,0,127}));
  connect(controller.yHeaCoi, hvac.uHea) annotation (Line(points={{-18,64.4615},
          {0,64.4615},{0,86},{18,86}},
                              color={0,0,127}));
  connect(controller.yOutDamPos, hvac.uEco) annotation (Line(points={{-18,
          54.3077},{4,54.3077},{4,72},{18,72}},
                                 color={0,0,127}));
  connect(TSetSupChiConst.y, hvac.TSetChi) annotation (Line(points={{-159,-10},
          {12,-10},{12,58},{18,58},{18,59}},
                                     color={0,0,127}));
  connect(errTRooCoo.y, hysChiPla.u)
    annotation (Line(points={{-51,20},{-42,20}},     color={0,0,127}));
  connect(hysChiPla.y, hvac.chiOn) annotation (Line(points={{-18,20},{8,20},{8,
          64},{18,64}},               color={255,0,255}));
  connect(hvac.TSup, controller.TSup) annotation (Line(points={{61,66},{70,66},
          {70,40},{-70,40},{-70,73.6923},{-62,73.6923}},
                                                 color={0,0,127}));
  connect(hvac.TMix, controller.TMix) annotation (Line(points={{61,70},{74,70},
          {74,44},{-68,44},{-68,70},{-62,70}},     color={0,0,127}));
  connect(occSch.tNexOcc, controller.tNexOcc) annotation (Line(points={{-159,
          -64},{-94,-64},{-94,88.4615},{-62,88.4615}},
                                          color={0,0,127}));
  connect(controller.uOcc, occSch.occupied) annotation (Line(points={{-62,
          81.0769},{-98,81.0769},{-98,-76},{-159,-76}},
                                        color={255,0,255}));
  connect(uWin.y, controller.uWin) annotation (Line(points={{-159,-40},{-106,
          -40},{-106,62.6154},{-62,62.6154}},
                                       color={255,0,255}));
  connect(controller.TZonCooSet, errTRooCoo.u2) annotation (Line(points={{-18,70},
          {-14,70},{-14,4},{-60,4},{-60,12}},
        color={0,0,127}));
  connect(hvac.TRet, controller.TCut) annotation (Line(points={{61,68},{72,68},
          {72,42},{-72,42},{-72,77.3846},{-62,77.3846}},
                                                 color={0,0,127}));

  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{40,-40},{80,-40}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(weaBus, singleZoneFloor.weaBus) annotation (Line(
      points={{80,-40},{110.8,-40},{110.8,95}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(controller.yCooCoi, hvac.uCooVal) annotation (Line(points={{-18,
          58.9231},{-8,58.9231},{-8,79},{18,79}},
                                         color={0,0,127}));
  connect(singleZoneFloor.TRooAir, errTRooCoo.u1) annotation (Line(points={{141,
          88.2},{148,88.2},{148,2},{-86,2},{-86,20},{-68,20}},         color={0,
          0,127}));
  connect(singleZoneFloor.TRooAir, optStaHea.TZon) annotation (Line(points={{141,
          88.2},{148,88.2},{148,2},{-152,2},{-152,73},{-142,73}},       color={0,
          0,127}));
  connect(TSetHeaOn.y, optStaHea.TSetZonHea) annotation (Line(points={{-159,84},
          {-142,84}},                     color={0,0,127}));
  connect(weaBus, hvac.weaBus) annotation (Line(
      points={{80,-40},{80,91.8},{24,91.8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(singleZoneFloor.TRooAir, controller.TZon) annotation (Line(points={{141,
          88.2},{148,88.2},{148,2},{-86,2},{-86,84.7692},{-62,84.7692}},
                                                                     color={0,0,
          127}));
  connect(occSch.tNexOcc, optStaHea.tNexOcc) annotation (Line(points={{-159,-64},
          {-146,-64},{-146,68},{-142,68}},color={0,0,127}));
  connect(TSetCooOn.y, optStaCoo.TSetZonCoo) annotation (Line(points={{-159,124},
          {-150,124},{-150,127},{-142,127}}, color={0,0,127}));
  connect(occSch.tNexOcc, optStaCoo.tNexOcc) annotation (Line(points={{-159,-64},
          {-146,-64},{-146,116},{-142,116}}, color={0,0,127}));
  connect(optStaCoo.tOpt, controller.cooDowTim) annotation (Line(points={{-118,
          128},{-90,128},{-90,96.2154},{-62,96.2154}}, color={0,0,127}));
  connect(optStaHea.tOpt, controller.warUpTim) annotation (Line(points={{-118,80},
          {-110,80},{-110,94.3692},{-62,94.3692}},     color={0,0,127}));
  connect(hvac.supplyAir, singleZoneFloor.ports[1]) annotation (Line(points={{
          60,82},{96,82},{96,66},{111.8,66}}, color={0,127,255}));
  connect(hvac.returnAir, singleZoneFloor.ports[2]) annotation (Line(points={{
          60,74},{86,74},{86,66},{113.8,66}}, color={0,127,255}));
  connect(optStaCoo.TZon, optStaHea.TZon) annotation (Line(points={{-142,121},{
          -152,121},{-152,73},{-142,73}}, color={0,0,127}));
  connect(controller1.yFan, hvac1.uFan) annotation (Line(points={{-18,-108.923},
          {-4,-108.923},{-4,-98},{18,-98}}, color={0,0,127}));
  connect(controller1.yHeaCoi, hvac1.uHea) annotation (Line(points={{-18,
          -125.538},{0,-125.538},{0,-104},{18,-104}}, color={0,0,127}));
  connect(controller1.yOutDamPos, hvac1.uEco) annotation (Line(points={{-18,
          -135.692},{4,-135.692},{4,-118},{18,-118}}, color={0,0,127}));
  connect(TSetSupChiConst.y, hvac1.TSetChi) annotation (Line(points={{-159,-10},
          {12,-10},{12,-132},{18,-132},{18,-131}},
                                                 color={0,0,127}));
  connect(hvac1.TSup, controller1.TSup) annotation (Line(points={{61,-124},{70,
          -124},{70,-150},{-70,-150},{-70,-116.308},{-62,-116.308}}, color={0,0,
          127}));
  connect(hvac1.TMix, controller1.TMix) annotation (Line(points={{61,-120},{74,
          -120},{74,-146},{-68,-146},{-68,-120},{-62,-120}}, color={0,0,127}));
  connect(hvac1.TRet, controller1.TCut) annotation (Line(points={{61,-122},{72,
          -122},{72,-148},{-72,-148},{-72,-112.615},{-62,-112.615}}, color={0,0,
          127}));
  connect(weaBus, singleZoneFloor1.weaBus) annotation (Line(
      points={{80,-40},{110.8,-40},{110.8,-95}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(controller1.yCooCoi, hvac1.uCooVal) annotation (Line(points={{-18,
          -131.077},{-8,-131.077},{-8,-111},{18,-111}}, color={0,0,127}));
  connect(weaBus, hvac1.weaBus) annotation (Line(
      points={{80,-40},{80,-98.2},{24,-98.2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(hvac1.supplyAir, singleZoneFloor1.ports[1]) annotation (Line(points={
          {60,-108},{96,-108},{96,-124},{111.8,-124}}, color={0,127,255}));
  connect(hvac1.returnAir, singleZoneFloor1.ports[2]) annotation (Line(points={
          {60,-116},{86,-116},{86,-124},{113.8,-124}}, color={0,127,255}));
  connect(occSch.occupied, controller1.uOcc) annotation (Line(points={{-159,-76},
          {-98,-76},{-98,-108.923},{-62,-108.923}}, color={255,0,255}));
  connect(uWin.y, controller1.uWin) annotation (Line(points={{-159,-40},{-106,
          -40},{-106,-127.385},{-62,-127.385}},
                                           color={255,0,255}));
  connect(errTRooCoo1.y, hysChiPla1.u)
    annotation (Line(points={{-51,-178},{-40,-178}}, color={0,0,127}));
  connect(singleZoneFloor1.TRooAir, controller1.TZon) annotation (Line(points={{141,
          -101.8},{146,-101.8},{146,-196},{-84,-196},{-84,-105.231},{-62,
          -105.231}}, color={0,0,127}));
  connect(occSch.tNexOcc, controller1.tNexOcc) annotation (Line(points={{-159,
          -64},{-146,-64},{-146,-102},{-74,-102},{-74,-101.538},{-62,-101.538}},
        color={0,0,127}));
  connect(hysChiPla1.y, hvac1.chiOn) annotation (Line(points={{-16,-178},{8,
          -178},{8,-126},{18,-126}}, color={255,0,255}));
  connect(controller1.TZonCooSet, errTRooCoo1.u2) annotation (Line(points={{-18,
          -120},{-4,-120},{-4,-192},{-60,-192},{-60,-186}},   color={0,0,127}));
  connect(errTRooCoo1.u1, controller1.TZon) annotation (Line(points={{-68,-178},
          {-84,-178},{-84,-105.231},{-62,-105.231}}, color={0,0,127}));
  connect(con.y, controller1.cooDowTim) annotation (Line(points={{-158,-110},{
          -130,-110},{-130,-93.7846},{-62,-93.7846}}, color={0,0,127}));
  connect(con.y, controller1.warUpTim) annotation (Line(points={{-158,-110},{
          -130,-110},{-130,-95.6308},{-62,-95.6308}}, color={0,0,127}));
  connect(controller1.TOut, controller.TOut) annotation (Line(points={{-62,
          -97.8462},{-78,-97.8462},{-78,92.1538},{-62,92.1538}}, color={0,0,127}));
  connect(controller1.TOut, weaBus.TDryBul) annotation (Line(points={{-62,
          -97.8462},{-78,-97.8462},{-78,-82},{80,-82},{80,-40}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-220,-220},{180,
            160}}), graphics={
        Text(
          extent={{-72,128},{-16,110}},
          lineColor={0,0,0},
          fillColor={229,229,229},
          fillPattern=FillPattern.Solid,
          textString="System with optimal start"),
        Rectangle(
          extent={{-188,142},{152,36}},
          lineColor={28,108,200},
          fillColor={229,229,229},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{70,146},{144,118}},
          lineColor={238,46,47},
          fillColor={229,229,229},
          fillPattern=FillPattern.Solid,
          textString="System with optimal start"),
        Rectangle(
          extent={{-190,-86},{152,-202}},
          lineColor={28,108,200},
          fillColor={229,229,229},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{58,-174},{142,-202}},
          lineColor={238,46,47},
          fillColor={229,229,229},
          fillPattern=FillPattern.Solid,
          textString="System without optimal start")}),
    experiment(
      StopTime=604800,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
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
end OptimalStartGuideline36;
