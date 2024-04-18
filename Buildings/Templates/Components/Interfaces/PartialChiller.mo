within Buildings.Templates.Components.Interfaces;
partial model PartialChiller "Interface class for chiller models"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
    redeclare final package Medium1=MediumCon,
    redeclare final package Medium2=MediumChiWat,
    final m1_flow_nominal=mCon_flow_nominal,
    final m2_flow_nominal=mChiWat_flow_nominal,
    final allowFlowReversal1=allowFlowReversal,
    final allowFlowReversal2=allowFlowReversal);

  replaceable package MediumChiWat=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW medium"
    annotation(__Linkage(enable=false));
  replaceable package MediumCon = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium model for condenser cooling fluid"
    annotation(__Linkage(enable=false));

  parameter Buildings.Templates.Components.Types.Chiller typ
    "Type of chiller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Buildings.Templates.Components.Data.Chiller dat(
    final typ=typ)
    "Design and operating parameters"
    annotation (
    Placement(transformation(extent={{70,80},{90,100}})),
    __ctrlFlow(enable=false));

  final parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal=
    dat.mChiWat_flow_nominal
    "CHW mass flow rate";
  final parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal=
    dat.mCon_flow_nominal
    "Condenser cooling fluid mass flow rate";
  final parameter Modelica.Units.SI.HeatFlowRate cap_nominal=
    dat.cap_nominal
    "Cooling capacity";
  final parameter Modelica.Units.SI.PressureDifference dpChiWat_nominal=
    dat.dpChiWat_nominal
    "CHW pressure drop";
  final parameter Modelica.Units.SI.PressureDifference dpCon_nominal=
    dat.dpCon_nominal
    "Condenser cooling fluid pressure drop";
  final parameter Modelica.Units.SI.Temperature TChiWatSup_nominal=
    dat.TChiWatSup_nominal
    "CHW supply temperature";

  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Modelica.Units.SI.Time tau=30
    "Time constant at nominal flow"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab="Dynamics", group="Conservation equations"));

  Buildings.Templates.Components.Interfaces.Bus bus
    "Control bus"
    annotation (Placement(transformation(extent={{-20,80},{20,120}}),
     iconTransformation(extent={{-20,80},{20, 120}})));
  annotation (Documentation(info="<html>
<p>
This partial class provides a standard interface for chiller models.
</p>
</html>", revisions="<html>
<ul>
<li>
November 18, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={
    Rectangle(
          extent={{100,60},{-100,-60}},
          lineColor={0,0,0},
          lineThickness=1),
    Bitmap(extent={{-20,60},{20,100}}, fileName=
    "modelica://Buildings/Resources/Images/Templates/Components/Boilers/ControllerOnboard.svg"),
    Text( extent={{-60,20},{60,-20}},
          textColor={0,0,0},
          textString="CHI")}));
end PartialChiller;
