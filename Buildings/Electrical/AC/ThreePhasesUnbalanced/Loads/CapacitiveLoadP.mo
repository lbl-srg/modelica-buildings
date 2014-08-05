within Buildings.Electrical.AC.ThreePhasesUnbalanced.Loads;
model CapacitiveLoadP
  extends BaseClasses.PartialLoad(
    redeclare Buildings.Electrical.AC.OnePhase.Loads.Capacitive load1(pf=pf,
        use_pf_in=use_pf_in),
    redeclare Buildings.Electrical.AC.OnePhase.Loads.Capacitive load2(pf=pf,
        use_pf_in=use_pf_in),
    redeclare Buildings.Electrical.AC.OnePhase.Loads.Capacitive load3(pf=pf,
        use_pf_in=use_pf_in));
  parameter Boolean use_pf_in = false "If true the pf is defined by an input"
    annotation(Dialog(group="Modelling assumption"));
  parameter Real pf(min=0, max=1) = 0.8 "Power factor"
  annotation(Dialog(group="Nominal conditions"));
  Modelica.Blocks.Interfaces.RealInput pf_in(
    min=0,
    max=1,
    unit="1") if (use_pf_in) "Power factor"
                   annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={30,-80}),  iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={40,-100})));
equation
  connect(pf_in, load1.pf_in) annotation (Line(
      points={{30,-80},{30,46},{10,46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pf_in, load2.pf_in) annotation (Line(
      points={{30,-80},{30,6},{10,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pf_in, load3.pf_in) annotation (Line(
      points={{30,-80},{30,-34},{10,-34}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(graphics={
        Rectangle(
          extent={{-80,80},{80,-80}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
          Line(points={{-42,-5.14335e-15},{10,0}},
                                         color={0,0,0},
          origin={-2,0},
          rotation=180),
          Line(points={{-26,-3.18398e-15},{6.85214e-44,8.39117e-60}},
                                         color={0,0,0},
          origin={48,0},
          rotation=180),
          Line(points={{-10,-1.22461e-15},{10,0}},
                                         color={0,0,0},
          origin={-82,0},
          rotation=180),
          Line(points={{-2,-2.44921e-16},{16,1.95937e-15}},
                                         color={0,0,0},
          origin={-82,0},
          rotation=180),
        Text(
          extent={{-120,120},{120,80}},
          lineColor={0,120,120},
          textString="%name"),
        Rectangle(
          extent={{-11,22},{11,-22}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-44,1},
          rotation=90),
          Line(
          points={{0,0},{32,3.91873e-15}},
          color={0,0,0},
          origin={10,50},
          rotation=180),
          Line(points={{-6.85214e-44,-8.39117e-60},{44,5.38825e-15}},
                                         color={0,0,0},
          origin={60,50},
          rotation=180),
        Rectangle(
          extent={{-11,22},{11,-22}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-44,51},
          rotation=90),
        Rectangle(
          extent={{-11,22},{11,-22}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-44,-51},
          rotation=90),
        Line(
          points={{60,50},{76,0},{60,-52}},
          color={0,0,0},
          smooth=Smooth.None),
          Line(points={{-6.85214e-44,-8.39117e-60},{10,1.22461e-15}},
                                         color={0,0,0},
          origin={-66,50},
          rotation=180),
          Line(points={{-6.85214e-44,-8.39117e-60},{10,1.22461e-15}},
                                         color={0,0,0},
          origin={-66,0},
          rotation=180),
          Line(points={{-6.85214e-44,-8.39117e-60},{10,1.22461e-15}},
                                         color={0,0,0},
          origin={-66,-52},
          rotation=180),
        Line(
          points={{10,68},{10,32}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{16,68},{16,32}},
          color={0,0,0},
          smooth=Smooth.None),
          Line(points={{-6.85214e-44,-8.39117e-60},{60,7.34764e-15}},
                                         color={0,0,0},
          origin={76,0},
          rotation=180),
        Line(
          points={{16,18},{16,-18}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{10,18},{10,-18}},
          color={0,0,0},
          smooth=Smooth.None),
          Line(
          points={{0,0},{32,3.91873e-15}},
          color={0,0,0},
          origin={10,0},
          rotation=180),
          Line(points={{-6.85214e-44,-8.39117e-60},{44,5.38825e-15}},
                                         color={0,0,0},
          origin={60,-52},
          rotation=180),
        Line(
          points={{16,-34},{16,-70}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{10,-34},{10,-70}},
          color={0,0,0},
          smooth=Smooth.None),
          Line(
          points={{0,0},{32,3.91873e-15}},
          color={0,0,0},
          origin={10,-52},
          rotation=180)}), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics));
end CapacitiveLoadP;
