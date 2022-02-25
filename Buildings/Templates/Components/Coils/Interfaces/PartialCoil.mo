within Buildings.Templates.Components.Coils.Interfaces;
partial model PartialCoil
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    redeclare final package Medium=MediumAir,
    final m_flow_nominal=mAir_flow_nominal);

  outer replaceable package MediumAir=Buildings.Media.Air
    "Source-side medium";
  /*
  The following definition is needed only for Dymola that does not allow
  port_aSou and port_bSou to be instantiated without redeclaring their medium
  to a non-partial class (which is done only in the derived class).
  */
  replaceable package MediumSou=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Source-side medium";

  parameter Buildings.Templates.Components.Types.Coil typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Valve typVal
    "Type of valve"
    annotation (Dialog(group="Configuration"));
  final parameter Boolean have_sou=
    typ==Buildings.Templates.Components.Types.Coil.WaterBasedHeating or
    typ==Buildings.Templates.Components.Types.Coil.WaterBasedCooling
    "Set to true for fluid ports on the source side"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  final parameter Boolean have_weaBus=
    typ==Buildings.Templates.Components.Types.Coil.EvaporatorMultiStage or
    typ==Buildings.Templates.Components.Types.Coil.EvaporatorVariableSpeed
    "Set to true to use a weather bus"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Buildings.Templates.Components.Coils.Interfaces.Data datRec(
    final have_sou=have_sou,
    final typ=typ,
    final typVal=typVal)
    "Design and operating parameters";

  final parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal(
    final min=0) = datRec.mAir_flow_nominal
    "Air mass flow rate";
  final parameter Modelica.Units.SI.PressureDifference dpAir_nominal(
    final min=0,
    displayUnit="Pa") = datRec.dpAir_nominal
    "Air pressure drop";
  final parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal=
    datRec.Q_flow_nominal
    "Nominal heat flow rate";

  Modelica.Fluid.Interfaces.FluidPort_a port_aSou(
    redeclare package Medium = MediumSou) if have_sou
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{30,-110},{50,-90}}),
        iconTransformation(extent={{40,-110},{60,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bSou(
    redeclare package Medium = MediumSou) if have_sou
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-30,-110},{-50,-90}}),
        iconTransformation(extent={{-40,-110},{-60,-90}})));
  Buildings.BoundaryConditions.WeatherData.Bus busWea if have_weaBus
    "Weather bus"
    annotation (Placement(
        transformation(extent={{-80,80},{-40,120}}), iconTransformation(extent={{-70,90},
            {-50,110}})));
  Buildings.Templates.Components.Interfaces.Bus bus
    if typ <> Buildings.Templates.Components.Types.Coil.None
    "Control bus"
    annotation (Placement(
      transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));
protected
  parameter Buildings.Templates.Components.Valves.Interfaces.Data datRecVal(
    final typ=typVal,
    final m_flow_nominal=datRec.mWat_flow_nominal,
    final dpValve_nominal=datRec.dpValve_nominal,
    final dpFixed_nominal=if typVal<>Buildings.Templates.Components.Types.Valve.None then
          datRec.dpWat_nominal else 0)
    "Design and operating parameters of the control valve";

  annotation (
  Icon(
    graphics={
    Bitmap(
      visible=funStr=="Cooling",
      extent={{-53,-100},{53,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Coils/Cooling.svg"),
    Bitmap(
      visible=typ==Buildings.Templates.Components.Types.Coil.WaterBasedCooling,
      extent={{-100,-500},{100,-300}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Coils/ChilledWaterSupplyReturn.svg"),
    Bitmap(
      visible=funStr=="Heating",
      extent={{-53,-100},{53,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Coils/Heating.svg"),
    Bitmap(
      visible=typ==Buildings.Templates.Components.Types.Coil.WaterBasedHeating,
      extent={{-100,-500},{100,-300}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Coils/HotWaterSupplyReturn.svg"),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Coil.None and
        typVal==Buildings.Templates.Components.Types.Valve.None,
      extent={{-150,-300},{50,-100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/None.svg"),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Coil.None and
        typVal==Buildings.Templates.Components.Types.Valve.TwoWayModulating,
      extent={{-150,-300},{50,-100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg"),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Coil.None and
        typVal==Buildings.Templates.Components.Types.Valve.ThreeWayModulating,
      extent={{-150,-300},{50,-100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/ThreeWay.svg"),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Coil.None and
        (typVal==Buildings.Templates.Components.Types.Valve.TwoWayModulating or
        typVal==Buildings.Templates.Components.Types.Valve.ThreeWayModulating),
      extent={{-190,-240},{-110,-160}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Coil.None,
      extent={{-50,-300},{150,-100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/None.svg")},
    coordinateSystem(preserveAspectRatio=false)),
    Diagram(
        coordinateSystem(preserveAspectRatio=false)));

end PartialCoil;
