within Buildings.Templates.ZoneEquipment;
model VAVBoxFanParallelConstant
  "Parallel fan-powered terminal unit - Constant volume"
  extends Buildings.Templates.ZoneEquipment.Interfaces.VAVBox(
    final typ=Buildings.Templates.ZoneEquipment.Types.Configuration.VAVBoxFanParallelConstant,
    redeclare replaceable
      Buildings.Templates.ZoneEquipment.Components.Controls.G36VAVBoxReheat ctl
      "Guideline 36 controller for VAV terminal unit with reheat");

annotation (
  __ctrlFlow(routing="template"),
  defaultComponentName="VAVBox",
  Documentation(info="<html>
<h4>Description</h4>
<p>
This template represents a parallel fan-powered terminal unit with constant-volume fan.
</p>
</html>"));
end VAVBoxFanParallelConstant;
