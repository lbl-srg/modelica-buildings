within Buildings.Fluid.HeatExchangers.Borefield.BaseClasses;
function deltaTWall
  "calculate the temperature difference from the inital temperature of the bore hole wall, due to the Load array."
  extends Aggregation.Interface.partialAggFunction;

  input Real[q_max,p_max] QMat;
  input Real[q_max,p_max] kappaMat;
  input Real R_ss;

  output Modelica.SIunits.TemperatureDifference deltaTWall;

protected
  Modelica.SIunits.HeatFlowRate q_sum;
algorithm
  q_sum := 0;
  for q in 1:q_max loop
    for p in 1:p_max loop
      q_sum := q_sum + QMat[q, p]*kappaMat[q, p];
    end for;
  end for;
  deltaTWall := R_ss*q_sum;
end deltaTWall;
