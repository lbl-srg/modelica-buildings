within Buildings.Examples.DistrictReservoirNetworks.Examples.BaseClasses;
block ConstraintViolation
  "Block that outputs the fraction of time when a constraint is violated"
  extends Modelica.Blocks.Interfaces.PartialRealMISO(
    final significantDigits = 3);
  parameter Real uMin "Minimum value for input";
  parameter Real uMax "Maximum value for input";

  Modelica.SIunits.Time t(final start=0, final fixed=true) "Integral of violated time";

protected
  parameter Modelica.SIunits.Time t0(fixed=false)
    "First sample time instant";

  Boolean vioMin "Flag, true if minimum is violated";
  Boolean vioMax "Flag, true if maximum is violated";
  Boolean tesMax[nu] = {u[i] > uMax for i in 1:nu}  "Test for maximum violation";
initial equation
  t0 = time-1E-15;
equation

  vioMin = Modelica.Math.BooleanVectors.anyTrue({u[i] < uMin for i in 1:nu});
  vioMax = Modelica.Math.BooleanVectors.anyTrue({u[i] > uMax for i in 1:nu});
  if vioMin or vioMax then
    der(t) = 1;
  else
    der(t) = 0;
  end if;
  y = t/(time-t0);
  annotation (Icon(graphics={Ellipse(
          extent={{-8,74},{12,-30}},
          lineColor={238,46,47},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid), Ellipse(
          extent={{-8,-48},{16,-74}},
          lineColor={238,46,47},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid)}));
end ConstraintViolation;
