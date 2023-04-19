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

  annotation (
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Line(
          points={{-100,0},{100,0}},
          color={0,0,0},
          thickness=0.5),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Pump.None,
        extent={{-100,-70},{0,30}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Pumps/Single.svg"),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Pump.None and have_valChe,
        extent={{26,-22},{100,28}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/Check.svg"),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Pump.None and have_var,
        extent={{-100,60},{0,160}},
        rotation=text_rotation,
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/VFD.svg"),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Pump.None and not have_var,
        extent={{-100,60},{0,160}},
        rotation=text_rotation,
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/MotorStarter.svg"),
    Line( visible=typ<>Buildings.Templates.Components.Types.Pump.None,
          points={{-50,60},{-50,22}},
          color={0,0,0},
          thickness=0.5)}),
  Documentation(info="<html>
<p>
This partial class provides a standard interface for 
single pump models.
</p>
</html>", revisions="<html>
<ul>
<li>
November 18, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialPumpSingle;
