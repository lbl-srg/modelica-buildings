within Buildings.HeatTransfer;
package Functions "Functions for heat transfer package"
  package ConvectiveHeatFlux "Correlations for convective heat flux"
    package BaseClasses
      "Base classes for convective heat transfer coefficients"
      extends Modelica.Fluid.Icons.BaseClassLibrary;

      partial function PartialConvectiveHeatFlux
        "Partial function for convective heat flux"
       input Modelica.SIunits.TemperatureDifference dT
          "Temperature difference solid minus fluid";
       output Modelica.SIunits.HeatFlux q_flow
          "Convective heat flux from solid to fluid";
      annotation (Documentation(info=
                                   "<html>
This is a partial function that is used to implement the convective heat flux
as <tt>q_flow = f(dT)</tt>,
where <tt>dT</tt> is the solid temperature minus the fluid temperature.
</html>",     revisions="<html>
<ul>
<li>
March 10 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
      end PartialConvectiveHeatFlux;
    end BaseClasses;

    function constantCoefficient
      "Constant convective heat transfer coefficient"
      extends
        Buildings.HeatTransfer.Functions.ConvectiveHeatFlux.BaseClasses.PartialConvectiveHeatFlux;
      input Modelica.SIunits.CoefficientOfHeatTransfer hCon = 3
        "Constant for convective heat transfer coefficient";
    algorithm
      q_flow :=hCon*dT;
    annotation (Documentation(info=
                                 "<html>
This function computes the convective heat transfer coefficient as
<tt>h=hCon</tt>, where <tt>hCon=3</tt> is a default input argument.
The convective convective heat flux is then
<tt>q_flow = h * dT</tt>,
where <tt>dT</tt> is the solid temperature minus the fluid temperature.
</html>",   revisions="<html>
<ul>
<li>
March 10 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
    end constantCoefficient;

    function wall "Free convection, wall"
      extends
        Buildings.HeatTransfer.Functions.ConvectiveHeatFlux.BaseClasses.PartialConvectiveHeatFlux;
    algorithm
      q_flow := sign(dT)*1.3*abs(dT)^1.3333;

    annotation (Documentation(info=
    "<html>
This function computes the buoyancy-driven convective heat transfer coefficient 
for a wall as
<tt>h=1.3*|dT|^0.3333</tt>,
where <tt>dT</tt> is the solid temperature minus the fluid temperature.
The convective convective heat flux is then
<tt>q_flow = h * dT</tt>.
</html>",
    revisions="<html>
<ul>
<li>
March 10 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
    end wall;

    function floor "Free convection, floor"
      extends
        Buildings.HeatTransfer.Functions.ConvectiveHeatFlux.BaseClasses.PartialConvectiveHeatFlux;

    algorithm
      q_flow  := if (dT>0) then 1.51*dT^1.3333 else -0.76*(-dT)^1.3333;
    annotation(smoothOrder=1,
                  Documentation(info=
    "<html>
This function computes the buoyancy-driven convective heat transfer coefficient 
for a floor as
<tt>h=k*|dT|^0.3333</tt>,
where 
<tt>k=1.51</tt> if the floor is warmer than the fluid,
or <tt>k=0.76</tt> otherwise, and where
<tt>dT</tt> is the solid temperature minus the fluid temperature.
The convective convective heat flux is then
<tt>q_flow = h * dT</tt>.
</html>",
    revisions="<html>
<ul>
<li>
March 10 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
    end floor;

    function ceiling "Free convection, ceiling"
      extends
        Buildings.HeatTransfer.Functions.ConvectiveHeatFlux.BaseClasses.PartialConvectiveHeatFlux;

    algorithm
       q_flow  := if (dT>0) then 0.76*dT^1.3333 else -1.51*(-dT)^1.3333;
    annotation(smoothOrder=1,
                Documentation(info=
    "<html>
This function computes the buoyancy-driven convective heat transfer coefficient 
for a ceiling as
<tt>h=k*|dT|^0.3333</tt>,
where 
<tt>k=1.51</tt> if the fluid is warmer than the ceiling,
or <tt>k=0.76</tt> otherwise, and where
<tt>dT</tt> is the solid temperature minus the fluid temperature.
The convective convective heat flux is then
<tt>q_flow = h * dT</tt>.
</html>",
    revisions="<html>
<ul>
<li>
March 10 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
    end ceiling;

    function raleigh "Raleigh number with smooth transition to lower limit"
     input Modelica.SIunits.Length x "Layer thickness";
     input Modelica.SIunits.Density rho "Mass density";
     input Modelica.SIunits.SpecificHeatCapacity c_p "Specific heat capacity";
     input Modelica.SIunits.DynamicViscosity mu "Dynamic viscosity";
     input Modelica.SIunits.ThermalConductivity k "Thermal conductivity";
     input Modelica.SIunits.Temperature T_a "Temperature of surface a";
     input Modelica.SIunits.Temperature T_b "Temperature of surface b";
     input Real Ra_min "Minimum value for Raleigh number";
     output Real Ra "Raleigh number";
    protected
     Modelica.SIunits.TemperatureDifference dT "Temperature difference";
    algorithm
      dT :=abs(T_a - T_b);
      Ra := rho^2*x^3*Modelica.Constants.g_n*c_p*dT/((T_a+T_b)/2*mu*k);
      Ra := Buildings.Utilities.Math.Functions.smoothMax(x1=Ra, x2=Ra_min, deltaX=Ra_min/10);
    annotation (smoothOrder=1,
    Documentation(info="<html>
This function returns the Raleigh number.
The parameter <code>RaMin</code> is used to transition
to a lower limit for the Raleigh number.
This is helpful to avoid a Raleigh number of zero or
to avoid an expression for a convection coefficient that
has an infinite derivative near zero, i.e., if <i>h=f(Ra^(1/2))</i>.
</html>",
    revisions="<html>
<ul>
<li>
August 18 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
    end raleigh;
    annotation (Documentation(info="<html>
This package contains functions for the convective heat transfer.
Input into the functions is the temperature difference between 
the solid and the fluid. 
The functions compute the convective heat flux, rather than the 
convective heat transfer coefficient.
The reason is that the convective heat transfer coefficient
is not differentiable around zero for certain flow configurations,
such as buoyancy driven flow at a horizontal surface. However, the
product of convective heat transfer coefficient times temperature 
difference is differentiable around zero.
</html>",   revisions="<html>
<ul>
<li>
March 8 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  end ConvectiveHeatFlux;
  annotation (Documentation(revisions="<html>
<ul>
<li>
March 8 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>", info="<html>
This package contains functions that are used in the
package 
<a href=\"modelica://Buildings.HeatTransfer\">
Buildings.HeatTransfer</a>.
</html>"));
end Functions;
