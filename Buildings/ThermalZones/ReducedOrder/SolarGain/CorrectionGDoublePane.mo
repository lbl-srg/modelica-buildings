within Buildings.ThermalZones.ReducedOrder.SolarGain;
model CorrectionGDoublePane
  "Double pane window solar correction"
  extends BaseClasses.PartialCorrectionG;
  import con = Modelica.Units.Conversions;

  // Parameters for the transmission correction factor based on VDI 6007 Part 3
  // A0 to A6 are experimental constants VDI 6007 Part 3 page 20
protected
  parameter Real A0=0.918 "Constant 0 to calculate reference transmission";
  parameter Real A1=2.21*10^(-4)
    "Constant 1 to calculate reference transmission";
  parameter Real A2=-2.75*10^(-5)
    "Constant 2 to calculate reference transmission";
  parameter Real A3=-3.82*10^(-7)
    "Constant 3 to calculate reference transmission";
  parameter Real A4=5.83*10^(-8)
    "Constant 4 to calculate reference transmission";
  parameter Real A5=-1.15*10^(-9)
    "Constant 5 to calculate reference transmission";
  parameter Real A6=4.74*10^(-12)
    "Constant 6 to calculate reference transmission";
  parameter Modelica.Units.SI.TransmissionCoefficient g_dir0=0.7537 "Reference vertical parallel transmission coefficient for direct radiation
    for double pane window";
  parameter Modelica.Units.SI.TransmissionCoefficient Ta_diff=0.84 "Energetic degree of transmission for diffuse radiation for uniformly
    overcast sky";
  parameter Modelica.Units.SI.TransmissionCoefficient Tai_diff=0.903
    "Pure degree of transmission for diffuse radiation";
  parameter Modelica.Units.SI.TransmissionCoefficient Ta1_diff=Ta_diff*Tai_diff
    "Degreee of transmission for single pane window";
  parameter Modelica.Units.SI.ReflectionCoefficient rho_T1_diff=1 - (Ta_diff)
    "Part of degree of transmission for single pane window related to Ta1_diff";
  parameter Modelica.Units.SI.ReflectionCoefficient rho_11_diff=rho_T1_diff/(2
       - (rho_T1_diff)) "Part of degree of transmission for single pane window
    related to rho_T1_diff";
  parameter Modelica.Units.SI.ReflectionCoefficient rho_1_diff=rho_11_diff + ((
      (1 - rho_11_diff)*Tai_diff)^2*rho_11_diff)/(1 - (rho_11_diff*Tai_diff)^2)
    "Degree of reflection for single pane window";
  parameter Modelica.Units.SI.ReflectionCoefficient XN2_diff=1 - rho_1_diff^2
    "Calculation factor to simplify equations";
  parameter Modelica.Units.SI.TransmissionCoefficient Ta2_diff=(Ta1_diff^2)/
      XN2_diff "Energetic dregree of transmission for second pane";
  parameter Modelica.Units.SI.Emissivity a1_diff=1 - Ta1_diff - rho_1_diff
    "Degree of absorption for single pane window";
  parameter Real Q21_diff=a1_diff*(1 + (
      Ta1_diff*rho_1_diff/XN2_diff))*UWin/25
    "Auxiliary parameter for heat transfer of exterior pane of double pane window";
  parameter Real Q22_diff=a1_diff*(
      Ta1_diff/XN2_diff)*(1 - (UWin/7.7))
    "Auxiliary parameter for heat transfer of interior pane of double pane window";
  parameter Real Qsek2_diff=Q21_diff + Q22_diff
    "Overall auxiliary parameter for heat transfer of double pane window";
  parameter Modelica.Units.SI.TransmissionCoefficient CorG_diff=(Ta2_diff +
      Qsek2_diff)/g_dir0
    "Transmission coefficient correction factor for diffuse radiation";
  parameter Modelica.Units.SI.TransmissionCoefficient CorG_gr=(Ta2_diff +
      Qsek2_diff)/g_dir0
    "Transmission coefficient correction factor for irradiations from ground";

  //Calculating the correction factor for direct solar radiation
  Modelica.Units.SI.TransmissionCoefficient[n] Ta_dir
    "Energetic degree of transmission for direct radiation";
  Modelica.Units.SI.TransmissionCoefficient[n] Tai_dir
    "Pure degree of transmission for direct radiation";
  Modelica.Units.SI.TransmissionCoefficient[n] Ta1_dir
    "Pure degree of transmission for single pane window";
  Modelica.Units.SI.ReflectionCoefficient[n] rho_T1_dir
    "Part of degree of transmission for single pane window related to Ta1_dir";
  Modelica.Units.SI.ReflectionCoefficient[n] rho_11_dir
    "Part of degree of transmission for single pane window related to T1_dir";
  Modelica.Units.SI.ReflectionCoefficient[n] rho_1_dir
    "Degree of reflection for single pane window";
  Modelica.Units.SI.ReflectionCoefficient[n] XN2_dir
    "Calculation factor to simplify equations";
  Modelica.Units.SI.TransmissionCoefficient[n] Ta2_dir
    "Energetic dregree of transmission for second pane";
  Modelica.Units.SI.Emissivity[n] a1_dir
    "Degree of absorption for single pane window";
  Real[n] Q21_dir
    "Coefficient of heat transfer for exterior pane of double pane window";
  Real[n] Q22_dir
    "Coefficient of heat transfer for interior pane of double pane window";
  Real[n] Qsek2_dir
    "Overall coefficient of heat transfer for double pane window";
  Modelica.Units.SI.TransmissionCoefficient[n] CorG_dir
    "Transmission coefficient correction factor for direct radiation";

equation
  for i in 1:n loop
    Ta_dir[i]= (((((A6*con.to_deg(inc[i])+A5)*con.to_deg(inc[i])+A4)*con.to_deg(inc[i])+A3)*
    con.to_deg(inc[i])+A2)*con.to_deg(inc[i])+A1)*con.to_deg(inc[i])+A0;
    Tai_dir[i]= 0.907^(1/sqrt(1-(sin(inc[i])/1.515)^2));
    Ta1_dir[i]= Ta_dir[i]*Tai_dir[i];
    rho_T1_dir[i]= 1-Ta_dir[i];
    rho_11_dir[i]= rho_T1_dir[i]/(2-rho_T1_dir[i]);
    rho_1_dir[i]=rho_11_dir[i]+(((1-rho_11_dir[i])*Tai_dir[i])^2*rho_11_dir[i])/
    (1-(rho_11_dir[i]*Tai_dir[i])^2);
    a1_dir[i]= 1-Ta1_dir[i]-rho_1_dir[i];
    XN2_dir[i]= 1+10^(-20)-rho_1_dir[i]^2;
    Q21_dir[i]=a1_dir[i]*(1+(Ta1_dir[i]*rho_1_dir[i]/XN2_dir[i]))*UWin/25;
    Q22_dir[i]= a1_dir[i]*(Ta1_dir[i]/XN2_dir[i])*(1-(UWin/7.7));
    Qsek2_dir[i]=Q21_dir[i]+Q22_dir[i];
    Ta2_dir[i]= Ta1_dir[i]^2/XN2_dir[i];
    CorG_dir[i]= (Ta2_dir[i]+Qsek2_dir[i])/g_dir0;

    //Calculating the input thermal energy due to solar radiation
    solarRadWinTrans[i] = ((HDirTil[i]*CorG_dir[i])+(HSkyDifTil[i]*CorG_diff)+
    (HGroDifTil[i]*CorG_gr));
  end for;

  annotation (defaultComponentName="corG",
  Documentation(info="<html>
  <p>This model computes short-wave radiation through
  transparent elements with any orientation and inclination by means of
  solar transmission correction factors. Transmission properties of transparent
  elements are in general dependent on the solar incidence angle. To take this
  dependency into account, correction factors can be multiplied with the solar
  radiation. These factors should not be mistaken as calculation of solar
  radiation on tilted surfaces, calculation of <i>g</i>-values or consideration of
  sunblinds, as it is an additional step. The implemented calculations are
  defined in the German Guideline VDI 6007 Part 3 (VDI, 2015). The given model
  is only valid for double pane windows. The guideline describes also
  calculations for single pane and triple pane windows.</p>
  <h4>References</h4>
  <p>VDI. German Association of Engineers Guideline VDI 6007-3 June 2015.
  Calculation of transient thermal response of rooms and buildings -
  modelling of solar radiation.</p>
  </html>",
  revisions="<html>
  <ul>
  <li>
  September 12, 2015 by Moritz Lauster:<br/>
  Adapted to Annex 60 requirements.
  </li>
  <li>
  February 24, 2014, by Reza Tavakoli:<br/>
  First implementation.
  </li>
  </ul>
  </html>"));
end CorrectionGDoublePane;
