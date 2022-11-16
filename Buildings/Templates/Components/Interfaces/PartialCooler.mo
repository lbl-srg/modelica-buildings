within Buildings.Templates.Components.Interfaces;
partial model PartialCooler
  "Interface class for models of condenser water cooling equipment"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    redeclare final package Medium=MediumConWat,
    final m_flow_nominal=mConWat_flow_nominal);

  replaceable package MediumConWat=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CW medium model"
    annotation(__Linkage(enable=false));

  parameter Buildings.Templates.Components.Types.Cooler typ
    "Type of equipment"
    annotation(Evaluate=true, Dialog(group="Configuration"));

  parameter Buildings.Templates.Components.Data.Cooler dat(
    final typ=typ)
    "Design and operating parameters";

  final parameter Modelica.Units.SI.MassFlowRate mConWat_flow_nominal=
    dat.mConWat_flow_nominal
    "CW mass flow rate";
  final parameter Modelica.Units.SI.PressureDifference dpConWatFri_nominal(
    final min=0)=
    dat.dpConWatFri_nominal
    "CW flow-friction losses through equipment and piping only (without elevation head or valve)";
  // RFE: Elevation head currently not modeled in Buildings.Fluid.HeatExchangers.CoolingTowers
  final parameter Modelica.Units.SI.PressureDifference dpConWatSta_nominal(
    final min=0)=
    dat.dpConWatSta_nominal
    "CW elevation head";
  final parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal=
    dat.mAir_flow_nominal
    "Air mass flow rate";

  parameter Modelica.Units.SI.Time tau=30
    "Time constant at nominal flow"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab="Dynamics", group="Conservation equations"));

  Buildings.Templates.Components.Interfaces.Bus bus
    "Control bus"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));
  BoundaryConditions.WeatherData.Bus busWea
    "Weather bus"
    annotation (Placement(transformation(extent={{-80,80},{-40,120}}),
      iconTransformation(extent={{-70,90},{-50,110}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This partial class provides a standard interface for cooler models.
</p>
</html>", revisions="<html>
<ul>
<li>
November 18, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialCooler;
