within IceTank.BaseClasses;
model qStar "Charging and discharging rate"

  parameter Integer n "Number of coefficients for qstar curve";
  parameter Real coeff[n] "Coefficients for qstar curve";
  parameter Real dt "Time step of curve fitting data";

  Modelica.Blocks.Interfaces.RealInput fraCha(unit="1")
    "Fraction of charge in ice tank"
    annotation (Placement(transformation(
          extent={{-140,20},{-100,60}}), iconTransformation(extent={{-140,20},{-100,
            60}})));

  Modelica.Blocks.Interfaces.RealInput lmtdSta(unit="1") "Normalized LMTD"
   annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
     iconTransformation(extent={{-140,-60},{ -100,-20}})));

  Modelica.Blocks.Interfaces.RealOutput qNor(final quantity="1")
    "Normalized heat transfer rate" annotation (Placement(transformation(extent=
           {{100,-10},{120,10}}), iconTransformation(extent={{100,-10},{120,10}})));

initial equation
  assert(mod(n,2)==0, "Parameter n must be an even number.");

equation
  qNor*dt = Buildings.Utilities.Math.Functions.polynomial(1 - fraCha, coeff[1:
    integer(n/2)]) + Buildings.Utilities.Math.Functions.polynomial(1 - fraCha,
    coeff[integer(n/2) + 1:end])*lmtdSta;

  annotation (defaultComponentName = "qSta",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid), Text(
        extent={{-148,150},{152,110}},
        textString="%name",
        lineColor={0,0,255})}),
        Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end qStar;
