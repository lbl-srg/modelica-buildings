within Buildings.Templates.Plants.HeatPumps.Components.Validation;
model AlternateEquipmentIndices
  "Validation model for computing indices of lead/lad alternate equipment"
  extends Modelica.Icons.Example;
  parameter Real staEqu[:, :](
    each final max=1,
    each final min=0,
    each final unit="1")=[
    1,  0,   0;
    0,  1/2, 1/2;
    1,  1/2, 1/2;
    0,  1,   1;
    1,  1,   1]
    "Staging matrix – Equipment required for each stage"
    annotation (Dialog(group="Equipment staging and rotation"));
  final parameter Integer nHp=size(staEqu,2)
    "Number of heat pumps"
    annotation (Evaluate=true);
  final parameter Integer nSta(
    final min=1)=size(staEqu, 1)
    "Number of stages"
    annotation (Evaluate=true);
  final parameter Integer nEquAlt(
    final min=0)=max({sum({(if staEqu[i, j] > 0 and staEqu[i, j] < 1 then 1 else 0) for j in 1:nHp}) for i in 1:nSta})
    "Number of lead/lag alternate equipment"
    annotation (Evaluate=true);
  parameter Integer idxEquAlt[:]=Modelica.Math.BooleanVectors.index(
    {Modelica.Math.BooleanVectors.anyTrue({staEqu[i,j] > 0 and staEqu[i,j] < 1 for i in 1:nSta})
    for j in 1:nHp})
    "Indices of lead/lag alternate equipment"
    annotation (Evaluate=true,
    Dialog(group="Equipment staging and rotation"));
end AlternateEquipmentIndices;
