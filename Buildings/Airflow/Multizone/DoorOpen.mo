within Buildings.Airflow.Multizone;
model DoorOpen
  "Door model for bi-directional air flow between rooms"
  extends Buildings.Airflow.Multizone.BaseClasses.Door(
    final vAB = VAB_flow/AOpe,
    final vBA = VBA_flow/AOpe);

  parameter Real CD=0.65 "Discharge coefficient"
    annotation (Dialog(group="Orifice characteristics"));

  parameter Real m = 0.5 "Flow coefficient"
    annotation (Dialog(group="Orifice characteristics"));


protected
  constant Real gamma(min=1) = 1.5
    "Normalized flow rate where dphi(0)/dpi intersects phi(1)";
  constant Real a = gamma
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real b = 1/8*m^2 - 3*gamma - 3/2*m + 35.0/8
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real c = -1/4*m^2 + 3*gamma + 5/2*m - 21.0/4
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real d = 1/8*m^2 - gamma - m + 15.0/8
    "Polynomial coefficient for regularized implementation of flow resistance";

  parameter Real CVal=CD*AOpe*sqrt(2/rho_default)
    "Flow coefficient, C = V_flow/ dp^m";
  parameter Real kT = rho_default * CD * AOpe/3 *
    sqrt(Modelica.Constants.g_n /(Medium.T_default*conTP) * hOpe)
    "Constant coefficient for buoyancy driven air flow rate";

  parameter Modelica.Units.SI.MassFlowRate m_flow_turbulent=CVal*rho_default*
      sqrt(dp_turbulent)
    "Mass flow rate where regularization to laminar flow occurs for temperature-driven flow";

equation
  // Air flow rate due to static pressure difference
  VABp_flow = Buildings.Airflow.Multizone.BaseClasses.powerLawFixedM(C=CVal,
      dp=port_a1.p-port_a2.p,
      m=m,
      a=a,
      b=b,
      c=c,
      d=d,
      dp_turbulent=dp_turbulent);
  // Air flow rate due to buoyancy
  // Because powerLawFixedM requires as an input a pressure difference pa-pb,
  // we convert Ta-Tb by multiplying it with rho*R, and we divide
  // above the constant expression by (rho*R)^m on the right hand-side of kT.
  // Note that here, k is for mass flow rate, whereas in powerLawFixedM, it is for volume flow rate.
  // We can use m=0.5 as this is from Bernoulli.
  mABt_flow = Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
      k=kT,
      dp=conTP*(Medium.temperature(state_a1_inflow)-Medium.temperature(state_a2_inflow)),
      m_flow_turbulent=m_flow_turbulent);

  annotation (defaultComponentName="doo",
Documentation(info="<html>
<p>
Model for bi-directional air flow through a large opening such as a door.
</p>
<p>
In this model, the air flow is composed of two components,
a one-directional bulk air flow
due to static pressure difference in the adjoining two thermal zones, and
a two-directional airflow due to temperature-induced differences in density
of the air in the two thermal zones.
Although turbulent air flow is a nonlinear phenomenon,
the model is based on the simplifying assumption that these two
air flow rates can be superposed.
(Superposition is only exact for laminar flow.)
This assumption is made because
it leads to a simple model and because there is significant uncertainty
and assumptions anyway in such simplified a model for bidirectional flow through a door.
</p>
<h4>Main equations</h4>
<p>
The air flow rate due to static pressure difference is
</p>
<p align=\"center\" style=\"font-style:italic;\">
    V&#775;<sub>ab,p</sub> =  C<sub>D</sub> w h (2/&rho;<sub>0</sub>)<sup>0.5</sup>  &Delta;p<sup>m</sup>,
</p>
<p>
where
<i>V&#775;</i> is the volumetric air flow rate,
<i>C<sub>D</sub></i> is the discharge coefficient,
<i>w</i> and <i>h</i> are the width and height of the opening,
<i>&rho;<sub>0</sub></i> is the mass density at the medium default pressure, temperature and humidity,
<i>m</i> is the flow exponent and
<i>&Delta;p = p<sub>a</sub> - p<sub>b</sub></i> is the static pressure difference between
the thermal zones.
For this model explanation, we will assume <i>p<sub>a</sub> &gt; p<sub>b</sub></i>.
For turbulent flow, <i>m=1/2</i> and for laminar flow <i>m=1</i>.
</p>
<p>
The air flow rate due to temperature difference in the thermal zones is
<i>V&#775;<sub>ab,t</sub></i> for flow from thermal zone <i>a</i> to <i>b</i>,
and
<i>V&#775;<sub>ba,t</sub></i> for air flow rate from thermal zone <i>b</i> to <i>a</i>.
The model has two air flow paths to allow bi-directional air flow.
The mass flow rates at these two air flow paths are
</p>
<p align=\"center\" style=\"font-style:italic;\">
    m&#775;<sub>a1</sub> = &rho;<sub>0</sub> &nbsp; (+V&#775;<sub>ab,p</sub>/2 + &nbsp; V&#775;<sub>ab,t</sub>),
</p>
<p>
and, similarly,
</p>
<p align=\"center\" style=\"font-style:italic;\">
    V&#775;<sub>ba</sub> = &rho;<sub>0</sub> &nbsp; (-V&#775;<sub>ab,p</sub>/2 + &nbsp; V&#775;<sub>ba,t</sub>),
</p>
<p>
where we simplified the calculation by using the density <i>&rho;<sub>0</sub></i>.
To calculate <i>V&#775;<sub>ba,t</sub></i>, we again use the density <i>&rho;<sub>0</sub></i>
and because of this simplification, we can write
</p>
<p align=\"center\" style=\"font-style:italic;\">
    m&#775;<sub>ab,t</sub> =  -m&#775;<sub>ba,t</sub> = &rho;<sub>0</sub> &nbsp; V&#775;<sub>ab,t</sub>
  =  -&rho;<sub>0</sub> &nbsp; V&#775;<sub>ba,t</sub>,
</p>
<p>
from which follows that the neutral height, e.g., the height where the air flow rate due to flow
induced by temperature difference is zero, is at <i>h/2</i>.
Hence,
</p>
<p align=\"center\" style=\"font-style:italic;\">
V&#775;<sub>ab,t</sub> = C<sub>D</sub> &int;<sub>0</sub><sup>h/2</sup> w v(z) dz,
</p>
<p>
where <i>v(z)</i> is the velocity at height <i>z</i>. From the Bernoulli equation, we obtain
</p>
<p align=\"center\" style=\"font-style:italic;\">
v(z) = (2 g z &Delta;&rho; &frasl; &rho;<sub>0</sub>)<sup>1/2</sup>.
</p>
<p>
The density difference can be written as
</p>
<p align=\"center\" style=\"font-style:italic;\">
  &Delta;&rho; = &rho;<sub>a</sub>-&rho;<sub>b</sub>
  &asymp; &rho;<sub>0</sub> (T<sub>b</sub> - T<sub>a</sub>) &frasl; T<sub>0</sub>,
</p>
<p>
where we used
<i>&rho;<sub>a</sub> = p<sub>0</sub> /(R T<sub>a</sub>)</i> and
<i>T<sub>a</sub> T<sub>b</sub> &asymp; T<sub>0</sub><sup>2</sup></i>.
Substituting this expression into the integral and integrating from <i>0</i> to <i>z</i> yields
</p>
<p align=\"center\" style=\"font-style:italic;\">
V&#775;<sub>ab,t</sub> = 1&frasl;3  C<sub>D</sub> w h
(g h &frasl; (R T<sub>0</sub> &rho;<sub>0</sub>))<sup>1/2</sup> &Delta;p<sup>1/2</sup>.
</p>
<p>
The above equation is equivalent to (6) in Brown and Solvason (1962).
<h4>Main assumptions</h4>
<p>
The main assumptions are as follows:
</p>
<ul>
<li>
<p>
The air flow rates due to static pressure difference and due to temperature-difference can be superposed.
</p>
</li>
<li>
<p>
For buoyancy-driven air flow, a constant density can be used to convert air volume flow rate to air mass flow rate.
</p>
</li>
</ul>
<p>
From these assumptions follows that the neutral height for buoyancy-driven air flow is at half of the height
of the opening.
</p>
<h4>Notes</h4>
<p>
For a more detailed model, use
<a href=\"modelica://Buildings.Airflow.Multizone.DoorDiscretizedOpen\">
Buildings.Airflow.Multizone.DoorDiscretizedOpen</a>.
</p>
<h4>References</h4>
<ul>
<li>
Brown, W.G. and K. R. Solvason.
Natural Convection through rectangular openings in partitions - 1.
<i>Int. Journal of Heat and Mass Transfer</i>.
Vol. 5, p. 859-868. 1962.
<a href=\"https://doi.org/10.1016/0017-9310(62)90184-9\">doi:10.1016/0017-9310(62)90184-9</a>.<br/>
Also available at
<a href=\"https://nrc-publications.canada.ca/eng/view/ft/?id=081c0ace-7c31-449c-9b3b-e6c14864b196\">
https://nrc-publications.canada.ca/eng/view/ft/?id=081c0ace-7c31-449c-9b3b-e6c14864b196</a>.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
January 22, 2020, by Michael Wetter:<br/>
Revised buoyancy-driven flow based on Brown and Solvason (1962).
</li>
<li>
January 19, 2020, by Klaas De Jonge:<br/>
Revised influence of stack effect.
</li>
<li>
October 6, 2020, by Michael Wetter:<br/>
First implementation for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1353\">#1353</a>.
</li>
</ul>
</html>"));
end DoorOpen;
