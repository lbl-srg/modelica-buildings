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

  Modelica.Blocks.Interfaces.RealInput uHea(
    final unit="1")
    "Heating loop control signal"
    annotation(Placement(transformation(extent={{-400,-140},{-360,-100}}),
      iconTransformation(extent={{-240,-140},{-200,-100}})));

  Modelica.Blocks.Interfaces.RealInput uCoo(
    final unit="1")
    "Cooling loop control signal"
    annotation(Placement(transformation(extent={{-400,-48},{-360,-8}}),
      iconTransformation(extent={{-240,-60},{-200,-20}})));

  Modelica.Blocks.Interfaces.RealInput uFan(
    final unit="1")
    "Fan control signal"
    annotation(Placement(transformation(extent={{-400,60},{-360,100}}),
      iconTransformation(extent={{-240,20},{-200,60}})));

  Modelica.Blocks.Interfaces.RealOutput yFan_actual(
    final unit="1",
    displayUnit="1")
    "Normalized actual fan speed signal"
    annotation (Placement(transformation(extent={{360,90},{400,130}}),
      iconTransformation(extent={{200,150},{220,170}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TAirSup
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{360,50},{400,90}}),
      iconTransformation(extent={{200,-120},{240,-80}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_Air_a(
    redeclare final package Medium = MediumA)
    "Return air port from zone"
    annotation (Placement(transformation(extent={{350,30},{370,50}}),
      iconTransformation(extent={{190,30},{210,50}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_Air_b(
    redeclare final package Medium = MediumA)
    "Supply air port to the zone"
    annotation (Placement(transformation(extent={{350,-50},{370,-30}}),
      iconTransformation(extent={{190,-50},{210,-30}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_CHW_b(
    redeclare final package Medium = Buildings.Media.Water)
    "Chilled water return port"
    annotation (Placement(transformation(extent={{70,-190},{90,-170}}),
      iconTransformation(extent={{50,-210},{70,-190}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_CHW_a(
    redeclare package Medium = Buildings.Media.Water)
    "Chilled water supply port"
    annotation (Placement(transformation(extent={{130,-190},{150,-170}}),
      iconTransformation(extent={{110,-210},{130,-190}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_HW_b(
    redeclare final package Medium = Buildings.Media.Water) if have_hotWat
    "Hot water return port"
    annotation (Placement(transformation(extent={{-50,-190},{-30,-170}}),
      iconTransformation(extent={{-130,-210},{-110,-190}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_HW_a(
    redeclare final package Medium = Buildings.Media.Water) if have_hotWat
    "Hot water supply port"
    annotation (Placement(transformation(extent={{10,-190},{30,-170}}),
      iconTransformation(extent={{-70,-210},{-50,-190}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TAirHea(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal)
    "Heating coil discharge air temperature sensor"
    annotation (Placement(transformation(extent={{50,-14},{70,6}})));

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
      origin={-10,-50})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear valHW(
    redeclare final package Medium = MediumHW,
    final m_flow_nominal=mHotWat_flow_nominal,
    final dpValve_nominal=50) if have_hotWat
    "Hot water flow control valve"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=90,
      origin={-40,-74})));

  Buildings.Fluid.Sensors.VolumeFlowRate VHW_flow(
    redeclare final package Medium = MediumHW,
    final m_flow_nominal=mHotWat_flow_nominal) if have_hotWat
    "Hot water volume flowrate sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={20,-84})));

  Buildings.Fluid.Sensors.TemperatureTwoPort THWRet(
    redeclare final package Medium = MediumHW,
    final m_flow_nominal=mHotWat_flow_nominal) if have_hotWat
    "Hot water return temperature sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=-90,
      origin={-40,-104})));

  Buildings.Fluid.Sensors.TemperatureTwoPort THWSup(
    redeclare final package Medium = MediumHW,
    final m_flow_nominal=mHotWat_flow_nominal) if have_hotWat
    "Hot water supply temperature sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={20,-114})));

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
      origin={110,-10})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear valCHW(
    redeclare final package Medium = MediumCHW,
    final m_flow_nominal=mChiWat_flow_nominal,
    final dpValve_nominal=50)
    "Chilled-water flow control valve"
    annotation(Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=90,
      origin={80,-54})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWLvg(
    redeclare final package Medium = MediumCHW,
    final m_flow_nominal=mChiWat_flow_nominal)
    "Chilled-water return temperature sensor"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=-90,
      origin={80,-90})));

  Buildings.Fluid.Sensors.VolumeFlowRate VCHW_flow(
    redeclare final package Medium = MediumCHW,
    final m_flow_nominal=mChiWat_flow_nominal)
    "Chilled-water volume flowrate sensor"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={140,-44})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWEnt(
    redeclare final package Medium = MediumCHW,
    final m_flow_nominal=mChiWat_flow_nominal)
    "Chilled-water supply temperature sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={140,-74})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TAirLvg(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal)
    "Supply air temperature sensor"
    annotation (Placement(transformation(extent={{240,-20},{260,0}})));

  Buildings.Fluid.Movers.FlowControlled_m_flow fan(
    redeclare final package Medium = MediumA,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    addPowerToMedium=false,
    final m_flow_nominal=mAir_flow_nominal,
    final dp_nominal=dpAir_nominal,
    dpMax=200)
    "Supply fan"
    annotation (Placement(transformation(extent={{200,-20},{220,0}})));

  Buildings.Fluid.Sensors.VolumeFlowRate vAirSup(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal)
    "Supply air volume flow rate"
    annotation (Placement(transformation(extent={{280,-20},{300,0}})));

  Buildings.Fluid.FixedResistances.PressureDrop totRes(
    final m_flow_nominal=mAir_flow_nominal,
    final dp_nominal=dpAir_nominal,
    final allowFlowReversal=true,
    redeclare final package Medium = MediumA)
    "Total resistance"
    annotation (Placement(transformation(extent={{160,-14},{180,6}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TAirRet(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal)
    "Return air temperature sensor"
    annotation (Placement(transformation(extent={{-150,10},{-130,30}})));

  Buildings.Fluid.Sensors.VolumeFlowRate vAirRet(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal)
    "Return air volume flowrate"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));

  Buildings.Fluid.HeatExchangers.HeaterCooler_u heaCoiEle(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal,
    final dp_nominal=0,
    final Q_flow_nominal=QHeaCoi_flow_nominal) if not have_hotWat
    "Electric heating coil"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));

  Modelica.Blocks.Math.Gain gai(
    final k=mAir_flow_nominal)
    "Find mass flowrate value by multiplying nominal flowrate by normalized fan speed signal"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));

  Modelica.Blocks.Math.Gain gaiFanNor(
    final k=1/mAir_flow_nominal)
    "Normalized fan signal"
    annotation (Placement(transformation(extent={{300,100},{320,120}})));

  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = MediumA,
    nPorts=1)
    "Boundary condition for normalizing pressure"
    annotation (Placement(transformation(extent={{164,12},{184,32}})));

protected
  final parameter Boolean have_hotWat=(heaCoiTyp ==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased)
    "Check if a hot water heating coil exists"
    annotation(Dialog(enable=false, tab="Non-configurable"));

equation
  connect(valHW.port_a, heaCoiHW.port_b1) annotation (Line(points={{-40,-64},{
          -40,-44},{-20,-44}},
                           color={0,127,255}));
  connect(THWRet.port_a, valHW.port_b)
    annotation (Line(points={{-40,-94},{-40,-84}}, color={0,127,255}));
  connect(THWSup.port_b, VHW_flow.port_a)
    annotation (Line(points={{20,-104},{20,-94}},
                                                color={0,127,255}));
  connect(heaCoiHW.port_b2, TAirHea.port_a) annotation (Line(points={{0,-56},{
          40,-56},{40,-4},{50,-4}},    color={0,127,255}));
  connect(uHea, valHW.y) annotation (Line(points={{-380,-120},{-60,-120},{-60,
          -74},{-52,-74}},
                      color={0,0,127}));
  connect(port_HW_a, THWSup.port_a)
    annotation (Line(points={{20,-180},{20,-124}},
                                                 color={0,127,255}));
  connect(port_HW_b, THWRet.port_b)
    annotation (Line(points={{-40,-180},{-40,-114}}, color={0,127,255}));
  connect(TCHWLvg.port_a, valCHW.port_b)
    annotation (Line(points={{80,-80},{80,-64}},   color={0,127,255}));
  connect(valCHW.port_a, cooCoi.port_b1) annotation (Line(points={{80,-44},{80,
          -16},{100,-16}}, color={0,127,255}));
  connect(VCHW_flow.port_b, cooCoi.port_a1) annotation (Line(points={{140,-34},
          {140,-16},{120,-16}},color={0,127,255}));
  connect(TCHWEnt.port_b, VCHW_flow.port_a)
    annotation (Line(points={{140,-64},{140,-54}}, color={0,127,255}));
  connect(TAirHea.port_b, cooCoi.port_a2) annotation (Line(points={{70,-4},{100,
          -4}},                   color={0,127,255}));
  connect(port_CHW_b, TCHWLvg.port_b) annotation (Line(points={{80,-180},{80,
          -100}},               color={0,127,255}));
  connect(fan.port_b, TAirLvg.port_a)
    annotation (Line(points={{220,-10},{240,-10}}, color={0,127,255}));
  connect(uCoo, valCHW.y) annotation (Line(points={{-380,-28},{60,-28},{60,-54},
          {68,-54}}, color={0,0,127}));
  connect(TAirLvg.port_b, vAirSup.port_a)
    annotation (Line(points={{260,-10},{280,-10}}, color={0,127,255}));
  connect(vAirSup.port_b, port_Air_b) annotation (Line(points={{300,-10},{320,-10},
          {320,-40},{360,-40}}, color={0,127,255}));
  connect(cooCoi.port_b2, totRes.port_a)
    annotation (Line(points={{120,-4},{160,-4}}, color={0,127,255}));
  connect(TAirRet.port_b, vAirRet.port_a)
    annotation (Line(points={{-130,20},{-120,20}}, color={0,127,255}));
  connect(TAirRet.port_a, port_Air_a) annotation (Line(points={{-150,20},{-160,
          20},{-160,40},{360,40}},               color={0,127,255}));
  connect(heaCoiEle.port_b, TAirHea.port_a) annotation (Line(points={{0,10},{40,
          10},{40,-4},{50,-4}},   color={0,127,255}));
  connect(uHea, heaCoiEle.u) annotation (Line(points={{-380,-120},{-60,-120},{-60,
          16},{-22,16}}, color={0,0,127}));
  connect(uFan, gai.u)
    annotation (Line(points={{-380,80},{-22,80}}, color={0,0,127}));
  connect(gai.y, fan.m_flow_in)
    annotation (Line(points={{1,80},{210,80},{210,2}}, color={0,0,127}));
  connect(TCHWEnt.port_a, port_CHW_a)
    annotation (Line(points={{140,-84},{140,-180}}, color={0,127,255}));
  connect(gaiFanNor.y, yFan_actual)
    annotation (Line(points={{321,110},{380,110}}, color={0,0,127}));
  connect(fan.m_flow_actual, gaiFanNor.u) annotation (Line(points={{221,-5},{
          240,-5},{240,110},{298,110}}, color={0,0,127}));
  connect(heaCoiHW.port_a1, VHW_flow.port_b)
    annotation (Line(points={{0,-44},{20,-44},{20,-74}},
                                                       color={0,127,255}));
  connect(TAirLvg.T, TAirSup)
    annotation (Line(points={{250,1},{250,70},{380,70}},   color={0,0,127}));
  connect(vAirRet.port_b, heaCoiEle.port_a) annotation (Line(points={{-100,20},
          {-80,20},{-80,10},{-20,10}},          color={0,127,255}));
  connect(vAirRet.port_b, heaCoiHW.port_a2) annotation (Line(points={{-100,20},
          {-80,20},{-80,-56},{-20,-56}},           color={0,127,255}));
  connect(totRes.port_b, fan.port_a) annotation (Line(points={{180,-4},{194,-4},
          {194,-10},{200,-10}}, color={0,127,255}));
  connect(bou.ports[1], fan.port_a) annotation (Line(points={{184,22},{194,22},
          {194,-10},{200,-10}}, color={0,127,255}));
  annotation (defaultComponentName = "fanCoiUni",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -200},{200,200}}), graphics={Rectangle(
          extent={{-200,200},{200,-200}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,200},{100,240}},
          textString="%name",
          textColor={0,0,255})}),
    Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-360,-180},{360,140}})),
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
