within Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses;
function performanceCurve
  "Performance curve of a generic desiccant dehumidifier"
  input Modelica.Units.SI.Temperature TProEnt
    "Temperature of the process air entering the dehumidifier";
  input Modelica.Units.SI.MassFraction X_w_ProEnt
    "Humidity ratio of the process air entering the dehumidifier";
  input Modelica.Units.SI.Velocity vPro
    "Velocity of the process air";
  input Real a[16]
    "Performance coefficients";
  output Real y
    "Return value";
protected
   Modelica.Units.NonSI.Temperature_degC TProEnt_degC
   "Temperature of the process air entering the dehumidifier";

algorithm
  TProEnt_degC := Modelica.Units.Conversions.to_degC(TProEnt);
  y:= a[1]
      + a[2]*TProEnt_degC
      + a[3]* X_w_ProEnt
      + a[4]*vPro
      + a[5]*TProEnt_degC*X_w_ProEnt
      + a[6]*TProEnt_degC*vPro
      + a[7]*X_w_ProEnt*vPro + a[8]*TProEnt_degC*TProEnt_degC
      + a[9]*X_w_ProEnt*X_w_ProEnt+ a[10]*vPro*vPro
      + a[11]*TProEnt_degC*TProEnt_degC*X_w_ProEnt*X_w_ProEnt
      + a[12]*TProEnt_degC*TProEnt_degC*vPro*vPro
      + a[13]*X_w_ProEnt*X_w_ProEnt*vPro*vPro
      + a[14]*Modelica.Math.log(TProEnt_degC)
      + a[15]*Modelica.Math.log(X_w_ProEnt)
      + a[16]*Modelica.Math.log(vPro);

  annotation (Documentation(info="<html>
This function computes a performance curve of desiccant dehumidifiers, with the following form
<p align=\"center\" style=\"font-style:italic;\">
  y = a<sub>1</sub> + a<sub>2</sub> T<sub>ProEnt</sub> + a<sub>3</sub> X<sub>_w_ProEnt</sub> + a<sub>4</sub> v<sub>Pro</sub>
      + a<sub>5</sub> T<sub>ProEnt</sub> X<sub>_w_ProEnt</sub> + a<sub>6</sub> T<sub>ProEnt</sub> v<sub>Pro</sub>
      + a<sub>7</sub> X<sub>_w_ProEnt</sub> v<sub>Pro</sub> + a<sub>8</sub> T<sub>ProEnt</sub> T<sub>ProEnt</sub>
      + a<sub>9</sub> X<sub>_w_ProEnt</sub> X<sub>_w_ProEnt</sub> + a<sub>10</sub> v<sub>Pro</sub> v<sub>Pro</sub>
      + a<sub>11</sub> T<sub>ProEnt</sub> T<sub>ProEnt</sub> X<sub>_w_ProEnt</sub> X<sub>_w_ProEnt</sub>
      + a<sub>12</sub> T<sub>ProEnt</sub> T<sub>ProEnt</sub> v<sub>Pro</sub> v<sub>Pro</sub>
      + a<sub>13</sub> X<sub>_w_ProEnt</sub> X<sub>_w_ProEnt</sub> v<sub>Pro</sub> v<sub>Pro</sub>
      + a<sub>14</sub>log(T<sub>ProEnt</sub>)
      + a<sub>15</sub>log(X<sub>_w_ProEnt</sub>)
      + a<sub>16</sub>log(v<sub>Pro</sub>)
</p>
<p>
where <i>T<sub>ProEnt</sub></i> is the temperature of the process air entering the dehumidifier (&deg;C);
<br>  
<i>X<sub>_w_ProEnt</sub></i> is the humidity ratio of the process air entering the dehumidifier (kg/kg);
<br> 
<i>v<sub>Pro</sub></i> is the velocity of the process air (m/s);
<br>
<i>a<sub>1</sub></i>,...,<i>a<sub>16</sub></i> are coefficients.
</p>
<h4>References</h4>
<ul>
<li>
<a href=\"https://energyplus.net/assets/nrel_custom/pdfs/pdfs_v22.1.0/EngineeringReference.pdf\">
U.S. Department of Energy, <i> &quot;EnergyPlus Version 22.1.0 Documentation: Engineering Reference&quot;.</i></a>
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>March 1, 2024, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end performanceCurve;
