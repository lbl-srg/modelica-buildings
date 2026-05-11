within Buildings.Media.Conversions;
package FlowResistance
  "Package with functions that convert between flow resistance coefficients"

  replaceable package MediumOri = Modelica.Media.Interfaces.PartialMedium
    "Medium for which flow resistances are declared"
    annotation (choicesAllMatching=true);

  replaceable package MediumNew = Modelica.Media.Interfaces.PartialMedium
    "New medium for which flow resistances will be computed"
    annotation (choicesAllMatching=true);

  final parameter MediumOri.ThermodynamicState staOri_default=
    MediumOri.setState_pTX(
      T=MediumOri.T_default,
      p=MediumOri.p_default,
      X=MediumOri.X_default)
    "Default thermodynamic state of original medium";

  final parameter Modelica.Units.SI.DynamicViscosity etaOri=
    MediumOri.dynamicViscosity(staOri_default)
    "Dynamic viscosity of original medium at default state";

  final parameter Modelica.Units.SI.Density rhoOri=
    MediumOri.density(staOri_default)
    "Mass density of original medium at default state";

  final parameter MediumNew.ThermodynamicState staNew_default=
    MediumNew.setState_pTX(
      T=MediumNew.T_default,
      p=MediumNew.p_default,
      X=MediumNew.X_default)
    "Default thermodynamic state of new medium";

  final parameter Modelica.Units.SI.DynamicViscosity etaNew=
    MediumNew.dynamicViscosity(staNew_default)
    "Dynamic viscosity of new medium at default state";

  final parameter Modelica.Units.SI.Density rhoNew=
    MediumNew.density(staNew_default)
    "Mass density of new medium at default state";

  function pressureDrop_massFlowRate
    "Function that returns the pressure drop ratio due to a change in medium properties for a given mass flow rate ratio"
    extends Modelica.Icons.Function;
    input Real ratio_m_flow(min=0, unit="1")
      "Ratio of mass flow rates, m_flow_new/m_flow_ori";
    input Real q(min=-1, max=0, unit="1")
      "Flow coefficient q, q=-1 for laminar, q=-0.312 for turbulent";
    output Real ratio_dp(min=0, unit="1")
      "Ratio of pressures, dp_new/dp_ori";
  algorithm
  ration_dp := ratio_m_flow^(2+q) * (etaOri/etaNew)^q * (rhoOri/rhoNew);
    annotation (Documentation(info="<html>
<p>
Function that converts a mass flow rate ratio to a pressure drop ratio
due to a change in medium properties. The flow coefficient <i>q=-1</i> for laminar
and <i>q=-0.312</i> for turbulent flow. The function assumes that the flow geometry and
the flow regime (laminar or turbulent) do not change when the medium changes.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 11, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end pressureDrop_massFlowRate;

  function pressureDrop_volumeFlowRate
    "Function that returns the pressure drop ratio due to a change in medium properties for a given volume flow rate ratio"
    extends Modelica.Icons.Function;
    input Real ratio_V_flow(min=0, unit="1")
      "Ratio of volume flow rates";
    input Real q(min=-1, max=0, unit="1")
      "Flow coefficient q, q=-1 for laminar, q=-0.312 for turbulent";
    output Real ratio_dp(min=0, unit="1")
      "Ratio of pressures";
  protected
    Real ratio_m_flow(min=0, unit="1")
      "Ratio of mass flow rates";
  algorithm
    ratio_m_flow := ratio_V_flow * rhoNew / rhoOri;
    ratio_dp := pressureDrop_massFlowRate(
      ratio_m_flow=ratio_m_flow,
      q=q);
    annotation (Documentation(info="<html>
<p>
Function that converts a volume flow rate ratio to a pressure drop ratio
due to a change in medium properties. The flow coefficient <i>q=-1</i> for laminar
and <i>q=-0.312</i> for turbulent flow. The function assumes that the flow geometry and
the flow regime (laminar or turbulent) do not change when the medium changes.
</p>
</html>", revisions="<html>
<ul>
<li>
May 11, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end pressureDrop_volumeFlowRate;

  function pressureDrop_equalHeatFlowRate
    "Function that returns the pressure drop ratio for equal heat flow rate"
    extends Modelica.Icons.Function;
    input Real q(min=-1, max=0, unit="1")
      "Flow coefficient q, q=-1 for laminar, q=-0.312 for turbulent";
    output Real ratio_dp(min=0, unit="1")
      "Ratio of pressures";
  algorithm
    annotation (Documentation(info="<html>
<p>
Function that returns the pressure drop ratio for equal heat flow rate.
</p>
<p>
If we want to operate the device such that the same amount of heat
is transferred with the same inlet temperature, resulting in the same outlet temperatures,
we can use
</p>
<p align=\"center\" style=\"font-style:italic;\">
Q&#775; = m&#775; c<sub>p</sub> &Delta;T,
</p>
<p>
and use
</p>
<p align=\"center\" style=\"font-style:italic;\">
m&#775; &frasl; m&#775;<sub>0</sub> = c<sub>p,0</sub> &frasl; c<sub>p</sub>.
</p>
<p>
This function uses these equations to compute the ratio of the pressure drop that
results in a change in medium properties for the same heat flow rate.
The flow coefficient <i>q=-1</i> for laminar and <i>q=-0.312</i> for turbulent flow.
The function assumes that the flow geometry and
the flow regime (laminar or turbulent) do not change when the medium changes.
</p>
</html>", revisions="<html>
<ul>
<li>
May 11, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end pressureDrop_equalHeatFlowRate;

  annotation (
    defaultComponentName="floRes",
    Documentation(info="<html>
<p>
Package with functions that convert between different representations of flow resistances.
</p>
</html>", revisions="<html>
<ul>
<li>
May 11, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end FlowResistance;