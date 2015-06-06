within Buildings.OpenStudioToModelica.InternalHeatGains;
model ElectricPowerWithCOP
  "This model computes the electric power consumed by the HVAC system using the COP"

  Modelica.Blocks.Interfaces.RealInput P_cool
    "Cooling/heating power of the HVAC unit"
    annotation (Placement(transformation(extent={{-100,-20},{-60,20}}),
        iconTransformation(extent={{-100,-20},{-60,20}})));
  Modelica.Blocks.Interfaces.RealOutput P_el "Cooling/heating electric power"
    annotation (Placement(transformation(extent={{90,-10},{110,10}}),
        iconTransformation(extent={{80,-10},{100,10}})));
  parameter Modelica.SIunits.Power P_hvac_nominal
    "Nominal HVAC cooling/heating power";
  parameter Real COP_nominal "Coefficient of performance"
    annotation (Dialog(group="Efficiency"));
  parameter Real a[:] = {1}
    "Coefficients for efficiency curve (need p(a=a, y=1)=1)"
    annotation (Dialog(group="Efficiency"));
protected
  Real y "Ratio between cooling/heat power and nominal power";
  Real COP "Coeff. of performance";
  Real effPL "Efficiency due to part load";
equation

  y = Buildings.Utilities.Math.Functions.smoothMax(x1=P_cool, x2=-P_cool, deltaX=0.25)/abs(P_hvac_nominal);
  effPL  = Buildings.Utilities.Math.Functions.polynomial(a=a, x=y);
  COP = COP_nominal*effPL;
  P_el = Buildings.Utilities.Math.Functions.smoothMax(x1=P_cool, x2=-P_cool, deltaX=0.25)/ Buildings.Utilities.Math.Functions.smoothMax(x1=1e-2, x2=COP, deltaX=0.25);
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,170}), Text(
          extent={{-160,140},{160,100}},
          lineColor={0,0,255},
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid,
          textString="El. Power"),  Text(
          extent={{-52,42},{60,-38}},
          lineColor={0,0,255},
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid,
          textString="f(x)")}));
end ElectricPowerWithCOP;
