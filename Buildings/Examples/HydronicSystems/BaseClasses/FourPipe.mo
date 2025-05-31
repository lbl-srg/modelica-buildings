within Buildings.Examples.HydronicSystems.BaseClasses;
model FourPipe "System model for a four-pipe fan coil unit"
  replaceable package MediumA = Modelica.Media.Interfaces.PartialMedium
    "Medium for air";

  replaceable package MediumHW = Modelica.Media.Interfaces.PartialMedium
    "Medium for hot water";

  replaceable package MediumCHW = Modelica.Media.Interfaces.PartialMedium
    "Medium for chilled water";

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil
    heaCoiTyp=Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Heating coil type"
    annotation (Dialog(group="System parameters"));

  parameter Modelica.Units.SI.HeatFlowRate QHeaCoi_flow_nominal(
    final min = 0)
    "Nominal heat flow rate of electric heating coil"
    annotation(Dialog(enable=not have_hotWat, group="Heating coil parameters"));

  parameter Modelica.Units.SI.MassFlowRate mHotWat_flow_nominal
    "Nominal mass flow rate of heating hot water"
    annotation(Dialog(enable=have_hotWat, group="Heating coil parameters"));

  parameter Modelica.Units.SI.PressureDifference dpAir_nominal
    "Total pressure difference across supply and return ports in airloop"
    annotation(Dialog(group="System parameters"));

  parameter Modelica.Units.SI.ThermalConductance UAHeaCoi_nominal
    "Thermal conductance at nominal flow, used to compute heat capacity"
    annotation(Dialog(enable=have_hotWat, group="Heating coil parameters"));

  parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal
    "Nominal mass flow rate of chilled water"
    annotation(Dialog(group="Cooling coil parameters"));

  parameter Modelica.Units.SI.ThermalConductance UACooCoi_nominal
    "Nominal Thermal conductance, used to compute heat capacity"
    annotation(Dialog(group="Cooling coil parameters"));

  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal
    "Nominal mass flow rate of supply air"
    annotation(Dialog(group="System parameters"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHea(
    final unit="1")
    "Heating loop control signal"
    annotation(Placement(transformation(extent={{-300,-140},{-260,-100}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoo(
    final unit="1")
    "Cooling loop control signal"
    annotation(Placement(transformation(extent={{-300,-48},{-260,-8}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uFan(
    final unit="1")
    "Fan control signal"
    annotation(Placement(transformation(extent={{-300,60},{-260,100}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yFan_actual(
    final unit="1",
    displayUnit="1")
    "Normalized actual fan speed signal"
    annotation (Placement(transformation(extent={{260,90},{300,130}}),
      iconTransformation(extent={{100,60},{140,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TAirSup
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{260,50},{300,90}}),
      iconTransformation(extent={{100,-100},{140,-60}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_Air_a(
    redeclare final package Medium = MediumA)
    "Return air port from zone"
    annotation (Placement(transformation(extent={{250,30},{270,50}}),
      iconTransformation(extent={{88,30},{108,50}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_Air_b(
    redeclare final package Medium = MediumA)
    "Supply air port to the zone"
    annotation (Placement(transformation(extent={{250,-50},{270,-30}}),
      iconTransformation(extent={{90,-50},{110,-30}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_CHW_b(
    redeclare final package Medium = Buildings.Media.Water)
    "Chilled water return port"
    annotation (Placement(transformation(extent={{-10,-150},{10,-130}}),
      iconTransformation(extent={{10,-110},{30,-90}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_CHW_a(
    redeclare package Medium = Buildings.Media.Water)
    "Chilled water supply port"
    annotation (Placement(transformation(extent={{50,-150},{70,-130}}),
      iconTransformation(extent={{50,-110},{70,-90}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_HW_b(
    redeclare final package Medium = Buildings.Media.Water) if have_hotWat
    "Hot water return port"
    annotation (Placement(transformation(extent={{-130,-150},{-110,-130}}),
      iconTransformation(extent={{-70,-110},{-50,-90}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_HW_a(
    redeclare final package Medium = Buildings.Media.Water) if have_hotWat
    "Hot water supply port"
    annotation (Placement(transformation(extent={{-70,-150},{-50,-130}}),
      iconTransformation(extent={{-30,-110},{-10,-90}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TAirHea(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal)
    "Heating coil discharge air temperature sensor"
    annotation (Placement(transformation(extent={{-30,-14},{-10,6}})));

  Buildings.Fluid.HeatExchangers.DryCoilCounterFlow heaCoiHW(
    redeclare final package Medium1 = MediumHW,
    redeclare final package Medium2 = MediumA,
    final m1_flow_nominal=mHotWat_flow_nominal,
    final m2_flow_nominal=mAir_flow_nominal,
    final dp1_nominal=0,
    final dp2_nominal=0,
    final UA_nominal=UAHeaCoi_nominal,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) if have_hotWat
    "Hot water heating coil"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
      rotation=180,
      origin={-90,-50})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear valHW(
    redeclare final package Medium = MediumHW,
    final m_flow_nominal=mHotWat_flow_nominal,
    final dpValve_nominal=50) if have_hotWat
    "Hot water flow control valve"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=90,
      origin={-120,-74})));

  Buildings.Fluid.Sensors.VolumeFlowRate VHW_flow(
    redeclare final package Medium = MediumHW,
    final m_flow_nominal=mHotWat_flow_nominal) if have_hotWat
    "Hot water volume flowrate sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-60,-84})));

  Buildings.Fluid.Sensors.TemperatureTwoPort THWRet(
    redeclare final package Medium = MediumHW,
    final m_flow_nominal=mHotWat_flow_nominal) if have_hotWat
    "Hot water return temperature sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=-90,
      origin={-120,-104})));

  Buildings.Fluid.Sensors.TemperatureTwoPort THWSup(
    redeclare final package Medium = MediumHW,
    final m_flow_nominal=mHotWat_flow_nominal) if have_hotWat
    "Hot water supply temperature sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-60,-114})));

  Buildings.Fluid.HeatExchangers.WetCoilCounterFlow cooCoi(
    redeclare final package Medium1 = MediumCHW,
    redeclare final package Medium2 = MediumA,
    final m1_flow_nominal=mChiWat_flow_nominal,
    final m2_flow_nominal=mAir_flow_nominal,
    final dp1_nominal=0,
    final dp2_nominal=0,
    final UA_nominal=UACooCoi_nominal,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Chilled-water cooling coil"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=180,
      origin={30,-10})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear valCHW(
    redeclare final package Medium = MediumCHW,
    final m_flow_nominal=mChiWat_flow_nominal,
    final dpValve_nominal=50)
    "Chilled-water flow control valve"
    annotation(Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=90,
      origin={0,-54})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWLvg(
    redeclare final package Medium = MediumCHW,
    final m_flow_nominal=mChiWat_flow_nominal)
    "Chilled-water return temperature sensor"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=-90,
      origin={0,-90})));

  Buildings.Fluid.Sensors.VolumeFlowRate VCHW_flow(
    redeclare final package Medium = MediumCHW,
    final m_flow_nominal=mChiWat_flow_nominal)
    "Chilled-water volume flowrate sensor"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={60,-44})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWEnt(
    redeclare final package Medium = MediumCHW,
    final m_flow_nominal=mChiWat_flow_nominal)
    "Chilled-water supply temperature sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={60,-74})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TAirLvg(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal)
    "Supply air temperature sensor"
    annotation (Placement(transformation(extent={{160,-20},{180,0}})));

  Buildings.Fluid.Movers.FlowControlled_m_flow fan(
    redeclare final package Medium = MediumA,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    addPowerToMedium=false,
    final m_flow_nominal=mAir_flow_nominal,
    final dp_nominal=dpAir_nominal,
    dpMax=200)
    "Supply fan"
    annotation (Placement(transformation(extent={{120,-20},{140,0}})));

  Buildings.Fluid.Sensors.VolumeFlowRate vAirSup(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal)
    "Supply air volume flow rate"
    annotation (Placement(transformation(extent={{200,-20},{220,0}})));

  Buildings.Fluid.FixedResistances.PressureDrop totRes(
    final m_flow_nominal=mAir_flow_nominal,
    final dp_nominal=dpAir_nominal,
    final allowFlowReversal=true,
    redeclare final package Medium = MediumA)
    "Total resistance"
    annotation (Placement(transformation(extent={{80,-14},{100,6}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TAirRet(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal)
    "Return air temperature sensor"
    annotation (Placement(transformation(extent={{-230,10},{-210,30}})));

  Buildings.Fluid.Sensors.VolumeFlowRate vAirRet(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal)
    "Return air volume flowrate"
    annotation (Placement(transformation(extent={{-200,10},{-180,30}})));

  Buildings.Fluid.HeatExchangers.HeaterCooler_u heaCoiEle(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal,
    final dp_nominal=0,
    final Q_flow_nominal=QHeaCoi_flow_nominal) if not have_hotWat
    "Electric heating coil"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));

  Modelica.Blocks.Math.Gain gai(
    final k=mAir_flow_nominal)
    "Find mass flowrate value by multiplying nominal flowrate by normalized fan speed signal"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));

  Modelica.Blocks.Math.Gain gaiFanNor(
    final k=1/mAir_flow_nominal)
    "Normalized fan signal"
    annotation (Placement(transformation(extent={{220,100},{240,120}})));

  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = MediumA,
    nPorts=1)
    "Boundary condition for normalizing pressure"
    annotation (Placement(transformation(extent={{84,12},{104,32}})));

protected
  final parameter Boolean have_hotWat=(heaCoiTyp ==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased)
    "Check if a hot water heating coil exists"
    annotation(Dialog(enable=false, tab="Non-configurable"));

equation
  connect(valHW.port_a, heaCoiHW.port_b1) annotation (Line(points={{-120,-64},{-120,
          -44},{-100,-44}},color={0,127,255}));
  connect(THWRet.port_a, valHW.port_b)
    annotation (Line(points={{-120,-94},{-120,-84}},
                                                   color={0,127,255}));
  connect(THWSup.port_b, VHW_flow.port_a)
    annotation (Line(points={{-60,-104},{-60,-94}},
                                                color={0,127,255}));
  connect(heaCoiHW.port_b2, TAirHea.port_a) annotation (Line(points={{-80,-56},{
          -40,-56},{-40,-4},{-30,-4}}, color={0,127,255}));
  connect(uHea, valHW.y) annotation (Line(points={{-280,-120},{-140,-120},{-140,
          -74},{-132,-74}},
                      color={0,0,127}));
  connect(port_HW_a, THWSup.port_a)
    annotation (Line(points={{-60,-140},{-60,-124}},
                                                 color={0,127,255}));
  connect(port_HW_b, THWRet.port_b)
    annotation (Line(points={{-120,-140},{-120,-114}},
                                                     color={0,127,255}));
  connect(TCHWLvg.port_a, valCHW.port_b)
    annotation (Line(points={{0,-80},{0,-64}},     color={0,127,255}));
  connect(valCHW.port_a, cooCoi.port_b1) annotation (Line(points={{0,-44},{0,-16},
          {20,-16}},       color={0,127,255}));
  connect(VCHW_flow.port_b, cooCoi.port_a1) annotation (Line(points={{60,-34},{60,
          -16},{40,-16}},      color={0,127,255}));
  connect(TCHWEnt.port_b, VCHW_flow.port_a)
    annotation (Line(points={{60,-64},{60,-54}},   color={0,127,255}));
  connect(TAirHea.port_b, cooCoi.port_a2) annotation (Line(points={{-10,-4},{20,
          -4}},                   color={0,127,255}));
  connect(port_CHW_b, TCHWLvg.port_b) annotation (Line(points={{0,-140},{0,-100}},
                                color={0,127,255}));
  connect(fan.port_b, TAirLvg.port_a)
    annotation (Line(points={{140,-10},{160,-10}}, color={0,127,255}));
  connect(uCoo, valCHW.y) annotation (Line(points={{-280,-28},{-20,-28},{-20,-54},
          {-12,-54}},color={0,0,127}));
  connect(TAirLvg.port_b, vAirSup.port_a)
    annotation (Line(points={{180,-10},{200,-10}}, color={0,127,255}));
  connect(vAirSup.port_b, port_Air_b) annotation (Line(points={{220,-10},{240,-10},
          {240,-40},{260,-40}}, color={0,127,255}));
  connect(cooCoi.port_b2, totRes.port_a)
    annotation (Line(points={{40,-4},{80,-4}},   color={0,127,255}));
  connect(TAirRet.port_b, vAirRet.port_a)
    annotation (Line(points={{-210,20},{-200,20}}, color={0,127,255}));
  connect(TAirRet.port_a, port_Air_a) annotation (Line(points={{-230,20},{-240,20},
          {-240,40},{260,40}},                   color={0,127,255}));
  connect(heaCoiEle.port_b, TAirHea.port_a) annotation (Line(points={{-80,10},{-40,
          10},{-40,-4},{-30,-4}}, color={0,127,255}));
  connect(uHea, heaCoiEle.u) annotation (Line(points={{-280,-120},{-140,-120},{-140,
          16},{-102,16}},color={0,0,127}));
  connect(uFan, gai.u)
    annotation (Line(points={{-280,80},{-102,80}},color={0,0,127}));
  connect(gai.y, fan.m_flow_in)
    annotation (Line(points={{-79,80},{130,80},{130,2}},
                                                       color={0,0,127}));
  connect(TCHWEnt.port_a, port_CHW_a)
    annotation (Line(points={{60,-84},{60,-140}},   color={0,127,255}));
  connect(gaiFanNor.y, yFan_actual)
    annotation (Line(points={{241,110},{280,110}}, color={0,0,127}));
  connect(fan.m_flow_actual, gaiFanNor.u) annotation (Line(points={{141,-5},{160,
          -5},{160,110},{218,110}},     color={0,0,127}));
  connect(heaCoiHW.port_a1, VHW_flow.port_b)
    annotation (Line(points={{-80,-44},{-60,-44},{-60,-74}},
                                                       color={0,127,255}));
  connect(TAirLvg.T, TAirSup)
    annotation (Line(points={{170,1},{170,70},{280,70}},   color={0,0,127}));
  connect(vAirRet.port_b, heaCoiEle.port_a) annotation (Line(points={{-180,20},{
          -160,20},{-160,10},{-100,10}},        color={0,127,255}));
  connect(vAirRet.port_b, heaCoiHW.port_a2) annotation (Line(points={{-180,20},{
          -160,20},{-160,-56},{-100,-56}},         color={0,127,255}));
  connect(totRes.port_b, fan.port_a) annotation (Line(points={{100,-4},{114,-4},
          {114,-10},{120,-10}}, color={0,127,255}));
  connect(bou.ports[1], fan.port_a) annotation (Line(points={{104,22},{114,22},{
          114,-10},{120,-10}},  color={0,127,255}));
  annotation (defaultComponentName = "fanCoiUni",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                               graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,100},{100,140}},
          textString="%name",
          textColor={0,0,255})}),
    Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-260,-140},{260,140}})),
    Documentation(info="<html>
    <p>
    This is a four-pipe fan coil unit system model. The system contains
    a supply fan, an electric or hot-water heating coil, and a chilled-water
    cooling coil.
    </p>
    </html>
    ", revisions="<html>
    <ul>
    <li>
    August 03, 2022 by Karthik Devaprasad, Sen Huang:<br/>
    First implementation.
    </li>
    </ul>
    </html>"));
end FourPipe;
