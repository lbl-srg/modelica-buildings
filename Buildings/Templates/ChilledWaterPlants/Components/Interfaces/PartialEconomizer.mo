within Buildings.Templates.ChilledWaterPlants.Components.Interfaces;
partial model PartialEconomizer "Partial waterside economizer model"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    port_a_x=400, port_a_y=-80, port_b_x=400, port_b_y=80,
    redeclare final package Medium=MediumChiWat,
    final m_flow_nominal=mChiWat_flow_nominal);

  replaceable package MediumChiWat = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW medium";
  replaceable package MediumConWat = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CW medium";

  parameter Buildings.Templates.ChilledWaterPlants.Types.Economizer typ
    "Type of equipment"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Buildings.Templates.ChilledWaterPlants.Components.Data.Economizer
    dat(final typ=typ)
    "Design and operating parameters";

  final parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal(
    final min=0)=dat.mChiWat_flow_nominal
    "CHW mass flow rate";
  final parameter Modelica.Units.SI.MassFlowRate mConWat_flow_nominal(
    final min=0)=dat.mConWat_flow_nominal
    "CHW mass flow rate";
  final parameter Modelica.Units.SI.PressureDifference dpChiWat_nominal(
    final min=0,
    displayUnit="Pa")=dat.dpChiWat_nominal
    "CHW pressure drop";
  final parameter Modelica.Units.SI.PressureDifference dpConWat_nominal(
    final min=0,
    displayUnit="Pa")=dat.dpConWat_nominal
    "CW pressure drop";
  final parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal(
    final max=0)=-1*dat.cap_nominal
    "Heat flow rate";
  final parameter Buildings.Templates.Components.Data.Valve datValConWatIso(
    final typ=if typ<>Buildings.Templates.ChilledWaterPlants.Types.Economizer.None
    then Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition else
    Buildings.Templates.Components.Types.Valve.None,
    final m_flow_nominal=mConWat_flow_nominal,
    final dpValve_nominal=dat.dpValConWatIso_nominal,
    final dpFixed_nominal=dpConWat_nominal)
    "WSE CW isolation valve";
  final parameter Buildings.Templates.Components.Data.Valve datValChiWatByp(
    final typ=if typ==Buildings.Templates.ChilledWaterPlants.Types.Economizer.HeatExchangerWithValve
    then Buildings.Templates.Components.Types.Valve.TwoWayModulating else
    Buildings.Templates.Components.Types.Valve.None,
    final m_flow_nominal=mChiWat_flow_nominal,
    final dpValve_nominal=dat.dpValChiWatByp_nominal)
    "WSE CHW bypass valve";
  final parameter Buildings.Templates.Components.Data.PumpSingle datPumChiWat(
    final typ=if typ==Buildings.Templates.ChilledWaterPlants.Types.Economizer.HeatExchangerWithPump
    then Buildings.Templates.Components.Types.Pump.Single else
    Buildings.Templates.Components.Types.Pump.None,
    final m_flow_nominal=mChiWat_flow_nominal,
    final dp_nominal=dat.dpPumChiWat_nominal,
    final per=dat.perPumChiWat)
    "Heat exchanger CHW pump";

  parameter Modelica.Units.SI.Time tau=1
    "Time constant of fluid volume for nominal flow, used if energy or mass balance is dynamic"
    annotation (Dialog(
      tab="Dynamics",
      group="Nominal condition",
      enable=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  Modelica.Fluid.Interfaces.FluidPort_a port_aConWat(
   redeclare final package Medium = MediumConWat,
   m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
   h_outflow(start = MediumConWat.h_default, nominal = MediumConWat.h_default))
   if typ<>Buildings.Templates.ChilledWaterPlants.Types.Economizer.None
   "Fluid connector a1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{90,70},{110,90}}),
        iconTransformation(extent={{-410,70},{-390,90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bConWat(
   redeclare final package Medium = MediumConWat,
   m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
   h_outflow(start = MediumConWat.h_default, nominal = MediumConWat.h_default))
   if typ<>Buildings.Templates.ChilledWaterPlants.Types.Economizer.None
    "Fluid connector b1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-90,70},{-110,90}}),
        iconTransformation(extent={{-390,-90},{-410,-70}})));

  Buildings.Templates.ChilledWaterPlants.Interfaces.Bus bus
    if typ<>Buildings.Templates.ChilledWaterPlants.Types.Economizer.None
    "Plant control bus"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}), iconTransformation(extent={{-20,80},{20,120}})));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-400,
            -100},{400,100}})),
     Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This partial class provides a standard interface for waterside
economizer models.
</p>
</html>", revisions="<html>
<ul>
<li>
November 18, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));

end PartialEconomizer;
