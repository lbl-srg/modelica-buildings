within Buildings.ChillerWSE.BaseClasses;
partial model PartialChillerWSEInterface
  "Partial model that defines the interface for chiller and WSE package"
  extends Buildings.Fluid.Interfaces.PartialFourPort;

  // Nominal conditions
  parameter Modelica.SIunits.MassFlowRate mChiller1_flow_nominal(min=0)
    "Nominal mass flow rate on the medium 2 side in the chiller"
    annotation(Dialog(group = "Chiller Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mChiller2_flow_nominal(min=0)
    "Nominal mass flow rate on the medium 2 side in the chiller"
    annotation(Dialog(group = "Chiller Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mWSE1_flow_nominal(min=0)
    "Nominal mass flow rate on the medium 2 side in the chiller"
    annotation(Dialog(group = "WSE Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mWSE2_flow_nominal(min=0)
    "Nominal mass flow rate on the medium 2 side in the chiller"
    annotation(Dialog(group = "WSE Nominal condition"));

  // Advanced
  parameter Medium1.MassFlowRate m1_flow_small(min=0) = 1E-4*abs(mChiller1_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));
  parameter Medium2.MassFlowRate m2_flow_small(min=0) = 1E-4*abs(mChiller2_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));
  // Diagnostics
  parameter Boolean show_T = false
    "= true, if actual temperature at port is computed"
    annotation(Dialog(tab="Advanced",group="Diagnostics"));
  parameter Integer n(min=1)=2 "Number of chillers and WSE";


  Modelica.Blocks.Interfaces.RealInput TSet
    "Set point for leaving water temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.BooleanInput on[n]
    "Set to true to enable equipment, or false to disable equipment"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,255})}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));

end PartialChillerWSEInterface;
