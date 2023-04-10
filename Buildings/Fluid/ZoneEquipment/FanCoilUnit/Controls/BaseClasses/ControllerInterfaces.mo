within Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls.BaseClasses;
partial model ControllerInterfaces
  "Baseclass for zone HVAC controller interfaces"

  replaceable package MediumA = Modelica.Media.Interfaces.PartialMedium
    "Medium model for air";

  replaceable package MediumHW = Modelica.Media.Interfaces.PartialMedium
    "Medium model for hot water";

   replaceable package MediumCHW = Modelica.Media.Interfaces.PartialMedium
    "Medium model for chilled water";

  parameter Buildings.Fluid.ZoneEquipment.FanCoilUnit.Types.HeaSou
    heaCoiTyp=Buildings.Fluid.ZoneEquipment.FanCoilUnit.Types.HeaSou.hotWat
    "Type of heating coil used"
    annotation (Dialog(group="System parameters"));

  parameter Buildings.Fluid.ZoneEquipment.FanCoilUnit.Types.CooSou
    cooCoiTyp=Buildings.Fluid.ZoneEquipment.FanCoilUnit.Types.CooSou.chiWat
    "Type of cooling coil used"
    annotation (Dialog(group="System parameters"));

  Modelica.Blocks.Interfaces.RealInput uHea(
    final unit="1")
    "Heating loop signal"
    annotation(Placement(transformation(extent={{-400,-140},{-360,-100}}),
      iconTransformation(extent={{-240,-140},{-200,-100}})));

  Modelica.Blocks.Interfaces.RealInput uCoo(
    final unit="1")
    "Cooling loop signal"
    annotation(Placement(transformation(extent={{-400,-100},{-360,-60}}),
      iconTransformation(extent={{-240,-60},{-200,-20}})));

  Modelica.Blocks.Interfaces.RealInput uFan(
    final unit="1")
    "Fan signal"
    annotation(Placement(transformation(extent={{-400,60},{-360,100}}),
      iconTransformation(extent={{-240,20},{-200,60}})));

  Modelica.Blocks.Interfaces.RealInput uEco(
    final unit="1")
    "Control signal for economizer"
    annotation (Placement(transformation(extent={{-400,100},{-360,140}}),
      iconTransformation(extent={{-240,100},{-200,140}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_Air_a(
    redeclare final package Medium=MediumA)
    "Return air port from zone"
    annotation (Placement(transformation(extent={{350,30},{370,50}}),
      iconTransformation(extent={{190,30},{210,50}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_Air_b(
    redeclare final package Medium = MediumA)
    "Supply air port to the zone"
    annotation (Placement(transformation(extent={{350,-50},{370,-30}}),
      iconTransformation(extent={{190,-50},{210,-30}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_CHW_b(
    redeclare final package Medium = MediumCHW) if has_CHW
    "Chilled water return port"
    annotation (Placement(transformation(extent={{94,-190},{114,-170}}),
      iconTransformation(extent={{50,-210},{70,-190}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_CHW_a(
    redeclare package Medium = MediumCHW) if has_CHW
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

  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    "Weather bus"
    annotation (Placement(transformation(extent={{-340,-40},{-300,0}}),
      iconTransformation(extent={{-182,166},{-162,186}})));

  Modelica.Blocks.Interfaces.RealOutput yFan_actual(
    final unit="1",
    displayUnit="1")
    "Normalized measured fan speed signal"
    annotation (Placement(transformation(extent={{360,100},{380,120}}),
      iconTransformation(extent={{200,150},{220,170}})));

  Modelica.Blocks.Interfaces.RealOutput TAirSup(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{360,70},{380,90}}),
      iconTransformation(extent={{200,90},{220,110}})));

  Actuators.Valves.TwoWayLinear                 valHW(
    redeclare final package Medium = MediumHW,
    final m_flow_nominal=mHotWat_flow_nominal,
    final dpValve_nominal=50) if has_HW
    "Hot water flow control valve" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-36,-80})));
  Sensors.VolumeFlowRate                 VHW_flow(redeclare final package
      Medium = MediumHW, final m_flow_nominal=mHotWat_flow_nominal) if
                                                  has_HW
    "Hot water volume flowrate sensor" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={4,-90})));
  Sensors.TemperatureTwoPort                 THWRet(redeclare final package
      Medium = MediumHW, final m_flow_nominal=mHotWat_flow_nominal) if
       has_HW "Hot water return temperature sensor" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-36,-110})));
  Sensors.TemperatureTwoPort                 THWSup(redeclare final package
      Medium = MediumHW, final m_flow_nominal=mHotWat_flow_nominal) if
       has_HW "Hot water supply temperature sensor" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={4,-120})));
  Actuators.Valves.TwoWayLinear                 valCHW(
    redeclare final package Medium = MediumCHW,
    final m_flow_nominal=mChiWat_flow_nominal,
    final dpValve_nominal=50) if has_CHW
    "Chilled-water flow control valve"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={104,-80})));
  Sensors.TemperatureTwoPort                 TCHWLvg(redeclare final package
      Medium = MediumCHW, final m_flow_nominal=mChiWat_flow_nominal) if has_CHW
    "Chilled-water return temperature sensor"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=-90,
      origin={104,-110})));
  Sensors.VolumeFlowRate                 VCHW_flow(redeclare final package
      Medium = MediumCHW, final m_flow_nominal=mChiWat_flow_nominal) if has_CHW
    "Chilled-water volume flowrate sensor"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={144,-90})));
  Sensors.TemperatureTwoPort                 TCHWEnt(redeclare final package
      Medium = MediumCHW, final m_flow_nominal=mChiWat_flow_nominal) if has_CHW
    "Chilled-water supply temperature sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={144,-120})));
protected
  final parameter Boolean has_HW=(heaCoiTyp == Buildings.Fluid.ZoneEquipment.FanCoilUnit.Types.HeaSou.hotWat)
    "Does the zone equipment have a hot water heating coil?"
    annotation(Dialog(enable=false, tab="Non-configurable"));

  final parameter Boolean has_CHW=(cooCoiTyp == Buildings.Fluid.ZoneEquipment.FanCoilUnit.Types.CooSou.chiWat)
    "Does the zone equipment have a chilled water cooling coil?"
    annotation(Dialog(enable=false, tab="Non-configurable"));

equation
  connect(THWRet.port_a,valHW. port_a)
    annotation (Line(points={{-36,-100},{-36,-90}},color={0,127,255}));
  connect(THWSup.port_b,VHW_flow. port_a)
    annotation (Line(points={{4,-110},{4,-100}},color={0,127,255}));
  connect(THWRet.port_b, port_HW_b)
    annotation (Line(points={{-36,-120},{-36,-180}}, color={0,127,255}));
  connect(THWSup.port_a, port_HW_a)
    annotation (Line(points={{4,-130},{4,-180}}, color={0,127,255}));
  connect(TCHWLvg.port_a,valCHW. port_a)
    annotation (Line(points={{104,-100},{104,-90}},color={0,127,255}));
  connect(TCHWEnt.port_b,VCHW_flow. port_a)
    annotation (Line(points={{144,-110},{144,-100}},
                                                   color={0,127,255}));
  connect(TCHWLvg.port_b, port_CHW_b)
    annotation (Line(points={{104,-120},{104,-180}}, color={0,127,255}));
  connect(TCHWEnt.port_a, port_CHW_a)
    annotation (Line(points={{144,-130},{144,-180}}, color={0,127,255}));
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
end ControllerInterfaces;
