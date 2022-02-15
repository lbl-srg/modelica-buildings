within Buildings.Airflow.Multizone;
model Coefficient_V_flow "Power law with coefficient for volume flow rate"
  extends Buildings.Airflow.Multizone.BaseClasses.PartialOneWayFlowElement(
    m_flow = V_flow*rho,
    V_flow = Buildings.Airflow.Multizone.BaseClasses.powerLawFixedM(
      C=C,
      dp=dp,
      m=m,
      a=a,
      b=b,
      c=c,
      d=d,
      dp_turbulent=dp_turbulent),
    final m_flow_nominal=rho_default*C*dp_turbulent,
    final m_flow_small=1E-4*abs(m_flow_nominal));
   extends Buildings.Airflow.Multizone.BaseClasses.PowerLawResistanceParameters(
     m = 0.5);

  parameter Real C "Flow coefficient, C = V_flow/ dp^m";

     annotation (
    Icon(graphics={
        Rectangle(
          extent={{-54,34},{48,-34}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-62,14},{76,-12}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,6},{-64,-6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{48,8},{100,-6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-70,4},{-52,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-88,6},{-52,-6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid)}),
    defaultComponentName="pow",
    Documentation(info="<html>
<p>
This model describes the one-directional pressure driven air flow through an opening, using the equation
</p>
<p align=\"center\" style=\"font-style:italic;\">
V&#775; = C &Delta;p<sup>m</sup>,
</p>
<p>
where <i>V&#775;</i> is the volume flow rate in m<sup>3</sup>/s,
<i>C</i> is a flow coefficient,
<i>&Delta;p</i> is the pressure difference in Pa,
and <i>m</i> is the flow exponent.
</p>
<p>
A similar model is also used in the CONTAM software (Dols and Walton, 2015).
Dols and Walton (2002) recommend to use for the flow exponent m=0.6 to m=0.7 if the flow exponent is not reported with the test results.
</p>
<h4>References</h4>
<ul>
<li><b>ASHRAE, 1997.</b> <i>ASHRAE Fundamentals</i>, American Society of Heating, Refrigeration and Air-Conditioning Engineers, 1997. </li>
<li><b>Dols and Walton, 2002.</b> W. Stuart Dols and George N. Walton, <i>CONTAMW 2.0 User Manual, Multizone Airflow and Contaminant Transport Analysis Software</i>, Building and Fire Research Laboratory, National Institute of Standards and Technology, Tech. Report NISTIR 6921, November, 2002. </li>
<li><b>W. S. Dols and B. J. Polidoro</b>,<b>2015</b>. <i>CONTAM User Guide and Program Documentation Version 3.2</i>, National Institute of Standards and Technology, NIST TN 1887, Sep. 2015. doi: <a href=\"https://doi.org/10.6028/NIST.TN.1887\">10.6028/NIST.TN.1887</a>. </li>
</ul>
</html>", revisions="<html>
<ul>
<li>
February 2, 2022, by Michael Wetter:<br/>
Revised implementation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1436\">IBPSA, #1436</a>.
</li>
<li>
Apr 6, 2021, by Klaas De Jonge:<br/>
First Implementation. Model expecting direct input of volume flow powerlaw coefficients.
</li>
</ul>
</html>"));
end Coefficient_V_flow;
