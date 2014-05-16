within Buildings.Electrical.Interfaces;
partial model PartialPluggableUnbalanced
  "Partial interface for undalanced loads"
  parameter Boolean PlugPhase1 = true
    "This flag indicates if the load on phase 1 is connected or not";
  parameter Boolean PlugPhase2 = true
    "This flag indicates if the load on phase 2 is connected or not";
  parameter Boolean PlugPhase3 = true
    "This flag indicates if the load on phase 3 is connected or not";
end PartialPluggableUnbalanced;
