within Buildings.DHC;
package Types  "Package with type definitions"
  extends Modelica.Icons.TypesPackage;

  type DistrictSystemType = enumeration(
      CombinedGeneration1
    "First generation district heating and cooling system",
      CombinedGeneration2to4
    "Second to fourth generation district heating and cooling system",
      CombinedGeneration5
    "Fifth generation district heating and cooling system",
      Cooling
    "District cooling system",
      HeatingGeneration1
    "First generation district heating system",
      HeatingGeneration2to4
    "Second to fourth generation district heating system")
    "Enumeration to define the type of district system"
    annotation (Documentation(info="<html>
  <p>
  Enumeration to define the type of district system:<br/>
  </p>
  <table border=\"1\" summary=\"Explanation of the enumeration\">
  <tr>
  <th>Enumeration</th>
  <th>Description</th>
  </tr>
  <tr>
  <td>CombinedGeneration1</td>
  <td>First generation district heating and cooling system (using steam and chilled
  water)</td>
  </tr>
  <tr>
  <td>CombinedGeneration2to4</td>
  <td>Second to fourth generation district heating and cooling system (using heating
  water and chilled water)</td>
  </tr>
  <tr>
  <td>CombinedGeneration5</td>
  <td>Fifth generation district heating and cooling system (using water near
  ambient temperature)</td>
  </tr>
  <tr>
  <td>Cooling</td>
  <td>District cooling system</td>
  </tr>
  <tr>
  <td>HeatingGeneration1</td>
  <td>First generation district heating system (using steam)</td>
  </tr>
  <tr>
  <td>HeatingGeneration2to4</td>
  <td>Second to fourth generation district heating system (using heating
  water)</td>
  </tr>
  </table>
  </html>",revisions="<html>
<ul>
<li>
December 10, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));

annotation (Documentation(info="<html>
<p>
This package contains type definitions.
</p>
</html>"));
end Types;
