within Buildings.Applications.DHC.Loads.Types;
type TerminalFunctionSpec = enumeration(
    None
      "No heating or cooling function",
    Water
      "Water based",
    ChangeOver
      "Water based with change-over",
    Electric
      "Electric")
  "Enumeration specifying the heating and cooling function of a terminal unit"
annotation(Documentation(info="<html>
<p>
Enumeration to specify the heating and cooling function of a terminal unit.
</p>
</html>",
revisions=
"<html>
<ul>
<li>
June 25, 2019, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
