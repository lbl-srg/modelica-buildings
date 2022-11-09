within Buildings.Templates.ChilledWaterPlants.Components.Validation;
model StagingMatrixComputation
  "Validation of the algorithm used to compute the chiller staging matrix"
  extends Modelica.Icons.Example;

  parameter Integer nChi=2;
  parameter Boolean have_eco=true;

  final parameter Integer staMat[nStaChiOnl, nChi](
    each fixed=false)
    "Staging matrix with chiller stage as row index and chiller as column index"
    annotation (Dialog(tab="General", group="Staging configuration"));
  final parameter Integer nStaChiOnl=
    if not have_eco then nSta-1
    else sum({if sta[i, nUniSta]>0 then 0 else 1 for i in 1:nSta}) - 1
    "Number of chiller stages, neither zero stage nor the stages with enabled waterside economizer is included"
    annotation (Evaluate=true, Dialog(tab="General", group="Staging configuration"));
  final parameter Real desChiNum[nStaChiOnl+1]=
    {if i==0 then 0 else sum(staMat[i]) for i in 0:nStaChiOnl}
    "Design number of chiller that should be ON at each chiller stage, including the zero stage"
    annotation (Dialog(tab="General", group="Staging configuration"));
  final parameter Real staTmp[nSta, nUniSta]={
    {if sta[i, j]>0 then (if j<=nChi then sta[i, j] else 0.5) else 0 for j in 1:nUniSta} for i in 1:nSta}
    "Intermediary parameter to compute staVec"
    annotation (Evaluate=true, Dialog(tab="General", group="Staging configuration"));
  final parameter Real staVec[nSta]={sum(staTmp[i]) for i in 1:nSta}
    "Plant stage vector, element value like x.5 means chiller stage x plus WSE";

  parameter Real sta[:, nUniSta]={
    {0, 0, 0},
    {0, 0, 1},
    {1, 0, 0},
    {1, 0, 1},
    {1, 1, 0},
    {1, 1, 1}}
    "Staging matrix with plant stage as row index and chiller as column index (nChi+1 for WSE)"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  final parameter Integer nUniSta=
    if have_eco then nChi+1
    else nChi
    "Number of units to stage, including chillers and optional WSE"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  final parameter Integer nSta=size(sta, 1)
    "Number of plant stages"
    annotation (Evaluate=true, Dialog(group="Configuration"));
protected
  Integer idx;
initial algorithm
  idx := 1;
  if have_eco then
    for i in 2:nSta loop
      if sta[i, nUniSta]<1 then
        staMat[idx] := {if sta[i,j]>0 then 1 else 0 for j in 1:nChi};
        idx := idx + 1;
      end if;
    end for;
  else
    staMat := {{if sta[k+1,j]>0 then 1 else 0 for j in 1:nChi} for k in 1:nStaChiOnl};
  end if;
equation
/* 
The when clause makes the variable discrete, and when the algorithm is executed, 
it is initialized with its pre value.
*/
algorithm
  when sample(0, 3E7) then
    idx := 0;
  end when;
  annotation (Documentation(info="<html>
<p>
This model validates the algorithm used to compute the so-called
staging matrix within the plant controller
<a href=\"modelica://Buildings.Templates.ChilledWaterPlants.Components.Controls.G36\">
Buildings.Templates.ChilledWaterPlants.Components.Controls.G36</a>.
</p>
</html>"));
end StagingMatrixComputation;
