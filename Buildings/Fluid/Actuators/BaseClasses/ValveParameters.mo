within Buildings.Fluid.Actuators.BaseClasses;
partial model ValveParameters "Model with parameters for valves"

  parameter Buildings.Fluid.Types.CvTypes CvData=Buildings.Fluid.Types.CvTypes.OpPoint
    "Selection of flow coefficient"
   annotation(Dialog(group = "Flow Coefficient"));
  parameter Real Kv(
    fixed= if CvData==Buildings.Fluid.Types.CvTypes.Kv then true else false)
    "Kv (metric) flow coefficient [m3/h/(bar)^(1/2)]"
  annotation(Dialog(group = "Flow Coefficient",
                    enable = (CvData==Buildings.Fluid.Types.CvTypes.Kv)));
  parameter Real Cv(
    fixed= if CvData==Buildings.Fluid.Types.CvTypes.Cv then true else false)
    "Cv (US) flow coefficient [USG/min/(psi)^(1/2)]"
  annotation(Dialog(group = "Flow Coefficient",
                    enable = (CvData==Buildings.Fluid.Types.CvTypes.Cv)));
  parameter Modelica.SIunits.Area Av(
    fixed= if CvData==Buildings.Fluid.Types.CvTypes.Av then true else false)
    "Av (metric) flow coefficient"
   annotation(Dialog(group = "Flow Coefficient",
                     enable = (CvData==Buildings.Fluid.Types.CvTypes.Av)));

  parameter Real deltaM = 0.02
    "Fraction of nominal flow rate where linearization starts, if y=1"
    annotation(Dialog(group="Pressure-flow linearization"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpValve_nominal(
     displayUnit="Pa",
     min=0,
     fixed= if CvData==Buildings.Fluid.Types.CvTypes.OpPoint then true else false)
    "Nominal pressure drop of fully open valve, used if CvData=Buildings.Fluid.Types.CvTypes.OpPoint"
    annotation(Dialog(group="Nominal condition",
               enable = (CvData==Buildings.Fluid.Types.CvTypes.OpPoint)));

  parameter Modelica.SIunits.Density rhoStd
    "Inlet density for which valve coefficients are defined"
  annotation(Dialog(group="Nominal condition", tab="Advanced"));

protected
  parameter Real Kv_SI(
    min=0,
    fixed= false)
    "Flow coefficient for fully open valve in SI units, Kv=m_flow/sqrt(dp) [kg/s/(Pa)^(1/2)]"
  annotation(Dialog(group = "Flow Coefficient",
                    enable = (CvData==Buildings.Fluid.Types.CvTypes.OpPoint)));
initial equation
  if  CvData == Buildings.Fluid.Types.CvTypes.OpPoint then
    Kv_SI =           m_flow_nominal/sqrt(dpValve_nominal);
    Kv    =           Kv_SI/(rhoStd/3600/sqrt(1E5));
    Cv    =           Kv_SI/(rhoStd*0.0631/1000/sqrt(6895));
    Av    =           Kv_SI/sqrt(rhoStd);
  elseif CvData == Buildings.Fluid.Types.CvTypes.Kv then
    Kv_SI =           Kv*rhoStd/3600/sqrt(1E5)
      "Unit conversion m3/(h*sqrt(bar)) to kg/(s*sqrt(Pa))";
    Cv    =           Kv_SI/(rhoStd*0.0631/1000/sqrt(6895));
    Av    =           Kv_SI/sqrt(rhoStd);
    dpValve_nominal =  (m_flow_nominal/Kv_SI)^2;
  elseif CvData == Buildings.Fluid.Types.CvTypes.Cv then
    Kv_SI =           Cv*rhoStd*0.0631/1000/sqrt(6895)
      "Unit conversion USG/(min*sqrt(psi)) to kg/(s*sqrt(Pa))";
    Kv    =           Kv_SI/(rhoStd/3600/sqrt(1E5));
    Av    =           Kv_SI/sqrt(rhoStd);
    dpValve_nominal =  (m_flow_nominal/Kv_SI)^2;
  else
    assert(CvData == Buildings.Fluid.Types.CvTypes.Av, "Invalid value for CvData.
Obtained CvData = " + String(CvData) + ".");
    Kv_SI =           Av*sqrt(rhoStd);
    Kv    =           Kv_SI/(rhoStd/3600/sqrt(1E5));
    Cv    =           Kv_SI/(rhoStd*0.0631/1000/sqrt(6895));
    dpValve_nominal =  (m_flow_nominal/Kv_SI)^2;
  end if;

  annotation (Documentation(info="<html>
<p>
Model that computes the flow coefficients of valves. This base class allows the following modeling options,
which have been adapted from the valve implementation
in <a href=\"modelica://Modelica.Fluid\">
Modelica.Fluid</a>
to specify the valve flow coefficient in fully open conditions:
</p>
<ul>
<li><code>CvData = Buildings.Fluid.Types.CvTypes.Av</code>: the flow coefficient is given by the metric <code>Av</code> coefficient (m^2).</li>
<li><code>CvData = Buildings.Fluid.Types.CvTypes.Kv</code>: the flow coefficient is given by the metric <code>Kv</code> coefficient (m^3/h).</li>
<li><code>CvData = Buildings.Fluid.Types.CvTypes.Cv</code>: the flow coefficient is given by the US <code>Cv</code> coefficient (USG/min).</li>
<li><code>CvData = Buildings.Fluid.Types.CvTypes.OpPoint</code>: the flow is computed from the nominal operating point specified by <code>dp_nominal</code> and <code>m_flow_nominal</code>.</li>
</ul>
<p>
The treatment of parameters <code>Kv</code> and <code>Cv</code> is
explained in detail in the
<a href=\"modelica://Modelica.Fluid.UsersGuide.ComponentDefinition.ValveCharacteristics\">Users Guide</a>.
</p>
<p>
In contrast to the model in <a href=\"modelica://Modelica.Fluid\">
Modelica.Fluid</a>, this model uses the protected parameter <code>Kv_SI</code>,
which is the flow coefficient in SI units, i.e.,
it is the ratio between mass flow rate in <code>kg/s</code> and square root
of pressure drop in <code>Pa</code>.
The value of <code>Kv_SI</code> is computed based on the parameters
<code>Av</code>,
<code>Kv</code>,
<code>Cv</code>, or, if
<code>CvData = Buildings.Fluid.Types.CvTypes.OpPoint</code>, based on
<code>m_flow_nominal</code> and <code>dpValve_nominal</code>.
Conversely, if
<code>CvData &lt;&gt; Buildings.Fluid.Types.CvTypes.OpPoint</code>, then
<code>dpValve_nominal</code> is computed based on
<code>Av</code>,
<code>Kv</code>, or
<code>Cv</code>, and the nominal mass flow rate <code>m_flow_nominal</code>.
Therefore, if
<code>CvData &lt;&gt; Buildings.Fluid.Types.CvTypes.OpPoint</code>,
then specifying a value for <code>dpValve_nominal</code> is a syntax error.
</p>
</html>", revisions="<html>
<ul>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
August 12, 2014, by Michael Wetter:<br/>
Changed attribute <code>min</code> of <code>dpValve_nominal</code>
to <code>0</code>.
This is needed as for example in
<a href=\"modelica://Buildings.Fluid.Actuators.Valves.Examples.TwoWayValveTable\">
Buildings.Fluid.Actuators.Valves.Examples.TwoWayValveTable</a>,
<code>dpValve_nominal=0</code>.
</li>
<li>
August 8, 2014, by Michael Wetter:<br/>
Changed the <code>initial algorithm</code> to an <code>initial equation</code>
section. Otherwise, OpenModelica attempts to solve for the parameter
values using numerical iteration, and fails in doing so.
</li>
<li>
May 29, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
March 25, 2013, by Michael Wetter:<br/>
Removed stray backslash in write statement.
</li>
<li>
February 28, 2013, by Michael Wetter:<br/>
Reformulated assignment of parameters, and removed <code>Kv_SI</code> as
a public parameter because it is always computed based on other parameters.
This change avoids a translation error in Dymola 2014 beta1 in
the pedantic mode, and a translation warning otherwise.
</li>
<li>
February 18, 2009 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ValveParameters;
