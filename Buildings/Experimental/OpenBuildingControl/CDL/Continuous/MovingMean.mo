within Buildings.Experimental.OpenBuildingControl.CDL.Continuous;
block MovingMean
  "Block to output moving average with centain time horizon"

  parameter Real Ts;

  Interfaces.RealInput u
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.RealOutput y
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  Real sum;
  Real sumDel;

initial equation
  sum = u;

equation
  u =der(sum);
  sumDel = delay(sum, Ts);
  if (time > Ts) then
    y = (sum-sumDel)/Ts;
  elseif time > 0 then
    y = (sum-sumDel)/time;
  else
    y = u;
  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end MovingMean;
