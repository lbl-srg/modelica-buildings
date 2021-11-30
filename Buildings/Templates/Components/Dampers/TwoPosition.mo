within Buildings.Templates.Components.Dampers;
model TwoPosition "Two-position damper"
  extends Buildings.Templates.Components.Dampers.Interfaces.PartialDamper(
    final typ=Buildings.Templates.Components.Types.Damper.TwoPosition,
    typBla=Buildings.Templates.Components.Types.DamperBlades.Opposed);

  parameter Buildings.Templates.Components.Types.DamperBlades typBla=
    Buildings.Templates.Components.Types.DamperBlades.Opposed
    "Type of blades"
    annotation(Dialog(tab="Graphics", enable=false));

  Buildings.Fluid.Actuators.Dampers.Exponential damExp(
    redeclare final package Medium=Medium,
    final m_flow_nominal=m_flow_nominal,
    final dpDamper_nominal=dpDamper_nominal)
    "Exponential damper"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Signal conversion"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,50})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold evaSta(t=0.99, h=0.5E-2)
    "Evaluate damper status"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-50})));
equation
  connect(port_a, damExp.port_a) annotation (Line(points={{-100,0},{-56,0},{-56,
          0},{-10,0}}, color={0,127,255}));
  connect(damExp.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(damExp.y_actual, evaSta.u) annotation (Line(points={{5,7},{5,6},{20,6},
          {20,-20},{2.22045e-15,-20},{2.22045e-15,-38}},
                                    color={0,0,127}));
  connect(bus.y, booToRea.u) annotation (Line(
      points={{0,100},{2.22045e-15,62}},
      color={255,204,51},
      thickness=0.5));
  connect(booToRea.y, damExp.y)
    annotation (Line(points={{-2.22045e-15,38},{0,12}}, color={0,0,127}));
  connect(evaSta.y, bus.y_actual) annotation (Line(points={{-2.22045e-15,-62},{0,
          -62},{0,-80},{40,-80},{40,100},{0,100}},          color={255,0,255}));
end TwoPosition;
