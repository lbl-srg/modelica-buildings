within Buildings.Templates.Plants.Controls.Utilities;
block TrueArrayConditional
  "Output a Boolean array with a given number of true elements and a priority order"
  parameter Boolean is_fix=false
    "Set to true to fix output between changes of number of true values, false to change output at any input change"
    annotation (Evaluate=true);
  parameter Integer nin(
    min=0)=0
    "Size of input array"
    annotation (Evaluate=true,
    Dialog(connectorSizing=true),HideResult=true);
  parameter Integer nout(
    min=0)=nin
    "Size of output array"
    annotation (Evaluate=true);
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput u
    "Number of true elements"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uIdx[nin]
    "Array of indices by order of priority to be true"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1[nout]
    "Output"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
protected
  Integer iTru
    "Iteration variable - Count number of true elements";
  Integer iIdx
    "Iteration variable - Count number of indices in input vector";
  Integer uIdx_internal[nin]
    "Sampled value of indices by order of priority to be true";
initial equation
  pre(u)=0;
equation
  if is_fix then
    when {initial(), change(u)} then
      uIdx_internal=uIdx;
    end when;
  else
    uIdx_internal=uIdx;
  end if;
algorithm
  iTru := 0;
  iIdx := 1;
  y1 := fill(false, nout);
  while
       (iTru < u) and (iIdx <= nin) loop
    if (uIdx_internal[iIdx] >= 1) and (uIdx_internal[iIdx] <= nout) then
      y1[uIdx_internal[iIdx]] := true;
      iTru := iTru + 1;
    end if;
    iIdx := iIdx + 1;
  end while;
  annotation (
    defaultComponentName="truArrCon",
    __cdl(
      extensionBlock=true),
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
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
      coordinateSystem(
        preserveAspectRatio=false)),
    Documentation(
      info="<html>
<p>
Accepts indices of true elements that may not be within the
range of indices of the output vector.
In this, the number of true elements will not be met.
</p>
</html>"));
end TrueArrayConditional;
