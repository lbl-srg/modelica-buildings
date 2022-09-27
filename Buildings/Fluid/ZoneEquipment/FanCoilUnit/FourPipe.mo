within Buildings.Fluid.ZoneEquipment.FanCoilUnit;
model FourPipe "System model for a four-pipe fan coil unit"

  extends Buildings.Fluid.ZoneEquipment.BaseClasses.EquipmentInterfaces;

  parameter Modelica.Units.SI.HeatFlowRate QHeaCoi_flow_nominal(
    final min = 0)
    "Heat flow rate of electric heating coil at full power"
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
    "Thermal conductance at nominal flow, used to compute heat capacity"
    annotation(Dialog(group="Cooling coil parameters"));
  parameter Modelica.Units.SI.MassFlowRate mAirOut_flow_nominal
    "Nominal mass flow rate of outdoor air"
    annotation(Dialog(group="System parameters"));
  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal
    "Nominal mass flow rate of supply air"
    annotation(Dialog(group="System parameters"));

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
  Buildings.Fluid.Sensors.VolumeFlowRate vAirOut(redeclare final package Medium =
        MediumA, final m_flow_nominal=mAirOut_flow_nominal)
    "Outdoor air volume flowrate"
    annotation (Placement(transformation(extent={{-240,-10},{-220,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TAirOut(redeclare final package
      Medium =
        MediumA, final m_flow_nominal=mAirOut_flow_nominal)
    "Outdoor air temperature sensor"
    annotation (Placement(transformation(extent={{-210,-10},{-190,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TAirExh(redeclare final package
      Medium =
        MediumA, final m_flow_nominal=mAirOut_flow_nominal)
    "Return air temperature sensor"
    annotation (Placement(transformation(extent={{-190,-50},{-210,-30}})));
  Buildings.Fluid.Sensors.VolumeFlowRate VAirExh_flow(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAirOut_flow_nominal)
    "Exhaust air volume flowrate"
    annotation (Placement(transformation(extent={{-220,-50},{-240,-30}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TAirMix(redeclare final package
      Medium =
        MediumA, final m_flow_nominal=mAir_flow_nominal)
    "Mixed air temperature sensor"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
  Buildings.Fluid.Sensors.VolumeFlowRate vAirMix(redeclare final package Medium =
        MediumA, final m_flow_nominal=mAir_flow_nominal)
    "Mixed air volume flowrate"
    annotation (Placement(transformation(extent={{-110,-20},{-90,0}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TAirHea(redeclare final package
      Medium =
        MediumA, final m_flow_nominal=mAir_flow_nominal)
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
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) if
       has_HW "Hot water heating coil" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-10,-50})));
  Buildings.Fluid.HeatExchangers.WetCoilCounterFlow cooCoi(
    redeclare final package Medium1 = MediumCHW,
    redeclare final package Medium2 = MediumA,
    final m1_flow_nominal=mChiWat_flow_nominal,
    final m2_flow_nominal=mAir_flow_nominal,
    final dp1_nominal=0,
    final dp2_nominal=0,
    final UA_nominal=UACooCoi_nominal,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Chilled-water cooling coil" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={130,-10})));
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
  Buildings.Fluid.Sensors.VolumeFlowRate vAirSup(redeclare final package Medium =
        MediumA, final m_flow_nominal=mAir_flow_nominal)
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
    final allowFlowReversal=false,
    redeclare final package Medium = MediumA) "Total resistance"
    annotation (Placement(transformation(extent={{156,-14},{176,6}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TAirRet(redeclare final package
      Medium =
        MediumA, final m_flow_nominal=mAir_flow_nominal)
    "Return air temperature sensor"
    annotation (Placement(transformation(extent={{-150,30},{-130,50}})));
  Buildings.Fluid.Sensors.VolumeFlowRate vAirRet(redeclare final package Medium =
        MediumA, m_flow_nominal=mAir_flow_nominal) "Return air volume flowrate"
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

  Modelica.Blocks.Math.Gain gaiFanNor(
    final k=1/mAir_flow_nominal)
    "Find normalized fan signal by dividing actual fan mass flowrate by nominal flowrate"
    annotation (Placement(transformation(extent={{300,100},{320,120}})));

protected
  final parameter Boolean has_HW=(heaCoiTyp ==Buildings.Fluid.ZoneEquipment.FanCoilUnit.Types.HeaSou.hotWat)
    "Does the zone equipment have a hot water heating coil?"
    annotation(Dialog(enable=false, tab="Non-configurable"));

equation
  connect(vAirOut.port_b, TAirOut.port_a)
    annotation (Line(points={{-220,0},{-210,0}}, color={0,127,255}));
  connect(TAirOut.port_b, eco.port_Out)
    annotation (Line(points={{-190,0},{-180,0},{-180,-4}}, color={0,127,255}));
  connect(out.ports[1], vAirOut.port_a) annotation (Line(points={{-260,-18},{-252,
          -18},{-252,0},{-240,0}}, color={0,127,255}));
  connect(TAirMix.port_b, vAirMix.port_a)
    annotation (Line(points={{-120,-10},{-110,-10}}, color={0,127,255}));
  connect(eco.port_Sup, TAirMix.port_a) annotation (Line(points={{-160,-4},{-140,
          -4},{-140,-10}}, color={0,127,255}));
  connect(vAirMix.port_b, heaCoiHW.port_a2) annotation (Line(points={{-90,-10},{
          -40,-10},{-40,-44},{-20,-44}}, color={0,127,255}));
  connect(heaCoiHW.port_b2, TAirHea.port_a) annotation (Line(points={{0,-44},
          {20,-44},{20,-10},{30,-10}}, color={0,127,255}));
  connect(TAirHea.port_b, cooCoi.port_a2) annotation (Line(points={{50,-10},{80,
          -10},{80,-4},{120,-4}}, color={0,127,255}));
  connect(fan.port_b, TAirLvg.port_a)
    annotation (Line(points={{220,-10},{240,-10}}, color={0,127,255}));
  connect(TAirLvg.port_b, vAirSup.port_a)
    annotation (Line(points={{260,-10},{280,-10}}, color={0,127,255}));
  connect(cooCoi.port_b2, totRes.port_a)
    annotation (Line(points={{140,-4},{156,-4}}, color={0,127,255}));
  connect(totRes.port_b, fan.port_a) annotation (Line(points={{176,-4},{180,-4},
          {180,-10},{200,-10}}, color={0,127,255}));
  connect(TAirRet.port_b, vAirRet.port_a)
    annotation (Line(points={{-130,40},{-120,40}}, color={0,127,255}));
  connect(vAirRet.port_b, eco.port_Ret) annotation (Line(points={{-100,40},{-88,
          40},{-88,14},{-150,14},{-150,-16},{-160,-16}}, color={0,127,255}));
  connect(vAirMix.port_b, heaCoiEle.port_a) annotation (Line(points={{-90,-10},{
          -40,-10},{-40,10},{-20,10}}, color={0,127,255}));
  connect(heaCoiEle.port_b, TAirHea.port_a) annotation (Line(points={{0,10},{20,
          10},{20,-10},{30,-10}}, color={0,127,255}));
  connect(gai.y, fan.m_flow_in)
    annotation (Line(points={{1,80},{210,80},{210,2}}, color={0,0,127}));
  connect(eco.port_Exh, TAirExh.port_a) annotation (Line(points={{-180,-16},{-180,
          -40},{-190,-40}}, color={0,127,255}));
  connect(TAirExh.port_b, VAirExh_flow.port_a)
    annotation (Line(points={{-210,-40},{-220,-40}}, color={0,127,255}));
  connect(VAirExh_flow.port_b, out.ports[2]) annotation (Line(points={{-240,-40},
          {-252,-40},{-252,-22},{-260,-22}}, color={0,127,255}));
  connect(fan.m_flow_actual, gaiFanNor.u) annotation (Line(points={{221,-5},{
          240,-5},{240,110},{298,110}}, color={0,0,127}));
  connect(TAirRet.port_a, port_Air_a) annotation (Line(points={{-150,40},{-160,40},
          {-160,60},{-68,60},{-68,40},{360,40}}, color={0,127,255}));
  connect(vAirSup.port_b, port_Air_b) annotation (Line(points={{300,-10},{340,-10},
          {340,-40},{360,-40}}, color={0,127,255}));
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
  connect(uFan, gai.u)
    annotation (Line(points={{-380,80},{-22,80}}, color={0,0,127}));
  connect(uHea, valHW.y) annotation (Line(points={{-380,-120},{-60,-120},{-60,-80},
          {-48,-80}}, color={0,0,127}));
  connect(uHea, heaCoiEle.u) annotation (Line(points={{-380,-120},{-60,-120},{-60,
          16},{-22,16}}, color={0,0,127}));
  connect(uCoo, valCHW.y) annotation (Line(points={{-380,-80},{-80,-80},{-80,-148},
          {80,-148},{80,-80},{92,-80}}, color={0,0,127}));
  connect(valHW.port_b, heaCoiHW.port_b1) annotation (Line(points={{-36,-70},{-36,
          -56},{-20,-56}}, color={0,127,255}));
  connect(heaCoiHW.port_a1, VHW_flow.port_b)
    annotation (Line(points={{0,-56},{4,-56},{4,-80}}, color={0,127,255}));
  connect(valCHW.port_b, cooCoi.port_b1) annotation (Line(points={{104,-70},{104,
          -16},{120,-16}}, color={0,127,255}));
  connect(cooCoi.port_a1, VCHW_flow.port_b) annotation (Line(points={{140,-16},{
          144,-16},{144,-80}}, color={0,127,255}));
  connect(gaiFanNor.y, yFan_actual)
    annotation (Line(points={{321,110},{370,110}}, color={0,0,127}));
  connect(TAirLvg.T, TAirSup)
    annotation (Line(points={{250,1},{250,80},{370,80}}, color={0,0,127}));
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
    This is a conventional four-pipe fan coil unit system model. The system contains
    a variable speed supply fan, electric or hot-water heating coil, chilled-water cooling coil,
    and an economizer. 
    </p>
    <p>
    This is a system model for a fan coil unit consisting of the following components:
    <ul>
    <li>
    Outdoor air economizer <code>eco</code>: <a href=\"modelica://Buildings.Fluid.Actuators.Dampers.MixingBox\">
    Buildings.Fluid.Actuators.Dampers.MixingBox</a>
    </li>
    <li>
    Chilled-water cooling coil <code>cooCoi</code>: <a href=\"modelica://Buildings.Fluid.HeatExchangers.WetCoilCounterFlow\">
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
    a hot-water heating coil <code>heaCoiHW</code>: <a href=\"modelica://Buildings.Fluid.HeatExchangers.DryCoilCounterFlow\">
    Buildings.Fluid.HeatExchangers.DryCoilCounterFlow</a>
    </li>
    </ul>
    <br>
    The heating coil type parameter <code>heaCoiTyp</code> is used to pick 
    between the two types of heating coils.
    </li>
    <li>
    Flow control valves <code>valHotWat</code> and <code>valCHiWat</code> for 
    controlling the flowrates of heating hot-water and chilled-water through their
    respective coils.
    </li>
    <li>
    Mixed air volume <code>out</code> of class <a href=\"modelica://Buildings.Fluid.Sources.Outside\">
    Buildings.Fluid.Sources.Outside</a> for providing the ventilation through the fan
    coil unit.
    </li>
    <li>
    Temperature and flowrate sensors at various points in the airloop, 
    chilled-water loop and hot-water loop. The sensors are all replaceable instances
    and can be redeclared as required.
    </li>
    <li>
    Pressure drops through the system are collected into a single instance <code>totRes</code>
    of class <a href=\"modelica://Buildings.Fluid.FixedResistances.PressureDrop\">
    Buildings.Fluid.FixedResistances.PressureDrop</a>.
    </li>
    </ul>
    </p>
    <p>
    The system model receives input signals for the fan speed <code>uFan</code>, heating and cooling 
    coil valve positions (<code>uHea</code> and <code>uCoo</code> respectively), 
    and the outdoor air damper position <code>uOA</code>. The system controls 
    the flowrate of the chilled-water and heating hot-water using the valves, and 
    assumes pressurized water supply from the hot-water and chilled-water loops.
    </p>
    <p>
    The control modules for the system are implemented separately in
    <a href=\"modelica://Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls\">
    Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls</a>. They are as follows:
    <ul>
    <li>
    <a href=\"modelica://Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls.ConstantFanVariableWaterFlowrate\">
    ConstantFanVariableWaterFlowrate</a>:
    Modifies the cooling coil and heating coil valve positions to regulate the zone temperature
    between the heating and cooling setpoints. The fan is enabled and run at the 
    maximum speed when there are zone heating or cooling loads. It is run at minimum speed when
    zone is occupied but there are no loads.
    </li>
    <li>
    <a href=\"modelica://Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls.VariableFanConstantWaterFlowrate\">
    VariableFanConstantWaterFlowrate</a>:
    Modifies the fan speed to regulate the zone temperature between the heating 
    and cooling setpoints. It is run at minimum speed when zone is occupied but 
    there are no loads. The heating and cooling coil valves are completely opened 
    when there are zone heating or cooling loads, respectively.
    </li>
    <li>
    <a href=\"modelica://Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls.MultispeedFanConstantWaterFlowrate\">
    MultispeedFanConstantWaterFlowrate</a>:
    Modifies the fan speed to regulate the zone temperature between the heating 
    and cooling setpoints. It is set at a range of fixed values between the maximum 
    and minimum speed, based on the heating and cooling loop signals generated. 
    It is run at minimum speed when zone is occupied but there are no loads. The 
    heating and cooling coil valves are completely opened when there are zone 
    heating or cooling loads, respectively.
    </li>
    </ul>
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
