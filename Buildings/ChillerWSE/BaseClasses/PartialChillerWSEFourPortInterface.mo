within Buildings.ChillerWSE.BaseClasses;
partial model PartialChillerWSEFourPortInterface
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

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialChillerWSEFourPortInterface;
