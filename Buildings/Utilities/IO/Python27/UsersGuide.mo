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
Linux 32 and 64 bit and Windows 32 and 64 bit.
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
The table below explains how to set these variables for
various system configurations.
</p>
<p>
Because some Python libraries may also link to compiled C code, we
recommend that if you are using a 64-bit operating system, you configure
Dymola to generate 64 bit code. Configuring the compilation
can be done by entering on the
Dymola command line the assignment
<code>Advanced.CompileWith64=1</code> for 32-bit, or
<code>Advanced.CompileWith64=2</code> for 64-bit.
</p>
  <table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
  <tr>
      <th>System</th>
      <th>Settings</th>
   </tr>
  <!-- =================================================================== -->
    <tr>
      <td>Linux 32 bit, Dymola 2016</td>
      <td>
      <p>
      Enter on a console the commands
      </p>
<pre>
  export PYTHONPATH=${PYTHONPATH}:\"Path_To_Buildings_Library\"/Resources/Python-Sources
  export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:\"Path_To_Buildings_Library\"/Resources/Library/linux32
  </pre>
  <p>
  Alternatively, these lines could be added to the file <code>~/.bashrc</code>.
  </p>
      </td>
    </tr>
    <tr>
  <!-- =================================================================== -->
      <td>Linux 64 bit, Dymola 2016</td>
      <td>
      <p>
      Use the same commands as for <i>Linux 64 bit, Dymola 2016</i>
      because Dymola 2016 generates by default 32 bit code.
      </p>
      <p>
      However, if you load other Python libraries such as numpy, you need to make sure
      that Dymola compiles 64 bit and uses the 64 bit library from
      <code>Buildings/Resources/Library/linux64</code>.
      To do so, enter on a console the commands
      </p>
<pre>
  export PYTHONPATH=${PYTHONPATH}:\"Path_To_Buildings_Library\"/Resources/Python-Sources
  export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:\"Path_To_Buildings_Library\"/Resources/Library/linux64
  </pre>
  <p>
Alternatively, these lines could be added to the file <code>~/.bashrc</code>.</p>
<p>
Next, in the Dymola command window, set
</p>
<pre>
 Advanced.CompileWith64=2;
</pre>
      </td>
    </tr>
  <!-- =================================================================== -->
    <tr>
      <td>Linux 32 bit, Dymola 2014</td>
      <td>
Enter on a console the commands
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
Enter on a console the commands
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

<h4>Type of Python functions</h4>
<p>
Two different types of Python functions are supported: Functions that
do not need to pass Python objects between one invocation to another, and functions
that need to pass a Python object from one invocation to another.
For the first case, a Python function may be
</p>
<pre>
def returnTwiceTheInput(xR):
    return 2.*xR
</pre>
<p>
For the second case, a Python function may be
</p>
<pre>
def incrementAndReturnACounter(i, obj):
    if obj == None:
        # Initialize the Python object
        obj = {'counter': i}
    else:
        # Use the python object
        obj['counter'] = obj['counter'] + i
    return [i, obj]
</pre>
<p>
For the first case, set in the function
<a href=\"modelica://Buildings.Utilities.IO.Python27.Functions.exchange\">
Buildings.Utilities.IO.Python27.Functions.exchange</a>
the input argument <code>passPythonObject = false</code>,
and for the second case, set <code>passPythonObject = true</code>.
The second case
allows for example to build up a Python data structure (or to instantiate a Python object),
and do computations on this object at each function invocation. For example,
a Model Predictive Control algorithm or a machine learning algorithm,
implemented in Python, could be fed with data at each time step.
It could then store this data
and use the current and its historical data to feed its algorithm.
Based on this algorithm, it could output a control signal for use in another Modelica model.
</p>
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
floats, integers and strings (and the Python object if <code>passPythonObject = true</code>).
If there is only one element of each data type, then a single value is passed.
If there are multiple elements of each data type, then they are stored in a list.
If there is no value of a data type (such as if <code>nDblWri=0</code>), then the argument is not present.
Thus, if a data type is not present, then the function will <i>not</i> receive an empty list of this data type.
If there are no arguments at all, then the function takes no arguments
(except if <code>passPythonObject = true</code>, in which case the only argument is the Python object).</p>
<p>
The table below shows the list of arguments for various combinations where no,
one or two double values, integers and strings are passed as an argument to a Python function.
</p>
<ul>
<li>If <code>passPythonObject = false</code>:<br/>
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
  </li>
<li>If <code>passPythonObject = true</code>:<br/>
 <table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
  <tr> <th>nDblWri</th>   <th>nIntWri</th>  <th>nStrWri</th>  <th>Arguments</th>  </tr>
  <tr> <td>1      </td>   <td>0      </td>  <td>0      </td>  <td>1., pytObj                            </td></tr>
  <tr> <td>0      </td>   <td>1      </td>  <td>1      </td>  <td>1, \"a\", pytObj                        </td></tr>
  <tr> <td>2      </td>   <td>0      </td>  <td>2      </td>  <td>[1.0, 2.0], [\"a\", \"b\"], pytObj        </td></tr>
  <tr> <td>1      </td>   <td>1      </td>  <td>1      </td>  <td> 1.0, 2, \"a\", pytObj                 </td></tr>
  <tr> <td>1      </td>   <td>2      </td>  <td>0      </td>  <td> 1.0       , [1, 2], pytObj           </td></tr>
  <tr> <td>2      </td>   <td>1      </td>  <td>0      </td>  <td>[1.0, 2.0], 1, pytObj                 </td></tr>
  <tr> <td>2      </td>   <td>2      </td>  <td>2      </td>  <td>[1.0, 2.0], [1, 2], [\"a\", \"b\"], pytObj</td></tr>
  </table>
  <br/>
  where <code>pytObj</code> is the Python object.
  </li>
  </ul>

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
<ul>
<li>If <code>passPythonObject = false</code>:<br/>
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
  </li>
  <li>If <code>passPythonObject = true</code>:<br/>
 <table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
  <tr> <th>nDblRea</th>   <th>nIntRea</th>  <th>Return value</th>  </tr>
  <tr> <td>1      </td>   <td>0      </td>  <td>1., pytObj                 </td></tr>
  <tr> <td>0      </td>   <td>1      </td>  <td>1, pytObj                  </td></tr>
  <tr> <td>2      </td>   <td>0      </td>  <td>[1.0, 2.0], pytObj         </td></tr>
  <tr> <td>1      </td>   <td>1      </td>  <td> 1.0, 2, pytObj            </td></tr>
  <tr> <td>1      </td>   <td>2      </td>  <td> 1.0      , [1, 2], pytObj </td></tr>
  <tr> <td>2      </td>   <td>1      </td>  <td>[1.0, 2.0],  1, pytObj     </td></tr>
  <tr> <td>2      </td>   <td>2      </td>  <td>[1.0, 2.0], [1, 2], pytObj </td></tr>
  </table>
  <br/>
  where <code>pytObj</code> is the Python object.
  </li>
  </ul>

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
Various examples are provided, and for each of these, the Python functions are stored in the directory
<code>Buildings/Resources/Python-Sources</code>.
</p>
<p>
The examples
<a href=\"modelica://Buildings.Utilities.IO.Python27.Functions.Examples.Exchange\">
Buildings.Utilities.IO.Python27.Functions.Examples.Exchange</a>
and
<a href=\"modelica://Buildings.Utilities.IO.Python27.Functions.Examples.ExchangeWithPassPythonObject\">
Buildings.Utilities.IO.Python27.Functions.Examples.ExchangeWithPassPythonObject</a>
contains various calls to different Python functions without and with memory.
</p>
<p>
The example
<a href=\"modelica://Buildings.Utilities.IO.Python27.Examples.KalmanFilter\">
Buildings.Utilities.IO.Python27.Examples.KalmanFilter</a>
shows how to implement in a Modelica block a call to a Python function.
This Python function stores its memory on disk between invocations (which,
in general, is not recommended).
</p>
<p>
The example
<a href=\"modelica://Buildings.Utilities.IO.Python27.Examples.SimpleRoom\">
Buildings.Utilities.IO.Python27.Examples.SimpleRoom</a>
shows a similiar example. However, rather than using a file to store the
room temperature and energy between invocations, the function returns
an object with this information, and receives this object again in the next invocation.
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
