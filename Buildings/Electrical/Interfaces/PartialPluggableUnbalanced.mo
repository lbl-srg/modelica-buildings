within Buildings.Electrical.Interfaces;
record PartialPluggableUnbalanced "Partial interface for unbalanced loads"
  parameter Boolean PlugPhase1 = true "If true, phase 1 is connected";
  parameter Boolean PlugPhase2 = true "If true, phase 2 is connected";
  parameter Boolean PlugPhase3 = true "If true, phase 3 is connected";
    // fixme: this requires an info and revision section.
end PartialPluggableUnbalanced;
