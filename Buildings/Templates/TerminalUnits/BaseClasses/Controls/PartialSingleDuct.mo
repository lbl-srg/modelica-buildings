within Buildings.Templates.TerminalUnits.BaseClasses.Controls;
partial block PartialSingleDuct
  "Partial control block for single duct terminal unit"
  extends Buildings.Templates.Interfaces.ControllerTerminalUnit;

  outer replaceable Buildings.Templates.BaseClasses.Coils.None coiReh
    "Reheat coil";

end PartialSingleDuct;
