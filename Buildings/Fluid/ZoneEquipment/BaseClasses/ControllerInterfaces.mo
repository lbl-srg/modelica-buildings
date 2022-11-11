within Buildings.Fluid.ZoneEquipment.BaseClasses;
partial model ControllerInterfaces
  "Baseclass for zone HVAC controller interfaces"

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yFan
    "Fan enable signal"
    annotation (Placement(transformation(extent={{140,-80},{180,-40}}),
      iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yFanSpe(
    final unit="1",
    displayUnit="1")
    "Fan speed signal"
    annotation (Placement(transformation(extent={{140,-40},{180,0}}),
      iconTransformation(extent={{100,-40},{140,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput           yCoo(final unit="1",
      displayUnit="1")
    "Cooling signal"
    annotation (Placement(transformation(extent={{140,40},{180,80}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput           yHea(final unit="1",
      displayUnit="1")
    "Heating signal"
    annotation (Placement(transformation(extent={{140,0},{180,40}}),
      iconTransformation(extent={{100,0},{140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput           uFan
    "Fan proven on signal"
    annotation (Placement(transformation(extent={{-180,60},{-140,100}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput           TZon(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-180,20},{-140,60}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput           TCooSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Zone cooling temperature setpoint"
    annotation (Placement(transformation(extent={{-180,-20},{-140,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput           THeaSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Zone heating temperature setpoint"
    annotation (Placement(transformation(extent={{-180,-60},{-140,-20}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput           uOcc
    "Occupancy signal"
    annotation (Placement(transformation(extent={{-180,-100},{-140,-60}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
protected
  final parameter Boolean has_HW=(heaCoiTyp == Buildings.Fluid.ZoneEquipment.FanCoilUnit.Types.HeaSou.hotWat)
    "Does the zone equipment have a hot water heating coil?"
    annotation(Dialog(enable=false, tab="Non-configurable"));

  final parameter Boolean has_CHW=(cooCoiTyp == Buildings.Fluid.ZoneEquipment.FanCoilUnit.Types.CooSou.chiWat)
    "Does the zone equipment have a chilled water cooling coil?"
    annotation(Dialog(enable=false, tab="Non-configurable"));

  annotation (defaultComponentName = "fanCoiUni",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),            graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,200},{100,240}},
          textString="%name",
          textColor={0,0,255}),
      Text(
        extent={{-100,100},{100,140}},
        textString="%name",
        textColor={0,0,255})}),
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
