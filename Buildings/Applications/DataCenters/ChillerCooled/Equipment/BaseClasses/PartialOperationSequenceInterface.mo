within Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses;
partial model PartialOperationSequenceInterface
  "Partial interface for operation sequence "

  Modelica.Blocks.Math.BooleanToReal booToRea(
    final realTrue=1,
    final realFalse=0)
    "Boolean to real (if true then 1 else 0)"
    annotation (Placement(transformation(extent={{-60,68},{-48,80}})));
  Modelica.Blocks.Math.Feedback inv
    "Inversion of the control signal"
    annotation (Placement(transformation(extent={{-14,88},{-2,100}})));
protected
  Modelica.Blocks.Sources.Constant uni(final k=1)
    "Unitary signal"
    annotation (Placement(transformation(extent={{-60,88},{-48,100}})));
equation
  connect(uni.y, inv.u1)
    annotation (Line(points={{-47.4,94},{-12.8,94}},
      color={0,0,127}));
  connect(booToRea.y, inv.u2)
    annotation (Line(points={{-47.4,74},{-30,74},{-8,74},{-8,89.2}},
      color={0,0,127}));
  annotation (    Documentation(info="<html>
<p>
Partial model that transforms the valve signal.
</p>
</html>",
        revisions="<html>
<ul>
<li>
June 30, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialOperationSequenceInterface;
