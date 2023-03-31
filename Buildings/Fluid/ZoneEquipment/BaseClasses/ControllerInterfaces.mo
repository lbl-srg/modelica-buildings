within Buildings.Fluid.ZoneEquipment.BaseClasses;
partial model ControllerInterfaces
  "Baseclass for zone HVAC controller interfaces"

  parameter Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes sysTyp
    "Select zonal HVAC system type"
    annotation (Dialog(group="System parameters"));

  parameter Buildings.Fluid.ZoneEquipment.BaseClasses.Types.HeaSou
    heaCoiTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.HeaSou.hotWat
    "Type of heating coil used"
    annotation (Dialog(group="System parameters"));

  parameter Buildings.Fluid.ZoneEquipment.BaseClasses.Types.CooSou
    cooCoiTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.CooSou.chiWat
    "Type of cooling coil used"
    annotation (Dialog(group="System parameters"));

  parameter Boolean has_fanOpeMod = true
    "Does the controller need a fan operating mode signal interface?";

  Modelica.Blocks.Interfaces.BooleanOutput yFan "Fan enable signal"
    annotation (Placement(transformation(extent={{140,-120},{180,-80}}),
      iconTransformation(extent={{180,-220},{220,-180}})));

  Modelica.Blocks.Interfaces.RealOutput yFanSpe(
    final unit="1",
    displayUnit="1")
    "Fan speed signal"
    annotation (Placement(transformation(extent={{140,-80},{180,-40}}),
      iconTransformation(extent={{180,-140},{220,-100}})));

  Modelica.Blocks.Interfaces.RealOutput yCoo(
    final unit="1",
    displayUnit="1") if has_coo and has_varCoo
    "Cooling signal"
    annotation (Placement(transformation(extent={{140,0},{180,40}}),
      iconTransformation(extent={{180,20},{220,60}})));

  Modelica.Blocks.Interfaces.RealOutput yHea(
    final unit="1",
    displayUnit="1") if has_hea and has_varHea
    "Heating signal"
    annotation (Placement(transformation(extent={{140,-40},{180,0}}),
      iconTransformation(extent={{180,-60},{220,-20}})));

  Modelica.Blocks.Interfaces.BooleanInput uFan
    "Fan proven on signal"
    annotation (Placement(transformation(extent={{-180,80},{-140,120}}),
      iconTransformation(extent={{-220,180},{-180,220}})));

  Modelica.Blocks.Interfaces.RealInput TZon(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-180,40},{-140,80}}),
      iconTransformation(extent={{-220,100},{-180,140}})));

  Modelica.Blocks.Interfaces.RealInput TCooSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") if has_coo
    "Zone cooling temperature setpoint"
    annotation (Placement(transformation(extent={{-180,0},{-140,40}}),
      iconTransformation(extent={{-220,20},{-180,60}})));

  Modelica.Blocks.Interfaces.RealInput THeaSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") if has_hea
    "Zone heating temperature setpoint"
    annotation (Placement(transformation(extent={{-180,-40},{-140,0}}),
      iconTransformation(extent={{-220,-60},{-180,-20}})));

  Modelica.Blocks.Interfaces.BooleanInput uAva
    "Availability signal"
    annotation (Placement(transformation(extent={{-180,-80},{-140,-40}}),
      iconTransformation(extent={{-220,-140},{-180,-100}})));

  Modelica.Blocks.Interfaces.BooleanInput fanOpeMod if has_fanOpeMod
    "Supply fan operating mode signal" annotation (Placement(transformation(
          extent={{-180,-120},{-140,-80}}), iconTransformation(extent={{-220,-220},
            {-180,-180}})));
  Modelica.Blocks.Interfaces.BooleanOutput yCooEna if not has_varCoo and
    has_coo                                        "Cooling enable signal"
    annotation (Placement(transformation(extent={{140,80},{180,120}}),
        iconTransformation(extent={{180,180},{220,220}})));
  Modelica.Blocks.Interfaces.BooleanOutput yHeaEna if not has_varHea and
    has_hea
    "Heating enable signal" annotation (Placement(transformation(extent={{140,40},
            {180,80}}), iconTransformation(extent={{180,100},{220,140}})));
protected
  final parameter Boolean has_hea=(sysTyp ==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes.fcu)
    or (sysTyp ==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes.ptac)
    or (sysTyp ==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes.pthp)
    or (sysTyp ==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes.unitHeater)
    or (sysTyp ==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes.zoneOAUnit)
    or (sysTyp ==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes.unitVentilator)
    and not (heaCoiTyp==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.HeaSou.noHea)
    "Does the zone equipment have heating equipment?"
    annotation(Dialog(enable=false, tab="Non-configurable"));

  final parameter Boolean has_coo=(sysTyp ==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes.fcu)
    or (sysTyp ==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes.ptac)
    or (sysTyp ==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes.pthp)
    or (sysTyp ==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes.windowAC)
    or (sysTyp ==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes.zoneOAUnit)
    or (sysTyp ==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes.unitVentilator)
    and not (cooCoiTyp==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.CooSou.noCoo)
    "Does the zone equipment have cooling equipment?"
    annotation(Dialog(enable=false, tab="Non-configurable"));

  final parameter Boolean has_varHea = (sysTyp ==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes.fcu)
    or (sysTyp ==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes.ptac)
    or (sysTyp ==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes.unitHeater)
    or (sysTyp ==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes.zoneOAUnit)
    or (sysTyp ==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes.unitVentilator)
    "Does the zone equipment have variable heating?";

  final parameter Boolean has_varCoo = (sysTyp ==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes.fcu)
    or (sysTyp ==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes.zoneOAUnit)
    or (sysTyp ==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes.unitVentilator)
    "Does the zone equipment have variable cooling?";

  annotation (defaultComponentName = "fanCoiUni",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-180,-240},{180,240}}),            graphics={
        Text(
          extent={{-180,240},{180,280}},
          textString="%name",
          textColor={0,0,255}),
                  Rectangle(
          extent={{-180,240},{180,-240}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-140,-140},{140,140}})),
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
