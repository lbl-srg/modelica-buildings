model HASensibleCoilConstant "Constant convective heat transfer model" 
  extends PartialHA;
annotation (Diagram,
Documentation(info="<html>
<p>
Model for constant sensible convective heat transfer coefficients.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 16, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  
  parameter Real r(min=0, max=1)=0.5 
    "Ratio between air-side and water-side convective heat transfer coefficient";
  parameter Modelica.SIunits.ThermalConductance hA0_w(min=0)=UA0 * (r+1)/r 
    "Water side convective heat transfer coefficient" 
          annotation(Dialog(tab="General", group="Nominal condition"));
  parameter Modelica.SIunits.ThermalConductance hA0_a(min=0)=r * hA0_w 
    "Air side convective heat transfer coefficient, including fin resistance" 
          annotation(Dialog(tab="General", group="Nominal condition"));
equation 
  hA_1 = hA0_w;
  hA_2 = hA0_a;
end HASensibleCoilConstant;
