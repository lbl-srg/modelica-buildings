within Buildings.Electrical.Types;
type InitMode = enumeration(
    zero_current "Assume i=0 during homotopy initialization",
    linearized "Uses linear model during homotopy initialization")
  "Enumeration that defines the type of initialization assumption can be used for a load model";
