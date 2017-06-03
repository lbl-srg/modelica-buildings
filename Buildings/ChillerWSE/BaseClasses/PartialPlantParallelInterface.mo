within Buildings.ChillerWSE.BaseClasses;
partial model PartialPlantParallelInterface
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface;
  extends Buildings.Fluid.Interfaces.FourPortFlowResistanceParameters(
     final computeFlowResistance1=true,
     final computeFlowResistance2=true);
  parameter Integer n(min=1)=2 "Number of equipment";
  Modelica.Blocks.Math.BooleanToReal booToRea[n](
    each final realTrue=1,
    each final realFalse=0) "Boolean to real (if true then 1 else 0)"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Modelica.Blocks.Interfaces.RealInput TSet
    "Set point for leaving water temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.BooleanInput on[n]
    "Set to true to enable equipment, or false to disable equipment"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
equation
  connect(on, booToRea.u) annotation (Line(points={{-120,40},{-120,40},{-82,40}},
        color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialPlantParallelInterface;
