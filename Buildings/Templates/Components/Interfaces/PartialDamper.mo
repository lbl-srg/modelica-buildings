within Buildings.Templates.Components.Interfaces;
partial model PartialDamper "Interface class for damper"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    final m_flow_nominal=dat.m_flow_nominal)
    annotation(__ctrlFlow(enable=false));

  parameter Buildings.Templates.Components.Types.Damper typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Buildings.Templates.Components.Data.Damper dat(final typ=typ)
    "Design and operating parameters"
    annotation (Placement(transformation(extent={{70,70},{90,90}})));

  final parameter Modelica.Units.SI.PressureDifference dp_nominal=
    dat.dp_nominal
    "Damper pressure drop";

  parameter Boolean use_inputFilter=true
    "= true, if opening is filtered with a 2nd order CriticalDamping filter"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",
    enabel=typ<>Buildings.Templates.Components.Types.Damper.None));
  parameter Modelica.Units.SI.Time riseTime=120
    "Rise time of the filter (time to reach 99.6 % of an opening step)"
    annotation (Dialog(
      tab="Dynamics",
      group="Filtered opening",
      enable=use_inputFilter and typ<>Buildings.Templates.Components.Types.Damper.None));
  parameter Modelica.Blocks.Types.Init init=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",
    enable=use_inputFilter and typ<>Buildings.Templates.Components.Types.Damper.None));
  parameter Real y_start=1 "Initial position of actuator"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",
    enable=use_inputFilter and typ<>Buildings.Templates.Components.Types.Damper.None));

  parameter Buildings.Templates.Components.Types.DamperBlades typBla=
    Buildings.Templates.Components.Types.DamperBlades.Parallel
    "Type of blades"
    annotation(Dialog(tab="Graphics", enable=false));
  parameter Integer text_rotation = 0
    "Text rotation angle in icon layer"
    annotation(Dialog(tab="Graphics", enable=false));
  parameter Boolean text_flip = false
    "True to flip text horizontally in icon layer"
    annotation(Dialog(tab="Graphics", enable=false));

  Buildings.Templates.Components.Interfaces.Bus bus
    if typ <> Buildings.Templates.Components.Types.Damper.None
     and typ <> Buildings.Templates.Components.Types.Damper.Barometric and typ
     <> Buildings.Templates.Components.Types.Damper.NoPath
    "Control bus"
    annotation (Placement(
      transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}),
      iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));

  annotation (
    Icon(
    graphics={
     Bitmap(
        visible=typ==Buildings.Templates.Components.Types.Damper.TwoPosition,
        extent=if text_flip then {{40,-240},{-40,-160}} else {{-40,-240},{40,-160}},
        rotation=text_rotation,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
     Bitmap(
        visible=typ==Buildings.Templates.Components.Types.Damper.Modulating or
          typ==Buildings.Templates.Components.Types.Damper.PressureIndependent,
        extent=if text_flip then {{40,-240},{-40,-160}} else {{-40,-240},{40,-160}},
        rotation=text_rotation,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
     Bitmap(
        extent={{-130,-160},{130,100}},
        visible=typ<>Buildings.Templates.Components.Types.Damper.None and
          typBla==Buildings.Templates.Components.Types.DamperBlades.Opposed,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Dampers/BladesOpposed.svg"),
     Bitmap(
        extent={{-130,-160},{130,100}},
        visible=typ<>Buildings.Templates.Components.Types.Damper.None and
          typBla==Buildings.Templates.Components.Types.DamperBlades.Parallel,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Dampers/BladesParallel.svg"),
     Bitmap(
        extent={{-130,-160},{130,100}},
        visible=typ<>Buildings.Templates.Components.Types.Damper.None and
          typBla==Buildings.Templates.Components.Types.DamperBlades.VAV,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Dampers/BladesVAV.svg")},
      coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-100},{100,100}})),
     Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
This partial class provides a standard interface for damper models.
</p>
</html>"));

end PartialDamper;
