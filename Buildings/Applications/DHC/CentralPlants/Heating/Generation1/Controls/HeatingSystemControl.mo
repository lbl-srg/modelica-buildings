within Buildings.Applications.DHC.CentralPlants.Heating.Generation1.Controls;
model HeatingSystemControl
  extends Modelica.Blocks.Icons.Block;

  parameter Integer nu(min=0) = 2 "Number of input connections";

  parameter Modelica.SIunits.Power QPla_flow_nominal
    "Nominal heating power of plant";

  Modelica.Blocks.Interfaces.RealVectorInput QBld_flow[nu]
    "Heat flow rate of each building on the network"
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}})));

  Modelica.Blocks.Interfaces.RealOutput y "Plant part load ratio"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));

  Modelica.SIunits.Power Q_flow_sum
    "Summation of instantaneous heating powers of all connected buildings";

equation
  Q_flow_sum = sum(i for i in QBld_flow[1:nu]);
  y = Q_flow_sum/QPla_flow_nominal;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HeatingSystemControl;
