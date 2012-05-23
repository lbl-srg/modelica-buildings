within Buildings.Fluid.Actuators.BaseClasses;
partial model ValveParameters "Model with parameters for valves"

  parameter Buildings.Fluid.Types.CvTypes CvData=Buildings.Fluid.Types.CvTypes.OpPoint
    "Selection of flow coefficient"
   annotation(Evaluate=true, Dialog(group = "Flow Coefficient"));
  parameter Real Kv(
    fixed= if CvData==Buildings.Fluid.Types.CvTypes.Kv then true else false) = 0
    "Kv (metric) flow coefficient [m3/h/(bar)^(1/2)]"
  annotation(Dialog(group = "Flow Coefficient",
                    enable = (CvData==Buildings.Fluid.Types.CvTypes.Kv)));
  parameter Real Cv(
    fixed= if CvData==Buildings.Fluid.Types.CvTypes.Cv then true else false) = 0
    "Cv (US) flow coefficient [USG/min/(psi)^(1/2)]"
  annotation(Dialog(group = "Flow Coefficient",
                    enable = (CvData==Buildings.Fluid.Types.CvTypes.Cv)));
  parameter Modelica.SIunits.Area Av(
    fixed= if CvData==Buildings.Fluid.Types.CvTypes.Av then true else false) = 0
    "Av (metric) flow coefficient"
   annotation(Evaluate=true, Dialog(group = "Flow Coefficient",
                     enable = (CvData==Buildings.Fluid.Types.CvTypes.Av)));
  parameter Real deltaM = 0.02
    "Fraction of nominal flow rate where linearization starts, if y=1"
    annotation(Dialog(group="Pressure-flow linearization"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Pressure dpValve_nominal(displayUnit="Pa",
                                                      min=Modelica.Constants.small)
    "Nominal pressure drop of fully open valve"
    annotation(Dialog(group="Nominal condition"));

  parameter Real Kv_SI(
    min=0,
    fixed= if CvData==Buildings.Fluid.Types.CvTypes.OpPoint then true else false,
    start=m_flow_nominal/sqrt(dpValve_nominal)) = m_flow_nominal/sqrt(dpValve_nominal)
    "Flow coefficient for fully open valve in SI units, Kv=m_flow/sqrt(dp) [kg/s/(Pa)^(1/2)]"
  annotation(Dialog(group = "Flow Coefficient",
                    enable = (CvData==Buildings.Fluid.Types.CvTypes.OpPoint)));

  parameter Modelica.SIunits.Density rhoStd
    "Inlet density for which valve coefficients are defined"
  annotation(Dialog(group="Nominal condition", tab="Advanced"));

initial equation
    Kv_SI = Av * sqrt(rhoStd);
    Kv_SI = Kv*rhoStd/3600/sqrt(1E5)
    "Unit conversion m3/(h*sqrt(bar)) to kg/(s*sqrt(Pa))";
    Kv_SI = Cv*rhoStd*0.0631/1000/sqrt(6895)
    "Unit conversion USG/(min*sqrt(psi)) to kg/(s*sqrt(Pa))";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
Documentation(info="<html>
<p>
Model that computes the flow coefficients of valves. This base class allows the following modeling options,
which have been adapted from the valve implementation 
in <a href=\"modelica://Modelica.Fluid\">
Modelica.Fluid</a>
to specify the valve flow coefficient in fully open conditions:
<ul><li><code>CvData = Buildings.Fluid.Types.CvTypes.Av</code>: the flow coefficient is given by the metric <code>Av</code> coefficient (m^2).
<li><code>CvData = Buildings.Fluid.Types.CvTypes.Kv</code>: the flow coefficient is given by the metric <code>Kv</code> coefficient (m^3/h).
<li><code>CvData = Buildings.Fluid.Types.CvTypes.Cv</code>: the flow coefficient is given by the US <code>Cv</code> coefficient (USG/min).
<li><code>CvData = Buildings.Fluid.Types.CvTypes.OpPoint</code>: the flow is computed from the nominal operating point specified by <code>dp_nominal</code> and <code>m_flow_nominal</code>.
</ul>
</p>
<p>
The treatment of parameters <code>Kv</code> and <code>Cv</code> is
explained in detail in the 
<a href=\"modelica://Modelica.Fluid.UsersGuide.ComponentDefinition.ValveCharacteristics\">Users Guide</a>.
</p>
<p>
In contrast to the model in <a href=\"modelica://Modelica.Fluid\">
Modelica.Fluid</a>, this model uses the parameter <code>Kv_SI</code>,
which is the flow coefficient in SI units, i.e., 
it is the ratio between mass flow rate in <code>kg/s</code> and square root 
of pressure drop in <code>Pa</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 18, 2009 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
revisions="<html>
<ul>
<li>
June 3, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>");
end ValveParameters;
