within Buildings.Templates.Plants.Controls.HeatPumps.Subsequences;
block RemoveFromStagingOrder
  parameter Integer nUni
    "Number of units"
    annotation(Evaluate=true);
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uIdxSor[nUni]
    "Indices of polyvalent units sorted by increasing runtime" annotation (
      Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yIdxSor[nUni]
    "Indices of polyvalent units sorted by increasing runtime" annotation (
      Placement(transformation(extent={{100,-20},{140,20}}), iconTransformation(
          extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1[nUni]
    "Indices of polyvalent units sorted by increasing runtime" annotation (
      Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Integer u1Idx[nUni] = {if u1[i] then i else 0 for i in 1:nUni};
  Boolean isInU1[nUni] = {Modelica.Math.Vectors.find(el, u1Idx) >0 for el in uIdxSor};
  Integer firIdxInU1Rev = Modelica.Math.BooleanVectors.firstTrueIndex(
    {isInU1[i] for i in nUni:-1:1});
algorithm
  yIdxSor[nUni] :=uIdxSor[nUni];
  for i in nUni-1:-1:1 loop
    yIdxSor[i] := if u1[uIdxSor[i]] then yIdxSor[i + 1] else uIdxSor[i];
  end for;
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end RemoveFromStagingOrder;
