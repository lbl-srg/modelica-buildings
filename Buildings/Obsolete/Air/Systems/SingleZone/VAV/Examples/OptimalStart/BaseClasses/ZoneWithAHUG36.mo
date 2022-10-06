within Buildings.Obsolete.Air.Systems.SingleZone.VAV.Examples.OptimalStart.BaseClasses;
block ZoneWithAHUG36
  "A single zone building with a VAV system and a Guideline36 controller"

  package MediumA = Buildings.Media.Air(extraPropertiesNames={"CO2"})
    "Buildings library air media package";
  package MediumW = Buildings.Media.Water
    "Buildings library water media package";
  parameter Modelica.Units.SI.Temperature TSupChi_nominal=279.15
    "Design value for chiller leaving water temperature";
  parameter Modelica.Units.SI.Volume VRoo=4555.7 "Space volume of the floor";
  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal=VRoo*4*1.2/3600
    "Design air flow rate";
  parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal=90000
    "Design heating flow rate";
  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal=-100000
    "Design cooling flow rate";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput warUpTim(
    final unit="s",
    final quantity="Time")
    "Warm-up time retrieved from optimal warm-up block"
    annotation (Placement(transformation(extent={{-180,40},{-140,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput cooDowTim(
    final unit="s",
    final quantity="Time")
    "Cool-down time retrieved from optimal cool-down block"
    annotation (Placement(transformation(extent={{-180,0},{-140,40}}),
        iconTransformation(extent={{-140,-2},{-100,38}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tNexOcc(
    final unit="s",
    final quantity="Time")
    "Next occupancy time" annotation (Placement(transformation(extent={{-180,-40},
            {-140,0}}), iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOcc
    "Current occupancy period, true if it is in occupant period"
    annotation (Placement(transformation(extent={{-180,-70},{-140,-30}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZon(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Zone air temperature"
    annotation (Placement(transformation(extent={{140,-20},{180,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Controller con(
    have_winSen=false,
    TZonHeaOn=293.15,
    TZonCooOff=303.15,
    kCoo=4,
    kCooCoi=1,
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
    TSupSetMax=343.15,
    TSupSetMin=286.15,
    uLow=0,
    uHigh=0.5)
    "VAV controller"
    annotation (Placement(transformation(extent={{-66,-36},{-26,12}})));
  Buildings.ThermalZones.Detailed.Validation.BaseClasses.SingleZoneFloor sinZonFlo(
    redeclare package Medium = MediumA)
    "Single zone floor"
    annotation (Placement(transformation(extent={{76,-24},{116,16}})));
  Buildings.Air.Systems.SingleZone.VAV.ChillerDXHeatingEconomizer hvac(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    mAir_flow_nominal=mAir_flow_nominal,
    etaHea_nominal=0.99,
    QHea_flow_nominal=QHea_flow_nominal,
    QCoo_flow_nominal=QCoo_flow_nominal,
    TSupChi_nominal=TSupChi_nominal) "HVAC system"
    annotation (Placement(transformation(extent={{20,-28},{60,12}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysChiPla1(uLow=-1, uHigh=0)
    "Hysteresis with delay to switch on cooling"
    annotation (Placement(transformation(extent={{-50,-80},{-30,-60}})));
  Modelica.Blocks.Math.Feedback errTRooCoo1
    "Control error on room temperature for cooling"
    annotation (Placement(transformation(extent={{-76,-80},{-56,-60}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    "Weather bus" annotation (Placement(
        transformation(extent={{48,70},{72,90}}),    iconTransformation(extent={{-80,72},
            {-60,92}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant demLim(
    final k=0)
    "Cooling and heating demand imit level"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetSupChiConst(
    final k=TSupChi_nominal)
    "Set point for chiller temperature"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));

equation
  connect(con.yFan, hvac.uFan) annotation (Line(points={{-24,-0.92308},{-20,-0.92308},
          {-20,10},{18,10}}, color={0,0,127}));
  connect(con.yHeaCoi, hvac.uHea) annotation (Line(points={{-24,-17.5385},{-16,
          -17.5385},{-16,4},{18,4}},
                           color={0,0,127}));
  connect(con.yOutDamPos, hvac.uEco) annotation (Line(points={{-24,-27.6923},{-12,
          -27.6923},{-12,-10},{18,-10}}, color={0,0,127}));
  connect(hvac.TSup, con.TSup) annotation (Line(points={{61.2,-16},{64,-16},{64,
          -42},{-76,-42},{-76,-10.1538},{-68,-10.1538}}, color={0,0,127}));
  connect(hvac.TMix, con.TMix) annotation (Line(points={{61.2,-12},{68,-12},{68,
          -38},{-74,-38},{-74,-15.6923},{-68,-15.6923}}, color={0,0,127}));
  connect(hvac.TRet, con.TCut) annotation (Line(points={{61.2,-14},{66,-14},{66,
          -40},{-78,-40},{-78,-12.9231},{-68,-12.9231}}, color={0,0,127}));
  connect(weaBus, sinZonFlo.weaBus) annotation (Line(
      points={{60,80},{82.8,80},{82.8,13}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(con.yCooCoi, hvac.uCooVal) annotation (Line(points={{-24,-23.0769},{
          -14,-23.0769},{-14,-3},{18,-3}},
                                       color={0,0,127}));
  connect(hvac.supplyAir, sinZonFlo.ports[1]) annotation (Line(points={{60.2,0},
          {76,0},{76,-16},{84.3,-16}}, color={0,127,255}));
  connect(hvac.returnAir, sinZonFlo.ports[2]) annotation (Line(points={{60.2,-8},
          {74,-8},{74,-16},{85.3,-16}}, color={0,127,255}));
  connect(errTRooCoo1.y,hysChiPla1. u)    annotation (Line(points={{-57,-70},{-52,-70}},   color={0,0,127}));
  connect(hysChiPla1.y, hvac.chiOn) annotation (Line(points={{-28,-70},{-10,-70},
          {-10,-18},{18,-18}}, color={255,0,255}));
  connect(con.TZonCooSet, errTRooCoo1.u2) annotation (Line(points={{-24,-12},{-20,
          -12},{-20,-84},{-66,-84},{-66,-78}}, color={0,0,127}));
  connect(con.TOut, weaBus.TDryBul) annotation (Line(points={{-68,11.0769},{-84,
          11.0769},{-84,26},{60,26},{60,80}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(errTRooCoo1.u1, con.TZon) annotation (Line(points={{-74,-70},{-82,-70},
          {-82,0},{-68,0}}, color={0,0,127}));
  connect(TSetSupChiConst.y, hvac.TSetChi) annotation (Line(points={{-38,50},{-8,
          50},{-8,-26},{18,-26}}, color={0,0,127}));
  connect(sinZonFlo.TRooAir, con.TZon) annotation (Line(points={{113,6.2},{120,6.2},
          {120,-90},{-82,-90},{-82,0},{-68,0},{-68,8.88178e-16}}, color={0,0,127}));
  connect(demLim.y, con.uCooDemLimLev) annotation (Line(points={{-98,-50},{-90,-50},
          {-90,-5.53846},{-68,-5.53846}}, color={255,127,0}));
  connect(demLim.y, con.uHeaDemLimLev) annotation (Line(points={{-98,-50},{-90,-50},
          {-90,-7.38462},{-68,-7.38462}}, color={255,127,0}));
  connect(sinZonFlo.TRooAir, TZon) annotation (Line(points={{113,6.2},{120,6.2},
          {120,0},{160,0}}, color={0,0,127}));
  connect(tNexOcc, con.tNexOcc) annotation (Line(points={{-160,-20},{-132,-20},{
          -132,2.76923},{-68,2.76923}}, color={0,0,127}));
  connect(uOcc, con.uOcc) annotation (Line(points={{-160,-50},{-130,-50},{-130,-2.76923},
          {-68,-2.76923}}, color={255,0,255}));
  connect(warUpTim, con.warUpTim) annotation (Line(points={{-160,60},{-88,60},{-88,
          8.30769},{-68,8.30769}}, color={0,0,127}));
  connect(cooDowTim, con.cooDowTim) annotation (Line(points={{-160,20},{-92,20},
          {-92,5.53846},{-68,5.53846}}, color={0,0,127}));

  connect(hvac.weaBus, weaBus) annotation (Line(
      points={{24.2,9.8},{24.2,80},{60,80}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  annotation (defaultComponentName="zonAHUG36",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(
          extent={{-151,147},{149,107}},
          textColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name")}),
       Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-140,-100},{140,100}})),
Documentation(info="<html>
<p>
This base class contains a controller based on Guideline36 
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Controller\">
Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Controller</a>,
a single-zone VAV system
<a href=\"modelica://Buildings.Air.Systems.SingleZone.VAV.ChillerDXHeatingEconomizer\">
Buildings.Air.Systems.SingleZone.VAV.ChillerDXHeatingEconomizer</a>, 
and a single-zone floor building
<a href=\"modelica://Buildings.ThermalZones.Detailed.Validation.BaseClasses.SingleZoneFloor\">
Buildings.ThermalZones.Detailed.Validation.BaseClasses.SingleZoneFloor</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 29, 2020, by Kun Zhang:<br/>
First implementation. This is for issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2126\">2126</a>.
</li>
</ul>
</html>"));
end ZoneWithAHUG36;
