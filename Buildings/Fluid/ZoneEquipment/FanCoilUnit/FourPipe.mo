within Buildings.Fluid.ZoneEquipment.FanCoilUnit;
model FourPipe "System model for a four-pipe fan coil unit"
  replaceable package MediumA = Modelica.Media.Interfaces.PartialMedium
    "Medium model of air";
  replaceable package MediumHW = Modelica.Media.Interfaces.PartialMedium
    "Medium model of hot water";
  replaceable package MediumCHW = Modelica.Media.Interfaces.PartialMedium
    "Medium model of chilled water";
  parameter Buildings.Fluid.ZoneEquipment.FanCoilUnit.Types.HeaSou
    heaCoiTyp=Buildings.Fluid.ZoneEquipment.FanCoilUnit.Types.HeaSou.hotWat
    "Heating coil type"
    annotation (Dialog(group="System parameters"));
  parameter Modelica.Units.SI.HeatFlowRate QHeaCoi_flow_nominal(
    final min = 0)
    "Nominal heat flow rate of electric heating coil"
    annotation(Dialog(enable=not has_HW, group="Heating coil parameters"));

  parameter Modelica.Units.SI.MassFlowRate mHotWat_flow_nominal
    "Nominal mass flow rate of heating hot water"
    annotation(Dialog(enable=has_HW, group="Heating coil parameters"));

  parameter Modelica.Units.SI.PressureDifference dpAir_nominal
    "Total pressure difference across supply and return ports in airloop"
    annotation(Dialog(group="System parameters"));

  parameter Modelica.Units.SI.ThermalConductance UAHeaCoi_nominal
    "Thermal conductance at nominal flow, used to compute heat capacity"
    annotation(Dialog(enable=has_HW, group="Heating coil parameters"));

  parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal
    "Nominal mass flow rate of chilled water"
    annotation(Dialog(group="Cooling coil parameters"));

  parameter Modelica.Units.SI.ThermalConductance UACooCoi_nominal
    "Nominal Thermal conductance, used to compute heat capacity"
    annotation(Dialog(group="Cooling coil parameters"));

  parameter Modelica.Units.SI.MassFlowRate mAirOut_flow_nominal
    "Nominal mass flow rate of outdoor air"
    annotation(Dialog(group="System parameters"));

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
    annotation(Placement(transformation(extent={{-400,-100},{-360,-60}}),
      iconTransformation(extent={{-240,-60},{-200,-20}})));

  Modelica.Blocks.Interfaces.RealInput uFan(
    final unit="1")
    "Fan control signal"
    annotation(Placement(transformation(extent={{-400,60},{-360,100}}),
      iconTransformation(extent={{-240,20},{-200,60}})));
  Modelica.Blocks.Interfaces.RealInput uEco(
    final unit="1")
    "Economizer control signal"
    annotation (Placement(transformation(extent={{-400,100},{-360,140}}),
      iconTransformation(extent={{-240,100},{-200,140}})));

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
    redeclare final package Medium = MediumCHW)
    "Chilled water return port"
    annotation (Placement(transformation(extent={{94,-190},{114,-170}}),
      iconTransformation(extent={{50,-210},{70,-190}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_CHW_a(
    redeclare package Medium = MediumCHW)
    "Chilled water supply port"
    annotation (Placement(transformation(extent={{134,-190},{154,-170}}),
      iconTransformation(extent={{110,-210},{130,-190}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_HW_b(
    redeclare final package Medium = MediumHW) if has_HW
    "Hot water return port"
    annotation (Placement(transformation(extent={{-46,-190},{-26,-170}}),
      iconTransformation(extent={{-130,-210},{-110,-190}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_HW_a(
    redeclare final package Medium = MediumHW) if has_HW
    "Hot water supply port"
    annotation (Placement(transformation(extent={{-6,-190},{14,-170}}),
      iconTransformation(extent={{-70,-210},{-50,-190}})));

  Buildings.Fluid.Actuators.Dampers.MixingBox eco(
    redeclare final package Medium = MediumA,
    final mOut_flow_nominal=mAirOut_flow_nominal,
    final dpDamOut_nominal=50,
    final mRec_flow_nominal=mAir_flow_nominal,
    final dpDamRec_nominal=50,
    final mExh_flow_nominal=mAirOut_flow_nominal,
    final dpDamExh_nominal=50)
    "Outdoor air economizer"
    annotation (Placement(transformation(extent={{-180,-20},{-160,0}})));

  Buildings.Fluid.Sources.Outside out(
    redeclare final package Medium = MediumA,
    final nPorts=2)
    "Boundary conditions for outside air"
    annotation (Placement(transformation(extent={{-280,-30},{-260,-10}})));

  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    "Weather bus"
    annotation (Placement(transformation(extent={{-340,-40},{-300,0}}),
      iconTransformation(extent={{-182,166},{-162,186}})));

  Buildings.Fluid.Sensors.VolumeFlowRate vAirOut(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAirOut_flow_nominal)
    "Outdoor air volume flowrate"
    annotation (Placement(transformation(extent={{-240,-10},{-220,10}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TAirOut(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAirOut_flow_nominal)
    "Outdoor air temperature sensor"
    annotation (Placement(transformation(extent={{-210,-10},{-190,10}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TAirExh(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAirOut_flow_nominal)
    "Return air temperature sensor"
    annotation (Placement(transformation(extent={{-190,-50},{-210,-30}})));

  Buildings.Fluid.Sensors.VolumeFlowRate VAirExh_flow(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAirOut_flow_nominal)
    "Exhaust air volume flowrate"
    annotation (Placement(transformation(extent={{-220,-50},{-240,-30}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TAirMix(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal)
    "Mixed air temperature sensor"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));

  Buildings.Fluid.Sensors.VolumeFlowRate vAirMix(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal)
    "Mixed air volume flowrate"
    annotation (Placement(transformation(extent={{-110,-20},{-90,0}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TAirHea(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal)
    "Heating coil discharge air temperature sensor"
    annotation (Placement(transformation(extent={{30,-20},{50,0}})));

  Buildings.Fluid.HeatExchangers.DryCoilCounterFlow heaCoiHW(
    redeclare final package Medium1 = MediumHW,
    redeclare final package Medium2 = MediumA,
    final m1_flow_nominal=mHotWat_flow_nominal,
    final m2_flow_nominal=mAir_flow_nominal,
    final dp1_nominal=0,
    final dp2_nominal=0,
    final UA_nominal=UAHeaCoi_nominal,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) if has_HW
    "Hot water heating coil"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
      rotation=180,
      origin={-10,-50})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear valHW(
    redeclare final package Medium = MediumHW,
    final m_flow_nominal=mHotWat_flow_nominal,
    final dpValve_nominal=50) if has_HW
    "Hot water flow control valve"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=90,
      origin={-36,-74})));

  Buildings.Fluid.Sensors.VolumeFlowRate VHW_flow(
    redeclare final package Medium = MediumHW,
    final m_flow_nominal=mHotWat_flow_nominal) if has_HW
    "Hot water volume flowrate sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={4,-84})));

  Buildings.Fluid.Sensors.TemperatureTwoPort THWRet(
    redeclare final package Medium = MediumHW,
    final m_flow_nominal=mHotWat_flow_nominal) if has_HW
    "Hot water return temperature sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=-90,
      origin={-36,-104})));

  Buildings.Fluid.Sensors.TemperatureTwoPort THWSup(
    redeclare final package Medium = MediumHW,
    final m_flow_nominal=mHotWat_flow_nominal) if has_HW
    "Hot water supply temperature sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={4,-114})));

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
      origin={130,-10})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear valCHW(
    redeclare final package Medium = MediumCHW,
    final m_flow_nominal=mChiWat_flow_nominal,
    final dpValve_nominal=50)
    "Chilled-water flow control valve"
    annotation(Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=90,
      origin={104,-54})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWLvg(
    redeclare final package Medium = MediumCHW,
    final m_flow_nominal=mChiWat_flow_nominal)
    "Chilled-water return temperature sensor"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=-90,
      origin={104,-90})));

  Buildings.Fluid.Sensors.VolumeFlowRate VCHW_flow(
    redeclare final package Medium = MediumCHW,
    final m_flow_nominal=mChiWat_flow_nominal)
    "Chilled-water volume flowrate sensor"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={144,-44})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWEnt(
    redeclare final package Medium = MediumCHW,
    final m_flow_nominal=mChiWat_flow_nominal)
    "Chilled-water supply temperature sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={144,-74})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TAirLvg(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal)
    "Supply air temperature sensor"
    annotation (Placement(transformation(extent={{240,-20},{260,0}})));

  Buildings.Fluid.Movers.FlowControlled_m_flow fan(
    redeclare final package Medium = MediumA,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal=mAir_flow_nominal,
    final per=fanPer,
    final dp_nominal=dpAir_nominal)
    "Supply fan"
    annotation (Placement(transformation(extent={{200,-20},{220,0}})));

  Buildings.Fluid.Sensors.VolumeFlowRate vAirSup(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal)
    "Supply air volume flow rate"
    annotation (Placement(transformation(extent={{280,-20},{300,0}})));

  replaceable parameter Buildings.Fluid.Movers.Data.Generic fanPer
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Record with performance data for supply fan"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{50,100},{70,120}})),
      Dialog(group="Fan parameters"));

  Buildings.Fluid.FixedResistances.PressureDrop totRes(
    final m_flow_nominal=mAir_flow_nominal,
    final dp_nominal=dpAir_nominal,
    final allowFlowReversal=true,
    redeclare final package Medium = MediumA)
    "Total resistance"
    annotation (Placement(transformation(extent={{156,-14},{176,6}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TAirRet(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal)
    "Return air temperature sensor"
    annotation (Placement(transformation(extent={{-150,30},{-130,50}})));

  Buildings.Fluid.Sensors.VolumeFlowRate vAirRet(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal)
    "Return air volume flowrate"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));

  Buildings.Fluid.HeatExchangers.HeaterCooler_u heaCoiEle(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal,
    final dp_nominal=0,
    final Q_flow_nominal=QHeaCoi_flow_nominal) if not has_HW
    "Electric heating coil"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Modelica.Blocks.Math.Gain gai(
    final k=mAir_flow_nominal)
    "Find mass flowrate value by multiplying nominal flowrate by normalized fan speed signal"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Modelica.Blocks.Interfaces.RealOutput yFan_actual(
    final unit="1",
    displayUnit="1")
    "Normalized actual fan speed signal"
    annotation (Placement(transformation(extent={{360,100},{380,120}}),
      iconTransformation(extent={{200,150},{220,170}})));
  Modelica.Blocks.Math.Gain gaiFanNor(
    final k=1/mAir_flow_nominal)
    "Normalized fan signal"
    annotation (Placement(transformation(extent={{300,100},{320,120}})));
protected
  final parameter Boolean has_HW=(heaCoiTyp ==Buildings.Fluid.ZoneEquipment.FanCoilUnit.Types.HeaSou.hotWat)
    "Check if a hot water heating coil exists"
    annotation(Dialog(enable=false, tab="Non-configurable"));

equation
  connect(uEco, eco.y) annotation (Line(points={{-380,120},{-170,120},{-170,2}},
        color={0,0,127}));
  connect(weaBus, out.weaBus) annotation (Line(
      points={{-320,-20},{-300,-20},{-300,-19.8},{-280,-19.8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(vAirOut.port_b, TAirOut.port_a)
    annotation (Line(points={{-220,0},{-210,0}}, color={0,127,255}));
  connect(TAirOut.port_b, eco.port_Out)
    annotation (Line(points={{-190,0},{-180,0},{-180,-4}}, color={0,127,255}));
  connect(out.ports[1], vAirOut.port_a) annotation (Line(points={{-260,-21},{-252,
          -21},{-252,0},{-240,0}}, color={0,127,255}));
  connect(TAirMix.port_b, vAirMix.port_a)
    annotation (Line(points={{-120,-10},{-110,-10}}, color={0,127,255}));
  connect(eco.port_Sup, TAirMix.port_a) annotation (Line(points={{-160,-4},{-140,
          -4},{-140,-10}}, color={0,127,255}));
  connect(valHW.port_a, heaCoiHW.port_b1) annotation (Line(points={{-36,-64},{-36,
          -44},{-20,-44}}, color={0,127,255}));
  connect(THWRet.port_a, valHW.port_b)
    annotation (Line(points={{-36,-94},{-36,-84}}, color={0,127,255}));
  connect(THWSup.port_b, VHW_flow.port_a)
    annotation (Line(points={{4,-104},{4,-94}}, color={0,127,255}));
  connect(vAirMix.port_b, heaCoiHW.port_a2) annotation (Line(points={{-90,-10},{
          -40,-10},{-40,-56},{-20,-56}}, color={0,127,255}));
  connect(heaCoiHW.port_b2, TAirHea.port_a) annotation (Line(points={{0,-56},{20,
          -56},{20,-10},{30,-10}},     color={0,127,255}));
  connect(uHea, valHW.y) annotation (Line(points={{-380,-120},{-60,-120},{-60,-74},
          {-48,-74}}, color={0,0,127}));
  connect(port_HW_a, THWSup.port_a)
    annotation (Line(points={{4,-180},{4,-124}}, color={0,127,255}));
  connect(port_HW_b, THWRet.port_b)
    annotation (Line(points={{-36,-180},{-36,-114}}, color={0,127,255}));
  connect(TCHWLvg.port_a, valCHW.port_b)
    annotation (Line(points={{104,-80},{104,-64}}, color={0,127,255}));
  connect(valCHW.port_a, cooCoi.port_b1) annotation (Line(points={{104,-44},{104,
          -16},{120,-16}}, color={0,127,255}));
  connect(VCHW_flow.port_b, cooCoi.port_a1) annotation (Line(points={{144,-34},{
          144,-16},{140,-16}}, color={0,127,255}));
  connect(TCHWEnt.port_b, VCHW_flow.port_a)
    annotation (Line(points={{144,-64},{144,-54}}, color={0,127,255}));
  connect(TAirHea.port_b, cooCoi.port_a2) annotation (Line(points={{50,-10},{80,
          -10},{80,-4},{120,-4}}, color={0,127,255}));
  connect(port_CHW_b, TCHWLvg.port_b) annotation (Line(points={{104,-180},{104,-100}},
                                color={0,127,255}));
  connect(fan.port_b, TAirLvg.port_a)
    annotation (Line(points={{220,-10},{240,-10}}, color={0,127,255}));
  connect(uCoo, valCHW.y) annotation (Line(points={{-380,-80},{-48,-80},{-48,-86},
          {-12,-86},{-12,-62},{84,-62},{84,-54},{92,-54}},
                     color={0,0,127}));
  connect(TAirLvg.port_b, vAirSup.port_a)
    annotation (Line(points={{260,-10},{280,-10}}, color={0,127,255}));
  connect(vAirSup.port_b, port_Air_b) annotation (Line(points={{300,-10},{320,-10},
          {320,-40},{360,-40}}, color={0,127,255}));
  connect(cooCoi.port_b2, totRes.port_a)
    annotation (Line(points={{140,-4},{156,-4}}, color={0,127,255}));
  connect(totRes.port_b, fan.port_a) annotation (Line(points={{176,-4},{180,-4},
          {180,-10},{200,-10}}, color={0,127,255}));
  connect(TAirRet.port_b, vAirRet.port_a)
    annotation (Line(points={{-130,40},{-120,40}}, color={0,127,255}));
  connect(vAirRet.port_b, eco.port_Ret) annotation (Line(points={{-100,40},{-88,
          40},{-88,14},{-150,14},{-150,-16},{-160,-16}}, color={0,127,255}));
  connect(TAirRet.port_a, port_Air_a) annotation (Line(points={{-150,40},{-160,40},
          {-160,60},{-60,60},{-60,40},{360,40}}, color={0,127,255}));
  connect(vAirMix.port_b, heaCoiEle.port_a) annotation (Line(points={{-90,-10},{
          -40,-10},{-40,10},{-20,10}}, color={0,127,255}));
  connect(heaCoiEle.port_b, TAirHea.port_a) annotation (Line(points={{0,10},{20,
          10},{20,-10},{30,-10}}, color={0,127,255}));
  connect(uHea, heaCoiEle.u) annotation (Line(points={{-380,-120},{-60,-120},{-60,
          16},{-22,16}}, color={0,0,127}));
  connect(uFan, gai.u)
    annotation (Line(points={{-380,80},{-22,80}}, color={0,0,127}));
  connect(gai.y, fan.m_flow_in)
    annotation (Line(points={{1,80},{210,80},{210,2}}, color={0,0,127}));
  connect(TCHWEnt.port_a, port_CHW_a)
    annotation (Line(points={{144,-84},{144,-180}}, color={0,127,255}));
  connect(eco.port_Exh, TAirExh.port_a) annotation (Line(points={{-180,-16},{-180,
          -40},{-190,-40}}, color={0,127,255}));
  connect(TAirExh.port_b, VAirExh_flow.port_a)
    annotation (Line(points={{-210,-40},{-220,-40}}, color={0,127,255}));
  connect(VAirExh_flow.port_b, out.ports[2]) annotation (Line(points={{-240,-40},
          {-252,-40},{-252,-19},{-260,-19}}, color={0,127,255}));
  connect(gaiFanNor.y, yFan_actual)
    annotation (Line(points={{321,110},{370,110}}, color={0,0,127}));
  connect(fan.m_flow_actual, gaiFanNor.u) annotation (Line(points={{221,-5},{
          240,-5},{240,110},{298,110}}, color={0,0,127}));
  connect(heaCoiHW.port_a1, VHW_flow.port_b)
    annotation (Line(points={{0,-44},{4,-44},{4,-74}}, color={0,127,255}));
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
    a supply fan, an electric or hot-water heating coil, a chilled-water cooling coil,
    and a mixing box. 
    </p>
    The control modules for the system are implemented separately in
    <a href=\"modelica://Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls\">
    Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls</a>:
    <ul>
    <li>
    <a href=\"modelica://Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls.ConstantFanVariableWaterFlowrate\">
    ConstantFanVariableWaterFlowrate</a>:
    Modulate the cooling coil and heating coil valve positions to regulate the zone temperature
    between the heating and cooling setpoints. The fan is enabled and operated at the 
    maximum speed when there are zone heating or cooling loads. It is run at minimum speed when
    zone is occupied but there are no loads.
    </li>
    <li>
    <a href=\"modelica://Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls.VariableFanConstantWaterFlowrate\">
    VariableFanConstantWaterFlowrate</a>:
    Modulate the fan speed to regulate the zone temperature between the heating 
    and cooling setpoints. It is run at minimum speed when zone is occupied but 
    there are no loads. The heating and cooling coil valves are completely opened 
    when there are zone heating or cooling loads, respectively.
    </li>
    <li>
    <a href=\"modelica://Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls.MultispeedFanConstantWaterFlowrate\">
    MultispeedFanConstantWaterFlowrate</a>:
    Modulate the fan speed to regulate the zone temperature between the heating 
    and cooling setpoints. It is set at a range of fixed values between the maximum 
    and minimum speed, based on the heating and cooling loop signals generated. 
    It is run at minimum speed when zone is occupied but there are no loads. The 
    heating and cooling coil valves are completely opened when there are zone 
    heating or cooling loads, respectively.
    </li>
    </ul>
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
