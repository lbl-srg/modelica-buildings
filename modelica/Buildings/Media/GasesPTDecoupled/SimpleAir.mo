package SimpleAir 
  "Package with dry air model that decouples pressure and temperature"
  extends Modelica.Media.Air.SimpleAir(
      mediumName="GasesPTDecoupled.SimpleAir",
      T_min=Cv.from_degC(-50));

  annotation (preferedView="info", Documentation(info="<HTML>
<p>
This medium model is identical to 
<a href=\"Modelica:Modelica.Media.Air.SimpleAir\" a>
Modelica.Media.Air.SimpleAir</a>, except the 
equation <tt>d = p/(R*T)</tt> has been replaced with 
<tt>d/dStp = p/pStp</tt> where 
<tt>pStd</tt> and <tt>dStp</tt> are constants for a reference
temperature and density.
</p>
<p>
This new formulation often leads to smaller systems of nonlinear equations 
because pressure and temperature are decoupled, at the expense of accuracy.
</p>
<p>
As in
<a href=\"Modelica:Modelica.Media.Air.SimpleAir\" a>
Modelica.Media.Air.SimpleAir</a>, the
specific enthalpy h and specific internal energy u are only
a function of temperature T and all other provided medium
quantities are constant.
</p>
</HTML>", revisions="<html>
<ul>
<li>
March 19, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));


 redeclare model BaseProperties "Basic medium properties" 
    extends BasePropertiesRecord;
  
    ThermodynamicState state 
    "thermodynamic state variables for optional functions";
    parameter Boolean preferredMediumStates=false 
    "= true if StateSelect.prefer shall be used for the independent property variables of the medium";
    Modelica.SIunits.Conversions.NonSIunits.Temperature_degC T_degC=
        Modelica.SIunits.Conversions.to_degC(T) 
    "Temperature of medium in [degC]";
    Modelica.SIunits.Conversions.NonSIunits.Pressure_bar p_bar=
        Modelica.SIunits.Conversions.to_bar(p) 
    "Absolute pressure of medium in [bar]";
   constant AbsolutePressure pStp = 101325 "Pressure for which dStp is defined";
   constant Density dStp = 1.2 "Fluid density at pressure pStp";
  
 equation 
    h = specificEnthalpy_pTX(p,T,X);
    u = h-R*T;
    R = R_gas;
    //    d = p/(R*T);
    d*pStp = p*dStp;
    MM = MM_const;
    state.T = T;
    state.p = p;
 end BaseProperties;


 redeclare replaceable function setState_dTX 
  "Return thermodynamic state from d, T, and X or Xi" 
    extends Modelica.Icons.Function;
    input Density d "density";
    input Temperature T "Temperature";
    input MassFraction X[:] = fill(0,0) "Mass fractions";
    output ThermodynamicState state;
 algorithm 
    state := ThermodynamicState(p=d/dStp*pStd,T=T);
 end setState_dTX;


 redeclare replaceable function extends density "return density of ideal gas" 
 algorithm 
    d := dStp*state.p/pStp;
 end density;


 redeclare replaceable function extends specificEntropy 
  "Return specific entropy" 
      extends Modelica.Icons.Function;
 algorithm 
    s := cp_const*Modelica.Math.log(state.T/T0);// - R_gas*Modelica.Math.log(state.p/reference_p);
 end specificEntropy;
end SimpleAir;
