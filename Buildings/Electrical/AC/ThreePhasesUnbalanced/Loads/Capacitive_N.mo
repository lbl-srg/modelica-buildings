within Buildings.Electrical.AC.ThreePhasesUnbalanced.Loads;
model Capacitive_N
  "Model of a three-phase unbalanced capacitive load with neutral cable"
  extends BaseClasses.LoadCtrl_N(
    redeclare Buildings.Electrical.AC.OnePhase.Loads.Capacitive load1(pf=pf,
        use_pf_in=use_pf_in),
    redeclare Buildings.Electrical.AC.OnePhase.Loads.Capacitive load2(pf=pf,
        use_pf_in=use_pf_in),
    redeclare Buildings.Electrical.AC.OnePhase.Loads.Capacitive load3(pf=pf,
        use_pf_in=use_pf_in));
  parameter Boolean use_pf_in = false
    "If true, the power factor is defined by an input"
    annotation(Dialog(group="Modeling assumption"));
  parameter Real pf(min=0, max=1) = 0.8 "Power factor"
  annotation(Dialog(group="Nominal conditions"));
  Modelica.Blocks.Interfaces.RealInput pf_in_1(
    min=0,
    max=1,
    unit="1") if (use_pf_in and plugPhase1) "Power factor of load on phase 1" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-60,-120}),
                          iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-60,-100})));
  Modelica.Blocks.Interfaces.RealInput pf_in_2(
    min=0,
    max=1,
    unit="1") if (use_pf_in and plugPhase2) "Power factor of load on phase 2" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={30,-120}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-100})));
  Modelica.Blocks.Interfaces.RealInput pf_in_3(
    min=0,
    max=1,
    unit="1") if (use_pf_in and plugPhase3) "Power factor of load on phase 3" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={80,-120}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={60,-100})));
equation
  connect(pf_in_1, load1.pf_in) annotation (Line(
      points={{-60,-120},{-60,56},{10,56}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(pf_in_2, load2.pf_in) annotation (Line(
      points={{30,-120},{30,-14},{10,-14}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(pf_in_3, load3.pf_in) annotation (Line(
      points={{80,-120},{80,-82},{10,-82}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  annotation (
  defaultComponentName="loa",
  Icon(graphics={
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
          textColor={0,0,0},
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
          rotation=180)}), Documentation(revisions="<html>
<ul>
<li>
September 24, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
<li>
August 27, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>", info="<html>
<p>
This model represents a three-phase unbalanced capacitive load.
The model extends from
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesUnbalanced.Loads.BaseClasses.LoadCtrl_N\">
Buildings.Electrical.AC.ThreePhasesUnbalanced.Loads.BaseClasses.LoadCtrl_N</a>
and uses the load model from the package
<a href=\"modelica://Buildings.Electrical.AC.OnePhase.Loads\">
Buildings.Electrical.AC.OnePhase.Loads</a>.
The model computes the voltages, currents and powers on each phase.
</p>
<p>
This model has a connector with four cables and it represents the neutral cable.
The current in the neutral cable is computed as the algebraic sum of the currents
of the loads.
</p>
<p>
For more information, see <a href=\"modelica://Buildings.Electrical.AC.ThreePhasesUnbalanced.Loads.BaseClasses.LoadCtrl_N\">
Buildings.Electrical.AC.ThreePhasesUnbalanced.Loads.BaseClasses.LoadCtrl_N</a> and
<a href=\"modelica://Buildings.Electrical.AC.OnePhase.Loads.Capacitive\">
Buildings.Electrical.AC.OnePhase.Loads.Capacitive</a>.
</p>
</html>"));
end Capacitive_N;
