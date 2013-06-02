within Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses;
function boreholeThermalResistance
  "Calculate the total thermal resistance of the borehole from the fluid to the soil"
  input Modelica.SIunits.Height hSeg "Height of the element";
  input Modelica.SIunits.Radius rBor "Radius of the borehole";
  input Modelica.SIunits.Radius rTub "Radius of the tube";
  input Modelica.SIunits.Length eTub "Thickness of the tubes";
  input Modelica.SIunits.ThermalConductivity kTub
    "Thermal conductivity of the tubes";
  input Modelica.SIunits.ThermalConductivity kFil
    "Thermal conductivity of the filling material";
  input Modelica.SIunits.ThermalConductivity kMed
    "Thermal conductivity of the fluid";
  input Modelica.SIunits.DynamicViscosity mueMed
    "Dynamic viscosity of the fluid";
  input Modelica.SIunits.SpecificHeatCapacity cpFluid
    "Specific heat capacity of the fluid";
  input Modelica.SIunits.MassFlowRate m_flow "Mass flow rate of the fluid";
  input Modelica.SIunits.MassFlowRate m_flow_nominal "Nominal mass flow rate";
  input Real B0 "Shape coefficient for grout resistance";
  input Real B1 "Shape coefficient for grout resistance";
  output Modelica.SIunits.ThermalResistance Rb "Borehole thermal resistance";
protected
  Modelica.SIunits.CoefficientOfHeatTransfer h
    "Convective heat transfer coefficient of the fluid";
  Modelica.SIunits.ThermalResistance RCon
    "Convective thermal resistance of the fluid";
  Modelica.SIunits.ThermalResistance RTub
    "Thermal resistance of the pipe's wall";
  Modelica.SIunits.ThermalResistance RFil
    "Thermal resistance of the filling material";
  Real k(unit="s/kg")
    "Coefficient used in the computation of the convective heat transfer coefficient";
algorithm
  k :=2/(mueMed*Modelica.Constants.pi*rTub);
  h := 0.023*kMed*(cpFluid*mueMed/kMed)^(0.35)/(2*rTub) *
    Buildings.Utilities.Math.Functions.regNonZeroPower(
    x=m_flow*k, n=0.8,
    delta=0.01*m_flow_nominal*k);
  RCon := 1/(4*Modelica.Constants.pi*rTub*hSeg*h);
  RTub := Modelica.Math.log((rTub + eTub)/rTub)/(4*Modelica.Constants.pi*hSeg*kTub);
  RFil := 1/(hSeg*kFil*B0*(rBor/(rTub + eTub))^B1);
  Rb := RCon + RTub + RFil;
  annotation (Diagram(graphics), Documentation(info="<html>
<p>
This model computes the borehole total thermal resistance for a single U-tube.
The computation is as defined in Hellstom (1991).
The total thermal resistance is the contribution of three different resistances as
</p>
<p align=\"center\" style=\"font-style:italic;\">
 R<sub>tot</sub>= R<sub>Con</sub> + R<sub>tub</sub> + R<sub>fil</sub>.
</p>
<p>
where 
<i>R<sub>Con</sub></i> is the convective resistance of the fluid, 
<i>R<sub>tub</sub></i> is the conductive resistance of the tube wall and 
<i>R<sub>fil</sub></i> is the resistance of the filling material.
</p>
<p>
The convective resistance is obtained as
</p>
<p>
 <p align=\"center\" style=\"font-style:italic;\">
 R<sub>Con</sub> = 1 &frasl; (4 &pi; h<sub>seg</sub> r<sub>tub</sub> h<sub>in</sub>),
</p> 
<p>
where <i>h<sub>seg</sub></i> is the height of the segment and 
<i>h<sub>in</sub></i> is the convective heat transfer coefficient. 
The convective heat transfer coefficient is determined using the 
Dittus-Boelter correlation,
</p>
<p align=\"center\" style=\"font-style:italic;\">
 h<sub>in</sub>= 0.023 k<sub>med</sub> Pr<sup>0.35</sup> Re<sup>0.8</sup> &frasl; 2 r<sub>tub</sub>,
</p>
<p>
where <i>k<sub>med</sub></i> is the thermal conductivity of the fluid, 
<i>Pr</i> is the Prandtl number, 
<i>Re</i> is the Reynolds number and 
<i>r<sub>tub</sub></i> is the inside radius of the pipe.
</p>
<p>
The conductive resistance is determined using
</p>
<p align=\"center\" style=\"font-style:italic;\">
R<sub>tub</sub>= ln[ ( r<sub>tub</sub>+e<sub>tub</sub> ) &frasl; r<sub>tub</sub> ] &frasl; 4 &pi; 
   k<sub>tub</sub> h<sub>seg</sub>,
</p>
<p>
where <i>k<sub>tub</sub></i> the heat conductivity of the pipe and 
<i>e<sub>tub</sub></i> is the thickness of the wall.
</p>
<p>
The resistance of the filling material is determined using the correlation from Paul (1996) :
</p>
<p align=\"center\" style=\"font-style:italic;\">
R<sub>fil</sub> = k<sub>fil</sub> h<sub>seg</sub> &beta;<sub>0</sub> 
  (r<sub>Bor</sub> &frasl; (r<sub>tub</sub> + e<sub>tub</sub>)) <sup>&beta;<sub>1</sub></sup> ,
</p>
<p>
where <i>k<sub>fil</sub></i> is the thermal conductivity of the filling material and 
<i>&beta;<sub>0</sub>, &beta;<sub>1</sub></i> are the resistance shape factors
(Paul 1996) based on U-tube shank spacing.
Paul's shape factors are based on experimental and finite element analysis of typical borehole.
The default values used for these coefficients are &beta;<sub>0</sub>= 20.100 and &beta;<sub>1</sub>=-0.94467.
Values listed by Paul are given in the table below.
</p>
<p>
  <table>
  <tr><th>pipe spacing</th><th><i>&beta;<sub>0</sub></i></th><th><i>&beta;<sub>1</sub></i></th></tr>
  <tr><td> close  </td><td> 20.100377 </td><td> -0.94467 </td></tr>
  <tr><td> middle  </td><td> 17.44 </td><td> -0.6052  </td></tr>
  <tr><td> spaced </td><td> 21.91 </td><td> -0.3796 </td></tr>
  </table>
</p>
<h4>References</h4>
<p>
Hellstrom, G (1991). <br/>
 <a href=\"http://intraweb.stockton.edu/eyos/energy_studies/content/docs/proceedings/HELLS.PDF\">
 Thermal Performance of Borehole Heat Exchangers</a>.<br/> 
Department of Mathematical Physics, Lund Institute of Technology.
</p>
<p>
Paul, N.D (1996). <i>The effect of grout thermal conductivity on vertical geothermal heat exchanger design
and performance.</i> 
Master of Science Thesis, South Dakota State University.
</p>
</html>", revisions="<html>
<ul>
<li>
August 2011, by Pierre Vigouroux:<br/>
First implementation.
</li>
</ul>
</html>"));
end boreholeThermalResistance;
