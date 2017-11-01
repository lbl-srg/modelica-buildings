within Buildings.Controls;
package Types "Package with type definitions"
  extends Modelica.Icons.TypesPackage;

  constant Integer nDayTypes = 3 "Integer with the number of day types";

  type Day = enumeration(
      WorkingDay "Working day, such as Monday through Friday",
      NonWorkingDay "Non-working day, such as week-ends, but not holidays",
      Holiday "Holiday") "Enumeration for the day types"
                                   annotation (Documentation(info="<html>
<p>
Enumeration for the type of days that are used in the demand response models.
The possible values are
</p>
<ol>
<li>
WorkingDay
</li>
<li>
NonWorkingDay
</li>
<li>
Holiday
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
March 20, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
annotation (Documentation(info="<html>
This package contains type definitions.
</html>"));
end Types;
