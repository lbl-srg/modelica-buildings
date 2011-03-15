within Buildings.HeatTransfer;
package UsersGuide "User's Guide"

  annotation (DocumentationClass=true, Documentation(info="<html>
The package <code>Buildings.HeatTransfer</code> consists of models
for heat transfer.
The models have the same interface as models of the package
<a href=\"Modelica:Modelica.Thermal.HeatTransfer\">Modelica.Thermal.HeatTransfer</a>.
</p>
<p>
This user's guide describes the model structure and how to instantiate
models for heat transfer calculations.
</p>

<h4>Model Structure</h4>
<p>
The models that compute heat transfer in solids consist of data records for
the materials and of models that compute the heat transfer.
The data records are composed hierarchically and consist of
data records that define material properties with thermal storage
(<a href=\"modelica://Buildings.HeatTransfer.Data.Solids\"\\>
Buildings.HeatTransfer.Data.Solids</a>)
and of material properties of thermal resistors with no heat storage
(<a href=\"modelica://Buildings.HeatTransfer.Data.Resistances\"\\>
Buildings.HeatTransfer.Data.Resistances</a>).
These records are used to assemble layers that define
the thermal properties of constructions
(<a href=\"modelica://Buildings.HeatTransfer.Data.OpaqueConstructions\"\\>
Buildings.HeatTransfer.Data.OpaqueConstructions</a>).
</p>
<p>
This layer definition is then used in models that compute the heat conduction.
Like the materials, these models are assembled hierarchically.
The simplest model is
<a href=\"modelica://Buildings.HeatTransfer.ConductorSingleLayer\"\\>
Buildings.HeatTransfer.ConductorSingleLayer</a>
for heat conduction through a single layer of material.
If the material's specific heat capacity is non-zero, then the model
solves the Fourier equation
</p>
<p align=\"center\" style=\"font-style:italic;\">
dT &frasl; dt = k &frasl; (&rho; c) d<sup>2</sup>T &frasl; dx<sup>2</sup>
</p>
<p>
If <i>&rho; c=0</i>, then the model computes steady-state heat conduction
</p>
<p align=\"center\" style=\"font-style:italic;\">
  Q = A k  (T<sub>a</sub>-T<sub>b</sub>)
</p>
<p>
The boundary conditions for
this model are the temperatures and heat flow rates at the material interface.
</p>
<p>
The model <a href=\"modelica://Buildings.HeatTransfer.ConductorSingleLayer\"\\>
Buildings.HeatTransfer.ConductorSingleLayer</a>
is then used to construct the heat conductor 
<a href=\"modelica://Buildings.HeatTransfer.ConductorMultiLayer\"\\>
Buildings.HeatTransfer.ConductorMultiLayer</a>
that has multiple layers of material. 
Some layers may be computed transient (if <i>&rho; c &gt; 0</i>)
and others are computed steady-state.
The boundary conditions for
this model are its surface temperatures and heat flow rates.
</p>
<p>
The model 
<a href=\"modelica://Buildings.HeatTransfer.ConductorMultiLayer\"\\>
Buildings.HeatTransfer.ConductorMultiLayer</a>
is then used to build the construction
<a href=\"modelica://Buildings.HeatTransfer.ConstructionOpaque\"\\>
Buildings.HeatTransfer.ConstructionOpaque</a> that consists
of <a href=\"modelica://Buildings.HeatTransfer.ConductorSingleLayer\"\\>
Buildings.HeatTransfer.ConductorSingleLayer</a> with a model for convective heat transfer at each side.
To model convective heat transfer, instances of the model
<a href=\"modelica://Buildings.HeatTransfer.Convection\"\\>
Buildings.HeatTransfer.Convection</a> are used, which allow
using a convective heat transfer coefficient that is fixed
or that is a function of the temperature difference between the
solid surface and the fluid.
</p>

<h4>Definition of Materials and Constructions</h4>
<p>
This section describes how to specify materials, and how to instantiate
models that compute the heat transfer.
The section describes the syntax used to declare heat conduction models.
Note that such syntax is typically generated through the use
of a graphical user interface that will show fields that can be edited
and that provide options for predefined data that may be used as-is or 
adjusted for a particular building.
</p>
<p>
Suppose we want to model a construction with a surface area of 
<i>20 m<sup>2</sup></i> 
that consists of a <i>0.1 m</i> insulation and
<i>0.2 m</i> concrete. This can be accomplished as follows.
</p>

<h5>Definition of Materials</h5>
<p>
First, we define the materials as
</p>
<pre>
  Buildings.HeatTransfer.Data.Solids.InsulationBoard insulation(x=0.1, nStaRef=4);
  Buildings.HeatTransfer.Data.Solids.Concrete concrete(x=0.2, nStaRef=4);
</pre>
<p>
Here, we selected to use four state variables for each material layer.
</p>
<p>
Next, we define the construction. In the room model, the convention is that the first material
layer faces the outside, and the last material layer faces the room-side.
Therefore, the declaration for an exterior wall with insulation at the outside is
</p>
<pre>
  Buildings.HeatTransfer.Data.OpaqueConstructions.Generic 
     wall(nLay=2, material={insulation,concrete});
</pre>
<p>
(Note that <code>nLay</code> must be set to the number of layers to allow
a Modelica translator to know how many layers there are prior to translating
the model.) 
</p>
<p>
Alternatively, to model the insulation in steady-state, we can set its heat capacity to zero by declaring
</p>
<pre>
  Buildings.HeatTransfer.Data.Solids.InsulationBoard insulation(c=0, x=0.1, nStaRef=4);
</pre>
<p>
Instead of specifying a material with specific heat capacity and setting <code>c=0</code>,
materials from the library 
<a href=\"modelica://Buildings.HeatTransfer.Data.Resistances\">
Buildings.HeatTransfer.Data.Resistances</a> can be used. 
For example, for a floor with carpet, the declaration would be
</p>
<pre>
  Buildings.HeatTransfer.Data.Resistances.Carpet carpet;
  Buildings.HeatTransfer.Data.Solids.Concrete    concrete(x=0.2, nStaRef=4);
  Buildings.HeatTransfer.Data.OpaqueConstructions.Generic 
       floor(nLay=2, material={concrete, carpet});
</pre>
<p>
To change the thermal resistance, we could have written
</p>
<pre>
  Buildings.HeatTransfer.Data.Resistances.Carpet carpet(R=0.3);
</pre>
<p>
or
</p>
<pre>
  Buildings.HeatTransfer.Data.Resistances.Generic carpet(R=0.3);
</pre>
<p>
Both definitions are identical.
</p>

<h5>Definition of Construction with Convective Heat Transfer Coefficients</h5>
<p>
If we want to use a construction that includes convective heat transfer coefficients, 
and that conists of the material <code>floor</code> defined above,
we can define
</p>
<pre>
  Buildings.HeatTransfer.ConstructionOpaque floorConstruction(
    A=10,
    layers = floor);
</pre>
<p>
In the above example, <code>carpet</code> is the material near 
<code>port_a</code> and 
<code>concrete</code> is the material near <code>port_b</code>. 
</p>
<p>
Alternatively, the layers of materials can be defined directly when 
instanciating the model that computes the heat conduction. 
For example,
<pre>
  Buildings.HeatTransfer.ConstructionOpaque floorConstruction(
    A=10,
    steadyStateInitial=true,
    redeclare Buildings.HeatTransfer.Data.OpaqueConstructions.Concrete200
      layers(
        material={Data.Solids.Concrete(x=0.30, nStaRef=4)}),
    redeclare function qCon_a_flow = 
        Buildings.HeatTransfer.Functions.ConvectiveHeatFlux.ceiling,
    redeclare function qCon_b_flow = 
        Buildings.HeatTransfer.Functions.ConvectiveHeatFlux.floor);
</pre>
<p>
This defines a floor with <i>10 m<sup>2</sup></i> area. 
It will be initialized at
steady-state. For the layers of materials, we used 
one layer of <code>Concrete200</code>, and redefined
its thickness to <i>x=0.3 m</i>. We also changed the number
of state variables that are used for the spatial discretization
of the term <i>d<sup>2</sup>T &frasl; dx<sup>2</sup></i> 
when solving the transient 
heat conduction in this layer of material.
To compute the convective heat transfer, we chose  
to use buoyancy-driven equations for the floor 
(which is at surface b and hence assigned to <code>qCon_b_flow</code>) 
and the ceiling, which is at surface a.
</p>

<h5>Definition of Construction without Convective Heat Transfer Coefficients</h5>
<p>
If we are interested in modeling heat transfer through the construction
without taking into account the convective heat transfer, we can define a construction model as
</p>
<pre>
  Buildings.HeatTransfer.ConductorMultiLayer conMul(A=20, layers=wall)
    \"Construction with 20 m2 area\";
</pre>
<p>
Since there is already a predefined construction with the same material
thickness in the library, we could have used the following identical definition:
</p>
<pre>
  Buildings.HeatTransfer.ConductorMultiLayer wall(A=20,
    redeclare 
      Buildings.HeatTransfer.Data.OpaqueConstructions.Insulation100Concrete200 layers);
</pre>
</html>"));

end UsersGuide;
