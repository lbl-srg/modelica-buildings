within Buildings.Examples.HydronicSystems;
model FanCoilUnit
  "Fan Coil Unit"

  extends Modelica.Icons.Example;

  replaceable package MediumA = Buildings.Media.Air(T_default=293.15)
    "Medium model for air";

  replaceable package MediumW = Buildings.Media.Water
    "Medium model";

  replaceable package MediumHW = Modelica.Media.Interfaces.PartialMedium
    "Medium model of hot water";

  replaceable package MediumCHW = Modelica.Media.Interfaces.PartialMedium
    "Medium model of chilled water";


  Fluid.Sources.Boundary_pT souHea(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 300000 + 6000,
    T=333.15,
    nPorts=5) "Source for heating "
    annotation (Placement(transformation(
        extent={{-9,-9},{9,9}},
        rotation=90,
        origin={11,-49})));

  Fluid.Sources.Boundary_pT sinHea(
    redeclare package Medium = MediumW,
    p=300000,
    T=328.15,
    nPorts=5) "Sink for heating "
     annotation (Placement(transformation(
        extent={{-9,-9},{9,9}},
        rotation=90,
        origin={-11,-49})));
  Fluid.Sources.Boundary_pT sinCoo(
    redeclare package Medium = MediumW,
    p=300000,
    T=288.15,
    nPorts=5) "Sink for cooling "
    annotation (Placement(transformation(
        extent={{-9,-9},{9,9}},
        rotation=90,
        origin={31,-49})));

  Fluid.Sources.Boundary_pT souCoo(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 300000 + 6000,
    T=279.15,
    nPorts=5) "Source for cooling "
    annotation (Placement(
        transformation(
        extent={{-9,-9},{9,9}},
        rotation=90,
        origin={51,-49})));

   ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice.BaseClasses.Floor floor1(
      redeclare package Medium = MediumA) "5-zone building model"
    annotation (Placement(transformation(extent={{62,76},{140,120}})));

  Fluid.ZoneEquipment.FanCoilUnit.FourPipe fanCoiUni[5](
    redeclare package MediumA = MediumA,
    redeclare package MediumHW = MediumW,
    redeclare package MediumCHW = MediumW,
    mHotWat_flow_nominal={0.21805,0.53883,0.33281,0.50946,0.33236},
    dpAir_nominal=fill(100, 5),
    UAHeaCoi_nominal={2.25*146.06,2.25*146.06,2.25*146.06,2.25*146.06,2.25*146.06},
    mChiWat_flow_nominal={0.23106,0.30892,0.18797,0.2984,0.18781},
    UACooCoi_nominal={2.25*146.06,2.25*146.06,2.25*146.06,2.25*146.06,2.25*146.06},
    mAir_flow_nominal={0.09,0.222,0.1337,0.21303,0.137},
    QHeaCoi_flow_nominal={6036.5,8070.45,4910.71,7795.7,4906.52},
    each fanPer=fanPer) "Fan coil units"
    annotation (Placement(transformation(extent={{20,16},{40,36}})));

  Controls.OBC.ASHRAE.G36.FanCoilUnits.Controller conFCU[5](each TSupSet_max=308.15,
      each TSupSet_min=285.85) "Fan coil unit controller"
    annotation (Placement(transformation(extent={{-36,-6},{4,54}})));

  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(each filNam=
        Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
      computeWetBulbTemperature=false) "Weather data reader"
    annotation (Placement(transformation(extent={{-60,100},{-40,120}})));

  Controls.SetPoints.OccupancySchedule           occSch(occupancy=3600*{6,19})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));
  Modelica.Blocks.Sources.Constant TSetAdj(k=0)
    "Temperature setpoint adjustment value"
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));

  Controls.OBC.CDL.Reals.Sources.Constant TOccSetPoi(k=23 + 273.15)
    "Occupied temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));

  Controls.OBC.CDL.Reals.Sources.Constant TUnOccCooSet(k=25 + 273.15)
    "Unoccupied cooling  temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-60},{-120,-40}})));

  Controls.OBC.CDL.Reals.Sources.Constant TUnOccHeaSet(k=21 + 273.15)
    "Unoccupied heating temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));

  Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep(nout=5)
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));

  Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep1(nout=5)
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));

  Controls.OBC.CDL.Reals.GreaterThreshold greThr[5]
    annotation (Placement(transformation(extent={{-140,-120},{-120,-100}})));

  Controls.OBC.CDL.Logical.Timer tim[5](t=fill(120, 5))
    annotation (Placement(transformation(extent={{-100,-120},{-80,-100}})));

  Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep2(nout=5)
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));

  Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep3(nout=5)
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep1(nout=5)
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));

  Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep4(nout=5)
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));

  Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep5(nout=5)
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));

  Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep6(nout=5)
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));

  Controls.OBC.CDL.Integers.Sources.Constant LimLev(k=0)
    "Cooling and heating demand limit level"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));

  replaceable parameter Fluid.Movers.Data.Generic           fanPer
    constrainedby Fluid.Movers.Data.Generic
    "Record with performance data for supply fan"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{106,-114},{124,-96}})),
      Dialog(group="Fan parameters"));

protected
  Controls.OBC.CDL.Reals.Sources.Constant           cooWarTim(final k=0)
    "Cooldown and warm-up time"
    annotation (Placement(transformation(extent={{-140,120},{-120,140}})));
equation
  connect(conFCU.yFan, fanCoiUni.uFan) annotation (Line(points={{6,37.3333},{14,
          37.3333},{14,28},{19,28}},
                              color={0,0,127}));
  connect(conFCU.yCooCoi, fanCoiUni.uCoo) annotation (Line(points={{6,24},{19,24}},
                                         color={0,0,127}));
  connect(conFCU.yHeaCoi, fanCoiUni.uHea) annotation (Line(points={{6,27.3333},
          {16,27.3333},{16,20},{19,20}},color={0,0,127}));
  connect(intScaRep.y, conFCU.uCooDemLimLev) annotation (Line(points={{-78,70},{
          -68,70},{-68,29},{-38,29}},                  color={255,127,0}));
  connect(intScaRep.y, conFCU.uHeaDemLimLev) annotation (Line(points={{-78,70},
          {-68,70},{-68,24},{-50,24},{-50,25.6667},{-38,25.6667}},       color=
          {255,127,0}));
  connect(cooWarTim.y, reaScaRep1.u) annotation (Line(points={{-118,130},{-102,
          130}},                     color={0,0,127}));
  connect(reaScaRep1.y, conFCU.warUpTim) annotation (Line(points={{-78,130},{
          -70,130},{-70,96},{-62,96},{-62,52.3333},{-38,52.3333}},
                                      color={0,0,127}));
  connect(reaScaRep1.y, conFCU.cooDowTim) annotation (Line(points={{-78,130},{-70,
          130},{-70,96},{-62,96},{-62,54},{-50,54},{-50,49},{-38,49}},
                                      color={0,0,127}));
  connect(greThr.y, tim.u) annotation (Line(points={{-118,-110},{-102,-110}},
               color={255,0,255}));
  connect(fanCoiUni.TAirSup, conFCU.TSup) annotation (Line(points={{41,21.2},{
          44,21.2},{44,64},{-66,64},{-66,22.3333},{-38,22.3333}},
                                                            color={0,0,127}));
  connect(TSetAdj.y, reaScaRep2.u)
    annotation (Line(points={{-119,100},{-102,100}}, color={0,0,127}));
  connect(reaScaRep2.y, conFCU.setAdj) annotation (Line(points={{-78,100},{-64,
          100},{-64,38},{-50,38},{-50,42.3333},{-38,42.3333}},
                                  color={0,0,127}));
  connect(occSch.tNexOcc, reaScaRep3.u) annotation (Line(points={{-119,16},{
          -110,16},{-110,40},{-102,40}},      color={0,0,127}));
  connect(reaScaRep3.y, conFCU.tNexOcc) annotation (Line(points={{-78,40},{-52,
          40},{-52,45.6667},{-38,45.6667}},  color={0,0,127}));
  connect(occSch.occupied, booScaRep1.u) annotation (Line(points={{-119,4},{
          -112,4},{-112,10},{-102,10}},
                                     color={255,0,255}));
  connect(booScaRep1.y, conFCU.u1Occ) annotation (Line(points={{-78,10},{-52,10},
          {-52,32.5},{-38,32.5}},      color={255,0,255}));
  connect(TOccSetPoi.y, reaScaRep4.u) annotation (Line(points={{-118,-20},{-102,
          -20}},                           color={0,0,127}));
  connect(reaScaRep4.y, conFCU.TOccHeaSet) annotation (Line(points={{-78,-20},{
          -52,-20},{-52,4},{-50,4},{-50,15.6667},{-38,15.6667}},
                                                              color={0,0,127}));
  connect(reaScaRep4.y, conFCU.TOccCooSet) annotation (Line(points={{-78,-20},{
          -52,-20},{-52,12.3333},{-38,12.3333}},
                                          color={0,0,127}));
  connect(TUnOccCooSet.y, reaScaRep5.u)
    annotation (Line(points={{-118,-50},{-102,-50}},    color={0,0,127}));
  connect(reaScaRep5.y, conFCU.TUnoCooSet) annotation (Line(points={{-78,-50},{-52,
          -50},{-52,-22},{-50,-22},{-50,5.66667},{-38,5.66667}},
                                          color={0,0,127}));
  connect(TUnOccHeaSet.y, reaScaRep6.u) annotation (Line(points={{-118,-80},{
          -102,-80}},              color={0,0,127}));
  connect(reaScaRep6.y, conFCU.TUnoHeaSet) annotation (Line(points={{-78,-80},{-70,
          -80},{-70,9},{-38,9}},          color={0,0,127}));

  connect(LimLev.y, intScaRep.u)
    annotation (Line(points={{-118,70},{-102,70}},     color={255,127,0}));
  connect(fanCoiUni[1].port_Air_a, floor1.portsCor[1]) annotation (Line(points={{40,28},
          {94,28},{94,72},{54,72},{54,100},{58,100},{58,124},{91.3348,124},{
          91.3348,99.0154}}, color={0,127,255}));
  connect(fanCoiUni[1].port_Air_b, floor1.portsCor[2]) annotation (Line(points={{40,24},
          {78,24},{78,28},{94,28},{94,72},{54,72},{54,100},{58,100},{58,124},{
          93.0304,124},{93.0304,99.0154}},                           color={0,
          127,255}));
  connect(fanCoiUni[2].port_Air_a, floor1.portsSou[1]) annotation (Line(points={{40,28},
          {91.3348,28},{91.3348,85.4769}},                           color={0,
          127,255}));
  connect(fanCoiUni[2].port_Air_b, floor1.portsSou[2]) annotation (Line(points={{40,24},
          {78,24},{78,28},{93.0304,28},{93.0304,85.4769}},             color={0,
          127,255}));
  connect(fanCoiUni[3].port_Air_a, floor1.portsEas[1]) annotation (Line(points={{40,28},
          {104,28},{104,68},{154,68},{154,99.0154},{129.996,99.0154}},
                     color={0,127,255}));
  connect(fanCoiUni[3].port_Air_b, floor1.portsEas[2]) annotation (Line(points={{40,24},
          {92,24},{92,20},{108,20},{108,72},{148,72},{148,99.0154},{131.691,
          99.0154}},         color={0,127,255}));
  connect(fanCoiUni[4].port_Air_a, floor1.portsNor[1]) annotation (Line(points={{40,28},
          {84,28},{84,68},{44,68},{44,96},{48,96},{48,120},{91.3348,120},{
          91.3348,110.523}}, color={0,127,255}));
  connect(fanCoiUni[4].port_Air_b, floor1.portsNor[2]) annotation (Line(points={{40,24},
          {78,24},{78,28},{100,28},{100,64},{54,64},{54,100},{58,100},{58,124},
          {93.0304,124},{93.0304,110.523}},color={0,127,255}));
  connect(fanCoiUni[5].port_Air_a, floor1.portsWes[1]) annotation (Line(points={{40,28},
          {86,28},{86,60},{46,60},{46,90},{58,90},{58,99.0154},{70.3087,99.0154}},
        color={0,127,255}));
  connect(fanCoiUni[5].port_Air_b, floor1.portsWes[2]) annotation (Line(points={{40,24},
          {54,24},{54,30},{70,30},{70,74},{30,74},{30,99.0154},{72.0043,99.0154}},
                                       color={0,127,255}));
  connect(floor1.TRooAir[5], conFCU[1].TZon) annotation (Line(points={{141.696,
          98.6769},{144,98.6769},{144,136},{-66,136},{-66,94},{-70,94},{-70,22},
          {-68,22},{-68,19},{-38,19}},                  color={0,0,127}));
  connect(conFCU[2].TZon, floor1.TRooAir[1]) annotation (Line(points={{-38,19},
          {-68,19},{-68,22},{-70,22},{-70,94},{-66,94},{-66,136},{141.696,136},
          {141.696,97.3231}},                                     color={0,0,127}));
  connect(conFCU[3].TZon, floor1.TRooAir[2]) annotation (Line(points={{-38,19},
          {-68,19},{-68,22},{-70,22},{-70,94},{-66,94},{-66,136},{141.696,136},
          {141.696,97.6615}},                                     color={0,0,127}));
  connect(conFCU[4].TZon, floor1.TRooAir[3]) annotation (Line(points={{-38,19},
          {-68,19},{-68,22},{-70,22},{-70,94},{-66,94},{-66,136},{144,136},{144,
          98},{141.696,98}},                                      color={0,0,127}));
  connect(conFCU[5].TZon, floor1.TRooAir[4]) annotation (Line(points={{-38,19},
          {-68,19},{-68,22},{-70,22},{-70,94},{-66,94},{-66,136},{144,136},{144,
          98.3385},{141.696,98.3385}},                            color={0,0,127}));
  connect(sinHea.ports, fanCoiUni.port_HW_b) annotation (Line(points={{-11,-40},
          {-6,-40},{-6,-24},{-2,-24},{-2,-16},{18,-16},{18,-2},{24,-2},{24,16}},
                                                                 color={0,127,
          255}));
  connect(fanCoiUni.port_HW_a, souHea.ports) annotation (Line(points={{27,16},{
          27,-36},{11,-36},{11,-40}}, color={0,127,255}));
  connect(fanCoiUni.port_CHW_a, souCoo.ports) annotation (Line(points={{36,16},
          {36,-36},{51,-36},{51,-40}}, color={0,127,255}));
  connect(fanCoiUni.port_CHW_b, sinCoo.ports) annotation (Line(points={{33,16},
          {33,-36},{31,-36},{31,-40}}, color={0,127,255}));
  connect(tim.passed, conFCU.u1Fan) annotation (Line(points={{-78,-118},{-68,-118},
          {-68,-1},{-38,-1}},         color={255,0,255}));
  connect(fanCoiUni.yFan_actual, greThr.u) annotation (Line(points={{40.5,34},{
          80,34},{80,-140},{-152,-140},{-152,-110},{-142,-110}}, color={0,0,127}));
  connect(weaDat.weaBus, floor1.weaBus) annotation (Line(
      points={{-40,110},{56,110},{56,132},{111.174,132},{111.174,126.769}},
      color={255,204,51},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,
            -140},{160,160}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-140},{160,
            160}})),
    experiment(
      StartTime=259200,
      StopTime=345600,
      Interval=60,
      Tolerance=1e-07,
      __Dymola_Algorithm="Cvode"),
    Documentation(info="<html>
<p>This model simulates <a href=\"modelica://Buildings.Fluid.ZoneEquipment.FanCoilUnit.FourPipe\">Buildings.Fluid.ZoneEquipment.FanCoilUnit.FourPipe</a> , a four-pipe fan coil unit(FCU) system model for a 5-zone thermal model. </p>
<p><br><span style=\"font-family: Arial;\">This model consist of an variable air volume(VAV) HVAC system, a building envelope model and a model for air flow through building leakage and through open doors. The HVAC system includes a fan-coil unit and a fan coil controller for each thermal zone. The fan-coil unit that consists of a a supply fan, an electric or hot-water heating coil, and a chilled-water cooling coil. The fan coil unit controller outputs supply fan enable signal and speed signal, the supply air temperature setpoint, the zone air heating and cooling setpoints, and valve positions of heating and cooling coils.</span></p>
<p>See the model <a href=\"modelica://Buildings.Fluid.ZoneEquipment.FanCoilUnit.FourPipe\">Buildings.Fluid.ZoneEquipment.FanCoilUnit.FourPipe</a> and <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnits.Controller\">Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnits.Controller</a> for a description of the Fan Coil unit and the controller, and see the model <a href=\"modelica://Buildings.Examples.VAVReheat.BaseClasses.Floor\">Buildings.Examples.VAVReheat.BaseClasses.Floor</a> for a description of the building envelope. </p>
<p>The HVAC system switches between occupied, unoccupied, unoccupied warm-up and unoccupied pre-cool modes.The cooling coil and heating coil valves are modulated to maintain the heating and cooling setpoints. The supply air temperature is modulated based on the differential between the temperature setpoint and the zone temperature to avoid unecessary heating and cooling use and avoid extreme temperature fluctuations. </p>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/HydronicSystems/FanCoilUnit.mos"
        "Simulate and plot"),
    experiment(StopTime=345600, Tolerance=1e-07));
end FanCoilUnit;
