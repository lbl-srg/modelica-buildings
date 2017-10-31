within Buildings.Media.Refrigerants.Validation;
model R410A_dSpecificVolumeVap_pT
  "Validation of the derivatives of the specific volume with regards to p and T"
  extends Modelica.Icons.Example;

  parameter Modelica.SIunits.AbsolutePressure p = 400e3
    "Pressure of refrigerant vapor";

  parameter Modelica.SIunits.Temperature T = 273.15
    "Temperature of refrigerant";

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
     "Numerical derivative ofspecific volume with regards to pressure";

  Real dvdT_num(
    final unit="m3/(kg.K)")
     "Numerical derivative of specific volume with regards to temperature";

protected
  Real dv_p(
    final unit="m3/(kg)")
    "Delta of specific volume of refrigerant with regards to pressure";

  Real dv_T(
    final unit="m3/(kg)")
    "Delta of specific volume of refrigerant with regards to temperature";

  Real dv_p_num(
    final unit="m3/(kg)")
    "Numerical delta of specific volume of refrigerant with regards to
    pressure";

  Real dv_T_num(
    final unit="m3/(kg)")
    "Numerical delta of specific volume of refrigerant with regards to
    temperature";

  constant Modelica.SIunits.Time oneSec = 1.0
    "Unit time variable for unit conversion of time derivatives";

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

  dvdp_num = dv_p / dp;

  dvdT_num = dv_T / dT;
  annotation (    __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Media/Refrigerants/Validation/R410A_dSpecificVolumeVap_pT.mos"
        "Simulate and plot"),
    experiment(
      Tolerance=1e-6, StopTime=100),
    Documentation(info="<html>
<p>
Validation case for evaluation of derivatives of the Martin-Hou equation of
state with regards to pressure and temperature.
</p>
<p>
The analytical implementation of derivatives is compared to a numerical
evaluation of the derivatives.
</p>
</html>", revisions="<html>
<ul>
<li>
January 25, 2017, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end R410A_dSpecificVolumeVap_pT;
