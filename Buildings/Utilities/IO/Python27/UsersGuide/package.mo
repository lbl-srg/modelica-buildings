within Buildings.Utilities.IO.Python27;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;


annotation (Documentation(info="<html>
<p>
This package contains classes that call Python functions.
The classes can be used to send data to Python functions,
and to obtain data from Python functions.
This allows for example to use Python to communicate
with web services, with hardware, or to do other computations
inside a Python module.
</p>
<h4>Software requirements and configuration</h4>
<p>
To use classes from this package, a Python
runtime environment must be installed.
The code has been tested with Python 2.7 on
Linux 32 bit, Linux 64 bit, and Windows 32 bit.
The examples of this package use Python modules
that are stored in the directory
<code>Buildings/Resources/Python-Sources</code>.
Therefore, to run the examples, the above directory
must be on the PYTHONPATH system variables.
Setting the PYTHONPATH can be done as follows:
<ul>
<li>
On Linux, enter on a console the command
<pre>
export PYTHONPATH=$PYTHONPATH:\"Path_To_Buildings_Library\"/Resources/Python-Sources
</pre>
Alternatively, this line could be added to the file <code>~/.bashrc</code>.
</li>
<li>
On Windows, set in System the PYTHONPATH system variable to the directory \"Path_To_Buildings_Library\"\Resources\Python-Sources
</li>
</ul>
</p>
<p>
To simulate models that use this interface, 
a dynamically linked library is needed. 
The library is in the directory
<code>Buildings/Resources/Library/\"os\"</code>,
where <code>\"os\"</code>
is 
<code>linux32</code>,
<code>linux64</code>,
<code>win32</code>.
Since on Linux, Dymola 2013 FD01 does not add these directories
to the search path for dynamically linked libraries,
a user needs to do the following so that Dymola can find
the library:
</p>
<p>
<ul>
<li>
On Linux 32 bit, run
<pre>
  sudo ln -s `pwd`/Resources/Library/linux32/libModelicaBuildingsPython2.7.so /usr/lib/libModelicaBuildingsPython2.7.so
</pre>
</li>
<li>
On Linux 64 bit, the above should also work if 32 is replaced with 64. 
However, Dymola 2013 FD01 is an exception because it generates 32 bit code even on a 64 bit computer.
We could copy the files to <code>/usr/lib</code>, but this may potentially overwrite 64 bit libraries.
A work-around is to modify <code>/opt/dymola/bin/dymola.sh</code> by replacing the line
<pre>
  export LD_LIBRARY_PATH=$DYMOLA/bin/lib
</pre>
with
<pre>
  export LD_LIBRARY_PATH=$DYMOLA/bin/lib:Resources/Library/linux32
</pre>
Then, restart Dymola and the examples should compile and simulate successfully.
If you start Dymola from a different directory than from the <code>Buildings</code> directory,
then add the full path to <code>Resources/Library/linux32</code>.
</li>
</ul>
</p>
<h4>Number of values to read to Python and write from Python</h4>
<p>
The parameters <code>nDblWri</code> (or <code>nIntWri</code> or <code>nStrWri</code>)
and <code>nDblRea</code> (or <code>nIntRea</code>) declare
how many double (integer or string) values should be written to or read from the Python function.
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
floats, integers and 
strings.
If there is only one element of each data type, then a single value is passed.
If there are multiple elements of each data type, then they are stored in a list.
If there is no value of a data type, then the argument is not present.
Thus, if a data type is not present, then the function will <i>not</i> receive an empty list of this data type.
If there are no arguments at all, then the function takes no arguments.
</p>
<p>
The table below shows the list of arguments for various combinations where no, one or two double values, integers and strings are passed as an argument to a Python function.
</p>
<p>
 <table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
  <tr> <th>nDblWri</th>   <th>nIntWri</th>  <th>nStrWri</th>  <th>Arguments</th>  </tr>
  <tr> <td>1      </td>   <td>0      </td>  <td>0      </td>  <td>1.                            </td></tr>
  <tr> <td>0      </td>   <td>1      </td>  <td>1      </td>  <td>1, \"a\"                        </td></tr>
  <tr> <td>2      </td>   <td>0      </td>  <td>2      </td>  <td>[1.0, 2.0], [\"a\", \"b\"]        </td></tr>
  <tr> <td>1      </td>   <td>1      </td>  <td>1      </td>  <td> 1.0, 2, \"a\"                  </td></tr>
  <tr> <td>1      </td>   <td>2      </td>  <td>0      </td>  <td> 1.0       , [1, 2]           </td></tr>
  <tr> <td>2      </td>   <td>1      </td>  <td>0      </td>  <td>[1.0, 2.0], 1                 </td></tr>
  <tr> <td>2      </td>   <td>2      </td>  <td>2      </td>  <td>[1.0, 2.0], [1, 2], [\"a\", \"b\"]</td></tr>
</table>
</p>

<h4>Returns values of the Python function</h4>
<p>
The Python function must return their values in the following order:
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
</p>
<p>
The table below shows valid return types for various combinations where no, one or two double values
and integer values are returned.
</p>
<p>
 <table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
  <tr> <th>nDblRea</th>   <th>nIntRea</th>  <th>Return value</th>  </tr>
  <tr> <td>1      </td>   <td>0      </td>  <td>1.                 </td></tr>
  <tr> <td>0      </td>   <td>1      </td>  <td>1                  </td></tr>
  <tr> <td>2      </td>   <td>0      </td>  <td>[1.0, 2.0]         </td></tr>
  <tr> <td>1      </td>   <td>1      </td>  <td> 1.0, 2            </td></tr>
  <tr> <td>1      </td>   <td>2      </td>  <td> 1.0      , [1, 2] </td></tr>
  <tr> <td>2      </td>   <td>1      </td>  <td>[1.0, 2.0],  1     </td></tr>
  <tr> <td>2      </td>   <td>2      </td>  <td>[1.0, 2.0], [1, 2] </td></tr>
</table>
</p>
<h4>Pure Modelica functions (functions without side effects)</h4>
<p>
The functions that exchange data with Python are implemented as <i>pure</i>
Modelica functions. 
Pure functions always return the same value if called repeatedly.
If these functions are used to call hardware sensors or web services,
they need to be called from a <code>when</code>-equation.
</p>
<p>
See the Modelica language specification for an explanation
of pure and impure functions.
</p>
<h4>Examples</h4>
<p>
The package
<a href=\"modelica://Buildings.Utilities.IO.Python27.Functions.Examples\">
Buildings.Utilities.IO.Python27.Functions.Examples</a>
contains various examples that call Python functions which are implemented
in files that are stored in the directory
<code>Buildings/Resources/Python-Sources</code>.
</p>
<h4>Implementation notes</h4>
<p>
String values cannot be returned from a Python function.
The reason is that Dymola 2013 FD01 generates a compile time error
if a Modelica function returns <code>(Real[nR], Integer[nI], String)</code>.
This will be fixed in Dymola 2014.
(Support request #14983.)
</p>
</html>"));
end UsersGuide;
