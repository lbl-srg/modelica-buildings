within Buildings.Fluid.HeatExchangers.Borefield;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;
  annotation (preferredView="info",
  Documentation(info="<html>
<p>
This package contains a borefield model. The model is able to simulate any arbitrary configuration of boreholes with both short and long-term accuracy. An aggregation method is used to speed up the calculations. 
</p>

<h4>Model description</h4>
<p>A detailed description of the model can be
found in
<a href=\"modelica://Buildings/Resources/Images/Fluid/HeatExchangers/Borefield/UsersGuide/2014-10thModelicaConference-Picard.pdf\">Picard (2014)</a>.
Below, the model is briefly described.
</p>
<p>
The proposed model is a so-called hybrid step response-
model (HSRM). This type of model uses the
borefield’s temperature response to a step load input.
An arbitrary load can always be approximated by a superposition
of step loads. The borefield’s response to
the load is then calculated by superposition of the step responses
using the linearity property of the heat diffusion
equation. The most famous example of HSRM
for borefields is probably the g-function of Eskilson
[1]. The major challenge of this approach is to obtain a
HSRM which is valid for both minute-based and year-based
simulations. To tackle this problem, a HSRM
has been implemented. A long-term response model
(LTM) is implemented in order to take into account
the interaction between the boreholes and the ground
temperature evolution of the surrounding ground. A
short-term response model is implemented in order to
describe the transient heat flux in the BHX to the surrounding
ground. The two models are merged into one
HSRM in order to achieve both short- and long-term
accuracy. Finally an aggregation method is implemented to speed up the calculation.
</p>

<h5>Long-term response model</h5>
<p>
The long-term temperature response of the borefield
is calculated using the analytical model of Javed (2012).
</p>
<p>
The model is based on the spatial superposition of
finite line-sources of equal length, each representing
one borehole of the borefield. The finite line-source
is calculated from the convolution of a point source of
constant power along the depth of the borefield. The
mirror of the solution at z=0 is subtracted to ensure
that zero temperature gradient at the boundary between the air and the ground. After several mathematical manipulations
to simplify the calculation, Javed and Claesson
obtain the following compact expression for the mean
borehole wall temperature:
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/HeatExchangers/Borefield/UsersGuide/Images/analyticalSolution.png\" />
</p>

where q<sub>0</sub> is the heat flux per meter length, lambda is the
ground heat conductivity, alpha is the ground heat diffusivity, N is the number of boreholes and H
is the depth of the borefield. I<sub>ls</sub> and r<sub>i</sub> are defined by the following equations:
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/HeatExchangers/Borefield/UsersGuide/Images/analyticalSolution2.png\" />
</p>
with erf the error function.
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/HeatExchangers/Borefield/UsersGuide/Images/analyticalSolution3.png\" />
</p>
where r<sub>b</sub> is the borehole radius and (x<sub>i</sub>,y<sub>i</sub>) are the spatial
coordinates of the center of each borehole from an arbitrary
reference point.

The analytical solution is valid only for time > 5*r<sub>b</sub>/alpha, i.e after the transient part
of the heat transfer through the BHX is completed.
</p>

<h5>Short-term response model</h5>
<p>
The short-term response model (STM) should be able
to calculate the transient thermal response of the HCF,
the grout and the surrounding ground accurately for
time periods ranging from minutes to t = 5*r<sub>b</sub>/alpha (typically
smaller than 200 hours). The interaction between the boreholes
for these short times can be neglected, therefore a single
borehole model is used.
</p>
<p>
The model is composed of a resistance-capacitive network as shown in the following figure:
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/HeatExchangers/Borefield/UsersGuide/Images/RC-model.png\" />
</p>

The different thermal resistances present in a single-U-tube borehole are calculated using the method of Bauer et al. [1]. 
The fluid-to-ground thermal resistance R<sub>b</sub> and the grout-to-grout thermal resistance R<sub>a</sub> as defined by Hellstroem [2] are calculated
using the multipole method. The multipole method is implemented in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.singleUTubeResistances\">
Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.singleUTubeResistances</a>. 
The convection resistance is calculated using the 
Dittus-Boelter correlation
as implemented in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.convectionResistance\">
Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.convectionResistance</a>. Finally, the surrounding ground 
is approximated by cylindrical layers
of a total thickness of three meters. The external side of the layer is connected to a constant temperature 
(equal to the initial ground temperature). Vertical discretization of the borehole is possible for the short-term model
as well as serial connection of boreholes but these features are not yet implemented for the hybrid borefield model.
<b>These features should therefore not yet be used</b>.
</p>


<h5>Aggregation method</h5>

<h4>Users Guide</h4>

<h4>References</h4>
<p>
D. Picard, L. Helsen.
<i> <a href=\"modelica://Buildings/Resources/Images/Fluid/HeatExchangers/Borefield/UsersGuide/2014-10thModelicaConference-Picard.pdf\">
Advanced Hybrid Model for Borefield Heat Exchanger
Performance Evaluation, an Implementation in Modelica</a></i>
Proc. of the 10th International ModelicaConference, p. 857-866. Lund, Sweden. March 2014.
</p>
<p>
S. Javed. <i> Thermal modelling and evaluation of
borehole heat transfer. </i> PhD thesis, Dep. Energy
and Environment, Chalmers University of Technology,
Göteborg, Sweden, 2012.
</p>
<p>
P. Eskilson. <i>Thermal analysis of heat extraction
boreholes.</i> PhD thesis, Dep. of Mathematical
Physics, University of Lund, Sweden, 1987.
</p>
<p>G. Hellstr&ouml;m. 
<i>Ground heat storage: thermal analyses of duct storage systems (Theory)</i>. 
Dept. of Mathematical Physics, University of Lund, Sweden, 1991.
</p>
<p>D. Bauer, W. Heidemann, H. M&uuml;ller-Steinhagen, and H.-J. G. Diersch. 
<i>Thermal resistance and capacity models for borehole heat exchangers</i>. 
International Journal Of Energy Research, 35:312&ndash;320, 2010.</p>
</html>"));

end UsersGuide;
