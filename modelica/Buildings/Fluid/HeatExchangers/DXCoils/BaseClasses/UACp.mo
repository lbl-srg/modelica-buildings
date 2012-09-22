within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
block UACp "Calculates UA/Cp of the coil"
  extends Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.NominalCondition;
  final parameter Modelica.SIunits.MassFraction XADP_nominal(
    start=0.008,
    min=0,
    max=1.0,
    fixed=false)
    "Rated/Nominal mass fraction of air at coil apparatus dew point";
  final parameter Modelica.SIunits.Temperature TADP_nominal(
    start=273.15+10,
    fixed=false) "Coil apparatus dew point temperature";
  final parameter Modelica.SIunits.SpecificEnthalpy hADP_nominal(
    fixed=false)
    "Enthalpy of air at coil apparatus dew point (at rated condition)";
  final parameter Real bypass_nominal(
    start=0.25,
    min=0,
    max=1.0,
    fixed=false) "Bypass factor for nominal condition";
  final parameter Real uACp(
    min=0,
    fixed=false) "UA/Cp of coil";
  parameter Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));
protected
  constant Real phiADP_nominal = 1.0 "Realtive humidity at ADP";
  final parameter Modelica.SIunits.AbsolutePressure psat_ADP_nominal(
    start=1250,
    fixed=false) "Saturation pressure";
initial equation
//------------------------Apparatus Dew Point (ADP) calculations---------------------//
  //Solve Eq. 1 , 2 and 3 for air properties (XADP_nominal and TADP_nominal)
  //of saturated air at coil apparatus dew point
//---------------------------------------Eq.1---------------------------------------//
  (XIn_nominal - XOut_nominal)*(per.TIn_nominal - TADP_nominal)
     =(XIn_nominal  - XADP_nominal)*(per.TIn_nominal - TOut_nominal);
//---------------------------------------Eq.2---------------------------------------//
  if homotopyInitialization then
    psat_ADP_nominal=homotopy(
      actual=Medium.saturationPressureLiquid(Tsat=TADP_nominal),
      simplified=1252.393+83.933*(TADP_nominal-283.15));
  else // do not use homotopy
    psat_ADP_nominal=Medium.saturationPressureLiquid(TADP_nominal);
  end if;
  //  Taylor series
  //  psat_ADP_nominal=1252.393+83.933*(TADP_nominal-283.15);
  //  Non-linear equation
  //  psat_ADP_nominal =  Medium.saturationPressureLiquid(TADP_nominal);
//---------------------------------------Eq.3---------------------------------------//
  if homotopyInitialization then
    XADP_nominal=homotopy(
      actual=  phiADP_nominal*k/(k*phiADP_nominal
            +per.p_nominal/psat_ADP_nominal-phiADP_nominal),
      simplified=0.007572544+6.19495*(10^(-6))*(psat_ADP_nominal-1228));

  else // do not use homotopy
    XADP_nominal=phiADP_nominal*k/(k*phiADP_nominal
            +per.p_nominal/psat_ADP_nominal-phiADP_nominal);
  end if;
//-----------------------------------uACp calculations-----------------------------//
  hADP_nominal = Medium.h_pTX(
              p=per.p_nominal,
              T=TADP_nominal,
              X=cat(1,{XADP_nominal}, {1-sum({XADP_nominal})}));
  bypass_nominal=Buildings.Utilities.Math.Functions.smoothMax(
              x1=0.00001,
              x2=Buildings.Utilities.Math.Functions.smoothMin(
                    x1=1.0,
                    x2=((hOut_nominal-hADP_nominal)/(hIn_nominal-hADP_nominal)),
                    deltaX=0.00001),
              deltaX=0.00001);
  uACp = -per.m_flow_nominal * log(bypass_nominal);
 annotation(defaultComponentName="uacp",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{-70,20},{70,-20}},
          lineColor={0,0,255},
          textString="U*A/Cp")}), Documentation(info="<html>
<p>
fixme: fix math notation.
This block calculates the <i>UA/Cp</i> value of the coil from the nominal inlet and outlet 
air properties. The nominal conditions are calculated using 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.NominalCondition\">
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.NominalCondition</a>.<br>
When compared with &epsilon;-NTU method:
<p align=\"center\" style=\"font-style:italic;\"> 
U A / Cp &hArr; NTU * m </p> 
(where m = mass flow rate). <br>
Similarly the bypass factor of the coil is analogous to the ineffectiveness 
<i>( 1 - &epsilon; )</i> of coil.<br>
<i>UA/Cp</i> is assumed to remain constant for further time dependent calculations.<br>
</p>
<p>

For phase change (Cr = C<sub>min</sub> / C<sub>max</sub> = 0) 
the &epsilon;-NTU relation is given as 
<p align=\"center\" style=\"font-style:italic;\">
  &epsilon; = 1 - e <sup>-NTU</sup>
</p>
Thus, <i>UA/Cp</i> of the coil in terms of the bypass factor is written as:
 <p align=\"center\" style=\"font-style:italic;\">
  Bypass Factor<sub>nominal</sub> = e <sup>- (UA/Cp) / m</sup><br><br>
  &there4; UA/Cp = - m * log(Bypass Factor<sub>nominal</sub>)

</p>
As <i>UA/Cp</i> is assumed to be constant, bypass factor is a function of 
the current mass flow rate.</p>

<h4>References</h4>
<p>
<a href=\"http://www.energyplus.gov\">EnergyPlus 7.0 Engineering Reference</a>, 
May 24, 2012.
</p>
<p>
Kruis, Nathanael. <i>Reconciling differences between Residential DX Cooling 
Coil models in DOE-2 and EnergyPlus.</i> 
Forth National Conference of IBPSA-USA. New York: SimBuild, 2010. 134-141.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 9, 2012 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>

</html>"));
end UACp;
