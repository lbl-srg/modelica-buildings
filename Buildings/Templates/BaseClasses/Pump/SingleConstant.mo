within Buildings.Templates.BaseClasses.Pump;
model SingleConstant
  extends Buildings.Templates.Interfaces.Pump(final typ=Types.Pump.SingleConstant);

  replaceable Fluid.Movers.SpeedControlled_y pum(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    constrainedby Fluid.Movers.SpeedControlled_y(
      redeclare final package Medium =Medium,
      final inputType=Buildings.Fluid.Types.InputType.Continuous,
      final per=per) "Pump"
    annotation (
      choicesAllMatching=true,
      Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,30})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold evaSta(t=1E-2, h=0.5E-2)
    "Evaluate pump status"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,30})));
equation
  connect(booToRea.y,pum. y)
    annotation (Line(points={{-38,30},{0,30},{0,12}},
                                             color={0,0,127}));
  connect(port_a,pum. port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(pum.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(pum.y_actual,evaSta. u) annotation (Line(points={{11,7},{30,7},{30,30},
          {38,30}},              color={0,0,127}));
  connect(busCon.out.yPum, booToRea.u) annotation (Line(
      points={{0.1,100.1},{0,100.1},{0,80},{-80,80},{-80,30},{-62,30}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(evaSta.y, busCon.inp.yPum_actual) annotation (Line(points={{62,30},{80,
          30},{80,80},{0.1,80},{0.1,100.1}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                    Bitmap(
        extent={{-80,-80},{80,80}},
        fileName="modelica://Buildings/Resources/Images/Templates/BaseClasses/Fans/SingleVariable.svg")}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SingleConstant;
