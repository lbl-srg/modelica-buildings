within Buildings.Fluid.ZoneEquipment.BaseClasses;
partial model ControllerInterfaces
  "Baseclass for zone HVAC controller interfaces"

  parameter Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes sysTyp
    "Select zonal HVAC system type"
    annotation (Dialog(group="System parameters"));

  parameter Buildings.Fluid.ZoneEquipment.BaseClasses.Types.FanTypes fanTyp
    "Select zonal HVAC fan type"
    annotation (Dialog(group="Fan parameters"));

  parameter Buildings.Fluid.ZoneEquipment.BaseClasses.Types.HeaSou heaCoiTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.HeaSou.hotWat
    "Type of heating coil used" annotation (Dialog(group="System parameters"));

  parameter Buildings.Fluid.ZoneEquipment.BaseClasses.Types.CooSou cooCoiTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.CooSou.chiWat
    "Type of cooling coil used" annotation (Dialog(group="System parameters"));

  parameter Boolean has_fanOpeMod = true
    "Does the controller need a fan operating mode signal interface?";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uFan
    "Fan proven on signal"
    annotation (Placement(transformation(extent={{-180,110},{-140,150}}),
      iconTransformation(extent={{-140,110},{-100,150}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uAva
    "Availability signal"
    annotation (Placement(transformation(extent={{-180,-76},{-140,-36}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput fanOpeMod if has_fanOpeMod
    "Supply fan operating mode signal"
    annotation (Placement(transformation(extent={{-180,-114},{-140,-74}}),
      iconTransformation(extent={{-140,-114},{-100,-74}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-180,74},{-140,114}}),
      iconTransformation(extent={{-140,74},{-100,114}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCooSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") if has_coo
    "Zone cooling temperature setpoint"
    annotation (Placement(transformation(extent={{-180,36},{-140,76}}),
      iconTransformation(extent={{-140,38},{-100,78}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") if has_hea
    "Zone heating temperature setpoint"
    annotation (Placement(transformation(extent={{-180,0},{-140,40}}),
      iconTransformation(extent={{-140,0},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Measured supply temperature"
    annotation (Placement(transformation(extent={{-180,-150},{-140,-110}}),
      iconTransformation(extent={{-140,-150},{-100,-110}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") if has_supHea
    "Outdoor air dry bulb temperature"
    annotation (Placement(transformation(extent={{-180,-40},{-140,0}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yCooEna if not has_varCoo and
    has_coo
    "Cooling enable signal"
    annotation (Placement(transformation(extent={{140,100},{180,140}}),
      iconTransformation(extent={{100,100},{140,140}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHeaEna if not has_varHea and
    has_hea
    "Heating enable signal"
    annotation (Placement(transformation(extent={{140,60},{180,100}}),
      iconTransformation(extent={{100,60},{140,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yFan
    "Fan enable signal"
    annotation (Placement(transformation(extent={{140,-140},{180,-100}}),
      iconTransformation(extent={{100,-140},{140,-100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHea(
    final unit="1",
    displayUnit="1") if has_hea and has_varHea
    "Heating signal"
    annotation (Placement(transformation(extent={{140,-60},{180,-20}}),
      iconTransformation(extent={{100,-60},{140,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yFanSpe(
    final unit="1",
    displayUnit="1") if has_varFan
    "Fan speed signal"
    annotation (Placement(transformation(extent={{140,-100},{180,-60}}),
      iconTransformation(extent={{100,-100},{140,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCoo(
    final unit="1",
    displayUnit="1") if has_coo and has_varCoo
    "Cooling signal"
    annotation (Placement(transformation(extent={{140,-20},{180,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySupHea(
    final min=0,
    final max=1,
    final unit="1") if has_supHea "Supplementary heating control signal"
    annotation (Placement(transformation(extent={{140,20},{180,60}}),
      iconTransformation(extent={{100,20},{140,60}})));

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
    or (sysTyp ==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes.unitHeater)
    or (sysTyp ==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes.zoneOAUnit)
    or (sysTyp ==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes.unitVentilator)
    "Does the zone equipment have variable heating?";

  final parameter Boolean has_varCoo = (sysTyp ==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes.fcu)
    or (sysTyp ==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes.zoneOAUnit)
    or (sysTyp ==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes.unitVentilator)
    "Does the zone equipment have variable cooling?";

  final parameter Boolean has_supHea = (sysTyp ==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes.pthp)
    and not (heaCoiTyp==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.HeaSou.noHea)
    "Does the zone equipment have supplementary heating coil?";

  final parameter Boolean has_conFan = (fanTyp ==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.FanTypes.conSpeFan)
    "Does the zone equipment have constant speed fan?";

  final parameter Boolean has_varFan = (fanTyp ==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.FanTypes.varSpeFan)
    "Does the zone equipment have variable speed fan?";

  final parameter Boolean has_mulFan = (fanTyp ==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.FanTypes.mulSpeFan)
    "Does the zone equipment have multiple speed fan?";

  annotation (defaultComponentName = "fanCoiUni",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-140},{100,
            140}}),                                                                              graphics={
        Text(
          extent={{-140,180},{140,140}},
          textString="%name",
          textColor={0,0,255}),
                  Rectangle(
          extent={{-100,140},{100,-140}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-140,-140},{140,140}})),
    Documentation(info="<html>
    <p>
    Baseclass for controller interfaces.
    </p>
    </html>
    ", revisions="<html>
    <ul>
    <li>
    April 10, 2023 by Karthik Devaprasad:<br/>
    First implementation.
    </li>
    </ul>
    </html>"));
end ControllerInterfaces;
