within Buildings.Fluid.Storage.Ice_ntu_bis.BaseClasses;
model UA_active
  Modelica.Blocks.Interfaces.RealInput x "State of charge"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}})));
  Modelica.Blocks.Interfaces.RealOutput UAhx
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.BooleanInput active
    annotation (Placement(transformation(extent={{-140,30},{-100,70}})));
parameter Real coeff[4] "Coefficients for qstar curve";
equation
  if active then
    UAhx = Buildings.Utilities.Math.Functions.polynomial(x, coeff[1:4]);
  else
    UAhx = 0;
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid), Text(
        extent={{-140,160},{160,120}},
        textString="%name",
        textColor={0,0,255})}),           Diagram(coordinateSystem(
          preserveAspectRatio=false)));

end UA_active;
