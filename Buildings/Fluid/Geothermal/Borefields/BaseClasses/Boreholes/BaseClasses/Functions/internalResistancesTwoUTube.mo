within Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions;
function internalResistancesTwoUTube
  "Thermal resistances for double U-tube, according to Bauer et al (2011)"
  extends
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.partialInternalResistances;

  // Outputs
  output Modelica.Units.SI.ThermalResistance Rgb
    "Thermal resistance between a grout capacity and the borehole wall, as defined by Bauer et al (2010)";
  output Modelica.Units.SI.ThermalResistance Rgg1
    "Thermal resistance between two neightbouring grout capacities, as defined by Bauer et al (2010)";
  output Modelica.Units.SI.ThermalResistance Rgg2
    "Thermal resistance between two  grout capacities opposite to each other, as defined by Bauer et al (2010)";
  output Modelica.Units.SI.ThermalResistance RCondGro
    "Thermal resistance between a pipe wall and the grout capacity, as defined by Bauer et al (2010)";
protected
  Real[4,4] RDelta(each unit="(m.K)/W") "Delta-circuit thermal resistances";
  Real[4,4] R(each unit="(m.K)/W") "Internal thermal resistances";
  Modelica.Units.SI.Position[4] xPip={-sha,sha,0.,0.} "x-Coordinates of pipes";
  Modelica.Units.SI.Position[4] yPip={0.,0.,-sha,sha} "y-Coordinates of pipes";
  Modelica.Units.SI.Radius[4] rPip={rTub,rTub,rTub,rTub}
    "Outer radius of pipes";
  Real[4] RFluPip(each unit="(m.K)/W") = {RCondPipe+RConv, RCondPipe+RConv, RCondPipe+RConv, RCondPipe+RConv} "Fluid to pipe wall thermal resistances";

  Real Ra( unit="(m.K)/W")
    "Grout-to-grout resistance (2D) as defined by Hellstrom. Interaction between the different grout parts";

  Modelica.Units.SI.ThermalResistance Rg
    "Thermal resistance between outer borehole wall and one tube";
  Modelica.Units.SI.ThermalResistance Rar1
    "Thermal resistance between the two closest pipe outer walls";
  Modelica.Units.SI.ThermalResistance Rar2
    "Thermal resistance between the two farthest pipe outer walls";

algorithm
  // Internal thermal resistances
  (RDelta, R) :=
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.multipoleThermalResistances(
      4, 3, xPip, yPip, rBor, rPip, kFil, kSoi, RFluPip);

  // Rb and Ra
  Rb_multipole := 1./(1./RDelta[1,1] + 1./RDelta[2,2] + 1./RDelta[3,3] + 1./RDelta[4,4]);
  Rb_internal := if use_Rb then Rb else Rb_multipole;
  // The short-circuit resistance in weigthed by the ratio between the used
  // value of Rb and the theoretical value
  Ra := (R[1,1] + R[3,3] - 2*R[1,3])*Rb_internal/Rb_multipole;

  // ------ Calculation according to Bauer et al. (2010)
  Rg := (4*Rb_internal - RCondPipe - RConv)/hSeg;
  Rar1 := ((2 + sqrt(2))*Rg*hSeg*(Ra - RCondPipe)/(Rg*hSeg + Ra - RCondPipe))/hSeg;
  Rar2 := sqrt(2)*Rar1;

  // If any of the internal delta-circuit resistances is negative, then
  // the location (x) of the thermal capacity is set to zero to limit
  // instabilities in the calculations. Otherwise, calculations follow the
  // method of Bauer et al. (2011).
  if (RDelta[1,2] < 0) or (RDelta[1,3] < 0) then
    //Thermal resistance between the grout zone and borehole wall
    Rgb := Rg;

    //Conduction resistance in grout from pipe wall to capacity in grout
    RCondGro := RCondPipe/hSeg;

    //Thermal resistance between the two grout zones
    Rgg1 := 2*Rgb*(Rar1)/(2*Rgb - Rar1);
    Rgg2 := 2*Rgb*(Rar2)/(2*Rgb - Rar2);

    test := true;
  else
    // ********** Resistances and capacity location according to Bauer **********
    while test == false and i <= 16 loop
      // Capacity location (with correction factor in case that the test is negative)
      x := Modelica.Math.log(sqrt(rBor^2 + 4*rTub^2)/(2*sqrt(2)*rTub))/
          Modelica.Math.log(rBor/(2*rTub))*((15 - i + 1)/15);

      //Thermal resistance between the grout zone and borehole wall
      Rgb := (1 - x)*Rg;

      //Conduction resistance in grout from pipe wall to capacity in grout
      RCondGro := x*Rg + RCondPipe/hSeg;

      //Thermal resistance between the two grout zones
      Rgg1 := 2*Rgb*(Rar1 - 2*x*Rg)/(2*Rgb - Rar1 + 2*x*Rg);
      Rgg2 := 2*Rgb*(Rar2 - 2*x*Rg)/(2*Rgb - Rar2 + 2*x*Rg);

      // Thermodynamic test to check if negative R values make sense. If not, decrease x-value.
      test := (((1/Rgg1 + 1/2/Rgb)^(-1) > 0) and ((1/Rgg2 + 1/2/Rgb)^(-1) > 0));
      i := i + 1;
    end while;
  end if;
  assert(test, "In " + getInstanceName() + ":\n" +
  "Maximum number of iterations exceeded. Check the borehole geometry.
  The tubes may be too close to the borehole wall.
  Input to the function
  Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.doubleUTubeResistances
  is
            hSeg = " + String(hSeg) + " m
            rBor = " + String(rBor) + " m
            rTub = " + String(rTub) + " m
            eTub = " + String(eTub) + " m
            sha = " + String(sha) + " m
            kSoi = " + String(kSoi) + " W/m/K
            kFil = " + String(kFil) + " W/m/K
            kTub = " + String(kTub) + " W/m/K
  Computed x    = " + String(x) + " m
            Rgb  = " + String(Rgb) + " K/W
            Rgg1  = " + String(Rgg1) + " K/W
            Rgg2  = " + String(Rgg2) + " K/W");

annotation (
  Documentation(info="<html>
<p>
This model computes the different thermal resistances present in a double U-tube
borehole using the method of Bauer et al. (2011).
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
end internalResistancesTwoUTube;
