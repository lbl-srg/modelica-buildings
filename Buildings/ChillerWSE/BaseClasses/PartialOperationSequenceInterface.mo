within Buildings.ChillerWSE.BaseClasses;
partial model PartialOperationSequenceInterface
  "Partial interface for operation sequence "

  Modelica.Blocks.Math.BooleanToReal booToRea(final realTrue=1,
      final realFalse=0) "Boolean to real (if true then 1 else 0)"
    annotation (Placement(transformation(extent={{-80,68},{-68,80}})));
  Modelica.Blocks.Math.Feedback inv
    annotation (Placement(transformation(extent={{-14,88},{-2,100}})));
protected
  Modelica.Blocks.Sources.Constant uni(final k=1)
    "Outputs one for WSE mode control valve"
    annotation (Placement(transformation(extent={{-80,88},{-68,100}})));
equation
  connect(uni.y, inv.u1) annotation (Line(points={{-67.4,94},{-12.8,94}},
        color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialOperationSequenceInterface;
