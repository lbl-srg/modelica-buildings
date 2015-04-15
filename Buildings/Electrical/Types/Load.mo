within Buildings.Electrical.Types;
type Load = enumeration(
    FixedZ_steady_state "Fixed Z, steady-state",
    FixedZ_dynamic "Fixed Z, dynamic",
    VariableZ_P_input "Variable Z, P input",
    VariableZ_y_input "Variable Z, y input")
  "Enumeration that defines the modelling assumption of the load." annotation (
    Documentation(revisions="<html>
<ul>
<li>
March 19, 2015, by Marco Bonvini:<br/>
Added documentation.
</li>
</ul>
</html>", info="<html>
This type indicates in which mode the load model operates.
</html>"));
