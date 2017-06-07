within Buildings.ChillerWSE.BaseClasses;
partial model PartialOperationSequenceInterface
  "Partial interface for operation sequence "

  Modelica.Blocks.Math.BooleanToReal booToRea(final realTrue=1,
      final realFalse=0) "Boolean to real (if true then 1 else 0)"
    annotation (Placement(transformation(extent={{-52,66},{-40,78}})));
  Modelica.Blocks.Math.Feedback inv
    annotation (Placement(transformation(extent={{-28,86},{-16,98}})));
protected
  Modelica.Blocks.Sources.Constant uni(final k=1)
    "Outputs one for WSE mode control valve"
    annotation (Placement(transformation(extent={{-52,86},{-40,98}})));
equation
  connect(uni.y, inv.u1) annotation (Line(points={{-39.4,92},{-34,92},{-26.8,92}},
        color={0,0,127}));
  connect(booToRea.y, inv.u2) annotation (Line(points={{-39.4,72},{-22,72},{-22,
          87.2}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialOperationSequenceInterface;
