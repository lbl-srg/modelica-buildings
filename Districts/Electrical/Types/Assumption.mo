within Districts.Electrical.Types;
type Assumption = enumeration(
    FixedZ_steady_state "Fixed Z, steady-state",
    FixedZ_dynamic "Fixed Z, dynamic",
    VariableZ_P_input "Variable Z, P input",
    VariableZ_y_input "Variable Z, y input")
  "Enumeration defining the modelling assumption of the load";
