within Buildings.Fluid.HeatExchangers.Borefield;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;
  annotation (preferredView="info",
  Documentation(info="<html>
<p>
This package contains a borefield model. The model is able to simulate any arbitrary configuration of boreholes with both short and long-term accuracy. 
An aggregation method is used to speed up the calculations. 
</p>

<h4>How to use the model</h4>
<p>
The following paragrahs briefly describe how to use the model 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Borefield.MultipleBoreHoles\">Buildings.Fluid.HeatExchangers.Borefield.MultipleBoreHoles</a>.
</p>
<p>
All the parameter values of the model are contained in the record called <i>BfData</i>. This record is composed of three subrecords, 
namely <i>soi</i> (containing the ground thermal charachteristics), <i>fill</i> (containing the grout thermal charachteristics), 
and <i>gen</i> (containing all others parameters). The record structures and default values are in the package: 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Boreholes.Data.Records\">Buildings.Fluid.HeatExchangers.Boreholes.Data.Records</a>.
Examples of <i>soi</i>, <i>fill</i> and <i>gen</i> records 
can be found in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Boreholes.Data.SoilData\">Buildings.Fluid.HeatExchangers.Boreholes.Data.SoilData</a>,
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Boreholes.Data.FillingData\">Buildings.Fluid.HeatExchangers.Boreholes.Data.FillingData</a> and 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Boreholes.Data.GeneralData\">Buildings.Fluid.HeatExchangers.Boreholes.Data.GeneralData</a>
, respectively.
</p>

<p>
In order to use the model with the desired parameters, create and save in your own library a new <i>BfData</i> record as an extension 
of <a href=\"modelica://Buildings.Fluid.HeatExchangers.Boreholes.Data.Records.BorefieldData\">Buildings.Fluid.HeatExchangers.Boreholes.Data.Records.BorefieldData</a>. 
This records call the subrecords <i>soi</i>, <i>fill</i> and <i>gen</i>. 
Create and save also these subrecords if they do not exist yet with the right parameter values.
<b>Do not use modifiers for the records</b> as the model computes a SHA-code of the records and compare it with the 
SHA-code of a previous simulation. This enable the user to avoid the re-computation of the short-term-response 
and the aggregation matrix if this has already be done by a previous simulation.
</p>

<p>
Now that you have created your own <i>BfData</i> record, you can run your model containing a borefield using this <i>BfData</i> record. 
At the initialization of the first simulation, you will receive an error message, asking you to paste a command in the command window 
of the simulation tab. Pasting the command and pressing <i>enter</i> will call a script which computes the short-term response of the 
borefield for the given parameters and save it in a folder <i>current folder/.bfData</i>. Once this is done, you can run your model. 
For any future simulations using the same record <i>BfData</i>, you will not need to call this initialization script anymore.
<b>Do not forget to adapt the parameter <i>lenSim</i></b>. <i>lenSim</i> should be equal or bigger than the simulation length. This parameter
is used to define the number and size and the aggregation cells.
</p>

<h4>Model description</h4>
<p>A detailed description of the model can be
found in
<a href=\"modelica://Buildings/Resources/Images/Fluid/HeatExchangers/Borefield/UsersGuide/2014-10thModelicaConference-Picard.pdf\">Picard (2014)</a>.
Below, the model is briefly described.
</p>
<p>
The proposed model is a so-called hybrid step-response
model (HSRM). This type of model uses the
borefield’s temperature response to a step load input.
An arbitrary load can always be approximated by a superposition
of step loads. The borefield’s response to
the load is then calculated by superposition of the step responses
using the linearity property of the heat diffusion
equation. The most famous example of HSRM
for borefields is probably the <i>g-function</i> of Eskilson
(1987). The major challenge of this approach is to obtain a
HSRM which is valid for both minute-based and year-based
simulations. To tackle this problem, a HSRM
has been implemented. A long-term response model
is implemented in order to take into account
the interactions between the boreholes and the
temperature evolution of the surrounding ground. A
short-term response model is implemented to
describe the transient heat flux in the borehole heat exchanger to the surrounding
ground. The step-response of each model is then calculated and merged into one
in order to achieve both short- and long-term
accuracy. Finally an aggregation method is implemented to speed up the calculation.
However, the aggregation method calculates the temperature for discrete time step. In order to avoid
abrut temperature changes, the aggregation method is used to calculate the average borehole wall
temperature instead of the average fluid temperature. The calculated borehole wall temperature is then
connected to the dynamic model of the borehole heat exchanger.
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
The short-term response model should be able
to calculate the transient thermal response of the HCF,
the grout and the surrounding ground accurately for
time periods ranging from minutes to t = 5*r<sub>b</sub>/alpha (typically
smaller than 200 hours). The interaction between the boreholes
for these short times can be neglected, therefore a single
borehole model is used.
</p>
<p>
The model is composed of a resistance-capacitive network as shown by the following figure:
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/HeatExchangers/Borefield/UsersGuide/Images/RC-model.png\" />
</p>

The different thermal resistances present in a single-U-tube borehole are calculated using the method of Bauer et al. (2010). 
The fluid-to-ground thermal resistance R<sub>b</sub> and the grout-to-grout thermal resistance R<sub>a</sub> 
as defined by Hellstroem (1991) are calculated
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
<p> The following paragraphs briefly explain the aggregation method of Claessons and Javed (2012). More details can be found in 
<a href=\"modelica://Buildings/Resources/Images/Fluid/HeatExchangers/Borefield/UsersGuide/2014-10thModelicaConference-Picard.pdf\">Picard (2014)</a>
or in Claessons and Javed (2012).
</p>
<p>
The aggregation technic is based on the discrete approximation of the heat load and the superposition technic. 
Assume that the discrete load input to the borefield
is <i>Q</i> and the HCF temperature is <i>T<sub>f</sub></i> . <i>Q</i> and <i>T<sub>f</sub></i> can be
written as:
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/HeatExchangers/Borefield/UsersGuide/Images/discreteLoad.png\" />
</p>
with <i>v<sub>max</sub></i> >= <i>n</i>, <i>h</i> the discrete time-step, <i>Q</i> the discrete
load and <i>T<sub>f,step</sub></i> the response function from HSRM with
step load <i>Q<sub>step</sub></i>. Notice that the model assumes an uniform
temperature at time 0.
</p>
<p>
The idea behind this aggregation is the following:
the average boreholes wall temperature difference of the borehole system
(from an initial steady state) at <i>t = nh</i> depends
on the <i>nh</i>  load pulses which have been applied to the
borehole system from <i>t = 0</i>  to <i>nh</i> . However, the influence
of the pulses on the wall temperature decreases
the further they are from the observation time <i>nh</i> . If
the pulses happened long before the observation time,
the transient behaviour of the BHX has faded out, and
only the net energy injection of extraction of the pulse
is important. This net energy injection or extraction
will indeed increase or decrease the global temperature
of the borefield. An accurate profile of the load,
far away from the observation time, is therefore not
necessary. On the contrary, the load profile at times
close to the observation time is important because they
still influence the transient behaviour of the borefield
and immediate surrounding ground.
</p>
<p>
Claesson and Javed proposed an aggregation algorithm
grouping (i.e. taking the average of) the load
pulses and their coefficients into cells of exponentially
increasing size. The cells are themselves grouped into
<i>q</i> levels. Each level has a given number of cells <i>p<sub>max</sub></i>
and each cell of a same level contains the same amount
of load pulses <i>R<sub>q</sub></i>. The following figure illustrates the concept grafically.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/HeatExchangers/Borefield/UsersGuide/Images/aggregationCells.png\" />
</p>
After several manipulations, the wall temperature can be written as followed:
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/HeatExchangers/Borefield/UsersGuide/Images/wallTemperature.png\" />
</p>
with
<span style=\"text-decoration: overline\">Q</span><sub>v(p,q)</sub> the average load in the aggregation cell <i>(p,q)</i>, 
<span style=\"text-decoration: overline\">k</span><sub>v(p,q)</sub> * <i>R<sub>ss</sub></i> the average thermal resistance of the cell <i>(p,q)</i>.
<span style=\"text-decoration: overline\">Q</span><sub>v(p,q)</sub><span style=\"text-decoration: overline\">k</span><sub>v(p,q)</sub>*<i>R<sub>ss</sub></i>
gives then the temperature rise (or decrease) that a load which has happened at the time of cell <i>(p,q)</i> cause at the boreholes wall. Summing all the 
temperature differences gives the temperature at time <i>nh</i>.

Finally, the aggregated load has to be updated at each time step <i>n</i>. This is done as described by the following equation:
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/HeatExchangers/Borefield/UsersGuide/Images/loadAggregation.png\" />
</p>
with <span style=\"text-decoration: overline\">Q</span><sub>v(p,q)</sub><sup>(n)</sup> the average load in the aggregation cell <i>(p,q)</i> 
at time <i>nh</i> and <i>r<sub>q</sub></i> the cell width at the <i>q</i> aggregation level.


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
<p>J. Claesson and S. Javed. 
<i>A load-aggregation
method to calculate extraction temperatures of
borehole heat exchangers. 
</i>
ASHRAE Transactions,
118, Part 1, 2012.</p>
</html>"));

end UsersGuide;
