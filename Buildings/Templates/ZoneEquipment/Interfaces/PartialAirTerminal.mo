within Buildings.Templates.ZoneEquipment.Interfaces;
partial model PartialAirTerminal
  "Interface class for terminal unit in air system"

  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium";
  replaceable package MediumHea=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Heating medium (such as HHW)"
    annotation(Dialog(enable=have_souCoiHea));

  parameter Buildings.Templates.ZoneEquipment.Types.Configuration typ
    "Type of system"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter String id
   "System tag"
    annotation (Dialog(group="Configuration"));

  parameter Boolean have_souCoiHea
    "Set to true if heating coil requires fluid ports on the source side"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  replaceable parameter
    Buildings.Templates.ZoneEquipment.Data.PartialAirTerminal dat(final typ=typ,
      final have_souCoiHea=have_souCoiHea) "Design and operating parameters";

  final parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal=
    dat.mAir_flow_nominal
    "Discharge air mass flow rate"
    annotation (Dialog(group="Nominal condition"));

  Modelica.Fluid.Interfaces.FluidPort_a port_Sup(
    redeclare final package Medium =MediumAir)
    if typ <> Buildings.Templates.ZoneEquipment.Types.Configuration.DualDuct
    "Supply air"
    annotation (
      Placement(transformation(extent={{-310,-210},{-290,-190}}),
        iconTransformation(extent={{-210,-10},{-190,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_SupCol(
    redeclare final package Medium =MediumAir)
    if typ == Buildings.Templates.ZoneEquipment.Types.Configuration.DualDuct
    "Dual duct cold deck air supply"
    annotation (Placement(transformation(
          extent={{-310,-250},{-290,-230}}), iconTransformation(extent={{-210,-110},
            {-190,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_SupHot(
    redeclare final package Medium =MediumAir)
    if typ == Buildings.Templates.ZoneEquipment.Types.Configuration.DualDuct
    "Dual duct hot deck air supply"
    annotation (Placement(
        transformation(extent={{-310,-170},{-290,-150}}), iconTransformation(
          extent={{-210,90},{-190,110}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_Dis(
    redeclare final package Medium =MediumAir)
    "Discharge air"
    annotation (Placement(transformation(extent={{290,-210},{310,-190}}),
        iconTransformation(extent={{190,-10},{210,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_Ret(
    redeclare final package Medium =MediumAir)
    if typ == Buildings.Templates.ZoneEquipment.Types.Configuration.FanPowered
     or typ == Buildings.Templates.ZoneEquipment.Types.Configuration.Induction
    "Return air"
    annotation (Placement(
        transformation(extent={{290,-90},{310,-70}}), iconTransformation(
          extent={{190,90},{210,110}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_coiHeaSup(
    redeclare final package Medium=MediumHea) if have_souCoiHea
    "Heating coil supply port"
    annotation (Placement(transformation(extent={{10,-290},{30,-270}}),
      iconTransformation(extent={{-30,-208},{-10,-188}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_coiHeaRet(
    redeclare final package Medium=MediumHea) if have_souCoiHea
    "Heating coil return port"
    annotation (Placement(transformation(extent={{-30,-290},{-10,-270}}),
      iconTransformation(extent={{10,-208},{30,-188}})));

  Interfaces.Bus bus
    "Terminal unit control bus"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-300,0}), iconTransformation(
        extent={{-20,-19},{20,19}},
        rotation=90,
        origin={-199,160})));

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-200,-200},{200,200}}), graphics={
        Text(
          extent={{-155,-218},{145,-258}},
          lineColor={0,0,255},
          textString="%name"), Rectangle(
          extent={{-200,200},{200,-200}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
                                       Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-300,-280},{300,
            280}}), graphics={
        Rectangle(
          extent={{-300,40},{300,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={245,239,184},
          pattern=LinePattern.None)}));
end PartialAirTerminal;
