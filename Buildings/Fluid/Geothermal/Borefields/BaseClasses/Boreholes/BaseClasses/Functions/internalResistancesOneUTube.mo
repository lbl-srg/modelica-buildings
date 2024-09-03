within Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions;
function internalResistancesOneUTube
  "Thermal resistances for single U-tube, according to Bauer et al. (2011)"
  extends
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.partialInternalResistances;

  // Outputs
  output Modelica.Units.SI.ThermalResistance Rgb
    "Thermal resistance between grout zone and borehole wall";
  output Modelica.Units.SI.ThermalResistance Rgg
    "Thermal resistance between the two grout zones";
  output Modelica.Units.SI.ThermalResistance RCondGro
    "Thermal resistance between: pipe wall to capacity in grout";
protected
  Real[2,2] RDelta(each unit="(m.K)/W") "Delta-circuit thermal resistances";
  Real[2,2] R(each unit="(m.K)/W") "Internal thermal resistances";
  Modelica.Units.SI.Position[2] xPip={-sha,sha} "x-Coordinates of pipes";
  Modelica.Units.SI.Position[2] yPip={0.,0.} "y-Coordinates of pipes";
  Modelica.Units.SI.Radius[2] rPip={rTub,rTub} "Outer radius of pipes";
  Real[2] RFluPip(each unit="(m.K)/W") = {RCondPipe+RConv, RCondPipe+RConv} "Fluid to pipe wall thermal resistances";
  Modelica.Units.SI.ThermalResistance Rg
    "Thermal resistance between outer borehole wall and one tube";
  Modelica.Units.SI.ThermalResistance Rar
    "Thermal resistance between the two pipe outer walls";

  Real Ra(unit="(m.K)/W")
    "Grout-to-grout resistance (2D) as defined by Hellstrom. Interaction between the different grout parts";

algorithm
  // Internal thermal resistances
  (RDelta, R) :=
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.multipoleThermalResistances(
      2, 3, xPip, yPip, rBor, rPip, kFil, kSoi, RFluPip);

  // Rb and Ra
  Rb_multipole := 1./(1./RDelta[1,1] + 1./RDelta[2,2]);
  Rb_internal := if use_Rb then Rb else Rb_multipole;
  // The short-circuit resistance in weigthed by the ratio between the used
  // value of Rb and the theoretical value
  Ra := (R[1,1] + R[2,2] - 2*R[1,2])*Rb_internal/Rb_multipole;

  // Conversion of Rb (resp. Ra) to Rg (resp. Rar) of Bauer:
  Rg  :=(2*Rb_internal-RCondPipe-RConv)/hSeg;
  Rar :=(Ra-2*(RCondPipe + RConv))/hSeg;

  // If any of the internal delta-circuit resistances is negative, then
  // the location (x) of the thermal capacity is set to zero to limit
  // instabilities in the calculations. Otherwise, calculations follow the
  // method of Bauer et al. (2011).
  if (RDelta[1,2] < 0) then
    //Thermal resistance between the grout zone and borehole wall
    Rgb := Rg;

    //Conduction resistance in grout from pipe wall to capacity in grout
    RCondGro := RCondPipe/hSeg;

    //Thermal resistance between the two grout zones
    Rgg := 2*Rgb*Rar/(2*Rgb - Rar);

    test := true;
  else
    // ********** Resistances and capacity location according to Bauer **********
    while test == false and i <= 10 loop
      // Capacity location (with correction factor in case that the test is
      // negative)
      x := Modelica.Math.log(sqrt(rBor^2 + 2*rTub^2)/(2*rTub))/
        Modelica.Math.log(rBor/(sqrt(2)*rTub))*((15 - i + 1)/15);

      //Thermal resistance between the grout zone and borehole wall
      Rgb := (1 - x)*Rg;

      //Conduction resistance in grout from pipe wall to capacity in grout
      RCondGro := x*Rg + RCondPipe/hSeg;

      //Thermal resistance between the two grout zones
      Rgg := 2*Rgb*(Rar - 2*x*Rg)/(2*Rgb - Rar + 2*x*Rg);

      // Thermodynamic test to check if negative R values make sense. If not,
      // decrease x-value.
      test := ((1/Rgg + 1/2/Rgb)^(-1) > 0);
      i := i + 1;
    end while;
  end if;
  assert(test, "In " + instanceName + ":\n" +
  "Maximum number of iterations exceeded. Check the borehole geometry.
  The tubes may be too close to the borehole wall.
  Input to the function
  Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.singleUTubeResistances
  is
           hSeg = " + String(hSeg) + " m
           rBor = " + String(rBor) + " m
           rTub = " + String(rTub) + " m
           eTub = " + String(eTub) + " m
           kSoi = " + String(kSoi) + " W/m/K
           kFil = " + String(kFil) + " W/m/K
           kTub = " + String(kTub) + " W/m/K
           i = "  + String(i) + "
  Computed x    = " + String(x) + " K/W
           Rgb  = " + String(Rgb) + " K/W
           Rgg  = " + String(Rgg) + " K/W");

annotation (
  Documentation(info="<html>
<p>
This model computes the different thermal resistances present in a single-U-tube borehole
using the method of Bauer et al. (2011).
It also computes the fluid-to-ground thermal resistance <i>R<sub>b</sub></i>
and the grout-to-grout thermal resistance <i>R<sub>a</sub></i>
as defined by Claesson and Hellstrom (2011) using the multipole method.
</p>

<h4>References</h4>
<p>J. Claesson and G. Hellstrom.
<i>Multipole method to calculate borehole thermal resistances in a borehole heat exchanger.
</i>
HVAC&amp;R Research,
17(6): 895-911, 2011.</p>
<p>D. Bauer, W. Heidemann, H. M&uuml;ller-Steinhagen, and H.-J. G. Diersch.
<i>Thermal resistance and capacity models for borehole heat exchangers</i>.
International Journal of Energy Research, 35:312&ndash;320, 2011.</p>
</html>", revisions="<html>
<ul>
<li>
November 22, 2023, by Michael Wetter:<br/>
Corrected use of <code>getInstanceName()</code> which was called inside a function which
is not allowed.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1814\">IBPSA, #1814</a>.
</li>
<li>
February 7, 2022, by Michael Wetter:<br/>
Changed function to be <code>pure</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1582\">IBPSA, #1582</a>.
</li>
<li>
December 11, 2021, by Michael Wetter:<br/>
Added <code>impure</code> declaration for MSL 4.0.0.
</li>
<li>
July 18, 2018 by Massimo Cimmino:<br/>
Implemented multipole method.
</li>
<li>
February 14, 2014 by Michael Wetter:<br/>
Added an assert statement to test for non-physical values.
</li>
<li>
February 12, 2014, by Damien Picard:<br/>
Remove the flow dependency of the resistances, as this function calculates the conduction resistances only.
</li>
<li>
January 24, 2014, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
January 23, 2014, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"));
end internalResistancesOneUTube;
