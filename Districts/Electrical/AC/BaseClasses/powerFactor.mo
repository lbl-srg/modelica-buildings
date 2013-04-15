within Districts.Electrical.AC.BaseClasses;
function powerFactor "Function that computes the power factor"
 input Real pf(min=0, max=1) "Power factor";
 input Boolean lagging
    "Set to true for lagging powerfactor (current lags voltage), or false otherwise";
 output Modelica.SIunits.Angle phi_p "Phase shift of power";
algorithm
  phi_p := if lagging then Modelica.Math.acos(pf)
     else -Modelica.Math.acos(pf);
end powerFactor;
