within Buildings.Fluid.Actuators.Valves;
model TwoWayButterfly
  "Two way valve with the flow characteristic of a typical butterfly valve"
  extends Buildings.Fluid.Actuators.Valves.TwoWayPolynomial(
    final CvData = Buildings.Fluid.Types.CvTypes.Kv,
    final Kv = Kvs,
    final c={0,1.101898284705380E-01, 2.217227395456580,  -7.483401207660790, 1.277617623360130E+01, -6.618045307070130});


  parameter Real Kvs "Kv value at fully open valve"
    annotation(choices(
     choice =  1.31 "DN 6",
     choice =  2.34 "DN 8",
     choice =  3.65 "DN 10",
     choice =  8.22 "DN 15",
     choice =  14.6 "DN 20",
     choice =  22.8 "DN 25",
     choice =  37.4 "DN 32",
     choice =  58.5 "DN 40",
     choice =  91.3 "DN 50",
     choice =   154 "DN 65",
     choice =   234 "DN 80",
     choice =   296 "DN 90",
     choice =   365 "DN 100",
     choice =   483 "DN 115",
     choice =   570 "DN 125",
     choice =   822 "DN 150",
     choice =  1492 "DN 200",
     choice =  2422 "DN 250",
     choice =  3611 "DN 300",
     choice =  5060 "DN 350",
     choice =  6790 "DN 400",
     choice =  8823 "DN 450",
     choice = 11159 "DN 500",
     choice = 16759 "DN 600",
     choice = 20068 "DN 650",
     choice = 23744 "DN 700",
     choice = 27767 "DN 750",
     choice = 32178 "DN 800",
     choice = 42212 "DN 900",
     choice = 53911 "DN 1000",
     choice = 60420 "DN 1050",
     choice = 82845 "DN 1200"));

annotation (
defaultComponentName="valBut",
Documentation(info="<html>
<p>
Two way valve with the flow characteristic of a typical butterfly valve as listed below.
</p>
<p>
<img src=\"modelica://Buildings/Resources/Images/Fluid/Actuators/Valves/Examples/TwoWayButterfly.png\" alt=\"Butterfly valve characteristic\"/>
</p>
<h4>Implementation</h4>
<p>
The model assigns a <code>Kv</code> based on the table at
<a href=\"http://www.mydatabook.org/fluid-mechanics/flow-coefficient-opening-and-closure-curves-of-butterfly-valves/\">mydatabook.org</a>.
The <code>Kv</code> values listed in the parameter <code>Kvs</code> are reasonable assumptions,
but the actual value can depend much on the design of the specific valve.
Moreover, the <code>Kv</code> values for DN value smaller than DN 150 are a quadratic extrapolation
from the value at DN 150.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 10, 2021, by Michael Wetter:<br/>
Changed implementation of the filter and changed the parameter <code>order</code> to a constant
as most users need not change this value.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1498\">#1498</a>.
</li>
<li>
December 22, 2020 by Michael Wetter:<br/>
Add parameter <code>Kvs</code>.
</li>
<li>
December 20, 2020 by Filip Jorissen:<br/>
Revised implementation with default <code>Kv</code> computation.
</li>
<li>
July 8, 2018 by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={Ellipse(
          extent={{-16,18},{16,-14}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}));
end TwoWayButterfly;
