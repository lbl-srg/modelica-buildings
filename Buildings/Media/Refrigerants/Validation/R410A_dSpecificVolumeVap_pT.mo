within Buildings.Media.Refrigerants.Validation;
model R410A_dSpecificVolumeVap_pT
  "Validation of the derivatives of the specific volume with regards to p and T"
  extends Modelica.Icons.Example;

  parameter Modelica.Units.SI.AbsolutePressure p=400e3
    "Pressure of refrigerant vapor";

  parameter Modelica.Units.SI.Temperature T=273.15 "Temperature of refrigerant";

  parameter Real dp(final unit="Pa") = 1.0
    "Delta of pressure of refrigerant vapor";

  parameter Real dT(final unit="K") = 0.01
    "Delta of temperature of refrigerant";

  Real dvdp(
    final unit="m3/(kg.Pa)")
    "Derivative of specific volume with regards to pressure";

  Real dvdT(
    final unit="m3/(kg.K)")
    "Derivative of specific volume with regards to temperature";

  Real dvdp_num(
    final unit="m3/(kg.Pa)")
    "Numerical derivative of specific volume with regards to pressure";

  Real dvdT_num(
    final unit="m3/(kg.K)")
    "Numerical derivative of specific volume with regards to temperature";

protected
  constant Modelica.Units.SI.Time oneSec=1.0
    "Unit time variable for unit conversion of time derivatives";

  constant Real convP(final unit="Pa/s2") = 40
    "Conversion factor for time-varying pressure";

  constant Real convT(final unit="K/s3") = 4e-5
    "Conversion factor for time-varying temperature";

  Real dv_p(
    final unit="m3/kg")
    "Delta of specific volume of refrigerant with regards to pressure";

  Real dv_T(
    final unit="m3/kg")
    "Delta of specific volume of refrigerant with regards to temperature";

  Real dv_p_num(
    final unit="m3/kg")
    "Numerical delta of specific volume of refrigerant with regards to pressure";

  Real dv_T_num(
    final unit="m3/kg")
    "Numerical delta of specific volume of refrigerant with regards to temperature";

  Modelica.Units.SI.AbsolutePressure p_t
    "Time-varying pressure of refrigerant vapor";

  Modelica.Units.SI.Temperature T_t
    "Time-varying temperature of refrigerant";

  Modelica.Units.SI.SpecificVolume v
    "Specific volume evaluated from function";

  Modelica.Units.SI.SpecificVolume v_int
    "Specific volume integrated from derivative function";

initial equation
  v_int = v;

equation
  // Analytical derivatives
  dv_p = Buildings.Media.Refrigerants.R410A.dSpecificVolumeVap_pT(
    p, T, dp/oneSec, 0.0)*oneSec;

  dv_T = Buildings.Media.Refrigerants.R410A.dSpecificVolumeVap_pT(
    p, T, 0.0, dT/oneSec)*oneSec;

  dvdp = dv_p / dp;

  dvdT = dv_T / dT;

  // Numerical derivatives
  dv_p_num = Buildings.Media.Refrigerants.R410A.specificVolumeVap_pT(p+0.5*dp, T)
    - Buildings.Media.Refrigerants.R410A.specificVolumeVap_pT(p-0.5*dp, T);

  dv_T_num = Buildings.Media.Refrigerants.R410A.specificVolumeVap_pT(p, T+0.5*dT)
    - Buildings.Media.Refrigerants.R410A.specificVolumeVap_pT(p, T-0.5*dT);

  dvdp_num = dv_p_num / dp;

  dvdT_num = dv_T_num / dT;

  assert(abs(dvdp - dvdp_num) < 1e-6*abs(dvdp),
    "Analytical and numerical pressure derivatives of specific volume differ.");
  assert(abs(dvdT - dvdT_num) < 1e-6*abs(dvdT),
    "Analytical and numerical temperature derivatives of specific volume differ.");

  // Time-derivative integration check via derivative annotation
  p_t = p + convP*time^2;
  T_t = T + convT*time^3;
  v = Buildings.Media.Refrigerants.R410A.specificVolumeVap_pT(p_t, T_t);
  der(v_int) = der(v);
  assert(abs(v - v_int) < 1e-2*v,
    "Integrated time derivative of specific volume differs from function evaluation.");

  annotation (
    experiment(
      StopTime=100,
      Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Media/Refrigerants/Validation/R410A_dSpecificVolumeVap_pT.mos"
      "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation case for the evaluation of derivatives of the Martin-Hou equation of
state with regards to pressure and temperature.
</p>
<p>
The analytical implementation of derivatives in
<a href=\"modelica://Buildings.Media.Refrigerants.R410A.dSpecificVolumeVap_pT\">
Buildings.Media.Refrigerants.R410A.dSpecificVolumeVap_pT</a>
is compared against finite-difference approximations and validated by
integrating the time derivative of
<a href=\"modelica://Buildings.Media.Refrigerants.R410A.specificVolumeVap_pT\">
Buildings.Media.Refrigerants.R410A.specificVolumeVap_pT</a>.
If the derivative implementation is wrong, the simulation stops with an assertion error.
</p>
</html>",
      revisions="<html>
<ul>
<li>
November 23, 2026, by Michael Wetter:<br/>
Corrected assignment of numerical derivatives and added assertions.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/2211\">IBPSA, #2211</a>.
</li>
<li>
January 25, 2017, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end R410A_dSpecificVolumeVap_pT;
