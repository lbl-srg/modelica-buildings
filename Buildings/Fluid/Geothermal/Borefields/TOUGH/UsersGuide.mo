within Buildings.Fluid.Geothermal.Borefields.TOUGH;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;

  annotation (preferredView="info",
  Documentation(info="<html>
<p>
This package contains models demonstrating the co-simulation coupling between Modelica
and <a href=\"https://tough.lbl.gov/software/tough3\">TOUGH 3</a>.
</p>
<p>
The model <a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.TOUGH.OneUTube\">
Buildings.Fluid.Geothermal.Borefields.TOUGH.OneUTube</a> assumes that in the
borefield, all the boreholes have the same heat transfer with the ground, with the ground
thermal response being simulated by the TOUGH simulator through
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.TOUGH.BaseClasses.GroundResponse\">
Buildings.Fluid.Geothermal.Borefields.TOUGH.BaseClasses.GroundResponse</a>.
</p>
<p>
Note that for this co-simulation, the TOUGH 3 simulator must be installed.
However, for demonstration purpose, the test models in this package calls a
code that imitates the TOUGH response.
</p>

<h4>When to use the model</h4>
<p>
TOUGH 3 simulations are needed for modeling geothermal energy
systems in which the underground geologic is complicated. For instance, when there
is strong underground waterflow, other models such as those based on g-functions
that assume heat transfer in the ground is purely by conduction are less
accurate as these g-function based models do not model the advective heat tranfer due to the water flow.
</p>

<h4>How the coupling works</h4>
<p>
The coupling is conducted through the instance <code>pyt</code> in the class
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.TOUGH.BaseClasses.GroundResponse\">
Buildings.Fluid.Geothermal.Borefields.TOUGH.BaseClasses.GroundResponse</a>.
It instantiates the Python interface model
<a href=\"modelica://Buildings.Utilities.IO.Python_3_8.Real_Real\">
Buildings.Utilities.IO.Python_3_8.Real_Real</a>, which can send data to Python
functions and obtain data from it. It allows doing the computations inside a Python
module that calls an external simulator, in this package the TOUGH 3 simulator.
</p>
<h5>Python interface</h5>
<p>
Through the interface instance as below,
</p>
<pre>    
  Buildings.Utilities.IO.Python_3_8.Real_Real pyt(
    final moduleName=\"GroundResponse\",
    final functionName=\"doStep\",
    final nDblRea=nSeg+3*nInt,
    final nDblWri=2*nSeg + 6,
    final samplePeriod=samplePeriod,
    final flag=0,
    final passPythonObject=true)
</pre>
<p>
the coupled simulation calls the function
<code>doStep</code> of the Python module <code>GroundReponse</code>.
The interface specifies through <code>nDblRea</code> the number of values that are read from the Python function,
and through <code>nDblWri</code> the number of values written to the Python function.
The argument <code>samplePeriod</code> defines the sampling period, and <code>flag</code>
configures whether to use the current value, an average over the interval, or
the integral over the interval. By setting the parameter <code>passPythonObject</code>
to <code>true</code>, it allows passing a Python object from one invocation to
another, thus builds up a Python data structure.
More explanation about the Python setup can be found in
<a href=\"modelica://Buildings.Utilities.IO.Python_3_8.UsersGuide\">
Buildings.Utilities.IO.Python_3_8.UsersGuide</a>.
</p>
<p>
The above interface calls the Python function <code>doStep</code> as showing below,
where only the major sections are demonstrated:
</p>
<pre>
  def doStep(dblInp, state):
    # retrieve state of last invoke, including
    #   -- the end time of the TOUGH simulation,
    #   -- the heat flow on the borehole wall that was measured in Modelica at last invoke,
    #   -- the borehole wall temperature at the end of last TOUGH simulation.
    {tLast, Q, T_tough} = {state['tLast'], state['Q'], state['T_tough']}
    
    # Map the heat flow in the Modelica domain mesh points (borehole segments)
    # to the TOUGH boundary mesh point
    Q_toTough = mesh_to_mesh(toughLayers, modelicaLayers, state['Q'], 'Q_Mo2To')

    # update TOUGH input files for each TOUGH call:
    #   -- update the INFILE to specify begining and ending TOUGH simulation time
    #   -- update the GENER for specifying the heat flow boundary condition
    write_incon()

    # conduct one step TOUGH simulation
    os.system(\"/.../tough3-install/bin/tough3-eos1\")

    # extract borehole wall temperature from TOUGH simulation result, for Modelica simulation
    read_save()

    data = extract_data('out.txt', nTouSeg, nInt)
    T_tough = data['T_Bor']
    
    # Map the temperature of the borehole wall in the TOUGH mesh points to
    # the Modelica domain mesh point
    T_toModelica = mesh_to_mesh(toughLayers, modelicaLayers, T_tough, 'To2Mo')
    
    # Outputs to Modelica, including the results of the interested ground points
    ToModelica = T_toModelica + data['p_Int'] + data['x_Int'] + data['T_Int']

    # update state
    state = {'tLast': tim, 'Q': Q, 'T_tough': T_tough}
  return [ToModelica, state]
</pre>

<p>
The argument <code>dblInp</code> to the Python function is an array with size <code>nDblWri</code>.
It inclues:
</p>
<ul>
<li>
<code>nSeg</code>: The total number of borehole segments.
</li>
<li>
<code>nTouSeg</code>: In TOUGH mesh, the total number of mesh points that covers
the entire borehole length.
</li>
<li>
<code>nInt</code>: The total number of interested points in the TOUGH mesh.
</li>
<li>
<code>QBor_flow[nSeg]</code>: The heat exchange flow rate between each borehole segment
and the ground.
</li>
<li>
<code>TBorWal_start[nSeg]</code>: The initial temperature of each borehole wall segement.
</li>
<li>
<code>TOut</code>: The outdoor air temperature. It will become the ground surface
temperature for the TOUGH simulation.
</li>
<li>
<code>clock.y</code>: The current simulation time.
</li>
<li>
<code>hBor</code>: The total height of the borehole.
</li>
</ul>

<h5>Coupling workflow</h5>
<p>
The borehole wall is the boundary between the Modelica simulation and the TOUGH simulation.
Modelica provides the heat flow rate through the wall as the boundary condition
for TOUGH, and TOUGH returns the wall temperature
as the boundary condition for Modelica.
The flow chart below shows the overall coupling workflow at each time step.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/Borefields/TOUGH/workFlow.png\" width=\"2000\"/>
</p>
<p>
When the Modelica variable <code>sampleTrigger</code>
(see <a href=\"modelica://Buildings.Utilities.IO.Python_3_8.Real_Real\">
Buildings.Utilities.IO.Python_3_8.Real_Real</a>) is <code>true</code>, Modelica calls the
TOUGH simulation through the ground response model as described above.
Through the function <code>doStep</code>, the Python module sends to TOUGH the heat
flow rates from the ground <code>QBor_flow</code>, the ambient
air temperature <code>TOut</code> and the current simulation time. 
The following steps are done inside the Python function:
</p>
<ol>
<li>
In the first invocation of Python function, the Python object is not yet initialized.
The Python function therefore takes the initial temperature from Modelica to initialize
the Python object.
</li>
<li>
Before each TOUGH simulation, the function <code>write_incon()</code> edits the
TOUGH input files in
<<code>\"Path_To_Buildings_Library\"/Resources/Python-Sources/TOUGH</code>>:
<ul>
<li>
<code>writeincon.inp</code>: It contains the initial borehole wall temperature,
initial ground surface temperature, and the heat flow rate. The borehole wall
temperature will be replaced with the borehole wall temperature stored in the
<code>state</code>. The surface temperature will be replaced by current outdoor
temperature <code>TOut</code>. The heat flow rate is
the one computed by the Modelica mode, <code>QBor_flow[nSeg]</code>.
</li>
<li>
<code>INFILE</code>: It is a structured, keyword-based file that contains TOUGH
simulation settings like the ground material properties and the simulation parameters.
The simulation times will be edited in the way that the start time is replaced by
the one stored in the <code>state</code> and the stop time is replaced by the current
simulation time <code>clock.y</code>.
</li>
<li>
<code>INCON</code>: It contains the initial conditions of all the TOUGH mesh
points, including the borehole wall and surface mesh points, of which the temperature
will be repalced by the one in <code>writeincon.inp</code>.
</li>
<li>
<code>GENER</code>: It includes the heat flow rate from the borehole hole
segments to the ground. It will be updated with the one in <code>writeincon.inp</code>.
The file does not exist initially but will be created and then updated after the
first invocation.
</li>
</ul>
</li>
<li>
Then a TOUGH simulation is started.
</li>
<li>
After the TOUGH simulation is done, with the function <code>read_save()</code>, it
extracts the borehole wall temperature, and if needed also the temperature of ground
on the interested points, from TOUGH simulation result file <code>SAVE</code>.
</li>
<li>
Update <code>state</code> to store the TOUGH simulation stop time, the heat flow
from the borehole wall to ground which is measured by Modelica, and the
new borehole wall temperatures at each section.
</li>
</ol>

<h4>Assumptions</h4>
<p>
This implementation of TOUGH is based on the following assumptions:
</p>
<ul>
<li>
All boreholes are connected in parallel.
</li>
<li>
All boreholes are uniformly distributed and the distances between them are the same.
</li>
<li>
All boreholes have the same inlet water flow rate and temperature.
</li>
<li>
All boreholes have the same length, the same radius, and are buried at the same
depth below the ground surface.
</li>
<li>
The conductivity, capacitance and density of the grout and pipe material are
constant, homogeneous and isotropic.
</li>
<li>
Inside the borehole grout, the heat conduction is only in the radial direction.
</li>
<li>
Each borehole assumes to have multiple segments and each segment has a uniform
temperature.
</li>
</ul>

<h4>How to use the model</h4>
<h5>Setup TOUGH files</h5>
<p>
A mesh file (<code>MESH</code>) for the simulation domain should be prepared for the
TOUGH simulation and the simulation domain should be initialized (<code>INCON</code>).
It also requires the <code>INFILE</code> to specificy the ground properties and to
set the start and end simulation time. Please see TOUGH manual of how to setup the
inputs files.
</p>
<h5>Update Python Module</h5>
<p>
The program <code>GroundReponse</code> should be updated if there is change in the TOUGH inputs
files <code>MESH</code> and <code>INFILE</code>. The reason is that the Python
script hardcodes the position of the nodes in the <code>MESH</code> and <code>INFILE</code>.
In particular the assumption is that all the relevant nodes, which are the ones next
to the borehole wall and the ones of the interested ground point, are at the top of
<code>MESH</code> and <code>INFILE</code>. The sub-functions that need to be updated
are:
</p>
<ul>
<li>
<code>modelica_mesh</code>: This function finds the size of the Modelica mesh.
</li>
<li>
<code>mesh_to_mesh</code>: This function maps the mesh difference between TOUGH and
Modelica and calculates <code>T</code> and <code>Q</code> for the respective nodes.
The code assumes that the <code>MESH</code> is bidimensional on the x-z axis.
If a different type of mesh is used (i.e. radial), following two functions also need to
be updated.
</li>
<li>
<code>find_layer_depth</code>: This function finds the depth of the borehole.
</li>
<li>
<code>add_grid_boundary</code>: This function finds the bounds of the TOUGH mesh.
</li>
</ul>
<p>
In order to test the changes, the Python script can be used without Modelica and
simply calling the <code>doStep</code> function with dummy <code>Q</code> inputs.
</p>
<h5>Example</h5>
<p>
The class
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.TOUGH.Examples.Borefields\">
Buildings.Fluid.Geothermal.Borefields.TOUGH.Examples.Borefields</a>
shows the comparisons between the g-function based ground response model and the
TOUGH ground response model.
In the case when the TOUGH simulator is not installed, for the demonstration purpose
the Python interface model includes a dummy code to imitate the TOUGH response for
updating the ground temperatures, <code>def tough_avatar(heatFlux, T_out)</code>.
</p>
<pre>
def tough_avatar(heatFlux, T_out):
    totEle = len(heatFlux)
    # Generate temperature of the ground elements and the interested points
    fin = open('SAVE')
    fout = open('temp_SAVE', 'wt')
    
    # based on the old results \"SAVE\", created new results file \"temp_SAVE\"
    ......

    # remove the old SAVE file
    os.remove('SAVE')
    os.rename('temp_SAVE', 'SAVE')
</pre>

<h4>References</h4>
<p>
J. Hu, C. Doughty, P. Dobson, P. Nico, M. Wetter.
<i>Coupling subsurface and above-surface models for design of borefields and
geothermal district heating and cooling systems.</i>
Proceedings, 45th Workshop on Geothermal Reservior Engineering.
<a href=\"https://pangea.stanford.edu/ERE/db/GeoConf/papers/SGW/2020/Hu.pdf\">
https://pangea.stanford.edu/ERE/db/GeoConf/papers/SGW/2020/Hu.pdf</a>.
</p>

</html>"));
end UsersGuide;
