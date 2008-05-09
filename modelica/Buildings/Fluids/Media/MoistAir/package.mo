package MoistAir 
  extends Modelica.Media.Air.MoistAir(
      mediumName="MoistAirASHRAE");
  import SI = Modelica.SIunits;

  annotation (Documentation(info="<HTML>
<p>
This is a medium model that is similar to <tt>Modelica.Media.Air.MoistAir</tt> but 
it has simplified property functions.
</p>
</HTML>", revisions="<html>
<ul>
<li>
May 8, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));

redeclare replaceable function extends enthalpyOfLiquid 
algorithm 
  h := (T - 273.15)*4186;
end enthalpyOfLiquid;

replaceable function enthalpyOfSteam "enthalpy of steam per unit mass of steam" 
  extends Modelica.Icons.Function;
  input Temperature T "temperature";
  output SpecificEnthalpy h "dry air enthalpy";
algorithm 
  h := (T-273.15) * 1860 + 2501000;
end enthalpyOfSteam;

redeclare replaceable function extends enthalpyOfGas 
algorithm 
  h := (enthalpyOfLiquid(T)+2501000)*X[Water]
       + enthalpyOfDryAir(T)*(1.0-X[Water]);
end enthalpyOfGas;

replaceable function enthalpyOfDryAir "enthalpy of dry air" 
  extends Modelica.Icons.Function;
  input Temperature T "temperature";
  output SpecificEnthalpy h "dry air enthalpy";
algorithm 
  h := (T - 273.15)*1006;
end enthalpyOfDryAir;

redeclare replaceable function extends specificHeatCapacityCp 
  "Return specific heat capacity at constant pressure" 
algorithm 
  cp := 1006*(1-state.X[Water]) + 1860*state.X[Water];
end specificHeatCapacityCp;

redeclare replaceable function extends specificHeatCapacityCv 
  "Return specific heat capacity at constant volume" 
algorithm 
  cv:= specificHeatCapacityCp(state) - gasConstant(state);
end specificHeatCapacityCv;

function h_pTX 
  "Compute specific enthalpy from pressure, temperature and mass fraction" 
  extends Modelica.Icons.Function;
  input SI.Pressure p "Pressure";
  input SI.Temperature T "Temperature";
  input SI.MassFraction X[nX] "Mass fractions of moist air";
  output SI.SpecificEnthalpy h "Specific enthalpy at p, T, X";
protected 
  SI.AbsolutePressure p_steam_sat "Partial saturation pressure of steam";
  SI.MassFraction x_sat "steam water mass fraction of saturation boundary";
  SI.MassFraction X_liquid "mass fraction of liquid water";
  SI.MassFraction X_steam "mass fraction of steam water";
  SI.MassFraction X_air "mass fraction of air";
algorithm 
  p_steam_sat :=saturationPressure(T);
  x_sat    :=k_mair*p_steam_sat/(p - p_steam_sat);
  X_liquid :=max(X[Water] - x_sat/(1 + x_sat), 0.0);
  X_steam  :=X[Water] - X_liquid;
  X_air    :=1 - X[Water];
/*  h        := {SingleGasNasa.h_Tlow(data=steam,  T=T, refChoice=3, h_off=46479.819+2501014.5),
               SingleGasNasa.h_Tlow(data=dryair, T=T, refChoice=3, h_off=25104.684)}*
    {X_steam, X_air} + enthalpyOfLiquid(T)*X_liquid;
*/
  h := enthalpyOfDryAir(T) * X_air
       + enthalpyOfSteam(T) * X_steam
       + enthalpyOfLiquid(T)*X_liquid;
end h_pTX;


end MoistAir;
