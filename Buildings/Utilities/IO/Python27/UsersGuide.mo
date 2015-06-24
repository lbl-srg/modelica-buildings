within Buildings.Utilities.IO.Python27;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;


annotation (preferredView="info",
Documentation(info="<html>
<p>
This package contains classes that call Python functions.
The classes can be used to send data to Python functions,
and to obtain data from Python functions.
This allows for example to use Python to communicate
with web services, with hardware, or to do other computations
inside a Python module.
</p>
<p>
The code has been tested with Python 2.7 on
Linux 32 bit, Linux 64 bit, and Windows 32 bit.
Windows 64 bit is currently supported if Dymola is run
as a 32 bit application.
</p>
<h4>Software configuration to use classes from this package</h4>
<p>
To use classes from this package, a Python 2.7
runtime environment must be installed.
Also, the system environment variable
<code>PYTHONPATH</code> must be set in order for Python
to find the modules that contain the functions.
These modules are stored in the directory
<code>Buildings/Resources/Python-Sources</code>.
In addition, an environment variable (<code>LD_LIBRARY_PATH</code> on Linux
and <code>PATH</code> on Windows) must be set in order for a simulation
environment to find the dynamically linked libraries.
The next sections explain how to set these variables for the
following system configurations:
</p>
  <table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
  <tr>
      <th>System</th>
      <th>Settings</th>
    </tr>
  <!-- =================================================================== -->
    <tr>
      <td>Linux 32 bit, Dymola 2014</td>
      <td>
Enter on a console the command
<pre>
  export PYTHONPATH=${PYTHONPATH}:\"Path_To_Buildings_Library\"/Resources/Python-Sources
  export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:\"Path_To_Buildings_Library\"/Resources/Library/linux32
</pre>
Alternatively, these lines could be added to the file <code>~/.bashrc</code>.
      </td>
    </tr>
    <tr>
  <!-- =================================================================== -->
      <td>Linux 64 bit, Dymola 2014</td>
      <td>
Use the same commands as for <i>Linux 64 bit, Dymola 2014</i> because Dymola 2014 only generates 32 bit code.
      </td>
    </tr>
  <!-- =================================================================== -->
    <tr>
      <td>Linux 32 bit, Dymola 2013 FD01</td>
      <td>
Enter on a console the command
<pre>
  export PYTHONPATH=${PYTHONPATH}:\"Path_To_Buildings_Library\"/Resources/Python-Sources
</pre>
Alternatively, these lines could be added to the file <code>~/.bashrc</code>.<br/>
<br/>
Next, modify <code>/opt/dymola/bin/dymola.sh</code> by replacing the line
<pre>
  export LD_LIBRARY_PATH=$DYMOLA/bin/lib
</pre>
with
<pre>
  export LD_LIBRARY_PATH=$DYMOLA/bin/lib:\"Path_To_Buildings_Library\"/Resources/Library/linux32
  export LD_LIBRARY_PATH=$DYMOLA/bin/lib:Resources/Library/linux32
</pre>
      </td>
    </tr>
  <!-- =================================================================== -->
    <tr>
      <td>Linux 64 bit, Dymola 2013 FD01</td>
      <td>
Use the same commands as for <i>Linux 32 bit, Dymola 2013 FD01</i> because Dymola 2013 FD01 only generates 32 bit code.
      </td>
    </tr>
  <!-- =================================================================== -->
    <tr>
      <td>Windows 32 bit, Dymola 2014
      <br/>Windows 64 bit, Dymola 2014
      <br/>Windows 32 bit, Dymola 2013 FD01
      <br/>Windows 64 bit, Dymola 2013 FD01 </td>
      <td>
        Add to the system environment variable <code>PYTHONPATH</code> the directory
        <code>\"Path_To_Buildings_Library\"\\Resources\\Python-Sources</code>.
      </td>
    </tr>
  <!-- =================================================================== -->
  </table>

<h4>Number of values to read to Python and write from Python</h4>
<p>
The parameters <code>nDblWri</code> (or <code>nIntWri</code> or <code>nStrWri</code>)
and <code>nDblRea</code> (or <code>nIntRea</code>) declare
how many double (integer or string) values should be written to, or read from, the Python function.
These values can be zero, in which case the Python function receives no
arguments for this data type, or it must return a list with zero elements.
However, because Modelica does not allow arrays with
zero elements, the arrays
<code>dblWri</code> and <code>dblRea</code>, respectively, must contain exactly one element
if <code>nDblWri=0</code> or <code>nDblRea=0</code>.
In this situation, <code>dblWri</code> is a dummy argument that will not be written to Python,
and <code>dblRea</code> contains a number that must not be used in any model.
</p>

<h4>Arguments of the Python function</h4>
<p>
The arguments of the python functions are, in this order,
floats, integers and strings.
If there is only one element of each data type, then a single value is passed.
If there are multiple elements of each data type, then they are stored in a list.
If there is no value of a data type (such as if <code>nDblWri=0</code>), then the argument is not present.
Thus, if a data type is not present, then the function will <i>not</i> receive an empty list of this data type.
If there are no arguments at all, then the function takes no arguments.</p>
<p>
The table below shows the list of arguments for various combinations where no,
one or two double values, integers and strings are passed as an argument to a Python function.
</p>
 <table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
  <tr> <th>nDblWri</th>   <th>nIntWri</th>  <th>nStrWri</th>  <th>Arguments</th>  </tr>
  <tr> <td>1      </td>   <td>0      </td>  <td>0      </td>  <td>1.                            </td></tr>
  <tr> <td>0      </td>   <td>1      </td>  <td>1      </td>  <td>1, \"a\"                        </td></tr>
  <tr> <td>2      </td>   <td>0      </td>  <td>2      </td>  <td>[1.0, 2.0], [\"a\", \"b\"]        </td></tr>
  <tr> <td>1      </td>   <td>1      </td>  <td>1      </td>  <td> 1.0, 2, \"a\"                  </td></tr>
  <tr> <td>1      </td>   <td>2      </td>  <td>0      </td>  <td> 1.0       , [1, 2]           </td></tr>
  <tr> <td>2      </td>   <td>1      </td>  <td>0      </td>  <td>[1.0, 2.0], 1                 </td></tr>
  <tr> <td>2      </td>   <td>2      </td>  <td>2      </td>  <td>[1.0, 2.0], [1, 2], [\"a\", \"b\"]</td></tr>
</table>
<br/>

<h4>Returns values of the Python function</h4>
<p>
The Python function must return their values in the following order:</p>
<ol>
<li>
If the function returns one or multiple double values, then the first return
value must be a double (if <code>nDblRea=1</code>) or a list of doubles
(if <code>nDblRea &gt; 1</code>).
</li>
<li>
If the function returns one or multiple integer values, then the next return
value must be an integer (if <code>nIntRea=1</code>) or a list of integers
(if <code>nIntRea &gt; 1</code>).
</li>
<li>
If <code>nDblRea = nIntRea = 0</code>, then the return values of the function, if any, are
ignored.
</li>
</ol>
<p>
The table below shows valid return types for various combinations where no, one or two double values
and integer values are returned.</p>
 <table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
  <tr> <th>nDblRea</th>   <th>nIntRea</th>  <th>Return value</th>  </tr>
  <tr> <td>1      </td>   <td>0      </td>  <td>1.                 </td></tr>
  <tr> <td>0      </td>   <td>1      </td>  <td>1                  </td></tr>
  <tr> <td>2      </td>   <td>0      </td>  <td>[1.0, 2.0]         </td></tr>
  <tr> <td>1      </td>   <td>1      </td>  <td> 1.0, 2            </td></tr>
  <tr> <td>1      </td>   <td>2      </td>  <td> 1.0      , [1, 2] </td></tr>
  <tr> <td>2      </td>   <td>1      </td>  <td>[1.0, 2.0],  1     </td></tr>
  <tr> <td>2      </td>   <td>2      </td>  <td>[1.0, 2.0], [1, 2] </td></tr>
</table>

<!-- Not yet implemented as pure functions are not supported in Dymola 2013 FD01 -->
<h4>Pure Modelica functions (functions without side effects)</h4>
<p>
The functions that exchange data with Python are implemented as <i>pure</i>
Modelica functions.
Pure functions always return the same value if called repeatedly.
If these functions are used to call hardware sensors or web services,
they need to be called from a <code>when</code>-equation.</p>
<p>
See the Modelica language specification for an explanation
of pure and impure functions.
</p>

<h4>Examples</h4>
<p>
The example
<a href=\"modelica://Buildings.Utilities.IO.Python27.Functions.Examples.Exchange\">
Buildings.Utilities.IO.Python27.Functions.Examples.Exchange</a>
contains various calls to different Python functions.
The Python functions are stored in the directory
<code>Buildings/Resources/Python-Sources</code>.
</p>
<p>
The example
<a href=\"modelica://Buildings.Utilities.IO.Python27.Examples.KalmanFilter\">
Buildings.Utilities.IO.Python27.Examples.KalmanFilter</a>
shows how to implement in a Modelica block a call to a Python function.
</p>

<h4>Implementation notes</h4>
<p>
String values cannot be returned from a Python function.
The reason is that Dymola 2013 FD01 generates a compile time error
if a Modelica function returns <code>(Real[nR], Integer[nI], String)</code>.
This will be fixed in Dymola 2014.
(Support request #14983.)
</p>
<h4>Known Issues</h4>
<p>
The Python installation of Ubuntu 14.04 has a bug that causes Dymola
to produce output of the following form:
</p>
<pre>
Traceback (most recent call last):
  File \"/usr/lib/python2.7/site.py\", line 563, in &lt;module&gt;
    main()
  File \"/usr/lib/python2.7/site.py\", line 545, in main
    known_paths = addusersitepackages(known_paths)
  File \"/usr/lib/python2.7/site.py\", line 272, in addusersitepackages
    user_site = getusersitepackages()
  File \"/usr/lib/python2.7/site.py\", line 247, in getusersitepackages
    user_base = getuserbase() # this will also set USER_BASE
  File \"/usr/lib/python2.7/site.py\", line 237, in getuserbase
    USER_BASE = get_config_var('userbase')
  File \"/usr/lib/python2.7/sysconfig.py\", line 578, in get_config_var
    return get_config_vars().get(name)
  File \"/usr/lib/python2.7/sysconfig.py\", line 524, in get_config_vars
    _init_posix(_CONFIG_VARS)
  File \"/usr/lib/python2.7/sysconfig.py\", line 408, in _init_posix
    from _sysconfigdata import build_time_vars
  File \"/usr/lib/python2.7/_sysconfigdata.py\", line 6, in &lt;module&gt;
    from _sysconfigdata_nd import *
ImportError: No module named _sysconfigdat
...(message truncated)
</pre>
<p>
As a work-around, type in a shell the commands
</p>
<pre>
$ cd /usr/lib/python2.7
$ sudo ln -s plat-x86_64-linux-gnu/_sysconfigdata_nd.py .
</pre>
<p>
See also <a href=\"https://bugs.launchpad.net/ubuntu/+source/python2.7/+bug/1115466\">
https://bugs.launchpad.net/ubuntu/+source/python2.7/+bug/1115466</a>.
</p>
</html>"));
end UsersGuide;
