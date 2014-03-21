within Buildings.UsersGuide;

class Conventions "Conventions"
  extends Modelica.Icons.Information;
  annotation(preferredView = "info", Documentation(info = "<html>
  <p>
  This library follows the conventions of the 
  <a href=\"modelica://Modelica.UsersGuide.Conventions\">Modelica Standard Library</a>, which are as follows:
  </p>

  <p>
  Note, in the html documentation of any Modelica library,
  the headings \"h1, h2, h3\" should not be used,
  because they are utilized from the automatically generated documentation/headings.
  Additional headings in the html documentation should start with \"h4\".
  </p>

  <p>
  In the Modelica package the following conventions are used:
  </p>

  <ol>
  <li> Class and instance names are written in upper and lower case
    letters, e.g., \"ElectricCurrent\". An underscore is only used
    at the end of a name to characterize a lower or upper index,
    e.g., \"pin_a\".</li>

  <li> <b>Class names</b> start always with an upper case letter.</li>

  <li> <b>Instance names</b>, i.e., names of component instances and
    of variables (with the exception of constants),
    start usually with a lower case letter with only
    a few exceptions if this is common sense
    (such as \"T\" for a temperature variable).</li>

  <li> <b>Constant names</b>, i.e., names of variables declared with the
    \"constant\" prefix, follow the usual naming conventions
    (= upper and lower case letters) and start usually with an
    upper case letter, e.g. UniformGravity, SteadyState.</li>
  <li> The two connectors of a domain that have identical declarations
    and different icons are usually distinguished by \"_a\", \"_b\"
    or \"_p\", \"_n\", e.g., Flange_a/Flange_b, HeatPort_a, HeatPort_b.</li>

  <li> The <b>instance name</b> of a component is always displayed in its icon
    (= text string \"%name\") in <b>blue color</b>. A connector class has the instance
    name definition in the diagram layer and not in the icon layer.
    <b>Parameter</b> values, e.g., resistance, mass, gear ratio, are displayed
    in the icon in <b>black color</b> in a smaller font size as the instance name.
   </li>

  <li> A main package has usually the following subpackages:
    <ul>
    <li><b>UsersGuide</b> containing an overall description of the library
     and how to use it.</li>
    <li><b>Examples</b> containing models demonstrating the
     usage of the library.</li>
    <li><b>Interfaces</b> containing connectors and partial
     models.</li>
    <li><b>Types</b> containing type, enumeration and choice
     definitions.</li>
    </ul>
    </li>
  </ol>

  <p>
  The <code>Buildings</code> library uses the following conventions
  in addition to the ones of the Modelica Standard Library:
  </p>

  <ol>
  <li>
  The nomenclature used in the package
  <a href=\"modelica://Buildings.Utilities.Psychrometrics\">
  Buildings.Utilities.Psychrometrics</a>
   is as follows, 
  <ul>
  <li>
  Uppercase <code>X</code> denotes mass fraction per total mass.
  </li>
  <li>
  Lowercase <code>x</code> denotes mass fraction per mass of dry air.
  </li>
  <li>
  The notation <code>z_xy</code> denotes that the function or block has output
  <code>z</code> and inputs <code>x</code> and <code>y</code>.
  </li>
  <li>
  The symbol <code>pW</code> denotes water vapor pressure, <code>TDewPoi</code> 
  denotes dew point temperature, <code>TWetBul</code> denotes wet bulb temperature,
  and <code>TDryBul</code> (or simply <code>T</code>) denotes dry bulb temperature.
  </li>
  </ul>
  <li>
  Names of models, blocks and packages should start with an upper-case letter and be a
  noun or a noun with a combination of adjectives and nouns.
  Use camel-case notation to combine multiple words, such as <code>HeatTransfer</code>.
  </li>
  <li>
  Parameter and variables names are usually a character, such as <code>T</code>
  for temperature and <code>p</code> for pressure, or a combination of the first three
  characters of a word, such as <code>higPreSetPoi</code> for high pressure set point.
  </li>
  <li>
  Comments should be added to each class (package, model, function etc.).
  The first character should be upper case.
  For one-line comments of parameters, variables and classes, no period should be used at the end of the comment.
  </li>
  <li>
  Where applicable, all variable must have units, also if the variable is protected.
  </li>
  <li>
  To indicate that a class (i.e., a package, model, block etc.) has not been extensively tested or validated,
  its class name ends with the string <code>Beta</code>.
  </li>
  </ol>
  </html>
  "));
end Conventions;