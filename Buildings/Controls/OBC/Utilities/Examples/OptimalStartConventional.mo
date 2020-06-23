within Buildings.Controls.OBC.Utilities.Examples;
model OptimalStartConventional
  "Example model using optimal start with a conventional controller for a single-zone system"
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
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather bus" annotation (Placement(
        transformation(extent={{120,-14},{140,6}}),  iconTransformation(extent=
            {{-250,-2},{-230,18}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable TSetRooHea(
    table=[0,15 + 273.15; 8*3600,20 + 273.15; 18*3600,15 + 273.15; 24*3600,15 +
        273.15],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.Periodic,
    y(unit="K",displayUnit="degC"))
    "Heating setpoint for room temperature"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable TSetRooCoo(
    table=[0,30 + 273.15; 8*3600,24 + 273.15; 18*3600,30 + 273.15; 24*3600,30 +
        273.15],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.Periodic,
    y(unit="K",displayUnit="degC"))
    "Cooling setpoint for room temperature"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Buildings.Air.Systems.SingleZone.VAV.ChillerDXHeatingEconomizer hvac(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    mAir_flow_nominal=mAir_flow_nominal,
    etaHea_nominal=0.99,
    QHea_flow_nominal=QHea_flow_nominal,
    QCoo_flow_nominal=QCoo_flow_nominal,
    TSupChi_nominal=TSupChi_nominal)   "Single zone VAV system"
    annotation (Placement(transformation(extent={{100,60},{140,100}})));
  Buildings.Air.Systems.SingleZone.VAV.ChillerDXHeatingEconomizerController
    con(
    minOAFra=0.2,
    kFan=4,
    kEco=4,
    kHea=4,
    TSupChi_nominal=TSupChi_nominal,
    TSetSupAir=286.15) "Controller"
    annotation (Placement(transformation(extent={{40,68},{60,88}})));
  Buildings.ThermalZones.Detailed.Validation.BaseClasses.SingleZoneFloor
    sinZonFlo(redeclare package Medium = MediumA, lat=lat)
    annotation (Placement(transformation(extent={{156,64},{196,104}})));
  Buildings.Controls.OBC.Utilities.OptimalStart optSta(
    computeHeating=true,
    computeCooling=true,
    thrOptOn(displayUnit="s")) "Optimal start for heating and cooling system "
    annotation (Placement(transformation(extent={{-150,78},{-130,98}})));
  Buildings.Controls.SetPoints.OccupancySchedule occSch(occupancy=3600*{8,18})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{-200,0},{-180,20}})));
  Modelica.Blocks.Sources.Constant TSetHeaOn(k=20 + 273.15)
    "Zone heating setpoint during occupied period"
    annotation (Placement(transformation(extent={{-200,86},{-180,106}})));
  Modelica.Blocks.Sources.Constant TSetCooOn(k=24 + 273.15)
    "Zone cooling setpoint during occupied time"
    annotation (Placement(transformation(extent={{-200,40},{-180,60}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(realTrue=-6)
    "Boolean to Real"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1(realTrue=5)
    "Boolean to Real"
    annotation (Placement(transformation(extent={{-100,84},{-80,104}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add3(final k1=+1, final k2=+1)
    "New cooling setpoint schedule for room"
    annotation (Placement(transformation(extent={{-20,44},{0,64}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add4(final k1=+1, final k2=+1)
    "New heating setpoint schedule for room"
    annotation (Placement(transformation(extent={{-20,78},{0,98}})));
  Air.Systems.SingleZone.VAV.ChillerDXHeatingEconomizer           hvac1(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    mAir_flow_nominal=mAir_flow_nominal,
    etaHea_nominal=0.99,
    QHea_flow_nominal=QHea_flow_nominal,
    QCoo_flow_nominal=QCoo_flow_nominal,
    TSupChi_nominal=TSupChi_nominal)   "Single zone VAV system"
    annotation (Placement(transformation(extent={{100,-92},{140,-52}})));
  Air.Systems.SingleZone.VAV.ChillerDXHeatingEconomizerController
    con1(
    minOAFra=0.2,
    kFan=4,
    kEco=4,
    kHea=4,
    TSupChi_nominal=TSupChi_nominal,
    TSetSupAir=286.15) "Controller"
    annotation (Placement(transformation(extent={{40,-84},{60,-64}})));
  ThermalZones.Detailed.Validation.BaseClasses.SingleZoneFloor
    sinZonFlo1(redeclare package Medium = MediumA, lat=lat)
    annotation (Placement(transformation(extent={{156,-88},{196,-48}})));
equation
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{60,10},{130,10},{130,-4}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(con.yCooCoiVal,hvac. uCooVal) annotation (Line(points={{61,78},{82,78},
          {82,85},{98,85}}, color={0,0,127}));
  connect(hvac.uEco,con. yOutAirFra) annotation (Line(points={{98,78},{84,78},{
          84,81},{61,81}},  color={0,0,127}));
  connect(con.chiOn,hvac. chiOn) annotation (Line(points={{61,74},{82,74},{82,
          70},{98,70}},    color={255,0,255}));
  connect(con.yFan, hvac.uFan) annotation (Line(points={{61,87},{72,87},{72,98},
          {98,98}},  color={0,0,127}));
  connect(con.yHea, hvac.uHea) annotation (Line(points={{61,84},{78,84},{78,92},
          {98,92}},  color={0,0,127}));
  connect(weaBus.TDryBul, con.TOut) annotation (Line(
      points={{130,-4},{18,-4},{18,76},{38,76}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(hvac.TMix, con.TMix) annotation (Line(points={{141,76},{146,76},{146,
          52},{30,52},{30,80},{38,80}},   color={0,0,127}));
  connect(hvac.TSup, con.TSup) annotation (Line(points={{141,72},{144,72},{144,
          54},{34,54},{34,69},{38,69}},   color={0,0,127}));
  connect(weaDat.weaBus, hvac.weaBus) annotation (Line(
      points={{60,10},{104,10},{104,97.8}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus, sinZonFlo.weaBus) annotation (Line(
      points={{130,-4},{162.8,-4},{162.8,101}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(TSetHeaOn.y, optSta.TSetZonHea) annotation (Line(points={{-179,96},{
          -152,96}},                color={0,0,127}));
  connect(TSetRooHea.y[1], add4.u1) annotation (Line(points={{-78,10},{-52,10},
          {-52,94},{-22,94}},color={0,0,127}));
  connect(TSetRooCoo.y[1], add3.u2) annotation (Line(points={{-78,-40},{-44,-40},
          {-44,48},{-22,48}},
                           color={0,0,127}));
  connect(add4.y, con.TSetRooHea)   annotation (Line(points={{2,88},{38,88}},  color={0,0,127}));
  connect(add3.y, con.TSetRooCoo) annotation (Line(points={{2,54},{8,54},{8,84},
          {38,84}},     color={0,0,127}));
  connect(sinZonFlo.TRooAir, con.TRoo) annotation (Line(points={{193,94.2},{200,
          94.2},{200,38},{22,38},{22,72},{38,72}},    color={0,0,127}));
  connect(hvac.supplyAir, sinZonFlo.ports[1]) annotation (Line(points={{140,88},
          {152,88},{152,72},{163.8,72}}, color={0,127,255}));
  connect(hvac.returnAir, sinZonFlo.ports[2]) annotation (Line(points={{140,80},
          {150,80},{150,72},{165.8,72}}, color={0,127,255}));
  connect(occSch.tNexOcc, optSta.tNexOcc) annotation (Line(points={{-179,16},{
          -168,16},{-168,80},{-152,80}},
                                     color={0,0,127}));
  connect(sinZonFlo.TRooAir, optSta.TZon) annotation (Line(points={{193,94.2},{
          200,94.2},{200,38},{-156,38},{-156,85},{-152,85}},
                                                           color={0,0,127}));
  connect(booToRea1.y, add4.u2) annotation (Line(points={{-78,94},{-60,94},{-60,
          82},{-22,82}}, color={0,0,127}));
  connect(booToRea.y, add3.u1) annotation (Line(points={{-78,60},{-22,60}},
                         color={0,0,127}));
  connect(optSta.optOn, booToRea1.u) annotation (Line(points={{-128,84},{-120,
          84},{-120,94},{-102,94}},
                                color={255,0,255}));
  connect(TSetCooOn.y, optSta.TSetZonCoo) annotation (Line(points={{-179,50},{
          -170,50},{-170,91},{-152,91}},
                                     color={0,0,127}));
  connect(optSta.optOn, booToRea.u) annotation (Line(points={{-128,84},{-120,84},
          {-120,60},{-102,60}},   color={255,0,255}));
  connect(con.TSetSupChi, hvac.TSetChi)
    annotation (Line(points={{61,70},{78,70},{78,65},{98,65}},
                                                             color={0,0,127}));
  connect(con1.yCooCoiVal, hvac1.uCooVal) annotation (Line(points={{61,-74},{82,
          -74},{82,-67},{98,-67}}, color={0,0,127}));
  connect(hvac1.uEco, con1.yOutAirFra) annotation (Line(points={{98,-74},{84,
          -74},{84,-71},{61,-71}}, color={0,0,127}));
  connect(con1.chiOn, hvac1.chiOn) annotation (Line(points={{61,-78},{82,-78},{
          82,-82},{98,-82}}, color={255,0,255}));
  connect(con1.yFan, hvac1.uFan) annotation (Line(points={{61,-65},{72,-65},{72,
          -54},{98,-54}}, color={0,0,127}));
  connect(con1.yHea, hvac1.uHea) annotation (Line(points={{61,-68},{78,-68},{78,
          -60},{98,-60}}, color={0,0,127}));
  connect(hvac1.TMix, con1.TMix) annotation (Line(points={{141,-76},{146,-76},{
          146,-100},{30,-100},{30,-72},{38,-72}}, color={0,0,127}));
  connect(hvac1.TSup, con1.TSup) annotation (Line(points={{141,-80},{144,-80},{
          144,-98},{34,-98},{34,-83},{38,-83}}, color={0,0,127}));
  connect(weaDat.weaBus, hvac1.weaBus) annotation (Line(
      points={{60,10},{104,10},{104,-54.2}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus, sinZonFlo1.weaBus) annotation (Line(
      points={{130,-4},{162.8,-4},{162.8,-51}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(sinZonFlo1.TRooAir, con1.TRoo) annotation (Line(points={{193,-57.8},{
          200,-57.8},{200,-114},{22,-114},{22,-80},{38,-80}}, color={0,0,127}));
  connect(hvac1.supplyAir, sinZonFlo1.ports[1]) annotation (Line(points={{140,
          -64},{152,-64},{152,-80},{163.8,-80}}, color={0,127,255}));
  connect(hvac1.returnAir, sinZonFlo1.ports[2]) annotation (Line(points={{140,
          -72},{150,-72},{150,-80},{165.8,-80}}, color={0,127,255}));
  connect(con1.TSetSupChi, hvac1.TSetChi) annotation (Line(points={{61,-82},{78,
          -82},{78,-87},{98,-87}}, color={0,0,127}));
  connect(TSetRooHea.y[1], con1.TSetRooHea) annotation (Line(points={{-78,10},{
          -52,10},{-52,-64},{38,-64}}, color={0,0,127}));
  connect(TSetRooCoo.y[1], con1.TSetRooCoo) annotation (Line(points={{-78,-40},
          {-44,-40},{-44,-68},{38,-68}}, color={0,0,127}));
  connect(weaBus.TDryBul, con1.TOut) annotation (Line(
      points={{130,-4},{130,-34},{16,-34},{16,-76},{38,-76}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-220,-140},{220,
            140}}), graphics={
        Rectangle(
          extent={{-28,-36},{204,-134}},
          lineColor={28,108,200},
          fillColor={229,229,229},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-28,128},{204,30}},
          lineColor={28,108,200},
          fillColor={229,229,229},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-20,128},{36,110}},
          lineColor={238,46,47},
          fillColor={229,229,229},
          fillPattern=FillPattern.Solid,
          textString="System with optimal start"),
        Text(
          extent={{-18,-116},{44,-134}},
          lineColor={238,46,47},
          fillColor={229,229,229},
          fillPattern=FillPattern.Solid,
          textString="System without optimal start")}),
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
end OptimalStartConventional;
