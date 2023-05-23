within Buildings.Templates.Components.Interfaces;
partial model PartialCoil "Interface class for coil"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    redeclare final package Medium=MediumAir,
    final m_flow_nominal=mAir_flow_nominal,
    final allowFlowReversal=allowFlowReversalAir)
    annotation(__Linkage(enable=false));

  replaceable package MediumAir=Buildings.Media.Air
    "Air medium"
    annotation(__Linkage(enable=false));
  /*
  The following definition is needed only for Dymola that does not allow
  port_aSou and port_bSou to be instantiated without redeclaring their medium
  to a non-partial class (which is done only in the derived class).
  */
  replaceable package MediumSou=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Source-side medium"
    annotation(Dialog(enable=false), __Linkage(enable=false));

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

  parameter Buildings.Templates.Components.Data.Coil dat(
    final typ=typ,
    final typVal=typVal)
    "Design and operating parameters"
    annotation (
    Placement(transformation(extent={{70,70},{90,90}})),
    __Linkage(enable=false));

  final parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal(
    final min=0) = dat.mAir_flow_nominal
    "Air mass flow rate";
  final parameter Modelica.Units.SI.PressureDifference dpAir_nominal(
    final min=0,
    displayUnit="Pa") = dat.dpAir_nominal
    "Air pressure drop";
  final parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal=
    dat.Q_flow_nominal
    "Nominal heat flow rate";

  parameter Modelica.Units.SI.Time tau=20
    "Time constant at nominal flow"
    annotation (Dialog(tab="Dynamics", group="Nominal condition",
      enable=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState and (
      typ==Buildings.Templates.Components.Types.Coil.ElectricHeating or
      typ==Buildings.Templates.Components.Types.Coil.EvaporatorMultiStage or
      typ==Buildings.Templates.Components.Types.Coil.EvaporatorVariableSpeed)),
      __Linkage(enable=false));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations",
      enable=typ==Buildings.Templates.Components.Types.Coil.ElectricHeating or
      typ==Buildings.Templates.Components.Types.Coil.EvaporatorMultiStage or
      typ==Buildings.Templates.Components.Types.Coil.EvaporatorVariableSpeed),
      __Linkage(enable=false));

  parameter Boolean allowFlowReversalAir=true
    "= true to allow flow reversal, false restricts to design direction - Air side"
    annotation (Dialog(tab="Assumptions"), Evaluate=true,
      __Linkage(enable=false));
  parameter Boolean allowFlowReversalLiq=true
    "= true to allow flow reversal, false restricts to design direction - CHW and HW side"
    annotation (Dialog(tab="Assumptions",
      enable=typ==Buildings.Templates.Components.Types.Coil.WaterBasedCooling or
      typ==Buildings.Templates.Components.Types.Coil.WaterBasedHeating),
      Evaluate=true,
      __Linkage(enable=false));

  Modelica.Fluid.Interfaces.FluidPort_a port_aSou(
    redeclare package Medium = MediumSou,
    m_flow(min=if allowFlowReversalLiq then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumSou.h_default, nominal=MediumSou.h_default))
    if have_sou
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{30,-110},{50,-90}}),
        iconTransformation(extent={{40,-110},{60,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bSou(
    redeclare package Medium = MediumSou,
    m_flow(max=if allowFlowReversalLiq then +Modelica.Constants.inf else 0),
    h_outflow(start = MediumSou.h_default, nominal = MediumSou.h_default))
    if have_sou
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-30,-110},{-50,-90}}),
        iconTransformation(extent={{-40,-110},{-60,-90}})));
  Buildings.BoundaryConditions.WeatherData.Bus busWea if have_weaBus
    "Weather bus"
    annotation (Placement(
        transformation(extent={{-80,80},{-40,120}}), iconTransformation(extent={{-50,90},
            {-30,110}})));
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
  parameter Buildings.Templates.Components.Data.Valve datVal(
    final typ=typVal,
    final m_flow_nominal=dat.mWat_flow_nominal,
    final dpValve_nominal=dat.dpValve_nominal,
    final dpFixed_nominal=if typVal <> Buildings.Templates.Components.Types.Valve.None
      then dat.dpWat_nominal else 0)
    "Local record for control valve with lumped flow resistance";
initial equation
  if typ==Buildings.Templates.Components.Types.Coil.EvaporatorMultiStage or
    typ==Buildings.Templates.Components.Types.Coil.EvaporatorVariableSpeed then
    assert(mAir_flow_nominal<=dat.datCoi.sta[dat.datCoi.nSta].nomVal.m_flow_nominal,
      "In "+ getInstanceName() + ": "+
      "The coil design airflow ("+String(mAir_flow_nominal)+
      ") exceeds the maximum airflow provided in the performance data record ("+
      String(dat.datCoi.sta[dat.datCoi.nSta].nomVal.m_flow_nominal)+").",
      level=AssertionLevel.warning);
    assert(abs(Q_flow_nominal)<=abs(dat.datCoi.sta[dat.datCoi.nSta].nomVal.Q_flow_nominal),
      "In "+ getInstanceName() + ": "+
      "The coil design capacity ("+String(Q_flow_nominal)+
      ") exceeds the maximum capacity provided in the performance data record ("+
      String(dat.datCoi.sta[dat.datCoi.nSta].nomVal.Q_flow_nominal)+").",
      level=AssertionLevel.warning);
  end if;

  annotation (
  Icon(
    graphics={
    Bitmap(
          visible=typ <> Buildings.Templates.Components.Types.Coil.None and
              typVal == Buildings.Templates.Components.Types.Valve.TwoWayModulating,
          extent={{-140,-300},{60,-100}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg"),
    Bitmap(
      visible=typ==Buildings.Templates.Components.Types.Coil.WaterBasedCooling or
       typ==Buildings.Templates.Components.Types.Coil.EvaporatorMultiStage or
       typ==Buildings.Templates.Components.Types.Coil.EvaporatorVariableSpeed,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Coils/Cooling.svg"),
    Bitmap(
      visible=typ==Buildings.Templates.Components.Types.Coil.WaterBasedCooling,
      extent={{-100,-500},{100,-300}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Coils/ChilledWaterSupplyReturn.svg"),
    Bitmap(
      visible=typ==Buildings.Templates.Components.Types.Coil.WaterBasedHeating or
        typ==Buildings.Templates.Components.Types.Coil.ElectricHeating,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Coils/Heating.svg"),
    Bitmap(
      visible=typ==Buildings.Templates.Components.Types.Coil.WaterBasedHeating,
      extent={{-100,-500},{100,-300}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Coils/HotWaterSupplyReturn.svg"),
    Line(
      visible=typ<>Buildings.Templates.Components.Types.Coil.None and
        typVal<>Buildings.Templates.Components.Types.Valve.None,
      points={{-100,-200},{-40,-200}}, color={0,0,0}),
    Line(
      visible=typ<>Buildings.Templates.Components.Types.Coil.None,
      points={{-40,-240},{-40,-320}},
      color={0,0,0},
      thickness=5),
    Line( visible=typ <> Buildings.Templates.Components.Types.Coil.None,
          points={{-40,-160},{-40,-100}},
          color={0,0,0},
          thickness=5),
    Line( visible=typ <> Buildings.Templates.Components.Types.Coil.None and
              typVal == Buildings.Templates.Components.Types.Valve.None,
          points={{-40,-160},{-40,-240}},
          color={0,0,0},
          thickness=5),
    Line(
      visible=typ<>Buildings.Templates.Components.Types.Coil.None,
      points={{40,-100},{40,-320}},
      color={0,0,0},
      thickness=5),
    Line(
      visible=typ<>Buildings.Templates.Components.Types.Coil.None and
        (typVal==Buildings.Templates.Components.Types.Valve.ThreeWayModulating or
        typVal==Buildings.Templates.Components.Types.Valve.ThreeWayTwoPosition),
      points={{0,-200},{40,-200}},
      color={0,0,0},
      thickness=5),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Coil.None and
        (typVal==Buildings.Templates.Components.Types.Valve.TwoWayModulating or
        typVal==Buildings.Templates.Components.Types.Valve.ThreeWayModulating),
      extent={{-180,-238},{-100,-158}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
    Bitmap(
          visible=typ <> Buildings.Templates.Components.Types.Coil.None and
              typVal == Buildings.Templates.Components.Types.Valve.ThreeWayModulating,
          extent={{-140,-300},{60,-100}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/ThreeWay.svg")},
    coordinateSystem(preserveAspectRatio=false)),
    Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This partial class provides a standard interface for coil models.
</p>
</html>"));
end PartialCoil;
