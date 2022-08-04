within Buildings.Fluid.ZoneEquipment.FanCoilUnit;
model FanCoilUnit "System model for fan coil unit"

  parameter Buildings.Fluid.ZoneEquipment.FanCoilUnit.Types.heatingCoil
    heatingCoilType=Buildings.Fluid.ZoneEquipment.FanCoilUnit.Types.heatingCoil.heatingHotWater
    "Type of heating coil used in the FCU"
    annotation (Dialog(group="System parameters"));

  parameter Modelica.Units.SI.HeatFlowRate QHeaCoi_flow_nominal
    "Heat flow rate at u=1, positive for heating"
    annotation(Dialog(enable=not has_heatingCoilHHW, group="Heating coil parameters"));

  parameter Modelica.Units.SI.MassFlowRate mHotWat_flow_nominal
    "Nominal mass flow rate of water"
    annotation(Dialog(enable=has_heatingCoilHHW, group="Heating coil parameters"));

  parameter Modelica.Units.SI.PressureDifference dpAirTot_nominal
    "Total pressure difference across supply and return ports in airloop"
    annotation(Dialog(group="System parameters"));

  parameter Modelica.Units.SI.ThermalConductance UAHeaCoi_nominal
    "Thermal conductance at nominal flow, used to compute heat capacity"
    annotation(Dialog(enable=has_heatingCoilHHW, group="Heating coil parameters"));

  parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal
    "Nominal mass flow rate of water"
    annotation(Dialog(group="Cooling coil parameters"));

  parameter Modelica.Units.SI.ThermalConductance UACooCoi_nominal
    "Thermal conductance at nominal flow, used to compute heat capacity"
    annotation(Dialog(group="Cooling coil parameters"));

  parameter Modelica.Units.SI.MassFlowRate mAirOut_flow_nominal
    "Nominal mass flow rate of outdoor air"
    annotation(Dialog(group="System parameters"));

  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal
    "Nominal mass flow rate, used for regularization near zero flow"
    annotation(Dialog(group="System parameters"));

  parameter Boolean has_heatingCoilHHW=(heatingCoilType == Buildings.Fluid.ZoneEquipment.FanCoilUnit.Types.heatingCoil.heatingHotWater)
    "Does the zone equipment have a hot water heating coil?"
    annotation(Dialog(enable=false, tab="Non-configurable"));

  replaceable package MediumA = Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialCondensingGases
    "Medium model for air"
    annotation(Dialog(enable=false));

  replaceable package MediumW = Buildings.Media.Water
    "Medium model for water"
    annotation(Dialog(enable=false));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHea(
    final unit="1",
    displayUnit="1",
    final min=0,
    final max=1)
    "Heating loop signal"
    annotation(Placement(transformation(extent={{-400,-140},{-360,-100}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoo(
    final unit="1",
    displayUnit="1",
    final min=0,
    final max=1)
    "Cooling loop signal"
    annotation(Placement(transformation(extent={{-400,-100},{-360,-60}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uFan(
    final unit="1",
    displayUnit="1",
    final min=0,
    final max=1)
    "Fan signal"
    annotation(Placement(transformation(extent={{-400,60},{-360,100}}),
      iconTransformation(extent={{-140,0},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOA(
    final unit="1",
    displayUnit="1",
    final min=0,
    final max=1)
    "Outdoor air signal"
    annotation(Placement(transformation(extent={{-400,100},{-360,140}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_return(
    redeclare package Medium = MediumA)
    "Return air port from zone"
    annotation(Placement(transformation(extent={{350,30},{370,50}}),
      iconTransformation(extent={{90,-10},{110,10}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_supply(
    redeclare package Medium = MediumA)
    "Supply air port to the zone"
    annotation(Placement(transformation(extent={{350,-50},{370,-30}}),
      iconTransformation(extent={{90,-50},{110,-30}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_CCW_outlet(
    redeclare package Medium = MediumW)
    "Chilled water return port"
    annotation(Placement(transformation(extent={{94,-190},{114,-170}}),
      iconTransformation(extent={{10,-110},{30,-90}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_CCW_inlet(
    redeclare package Medium = MediumW)
    "Chilled water supply port"
    annotation(Placement(transformation(extent={{134,-190},{154,-170}}),
      iconTransformation(extent={{50,-110},{70,-90}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_HHW_outlet(
    redeclare package Medium = MediumW) if has_heatingCoilHHW
    "Hot water return port"
    annotation(Placement(transformation(extent={{-46,-190},{-26,-170}}),
      iconTransformation(extent={{-70,-110},{-50,-90}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_HHW_inlet(
    redeclare package Medium = MediumW) if has_heatingCoilHHW
    "Hot water supply port"
    annotation(Placement(transformation(extent={{-6,-190},{14,-170}}),
      iconTransformation(extent={{-30,-110},{-10,-90}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSupAir(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Supply air temperature"
    annotation(Placement(transformation(extent={{360,100},{400,140}}),
      iconTransformation(extent={{100,60},{140,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VSupAir_flow(
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate")
    "Supply air flowrate"
    annotation(Placement(transformation(extent={{360,60},{400,100}}),
      iconTransformation(extent={{100,20},{140,60}})));

  Buildings.Fluid.Actuators.Dampers.MixingBox eco(
    redeclare package Medium = MediumA,
    final mOut_flow_nominal=mAirOut_flow_nominal,
    final dpDamOut_nominal=50,
    final mRec_flow_nominal=mAir_flow_nominal,
    final dpDamRec_nominal=50,
    final mExh_flow_nominal=mAirOut_flow_nominal,
    final dpDamExh_nominal=50)
    "Outdoor air economizer"
    annotation (Placement(transformation(extent={{-180,-20},{-160,0}})));

  Buildings.Fluid.Sources.Outside out(
    redeclare package Medium = MediumA,
    final nPorts=2)
    "Boundary conditions for outside air"
    annotation (Placement(transformation(extent={{-280,-30},{-260,-10}})));

  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    "Weather bus"
    annotation (Placement(transformation(extent={{-340,-40},{-300,0}}),
      iconTransformation(extent={{-90,70},{-70,90}})));

  replaceable Buildings.Fluid.Sensors.VolumeFlowRate VAirOut_flow(
    redeclare package Medium = MediumA,
    final m_flow_nominal=mAirOut_flow_nominal)
    "Outdoor air volume flowrate"
    annotation (Placement(transformation(extent={{-240,-10},{-220,10}})));

  replaceable Buildings.Fluid.Sensors.TemperatureTwoPort TAirOutSen(
    redeclare package Medium = MediumA,
    final m_flow_nominal=mAirOut_flow_nominal)
    "Outdoor air temperature sensor"
    annotation (Placement(transformation(extent={{-210,-10},{-190,10}})));

  replaceable Buildings.Fluid.Sensors.TemperatureTwoPort TAirExhSen(
    redeclare package Medium = MediumA,
    final m_flow_nominal=mAirOut_flow_nominal)
    "Return air temperature sensor"
    annotation (Placement(transformation(extent={{-210,-50},{-190,-30}})));

  replaceable Buildings.Fluid.Sensors.VolumeFlowRate VAirExh_flow(
    redeclare package Medium = MediumA,
    final m_flow_nominal=mAirOut_flow_nominal)
    "Exhaust air volume flowrate"
    annotation (Placement(transformation(extent={{-240,-50},{-220,-30}})));

  replaceable Buildings.Fluid.Sensors.TemperatureTwoPort TAirMixSen(
    redeclare package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal)
    "Mixed air temperature sensor"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));

  replaceable Buildings.Fluid.Sensors.VolumeFlowRate VAirMix_flow(
    redeclare package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal)
    "Mixed air volume flowrate"
    annotation (Placement(transformation(extent={{-110,-20},{-90,0}})));

  replaceable Buildings.Fluid.Sensors.TemperatureTwoPort TAirHeaSen(
    redeclare package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal)
    "Heating coil discharge air temperature sensor"
    annotation (Placement(transformation(extent={{30,-20},{50,0}})));

  Buildings.Fluid.HeatExchangers.DryCoilCounterFlow heaCoiHHW(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumA,
    final m1_flow_nominal=mHotWat_flow_nominal,
    final m2_flow_nominal=mAir_flow_nominal,
    final dp1_nominal=0,
    final dp2_nominal=0,
    final UA_nominal=UAHeaCoi_nominal,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) if has_heatingCoilHHW
    "Hot water heating coil"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=180,
      origin={-10,-50})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear valHotWat(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mHotWat_flow_nominal,
    final dpValve_nominal=50) if has_heatingCoilHHW
    "Hot water flow control valve"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-36,-74})));

  replaceable Buildings.Fluid.Sensors.VolumeFlowRate VHotWat_flow(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mHotWat_flow_nominal) if has_heatingCoilHHW
    "Hot water volume flowrate sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={4,-84})));

  replaceable Buildings.Fluid.Sensors.TemperatureTwoPort THotWatRetSen(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mHotWat_flow_nominal) if has_heatingCoilHHW
    "Hot water return temperature sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=-90,
      origin={-36,-104})));

  replaceable Buildings.Fluid.Sensors.TemperatureTwoPort THotWatSupSen(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mHotWat_flow_nominal) if has_heatingCoilHHW
    "Hot water supply temperature sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={4,-114})));

  Buildings.Fluid.HeatExchangers.WetCoilCounterFlow cooCoiCHW(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumA,
    final m1_flow_nominal=mChiWat_flow_nominal,
    final m2_flow_nominal=mAir_flow_nominal,
    final dp1_nominal=0,
    final dp2_nominal=0,
    final UA_nominal=UACooCoi_nominal,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Chilled-water cooling coil"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=180,
      origin={130,-10})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear valChiWat(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mChiWat_flow_nominal,
    final dpValve_nominal=50)
    "Chilled water flow control valve"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={104,-34})));

  replaceable Buildings.Fluid.Sensors.TemperatureTwoPort TChiWatRetSen(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mChiWat_flow_nominal)
    "Chilled water return temperature sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=-90,
      origin={104,-64})));

  replaceable Buildings.Fluid.Sensors.VolumeFlowRate VChiWat_flow(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mChiWat_flow_nominal)
    "Chilled water volume flowrate sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={144,-44})));

  replaceable Buildings.Fluid.Sensors.TemperatureTwoPort TChiWatSupSen(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mChiWat_flow_nominal)
    "Chilled water supply temperature sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={144,-74})));

  replaceable Buildings.Fluid.Sensors.TemperatureTwoPort TAirSupSen(
    redeclare package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal)
    "Discharge air temperature sensor"
    annotation (Placement(transformation(extent={{240,-20},{260,0}})));

  Buildings.Fluid.Movers.FlowControlled_m_flow fan(
    redeclare package Medium = MediumA,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal=mAir_flow_nominal,
    final per=fanPer,
    final dp_nominal=dpAirTot_nominal + 1000)
    "Supply fan"
    annotation (Placement(transformation(extent={{200,-20},{220,0}})));

  replaceable Buildings.Fluid.Sensors.VolumeFlowRate VAirSup_flow(
    redeclare package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal)
    "Discharge air volume flow rate"
    annotation (Placement(transformation(extent={{280,-20},{300,0}})));

  replaceable parameter Buildings.Fluid.Movers.Data.Generic fanPer
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Record with performance data for supply fan"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{50,100},{70,120}})),
      Dialog(group="Fan parameters"));

  Buildings.Fluid.FixedResistances.PressureDrop totalRes(
    final m_flow_nominal=mAir_flow_nominal,
    final dp_nominal=dpAirTot_nominal,
    final allowFlowReversal=false,
    redeclare package Medium = MediumA)
    "Total resistance"
    annotation (Placement(transformation(extent={{156,-14},{176,6}})));

  replaceable Buildings.Fluid.Sensors.TemperatureTwoPort TAirRetSen(
    redeclare package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal)
    "Return air temperature sensor"
    annotation (Placement(transformation(extent={{-150,30},{-130,50}})));

  replaceable Buildings.Fluid.Sensors.VolumeFlowRate VAirRet_flow(
    redeclare package Medium = MediumA,
    m_flow_nominal=mAir_flow_nominal)
    "Return air volume flowrate"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));

  Buildings.Fluid.HeatExchangers.HeaterCooler_u heaCoiEle(
    redeclare package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal,
    final dp_nominal=0,
    final Q_flow_nominal=QHeaCoi_flow_nominal) if not has_heatingCoilHHW
    "Electric heating coil"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));

equation
  connect(uOA, eco.y) annotation (Line(points={{-380,120},{-170,120},{-170,2}},
                      color={0,0,127}));

  connect(weaBus, out.weaBus) annotation (Line(
      points={{-320,-20},{-300,-20},{-300,-19.8},{-280,-19.8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

  connect(VAirOut_flow.port_b, TAirOutSen.port_a)
    annotation (Line(points={{-220,0},{-210,0}}, color={0,127,255}));

  connect(TAirOutSen.port_b, eco.port_Out)
    annotation (Line(points={{-190,0},{-180,0},{-180,-4}}, color={0,127,255}));

  connect(out.ports[1], VAirOut_flow.port_a) annotation (Line(points={{-260,-18},
          {-252,-18},{-252,0},{-240,0}}, color={0,127,255}));

  connect(VAirExh_flow.port_b, TAirExhSen.port_a)
    annotation (Line(points={{-220,-40},{-210,-40}}, color={0,127,255}));

  connect(TAirExhSen.port_b, eco.port_Exh) annotation (Line(points={{-190,-40},{
          -180,-40},{-180,-16}}, color={0,127,255}));

  connect(VAirExh_flow.port_a, out.ports[2]) annotation (Line(points={{-240,-40},
          {-252,-40},{-252,-22},{-260,-22}}, color={0,127,255}));

  connect(TAirMixSen.port_b, VAirMix_flow.port_a)
    annotation (Line(points={{-120,-10},{-110,-10}}, color={0,127,255}));

  connect(eco.port_Sup, TAirMixSen.port_a) annotation (Line(points={{-160,-4},{-140,
          -4},{-140,-10}}, color={0,127,255}));

  connect(valHotWat.port_b, heaCoiHHW.port_b1) annotation (Line(points={{-36,-64},
          {-36,-56},{-20,-56}}, color={0,127,255}));

  connect(VHotWat_flow.port_b, heaCoiHHW.port_a1)
    annotation (Line(points={{4,-74},{4,-56},{0,-56}}, color={0,127,255}));

  connect(THotWatRetSen.port_a, valHotWat.port_a)
    annotation (Line(points={{-36,-94},{-36,-84}}, color={0,127,255}));

  connect(THotWatSupSen.port_b, VHotWat_flow.port_a)
    annotation (Line(points={{4,-104},{4,-94}}, color={0,127,255}));

  connect(VAirMix_flow.port_b, heaCoiHHW.port_a2) annotation (Line(points={{-90,
          -10},{-40,-10},{-40,-44},{-20,-44}}, color={0,127,255}));

  connect(heaCoiHHW.port_b2, TAirHeaSen.port_a) annotation (Line(points={{0,-44},
          {20,-44},{20,-10},{30,-10}}, color={0,127,255}));

  connect(uHea, valHotWat.y) annotation (Line(points={{-380,-120},{-60,-120},{-60,
          -74},{-48,-74}}, color={0,0,127}));

  connect(port_HHW_inlet, THotWatSupSen.port_a)
    annotation (Line(points={{4,-180},{4,-124}}, color={0,127,255}));

  connect(port_HHW_outlet, THotWatRetSen.port_b)
    annotation (Line(points={{-36,-180},{-36,-114}}, color={0,127,255}));

  connect(TChiWatRetSen.port_a, valChiWat.port_a)
    annotation (Line(points={{104,-54},{104,-44}}, color={0,127,255}));

  connect(valChiWat.port_b, cooCoiCHW.port_b1) annotation (Line(points={{104,-24},
          {104,-16},{120,-16}}, color={0,127,255}));

  connect(VChiWat_flow.port_b, cooCoiCHW.port_a1) annotation (Line(points={{144,
          -34},{144,-16},{140,-16}}, color={0,127,255}));

  connect(TChiWatSupSen.port_b, VChiWat_flow.port_a)
    annotation (Line(points={{144,-64},{144,-54}}, color={0,127,255}));

  connect(TAirHeaSen.port_b, cooCoiCHW.port_a2) annotation (Line(points={{50,-10},
          {80,-10},{80,-4},{120,-4}}, color={0,127,255}));

  connect(port_CCW_outlet, TChiWatRetSen.port_b)
    annotation (Line(points={{104,-180},{104,-74}}, color={0,127,255}));

  connect(TChiWatSupSen.port_a, port_CCW_inlet)
    annotation (Line(points={{144,-84},{144,-180}}, color={0,127,255}));

  connect(fan.port_b, TAirSupSen.port_a)
    annotation (Line(points={{220,-10},{240,-10}}, color={0,127,255}));

  connect(uCoo, valChiWat.y) annotation (Line(points={{-380,-80},{-80,-80},{-80,
          -34},{92,-34}}, color={0,0,127}));

  connect(TAirSupSen.T, TSupAir)
    annotation (Line(points={{250,1},{250,120},{380,120}}, color={0,0,127}));

  connect(TAirSupSen.port_b, VAirSup_flow.port_a)
    annotation (Line(points={{260,-10},{280,-10}}, color={0,127,255}));

  connect(VAirSup_flow.port_b, port_supply) annotation (Line(points={{300,-10},
          {320,-10},{320,-40},{360,-40}},
                                       color={0,127,255}));

  connect(VAirSup_flow.V_flow, VSupAir_flow)
    annotation (Line(points={{290,1},{290,80},{380,80}},   color={0,0,127}));

  connect(cooCoiCHW.port_b2, totalRes.port_a)
    annotation (Line(points={{140,-4},{156,-4}}, color={0,127,255}));

  connect(totalRes.port_b, fan.port_a) annotation (Line(points={{176,-4},{180,-4},
          {180,-10},{200,-10}}, color={0,127,255}));

  connect(TAirRetSen.port_b, VAirRet_flow.port_a)
    annotation (Line(points={{-130,40},{-120,40}}, color={0,127,255}));

  connect(VAirRet_flow.port_b, eco.port_Ret) annotation (Line(points={{-100,40},
          {-88,40},{-88,14},{-150,14},{-150,-16},{-160,-16}}, color={0,127,255}));

  connect(TAirRetSen.port_a, port_return) annotation (Line(points={{-150,40},{-160,
          40},{-160,60},{-60,60},{-60,40},{360,40}}, color={0,127,255}));

  connect(uFan, fan.m_flow_in)
    annotation (Line(points={{-380,80},{210,80},{210,2}}, color={0,0,127}));
  connect(VAirMix_flow.port_b, heaCoiEle.port_a) annotation (Line(points={{-90,-10},
          {-40,-10},{-40,10},{-20,10}}, color={0,127,255}));
  connect(heaCoiEle.port_b, TAirHeaSen.port_a) annotation (Line(points={{0,10},{
          20,10},{20,-10},{30,-10}}, color={0,127,255}));
  connect(uHea, heaCoiEle.u) annotation (Line(points={{-380,-120},{-60,-120},{-60,
          16},{-22,16}}, color={0,0,127}));
  annotation (defaultComponentName = "fanCoiUni",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,100},{100,140}},
          textString="%name",
          textColor={0,0,255})}),
    Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-360,-180},{360,140}})),
    Documentation(info="<html>
    <p>
    This is a system model for a fan coil unit consisting of the following components:
    <br>
    <ul>
    <li>
    Outdoor air economizer <code>eco</code>: <a href=\"modelica://Buildings.Fluid.Actuators.Dampers.MixingBox\">
    Buildings.Fluid.Actuators.Dampers.MixingBox</a>
    </li>
    <li>
    Chilled-water cooling coil <code>cooCoiCHW</code>: <a href=\"modelica://Buildings.Fluid.HeatExchangers.WetCoilCounterFlow\">
    Buildings.Fluid.HeatExchangers.WetCoilCounterFlow</a>
    </li>
    <li>
    Supply fan <code>fan</code>: <a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_m_flow\">
    Buildings.Fluid.Movers.FlowControlled_m_flow</a>
    </li>
    <li>
    Heating coil: The model supports two different heating coils,
    <ul>
    <li>
    an electric heating coil <code>heaCoiEle</code>: <a href=\"modelica://Buildings.Fluid.HeatExchangers.HeaterCooler_u\">
    Buildings.Fluid.HeatExchangers.HeaterCooler_u</a>
    </li>
    <li>
    a hot-water heating coil <code>heaCoiHHW</code>: <a href=\"modelica://Buildings.Fluid.HeatExchangers.DryCoilCounterFlow\">
    Buildings.Fluid.HeatExchangers.DryCoilCounterFlow</a>
    </li>
    </ul>
    <br>
    The heating coil type parameter <code>heatingCoilType</code> is used to pick 
    between the two types of heating coils.
    </li>
    <li>
    Flow control valves <code>valHotWat</code> and <code>valCHiWat</code> for 
    controlling the flowrates of heating hot-water and chilled-water through their
    respective coils.
    </li>
    <li>
    Temperature and flowrate sensors at various points in the airloop, 
    chilled-water loop and hot-water loop.
    </li>
    </ul>
    </p>
    </html>
    ", revisions="<html>
    <ul>
    <li>
    August 03, 2022 by Karthik Devaprasad:<br/>
    First implementation.
    </li>
    </ul>
    </html>"));
end FanCoilUnit;
