within Buildings.Air.Systems.SingleZone.VAV.Examples.OptimalStart.BaseClasses;
block ZoneWithAHUConventional
  "A single zone building with an air handling system, a conventional controller"

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

  Buildings.Air.Systems.SingleZone.VAV.ChillerDXHeatingEconomizer hvac(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    mAir_flow_nominal=mAir_flow_nominal,
    etaHea_nominal=0.99,
    QHea_flow_nominal=QHea_flow_nominal,
    QCoo_flow_nominal=QCoo_flow_nominal,
    TSupChi_nominal=TSupChi_nominal)   "Single zone VAV system"
    annotation (Placement(transformation(extent={{-18,-20},{22,20}})));
  ChillerDXHeatingEconomizerController
    con(
    minOAFra=0.2,
    kFan=4,
    kEco=4,
    kHea=4,
    TSupChi_nominal=TSupChi_nominal,
    TSetSupAir=286.15) "Controller"
    annotation (Placement(transformation(extent={{-78,-12},{-58,8}})));
  ThermalZones.Detailed.Validation.BaseClasses.SingleZoneFloor
    sinZonFlo(redeclare package Medium = MediumA, lat=lat)
    annotation (Placement(transformation(extent={{38,-16},{78,24}})));
  Controls.OBC.CDL.Interfaces.RealOutput TRoo(unit="K", displayUnit="degC")
    "Room temperature"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Controls.OBC.CDL.Interfaces.RealInput TSetRooHea(unit="K", displayUnit="degC")
    "Room heating setpoint temperature" annotation (Placement(transformation(
          extent={{-140,32},{-100,72}}), iconTransformation(extent={{-140,32},{-100,
            72}})));
  Controls.OBC.CDL.Interfaces.RealInput TSetRooCoo(unit="K", displayUnit="degC")
    "Room cooling setpoint temperature" annotation (Placement(transformation(
          extent={{-140,-70},{-100,-30}}), iconTransformation(extent={{-140,-70},
            {-100,-30}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  BoundaryConditions.WeatherData.Bus weaBus "Weather bus" annotation (Placement(
        transformation(extent={{-4,50},{16,70}}),    iconTransformation(extent={{-78,70},
            {-58,90}})));
equation
  connect(con.yCooCoiVal,hvac. uCooVal) annotation (Line(points={{-57,-2},{-36,-2},
          {-36,5},{-20,5}}, color={0,0,127}));
  connect(hvac.uEco,con. yOutAirFra) annotation (Line(points={{-20,-2},{-34,-2},
          {-34,1},{-57,1}}, color={0,0,127}));
  connect(con.chiOn,hvac. chiOn) annotation (Line(points={{-57,-6},{-36,-6},{-36,
          -10},{-20,-10}}, color={255,0,255}));
  connect(con.yFan,hvac. uFan) annotation (Line(points={{-57,7},{-46,7},{-46,18},
          {-20,18}}, color={0,0,127}));
  connect(con.yHea,hvac. uHea) annotation (Line(points={{-57,4},{-40,4},{-40,12},
          {-20,12}}, color={0,0,127}));
  connect(hvac.TMix,con. TMix) annotation (Line(points={{23,-4},{28,-4},{28,-28},
          {-88,-28},{-88,0},{-80,0}},     color={0,0,127}));
  connect(hvac.TSup,con. TSup) annotation (Line(points={{23,-8},{26,-8},{26,-26},
          {-84,-26},{-84,-11},{-80,-11}}, color={0,0,127}));
  connect(sinZonFlo.TRooAir,con. TRoo) annotation (Line(points={{75,14.2},{82,14.2},
          {82,-42},{-92,-42},{-92,-8},{-80,-8}},      color={0,0,127}));
  connect(hvac.supplyAir,sinZonFlo. ports[1]) annotation (Line(points={{22,8},{34,
          8},{34,-8},{45.8,-8}},         color={0,127,255}));
  connect(hvac.returnAir,sinZonFlo. ports[2]) annotation (Line(points={{22,0},{32,
          0},{32,-8},{47.8,-8}},         color={0,127,255}));
  connect(con.TSetSupChi,hvac. TSetChi)
    annotation (Line(points={{-57,-10},{-40,-10},{-40,-15},{-20,-15}},
                                                             color={0,0,127}));
  connect(TSetRooHea, con.TSetRooHea) annotation (Line(points={{-120,52},{-90,52},
          {-90,8},{-80,8}}, color={0,0,127}));
  connect(TSetRooCoo, con.TSetRooCoo) annotation (Line(points={{-120,-50},{-96,-50},
          {-96,4},{-80,4}}, color={0,0,127}));
  connect(sinZonFlo.TRooAir, TRoo) annotation (Line(points={{75,14.2},{82,14.2},
          {82,0},{120,0}}, color={0,0,127}));
  connect(weaDat.weaBus,weaBus)  annotation (Line(
      points={{-20,60},{6,60}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(weaBus, hvac.weaBus) annotation (Line(
      points={{6,60},{6,32},{-14,32},{-14,17.8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus, sinZonFlo.weaBus) annotation (Line(
      points={{6,60},{6,32},{44.8,32},{44.8,21}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(con.TOut, weaBus.TDryBul) annotation (Line(points={{-80,-4},{-86,-4},{
          -86,32},{6,32},{6,60}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (defaultComponentName="zonAHUCon",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(
          extent={{-151,147},{149,107}},
          lineColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name")}),          Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end ZoneWithAHUConventional;
