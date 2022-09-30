within Buildings.Fluid.Geothermal.Borefields.TOUGHResponse;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;

  annotation (preferredView="info",
  Documentation(info="<html>
<p>
This package contains models demonstrating the coupling between Modelica simulation
and TOUGH simulation.
</p>
<h4>Python interface</h4>
<p>
The coupling is conducted through the instance <code>pyt</code> in 
class <a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.TOUGHResponse.BaseClasses.GroundResponse\">
Buildings.Fluid.Geothermal.Borefields.TOUGHResponse.BaseClasses.GroundResponse</a>.
It instantiates the Pyhton
interface model <a href=\"modelica://Buildings.Utilities.IO.Python_3_8.Real_Real\">
Buildings.Utilities.IO.Python_3_8.Real_Real</a>, which can send data to Python
functions and obtain data from it. It allows doing the computations inside a Python
module that calls an external simulator like TOUGH.
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
Through the interface instance as above, the coupled simulation calls the module
<code>doStep</code> of the Python function <code>GroundReponse</code> (see
<a href=\"modelica://Buildings.Utilities.IO.Python_3_8.UsersGuide\">
Buildings.Utilities.IO.Python_3_8.UsersGuide</a> for how to setup the Python interface).
The interface also specifies the number of values that are read from (<code>nDblRea</code>)
and written to <code>nDblWri</code> the Python function; sample period <code>samplePeriod</code>
that defines how often Modelica should call the Python interface; flag (<code>flag</code>)
that specifies the type values (current value, average over interval, or integral over
interval) written to the Python function.
</p>
<pre>
  def doStep(dblInp, state):
      # retrieve state of last invoke
      {tLast, Q, T} = {state['tLast'], state['Q'], state['T']}
      # update TOUGH input files for each TOUGH call
      os.system(\"./writeincon < writeincon.inp\")
      # conduct one step TOUGH simulation
      os.system(\"/.../tough3-install/bin/tough3-eos1\")
      # extract borehole wall temperature for Modelica simulation
      os.system(\"./readsave < readsave.inp > out.txt\")
      T = borehole_temperature('out.txt')
      # update state
      state = {'tLast': tim, 'Q': Q, 'T': T}
  return [T, state]
</pre>

<p>
The argument <code>dblInp</code> to the Python function is an array with size <code>nDblWri</code>.
It inclues:
</p>
<ul>
<li>
<code>QBor_flow[nSeg]</code>: the heat exchange flow rate between each borehole segment
and the ground.
</li>
<li>
<code>TBorWal_start[nSeg]</code>: the initial temperature of each borehole wal segement.
</li>
<li>
<code>TOut</code>: the outdoor air temperature. It will become the ground surface temperature for
the TOUGH simulation.
</li>
<li>
<code>clock.y</code>: the current simulation time.
</li>
</ul>
<h4>Coupling workflow</h4>
<p>
The flow chart below shows the overall workflow of the coupling.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/Borefields/TOUGHResponse/workFlow.png\" width=\"1200\"/>
</p>
<p>
When the Modelica variable <code>sampleTirgger</code> is true, Modelica calls the
Python module that invokes heat flow rates from the ground <code>QBor_flow</code>,
the initial borehole wall temperature <code>TBorWal_start</code>, the ambient
air temperature <code>TOut</code> and the current simulation time. 
</p>
<ol>
<li>
In the first invocation of Python, this object is not yet initialized. Python therefore takes
the initial temperature from the Modelica to initialize the object.
</li>
<li>
With the utility program <code>writeincon</code>, it then updates the TOUGH input files.
Note that the initial input files are in <code>\"Path_To_Buildings_Library\"Resources/Python-Sources/ToughFiles</code>:
<ul>
<li>
<code>writeincon.inp</code>: the file contains the initial borehole wall temperature and 
the heat flow rate. The initial brehole wall temperature will be updated with the
borehole wall temperature stored in the state. The heat flow rate is the heat flow rate
measured in the Modelica model.
</li>
<li>
<code>INFILE</code>: the start and stop TOUGH simulation time will be updated. The start time is the one
stored in the state. The stop time is the current simulation time.
</li>
<li>
<code>INCON</code>: it has the same format as the TOUGH output file <code>SAVE</code>. But
the initial borehole wall will be updated with the one in <code>writeincon.inp</code>.
</li>
<li>
<code>GENER</code>: the file defines the heat flow rate on the borehole hole. It will
be updated with the one in <code>writeincon.inp</code>.
</li>
</ul>
</li>
<li>
Then it invokes TOUGH simulator.
</li>
<li>
With the utility program <code>readsave</code>, it extracts the borehole wall temperature and
the temperature of ground on the interested points.
</li>
<li>
Update the state
</li>
</ol>

<p>
The utility program are written in Fortran and
the source code are in <code>\"Path_To_Buildings_Library\"/Resources/src/Fluid/Geothermal</code>.
</p>

<h4>Simulation domain</h4>
<p>Assumptions</p>
<ul>
<li>
Boreholes are connected in parallel.
</li>
<li>
Boreholes are uniformly distributed and the distances between them are the same.
</li>
<li>
All boreholes have the same inlet water flow rate and temperature.
</li>
<li>
All boreholes have the same length, the same radius, and are buried at the same depth below the ground surface.
</li>
<li>
The conductivity, capacitance and density of the grout and pipe material are constant, homogeneous and isotropic.
</li>
<li>
Inside the borehole, the non-advective heat transfer is only in the radial direction.
</li>
<li>
The borehole length can be divided into multiple segments.
</li>
<li>
Each borehole has multiple segments and each segment has a uniform temperature.
</li>
</ul>
<p>TOUGH setup</p>
<ul>
<li>
Mesh generation
</li>

<li>
Initial condition
</li>

<li>
Pressure boundary
</li>
</ul>
  
<h4>Example setup</h4>
  
  
  
</html>"));
end UsersGuide;
