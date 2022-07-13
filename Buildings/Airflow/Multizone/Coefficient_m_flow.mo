within Buildings.Airflow.Multizone;
model Coefficient_m_flow "Powerlaw with coefficient for mass flow rate"
  extends Buildings.Airflow.Multizone.BaseClasses.PartialOneWayFlowElement(
    m_flow=rho*Buildings.Airflow.Multizone.BaseClasses.powerLawFixedM(
        C=C,
        dp=dp,
        m=m,
        a=a,
        b=b,
        c=c,
        d=d,
        dp_turbulent=dp_turbulent),
    final m_flow_nominal=k*dp_turbulent,
    final m_flow_small=1E-4*abs(m_flow_nominal));
  extends Buildings.Airflow.Multizone.BaseClasses.PowerLawResistanceParameters(
    m = 0.5);
  parameter Real k "Flow coefficient, k = m_flow/ dp^m";
protected
  parameter Real C=k/rho_default "Flow coefficient, C = V_flow/dp^m";

     annotation (
    Icon(graphics={
        Rectangle(
          extent={{-52,34},{50,-34}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,14},{78,-12}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-98,6},{-62,-6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{50,8},{102,-6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-68,4},{-50,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-86,6},{-50,-6}},
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
m&#775; = k &Delta;p<sup>m</sup>,
</p>
<p>
where <i>m&#775;</i> is the mass flow rate in kg/s,
<i>k</i> is a flow coefficient,
<i>&Delta;p</i> is the pressure difference in Pa,
and <i>m</i> is the flow exponent.
</p>
<p><br>A similar model is also used in the CONTAM software (Dols and Walton, 2015).
Dols and Walton (2002) recommend to use for the flow exponent <i>m=0.6</i> to <i>m=0.7</i> if the flow exponent is not reported with the test results.
</p>
<h4>References</h4>
<ul>
<li><b>ASHRAE, 1997.</b> <i>ASHRAE Fundamentals</i>, American Society of Heating, Refrigeration and Air-Conditioning Engineers, 1997. </li>
<li><b>Dols and Walton, 2002.</b> W. Stuart Dols and George N. Walton, <i>CONTAMW 2.0 User Manual, Multizone Airflow and Contaminant Transport Analysis Software</i>, Building and Fire Research Laboratory, National Institute of Standards and Technology, Tech. Report NISTIR 6921, November, 2002. [1]</li>
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
First Implementation. Model expecting direct input of mass flow powerlaw coefficients.
</li>
</ul>
</html>"));
end Coefficient_m_flow;
