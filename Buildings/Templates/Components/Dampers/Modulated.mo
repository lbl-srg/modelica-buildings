within Buildings.Templates.Components.Dampers;
model Modulated
  extends Buildings.Templates.Components.Dampers.Interfaces.PartialDamper(
    final typ=Buildings.Templates.Components.Types.Damper.Modulated);

  parameter Buildings.Templates.Components.Types.DamperBlades typBla=
    Buildings.Templates.Components.Types.DamperBlades.Parallel
    "Type of blades"
    annotation(Dialog(tab="Graphics", enable=false));

  Fluid.Actuators.Dampers.Exponential damExp(
    redeclare final package Medium=Medium,
    final m_flow_nominal=m_flow_nominal,
    final dpDamper_nominal=dpDamper_nominal)
    "Exponential damper"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(port_a, damExp.port_a) annotation (Line(points={{-100,0},{-56,0},{-56,
          0},{-10,0}}, color={0,127,255}));
  connect(damExp.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(bus.y, damExp.y) annotation (Line(
      points={{0,100},{0,56},{0,56},{0,12}},
      color={255,204,51},
      thickness=0.5));
  connect(damExp.y_actual, bus.y_actual) annotation (Line(points={{5,7},{40,7},{
          40,100},{0,100}},           color={0,0,127}));
annotation(Icon(graphics={
     Bitmap(
        extent=if text_flip then {{40,-220},{-40,-140}} else {{-40,-220},{40,-140}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulated.svg",
        rotation=text_rotation),
      Bitmap(
        extent={{-40,-140},{40,100}},
        visible=typBla==Buildings.Templates.Components.Types.DamperBlades.Parallel,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Dampers/BladesParallel.svg"),
      Bitmap(
        extent={{-40,-140},{40,100}},
        visible=typBla==Buildings.Templates.Components.Types.DamperBlades.Opposed,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Dampers/BladesOpposed.svg")}));
end Modulated;
