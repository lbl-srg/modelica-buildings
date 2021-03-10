within Buildings.Templates.AHUs.BaseClasses.Dampers;
model TwoPosition
  extends Templates.AHUs.Interfaces.Damper(
    final typ=Templates.AHUs.Types.Damper.Modulated);
  extends Data.TwoPosition
    annotation (IconMap(primitivesVisible=false));

  Fluid.Actuators.Dampers.Exponential damExp(
    redeclare final package Medium=Medium,
    final m_flow_nominal=m_flow_nominal,
    final dpDamper_nominal=dpDamper_nominal)
    "Exponential damper"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Routing.BooleanPassThrough
                                          damOutMin if
    braStr=="Minimum outdoor air"
    "Minimum outdoor air damper control signal" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,70})));
  Modelica.Blocks.Routing.BooleanPassThrough
                                          damRel if
    braStr=="Relief air"
    "Relief air damper control signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,70})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Signal conversion" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,30})));
equation
  connect(port_a, damExp.port_a) annotation (Line(points={{-100,0},{-56,0},{-56,
          0},{-10,0}}, color={0,127,255}));
  connect(damExp.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(ahuBus.ahuO.yDamOutMin, damOutMin.u) annotation (Line(
      points={{0.1,100.1},{-10,100.1},{-10,100},{-40,100},{-40,82}},
      color={255,204,51},
      thickness=0.5));
  connect(ahuBus.ahuO.yDamRel, damRel.u) annotation (Line(
      points={{0.1,100.1},{20,100.1},{20,100},{40,100},{40,82}},
      color={255,204,51},
      thickness=0.5));
  connect(booToRea.y, damExp.y)
    annotation (Line(points={{0,18},{0,12}}, color={0,0,127}));
  connect(damOutMin.y, booToRea.u) annotation (Line(points={{-40,59},{-40,50},{0,
          50},{0,42}}, color={255,0,255}));
  connect(damRel.y, booToRea.u) annotation (Line(points={{40,59},{40,50},{0,50},
          {0,42}}, color={255,0,255}));
end TwoPosition;
