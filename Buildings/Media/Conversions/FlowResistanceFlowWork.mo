within Buildings.Media.Conversions;
package FlowResistanceFlowWork
  "Package with functions that convert between flow resistance coefficients"

  replaceable package MediumOri = Modelica.Media.Interfaces.PartialMedium
    "Medium for which flow resistances are declared"
    annotation (choicesAllMatching=true);

  replaceable package MediumNew = Modelica.Media.Interfaces.PartialMedium
    "New medium for which flow resistances will be computed"
    annotation (choicesAllMatching=true);

  constant Modelica.Units.SI.Temperature TOri=MediumOri.T_default
    "Temperature of original medium at default state";

  constant Modelica.Units.SI.AbsolutePressure pOri=MediumOri.p_default
    "Pressure of original medium at default state";

  constant MediumOri.MassFraction XOri[MediumOri.nX]=MediumOri.X_default
    "Mass fractions of original medium at default state";

  constant MediumOri.ThermodynamicState staOri_default=
    MediumOri.setState_pTX(
      T=TOri,
      p=pOri,
      X=XOri)
    "Default thermodynamic state of original medium";

  constant Modelica.Units.SI.DynamicViscosity etaOri=
    MediumOri.dynamicViscosity(staOri_default)
    "Dynamic viscosity of original medium at default state";

  constant Modelica.Units.SI.Density rhoOri=
    MediumOri.density(staOri_default)
    "Mass density of original medium at default state";

  constant Modelica.Units.SI.Temperature TNew=MediumNew.T_default
    "Temperature of new medium at default state";

  constant Modelica.Units.SI.AbsolutePressure pNew=MediumNew.p_default
    "Pressure of new medium at default state";

  constant MediumNew.MassFraction XNew[MediumNew.nX]=MediumNew.X_default
    "Mass fractions of new medium at default state";

  constant MediumNew.ThermodynamicState staNew_default=
    MediumNew.setState_pTX(
      T=TNew,
      p=pNew,
      X=XNew)
    "Default thermodynamic state of new medium";

  constant Modelica.Units.SI.DynamicViscosity etaNew=
    MediumNew.dynamicViscosity(staNew_default)
    "Dynamic viscosity of new medium at default state";

  constant Modelica.Units.SI.Density rhoNew=
    MediumNew.density(staNew_default)
    "Mass density of new medium at default state";

  constant Modelica.Units.SI.SpecificHeatCapacity cpOri=
    MediumOri.specificHeatCapacityCp(staOri_default)
    "Specific heat capacity of original medium at default state";

  constant Modelica.Units.SI.SpecificHeatCapacity cpNew=
    MediumNew.specificHeatCapacityCp(staNew_default)
    "Specific heat capacity of new medium at default state";

  function pressureDrop_massFlowRate
    "Function that returns the pressure drop ratio due to a change in medium properties for a given mass flow rate ratio"
    extends Modelica.Icons.Function;
    input Real ratio_m_flow(min=0, unit="1")
      "Ratio of mass flow rates, m_flow_new/m_flow_ori";
    input Real n(min=1, max=2, unit="1")
      "Flow coefficient n, n=1 for laminar, n=2 for fully turbulent";
    output Real ratio_dp(min=0, unit="1")
      "Ratio of pressures, dp_new/dp_ori";
  algorithm
  ratio_dp := ratio_m_flow^n * (etaOri/etaNew)^(n-2) * (rhoOri/rhoNew);
    annotation (Documentation(info="<html>
<p>
Function that converts a mass flow rate ratio to a pressure drop ratio
due to a change in medium properties.
</p>
<p>
The flow coefficient is <i>n=1</i> for laminar and <i>n=1.688</i> for turbulent flow.
Note that typical textbook equations use <i>n=2</i>.
The value <i>n=1.688</i> is based on a friction coefficient for a Reynolds number of
<i>Re=2,300...10,000</i>, in which case the friction coefficient can be approximated as
<i>f<sub>1</sub> = 0.2767 Re<sup>-0.312</sup></i>
with a maximum error or <i>0.8%</i> (Melinder, 2010),
and hence the pressure drop is proportional to <i>v<sup>1.688</sup></i>,
where <i>v</i> is the flow velocity.
</p>
<p>
The function assumes that the flow geometry and
the flow regime (laminar or turbulent) do not change when the medium changes.
</p>
<h4>References</h4>
<p>
Melinder, Åke (2010a).
<i>Handbook on Indirect Refrigeration and Heat Pump Systems</i>. 
Kullavik, Sverige: Svenska Kyltekniska Föreningen.
<a href=\"https://varmtochkallt.se/wp-content/uploads/Projekt/Effsys2/P02/ke-Melinder-engelsk-handbok.pdf\">
https://varmtochkallt.se/wp-content/uploads/Projekt/Effsys2/P02/ke-Melinder-engelsk-handbok.pdf</a>
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
    input Real n(min=1, max=2, unit="1")
      "Flow coefficient n, n=1 for laminar, n=2 for fully turbulent";
    output Real ratio_dp(min=0, unit="1")
      "Ratio of pressures";
  protected
    Real ratio_m_flow(min=0, unit="1")
      "Ratio of mass flow rates";
  algorithm
    ratio_m_flow := ratio_V_flow * rhoNew / rhoOri;
    ratio_dp := pressureDrop_massFlowRate(
      ratio_m_flow=ratio_m_flow,
      n=n);
    annotation (Documentation(info="<html>
<p>
Function that converts a volume flow rate ratio to a pressure drop ratio
due to a change in medium properties.
</p>
<p>
The flow coefficient is <i>n=1</i> for laminar and <i>n=1.688</i> for turbulent flow.
Note that typical textbook equations use <i>n=2</i>.
The value <i>n=1.688</i> is based on a friction coefficient for a Reynolds number of
<i>Re=2,300...10,000</i>, in which case the friction coefficient can be approximated as
<i>f<sub>1</sub> = 0.2767 Re<sup>-0.312</sup></i>
with a maximum error or <i>0.8%</i> (Melinder, 2010),
and hence the pressure drop is proportional to <i>v<sup>1.688</sup></i>,
where <i>v</i> is the flow velocity.
</p>
<p>
The function assumes that the flow geometry and
the flow regime (laminar or turbulent) do not change when the medium changes.
</p>
<h4>References</h4>
<p>
Melinder, Åke (2010a).
<i>Handbook on Indirect Refrigeration and Heat Pump Systems</i>. 
Kullavik, Sverige: Svenska Kyltekniska Föreningen.
<a href=\"https://varmtochkallt.se/wp-content/uploads/Projekt/Effsys2/P02/ke-Melinder-engelsk-handbok.pdf\">
https://varmtochkallt.se/wp-content/uploads/Projekt/Effsys2/P02/ke-Melinder-engelsk-handbok.pdf</a>
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

  function flowWork_equalHeatFlowRate
    "Function that returns the flow work ratio for equal heat flow rate"
    extends Modelica.Icons.Function;
    input Real n(min=1, max=2, unit="1")
      "Flow coefficient n, n=1 for laminar, n=2 for fully turbulent";
    output Real ratio_WFlo(min=0, unit="1")
      "Ratio of flow work";

  algorithm
    ratio_WFlo := rhoOri / rhoNew * cpOri / cpNew * pressureDrop_equalHeatFlowRate(n=n);
  
    annotation (Documentation(info="<html>
<p>
Function that returns the ratio of flow work for equal heat flow rate.
</p>
<p>
If we want to operate the device such that the same amount of heat
is transferred with the same inlet temperature, resulting in the same outlet temperatures,
we can use for the same heat flow rate
</p>
<p align=\"center\" style=\"font-style:italic;\">
Q&#775; = m&#775; c<sub>p</sub> &Delta;T,
</p>
<p>
adjust the mass flow rate according to
</p>
<p align=\"center\" style=\"font-style:italic;\">
m&#775; &frasl; m&#775;<sub>0</sub> = c<sub>p,0</sub> &frasl; c<sub>p</sub>,
</p>
<p>
and use for the flow work the equation <i>W = V&#775; &Delta;p / rho</i>.
</p>
<p>
This function uses these equations to compute the ratio of the the flow work that
results from a change in medium properties for the same heat flow rate.
</p>
<p>
The flow coefficient is <i>n=1</i> for laminar and <i>n=1.688</i> for turbulent flow.
Note that typical textbook equations use <i>n=2</i>.
The value <i>n=1.688</i> is based on a friction coefficient for a Reynolds number of
<i>Re=2,300...10,000</i>, in which case the friction coefficient can be approximated as
<i>f<sub>1</sub> = 0.2767 Re<sup>-0.312</sup></i>
with a maximum error or <i>0.8%</i> (Melinder, 2010),
and hence the pressure drop is proportional to <i>v<sup>1.688</sup></i>,
where <i>v</i> is the flow velocity.
</p>
<p>
The function assumes that the flow geometry and
the flow regime (laminar or turbulent) do not change when the medium changes.
</p>
<h4>References</h4>
<p>
Melinder, Åke (2010a).
<i>Handbook on Indirect Refrigeration and Heat Pump Systems</i>. 
Kullavik, Sverige: Svenska Kyltekniska Föreningen.
<a href=\"https://varmtochkallt.se/wp-content/uploads/Projekt/Effsys2/P02/ke-Melinder-engelsk-handbok.pdf\">
https://varmtochkallt.se/wp-content/uploads/Projekt/Effsys2/P02/ke-Melinder-engelsk-handbok.pdf</a>
</p>
</html>", revisions="<html>
<ul>
<li>
May 11, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end flowWork_equalHeatFlowRate;

  function pressureDrop_equalHeatFlowRate
    "Function that returns the pressure drop ratio for equal heat flow rate"
    extends Modelica.Icons.Function;
    input Real n(min=1, max=2, unit="1")
      "Flow coefficient n, n=1 for laminar, n=2 for fully turbulent";
    output Real ratio_dp(min=0, unit="1")
      "Ratio of pressures";

  algorithm
    ratio_dp := pressureDrop_massFlowRate(
      ratio_m_flow=cpOri / cpNew,
      n=n);
  
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
results from a change in medium properties for the same heat flow rate.
</p>
<p>
The flow coefficient is <i>n=1</i> for laminar and <i>n=1.688</i> for turbulent flow.
Note that typical textbook equations use <i>n=2</i>.
The value <i>n=1.688</i> is based on a friction coefficient for a Reynolds number of
<i>Re=2,300...10,000</i>, in which case the friction coefficient can be approximated as
<i>f<sub>1</sub> = 0.2767 Re<sup>-0.312</sup></i>
with a maximum error or <i>0.8%</i> (Melinder, 2010),
and hence the pressure drop is proportional to <i>v<sup>1.688</sup></i>,
where <i>v</i> is the flow velocity.
</p>
<p>
The function assumes that the flow geometry and
the flow regime (laminar or turbulent) do not change when the medium changes.
</p>
<h4>References</h4>
<p>
Melinder, Åke (2010a).
<i>Handbook on Indirect Refrigeration and Heat Pump Systems</i>. 
Kullavik, Sverige: Svenska Kyltekniska Föreningen.
<a href=\"https://varmtochkallt.se/wp-content/uploads/Projekt/Effsys2/P02/ke-Melinder-engelsk-handbok.pdf\">
https://varmtochkallt.se/wp-content/uploads/Projekt/Effsys2/P02/ke-Melinder-engelsk-handbok.pdf</a>
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
end FlowResistanceFlowWork;