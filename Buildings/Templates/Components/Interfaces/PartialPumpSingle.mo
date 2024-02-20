within Buildings.Templates.Components.Interfaces;
partial model PartialPumpSingle "Interface class for single pump"
  extends Buildings.Templates.Components.Interfaces.PartialPump;
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    redeclare replaceable package Medium=Buildings.Media.Water,
    final m_flow_nominal(min=0)=dat.m_flow_nominal)
    annotation(__Linkage(enable=false));

  parameter Buildings.Templates.Components.Data.PumpSingle dat(
    final typ=typ)
    "Design and operating parameters"
    annotation(__Linkage(enable=false));

  final parameter Modelica.Units.SI.PressureDifference dp_nominal(
    final min=0,
    displayUnit="Pa")=dat.dp_nominal
    "Pump head at design conditions"
    annotation (Dialog(group="Nominal condition",
      enable=typ<>Buildings.Templates.Components.Types.Pump.None));

  // This parameter is declared outside the parameter record dat as
  // it is considered to be an advanced parameter for which a default
  // value can probably be used.
  parameter Modelica.Units.SI.PressureDifference dpValChe_nominal(
    final min=0,
    start=Buildings.Templates.Data.Defaults.dpValChe,
    displayUnit="Pa")=Buildings.Templates.Data.Defaults.dpValChe
    "Check valve pressure drop at design conditions"
    annotation (Dialog(group="Nominal condition",
      enable=typ<>Buildings.Templates.Components.Types.Pump.None
      and have_valChe));

  annotation (
  Icon(coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>
<p>
This partial class provides a standard interface for 
single pump models.
</p>
</html>", revisions="<html>
<ul>
<li>
April 28, 2023, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialPumpSingle;
