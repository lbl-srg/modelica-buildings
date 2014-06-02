within Buildings.Electrical.Types;
type Assumption = enumeration(
    FixedZ_steady_state "Fixed Z, steady-state",
    FixedZ_dynamic "Fixed Z, dynamic",
    VariableZ_P_input "Variable Z, P input",
    VariableZ_y_input "Variable Z, y input")
  "Enumeration that defines the modelling assumption of the load. Fixme: rename this to Load, so it is Types.Load, as Assumption is too generic";
