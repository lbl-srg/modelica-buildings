within Buildings.Templates.Plants.Controls.Utilities;
block TrueArrayConditional
  "Output a Boolean array with a given number of true elements and a priority order"
  parameter Integer nin(
    min=0)=0
    "Size of input array"
    annotation (Evaluate=true,
    Dialog(connectorSizing=true),HideResult=true);
  parameter Integer nout(
    min=0)=nin
    "Size of output array"
    annotation (Evaluate=true);
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput u(start=0, fixed=true)
    "Number of true elements"
    annotation (Placement(transformation(extent={{-140,
            -20},{-100,20}}), iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uIdx[nin]
    "Array of indices by order of priority to be true"
    annotation (Placement(
        transformation(extent={{-140,-80},{-100,-40}}), iconTransformation(
          extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1[nout]
    "Output"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
protected
  Integer uIdx_internal[nin]
    "Internal variable keeping uIdx unchanged when u changes";
  Integer i
    "Iteration variable";
initial equation
  pre(uIdx) = {i for i in 1:nin};
equation
  uIdx_internal = if change(u) then pre(uIdx) else uIdx;
algorithm
  i := 1;
  y1 := fill(false, nout);
  while i <= u loop
    if uIdx[i] >= 1 and uIdx[i] <= nout then
      y1[uIdx[i]] := true;
    end if;
    i := i + 1;
  end while;
  annotation (
    defaultComponentName="truArrCon",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Line(
          points={{-90,-80.3976},{68,-80.3976}},
          color={192,192,192}),
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255})}),
    Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Accepts indices of true elements that may not be within the
range of indices of the output vector.
In this, the number of true elements will not be met.
</p>
</html>"));
end TrueArrayConditional;
