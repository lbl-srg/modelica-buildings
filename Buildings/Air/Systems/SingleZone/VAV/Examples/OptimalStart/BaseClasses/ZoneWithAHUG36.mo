within Buildings.Air.Systems.SingleZone.VAV.Examples.OptimalStart.BaseClasses;
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
    annotation (Placement(transformation(extent={{-200,0},{-160,40}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput cooDowTim(
    final unit="s",
    final quantity="Time")
    "Cool-down time retrieved from optimal cool-down block"
    annotation (Placement(transformation(extent={{-200,-40},{-160,0}}),
        iconTransformation(extent={{-140,-2},{-100,38}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tNexOcc(
    final unit="s",
    final quantity="Time")
    "Next occupancy time"
    annotation (Placement(transformation(extent={{-200,-80},{-160,-40}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOcc
    "Current occupancy period, true if it is in occupant period"
    annotation (Placement(transformation(extent={{-200,-110},{-160,-70}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZon(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Zone air temperature"
    annotation (Placement(transformation(extent={{160,-70},{200,-30}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Controller con(
    eneStd=Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1,
    venStd=Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1,
    VAreBreZon_flow=0.4989,
    VPopBreZon_flow=0.2075,
    ecoHigLimCon=Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedDryBulb,
    ashCliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_6B,
    freSta=Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.No_freeze_stat,
    have_winSen=false,
    have_CO2Sen=false,
    buiPreCon=Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.BarometricRelief,
    have_locAdj=false,
    TSupDew_max=297.15,
    maxHeaSpe=0.2,
    maxCooSpe=1,
    minSpe=0.1,
    kCoo=0.1,
    kCooCoi=1,
    VOutMin_flow=0.5,
    VOutDes_flow=0.71,
    kHea=0.1,
    kMod=4,
    have_occSen=false,
    TSup_max=343.15,
    TSup_min=286.15,
    uLow=0,
    uHigh=0.5)
    "VAV controller"
    annotation (Placement(transformation(extent={{-80,-90},{-40,-10}})));
  Buildings.ThermalZones.Detailed.Validation.BaseClasses.SingleZoneFloor sinZonFlo(
    redeclare package Medium = MediumA)
    "Single zone floor"
    annotation (Placement(transformation(extent={{96,-74},{136,-34}})));
  Buildings.Air.Systems.SingleZone.VAV.ChillerDXHeatingEconomizer hvac(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    mAir_flow_nominal=mAir_flow_nominal,
    etaHea_nominal=0.99,
    QHea_flow_nominal=QHea_flow_nominal,
    QCoo_flow_nominal=QCoo_flow_nominal,
    TSupChi_nominal=TSupChi_nominal) "HVAC system"
    annotation (Placement(transformation(extent={{40,-78},{80,-38}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysChiPla1(uLow=-1, uHigh=0)
    "Hysteresis with delay to switch on cooling"
    annotation (Placement(transformation(extent={{-50,-130},{-30,-110}})));
  Modelica.Blocks.Math.Feedback errTRooCoo1
    "Control error on room temperature for cooling"
    annotation (Placement(transformation(extent={{-76,-130},{-56,-110}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    "Weather bus"
    annotation (Placement(transformation(extent={{68,20},{92,40}}),
        iconTransformation(extent={{-80,72},{-60,92}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant demLim(
    final k=0)
    "Cooling and heating demand imit level"
    annotation (Placement(transformation(extent={{-140,-120},{-120,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOccHeaSet(final k=293.15)
    "Occupied heating setpoint"
    annotation (Placement(transformation(extent={{-140,130},{-120,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOccCooSet(final k=297.15)
    "Occupied cooling setpoint"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TUnoHeaSet(final k=288.15)
    "Unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TUnoCooSet(final k=303.15)
    "Unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-140,30},{-120,50}})));
  Modelica.Blocks.Sources.BooleanConstant freRes(k=true)
    "Freeze protection reset"
    annotation (Placement(transformation(extent={{-140,-154},{-120,-134}})));
protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetSupChiConst(
    final k=TSupChi_nominal)
    "Set point for chiller temperature"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));

equation
  connect(con.yHeaCoi, hvac.uHea) annotation (Line(points={{-38,-64},{-4,-64},{-4,
          -46},{38,-46}},  color={0,0,127}));
  connect(weaBus, sinZonFlo.weaBus) annotation (Line(
      points={{80,30},{102.8,30},{102.8,-37}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(con.yCooCoi, hvac.uCooVal) annotation (Line(points={{-38,-61},{0,-61},
          {0,-53},{38,-53}},           color={0,0,127}));
  connect(hvac.supplyAir, sinZonFlo.ports[1]) annotation (Line(points={{80.2,-50},
          {96,-50},{96,-66},{104.3,-66}}, color={0,127,255}));
  connect(hvac.returnAir, sinZonFlo.ports[2]) annotation (Line(points={{80.2,-58},
          {94,-58},{94,-66},{105.3,-66}}, color={0,127,255}));
  connect(errTRooCoo1.y,hysChiPla1. u)    annotation (Line(points={{-57,-120},{-52,
          -120}}, color={0,0,127}));
  connect(hysChiPla1.y, hvac.chiOn) annotation (Line(points={{-28,-120},{-10,-120},
          {-10,-68},{38,-68}}, color={255,0,255}));
  connect(con.TZonCooSet, errTRooCoo1.u2) annotation (Line(points={{-38,-31},{-20,
          -31},{-20,-134},{-66,-134},{-66,-128}}, color={0,0,127}));
  connect(TSetSupChiConst.y, hvac.TSetChi) annotation (Line(points={{2,20},{20,20},
          {20,-76},{38,-76}},     color={0,0,127}));
  connect(sinZonFlo.TRooAir, con.TZon) annotation (Line(points={{133,-43.8},{140,
          -43.8},{140,-140},{-100,-140},{-100,-24},{-82,-24}},    color={0,0,127}));
  connect(demLim.y, con.uCooDemLimLev) annotation (Line(points={{-118,-110},{
          -110,-110},{-110,-44},{-82,-44}},
                                          color={255,127,0}));
  connect(demLim.y, con.uHeaDemLimLev) annotation (Line(points={{-118,-110},{
          -110,-110},{-110,-46},{-82,-46}},
                                          color={255,127,0}));
  connect(sinZonFlo.TRooAir, TZon) annotation (Line(points={{133,-43.8},{140,-43.8},
          {140,-50},{180,-50}}, color={0,0,127}));
  connect(tNexOcc, con.tNexOcc) annotation (Line(points={{-180,-60},{-124,-60},{
          -124,-21},{-82,-21}},         color={0,0,127}));
  connect(warUpTim, con.warUpTim) annotation (Line(points={{-180,20},{-112,20},{
          -112,-16},{-82,-16}},    color={0,0,127}));
  connect(cooDowTim, con.cooDowTim) annotation (Line(points={{-180,-20},{-128,-20},
          {-128,-14},{-82,-14}},        color={0,0,127}));
  connect(hvac.weaBus, weaBus) annotation (Line(
      points={{44.2,-40.2},{44.2,30},{80,30}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(sinZonFlo.TRooAir, errTRooCoo1.u1) annotation (Line(points={{133,-43.8},
          {140,-43.8},{140,-140},{-100,-140},{-100,-120},{-74,-120}}, color={0,0,
          127}));
  connect(weaBus.TDryBul, con.TOut) annotation (Line(
      points={{80,30},{80,0},{-100,0},{-100,-11},{-82,-11}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(uOcc, con.u1Occ) annotation (Line(points={{-180,-90},{-120,-90},{-120,
          -19},{-82,-19}}, color={255,0,255}));
  connect(TOccHeaSet.y, con.TOccHeaSet) annotation (Line(points={{-118,140},{-104,
          140},{-104,-26},{-82,-26}}, color={0,0,127}));
  connect(TOccCooSet.y, con.TOccCooSet) annotation (Line(points={{-118,110},{-104,
          110},{-104,-28},{-82,-28}}, color={0,0,127}));
  connect(TUnoHeaSet.y, con.TUnoHeaSet) annotation (Line(points={{-118,70},{-108,
          70},{-108,-30},{-82,-30}}, color={0,0,127}));
  connect(TUnoCooSet.y, con.TUnoCooSet) annotation (Line(points={{-118,40},{-108,
          40},{-108,-32},{-82,-32}}, color={0,0,127}));
  connect(hvac.TSup, con.TAirSup) annotation (Line(points={{81.2,-66},{86,-66},{
          86,-100},{-92,-100},{-92,-54},{-82,-54}}, color={0,0,127}));
  connect(hvac.TMix, con.TAirMix) annotation (Line(points={{81.2,-62},{88,-62},
          {88,-102},{-96,-102},{-96,-79},{-82,-79}},color={0,0,127}));
  connect(con.yOutDam, hvac.uEco) annotation (Line(points={{-38,-41},{4,-41},{4,
          -60},{38,-60}}, color={0,0,127}));
  connect(con.ySupFan, hvac.uFan) annotation (Line(points={{-38,-46},{-8,-46},{-8,
          -40},{38,-40}}, color={0,0,127}));
  connect(freRes.y, con.u1SofSwiRes) annotation (Line(points={{-119,-144},{-106,
          -144},{-106,-69},{-82,-69}}, color={255,0,255}));
  connect(con.yHeaCoi, con.uHeaCoi_actual) annotation (Line(points={{-38,-64},{
          -4,-64},{-4,-96},{-86,-96},{-86,-89},{-82,-89}}, color={0,0,127}));
  connect(con.yCooCoi, con.uCooCoi_actual) annotation (Line(points={{-38,-61},{
          0,-61},{0,-98},{-88,-98},{-88,-87},{-82,-87}}, color={0,0,127}));
  connect(con.ySupFan, con.uSupFan_actual) annotation (Line(points={{-38,-46},{
          -8,-46},{-8,-104},{-90,-104},{-90,-84},{-82,-84}}, color={0,0,127}));
  annotation (defaultComponentName="zonAHUG36",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                    graphics={
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
          preserveAspectRatio=false, extent={{-160,-160},{160,160}})),
Documentation(info="<html>
<p>
This base class contains a controller based on Guideline36 
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Controller\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Controller</a>,
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
June 24, 2022, by Jianjun Hu:<br/>
Replaced the AHU controller with the one based official release version.
</li>
<li>
July 29, 2020, by Kun Zhang:<br/>
First implementation. This is for issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2126\">2126</a>.
</li>
</ul>
</html>"));
end ZoneWithAHUG36;
