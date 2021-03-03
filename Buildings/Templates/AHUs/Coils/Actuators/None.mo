within Buildings.Experimental.Templates.AHUs.Coils.Actuators;
model None "No actuator"
  extends Interfaces.Actuator(
    final typ=Types.Actuator.None);

  BaseClasses.PassThrough pas(
    redeclare final package Medium=Medium)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,0})));
  BaseClasses.PassThrough pas1(
   redeclare final package Medium=Medium)
   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,0})));
equation
  connect(pas.port_b, port_bSup)
    annotation (Line(points={{-40,10},{-40,100}}, color={0,127,255}));
  connect(pas.port_a, port_aSup) annotation (Line(points={{-40,-10},{-40,-100},{
          -40,-100}}, color={0,127,255}));
  connect(port_aRet, pas1.port_a)
    annotation (Line(points={{40,100},{40,10}}, color={0,127,255}));
  connect(pas1.port_b, port_bRet)
    annotation (Line(points={{40,-10},{40,-100}}, color={0,127,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                                              Line(
          points={{-40,100},{-40,-100}},
          color={28,108,200},
          thickness=1),                                       Line(
          points={{40,100},{40,-100}},
          color={28,108,200},
          thickness=1)}),                              Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end None;
