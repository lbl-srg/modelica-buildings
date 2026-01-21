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
    moduleName=\"GroundResponse\",
    functionName=\"doStep\",
    nDblRea=nSeg+3*nInt,
    nDblWri=2*nSeg+2,
    samplePeriod=samplePeriod,
    flag=flag,
    passPythonObject=true)
</pre>
<p>
the coupled simulation calls the function
<code>doStep</code> of the Python module <code>GroundReponse</code>.
The interface specifies through <code>nDblRea</code> the number of values that are read from the Python function,
and through <code>nDblWri</code> the number of values written to the Python function.
The argument <code>samplePeriod</code> defines the sampling period, and <code>flag</code>
configures whether to use the current value, an average over the interval, or the integral over the
interval.
More explanation about the Python setup can be found in
<a href=\"modelica://Buildings.Utilities.IO.Python_3_8.UsersGuide\">
Buildings.Utilities.IO.Python_3_8.UsersGuide</a>.
</p>
<p>
The above interface calls the Python function <code>doStep</code>, which is implemented as
</p>
<pre>
  def doStep(dblInp, state):
    # retrieve state of last invoke, including
    #   -- the end time of the TOUGH simulation,
    #   -- the heat flow on the borehole wall that was measured in Modelica at last invoke,
    #   -- the borehole wall temperature at the end of last TOUGH simulation.
    {tLast, Q, T} = {state['tLast'], state['Q'], state['T']}
    
    # Map the heat flow in the Modelica domain grid points to the TOUGH boundary
    # grid point
    Q_toTough = mesh_to_mesh(toughLayers, modelicaLayers, state['Q'], 'Q_Mo2To')

    # update TOUGH input files for each TOUGH call:
    #   -- update the INFILE to specify begining and ending TOUGH simulation time
    #   -- update the GENER for specifying the heat flow boundary condition
    # os.system(\"./writeincon < writeincon.inp\")
    write_incon()

    # conduct one step TOUGH simulation
    os.system(\"/.../tough3-install/bin/tough3-eos1\")

    # extract borehole wall temperature for Modelica simulation
    # os.system(\" ./readsave < readsave.inp > out.txt\")
    readsave()

    data = extract_data('out.txt')
    T_tough = data['T_Bor']
    
    # Map the temperature of the borehole wall in the TOUGH grid points to
    # the Modelica domain grid point
    T_toModelica = mesh_to_mesh(toughLayers, modelicaLayers, T_tough, 'To2Mo')

    # update state
    state = {'tLast': tim, 'Q': Q, 'T': T_tough}
  return [T_toModelica, state]
</pre>

<p>
The argument <code>dblInp</code> to the Python function is an array with size <code>nDblWri</code>.
It inclues:
</p>
<ul>
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
</ul>

<h5>Coupling workflow</h5>
<p>
The borehole wall
is the boundary between the Modelica simulation and the TOUGH simulation.
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
The Python module sends to TOUGH the heat flow rates from the ground <code>QBor_flow</code>,
the initial borehole wall temperature <code>TBorWal_start</code>, the ambient
air temperature <code>TOut</code> and the current simulation time. 
Then, the following steps are done inside the Python function:
</p>
<ol>
<li>
In the first invocation of Python, this object is not yet initialized. Python
therefore takes the initial temperature from Modelica to initialize the object.
</li>
<li>
The function <code>write_incon</code> updates the TOUGH input files.
Note that the initial input files are in
<code>\"Path_To_Buildings_Library\"/Resources/Python-Sources/TOUGH</code>:
<ul>
<li>
<code>writeincon.inp</code>: This file contains the initial borehole wall temperature and 
the heat flow rate. The initial borehole wall temperature will be updated with the
borehole wall temperature stored in the state. The heat flow rate is the heat flow rate
computed by the Modelica model.
</li>
<li>
<code>INFILE</code>: The start and stop TOUGH simulation time will be updated.
The start time is the one stored in the state. The stop time is the current
simulation time.
</li>
<li>
<code>INCON</code>: This file has the same format as the TOUGH output file <code>SAVE</code>. But
the initial borehole wall temperature will be updated with the one in <code>writeincon.inp</code>.
</li>
<li>
<code>GENER</code>: This file defines the heat flow rate of the borehole hole. It will
be updated with the one in <code>writeincon.inp</code>.
</li>
</ul>
</li>
<li>
Then a TOUGH simulation is started.
</li>
<li>
After the TOUGH simulation is done, with the function <code>readsave</code>, it
extracts the borehole wall temperature, and if needed also the temperature of ground
on the interested points, from TOUGH simulation result file <code>SAVE</code>.
</li>
<li>
Update the state to store the TOUGH simulation stop time, the heat flow
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
