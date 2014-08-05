within Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines;
model TwoPortRL
  import Buildings;
  //extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort(T = T_ref);
  parameter Modelica.SIunits.Resistance R(start=1)
    "Resistance at temperature T_ref" annotation(Evaluate=true);
  parameter Modelica.SIunits.Temperature T_ref = 298.15 "Reference temperature"
                                                                                annotation(Evaluate=true);
  parameter Modelica.SIunits.Temperature M = 507.65
    "Temperature constant (R_actual = R*(M + T_heatPort)/(M + T_ref))" annotation(Evaluate=true);
  parameter Modelica.SIunits.Capacitance C(start=0) "Capacity";
  parameter Modelica.SIunits.Inductance L(start=0) "Inductance";
  parameter Modelica.SIunits.Voltage V_nominal(min=0, start=220)=100
    "Nominal voltage (V_nominal >= 0)"  annotation(Dialog(group="Nominal conditions"));
  Interfaces.Terminal_n terminal_n
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Interfaces.Terminal_p terminal_p
    annotation (Placement(transformation(extent={{90,-10},{110,10}}),
        iconTransformation(extent={{90,-10},{110,10}})));
  OnePhase.Lines.TwoPortRL  phase1(
    T_ref=T_ref,
    M=M,
    V_nominal=V_nominal,
    R=R/3,
    L=L/3,
    useHeatPort=true)
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  OnePhase.Lines.TwoPortRL phase2(
    T_ref=T_ref,
    M=M,
    V_nominal=V_nominal,
    R=R/3,
    L=L/3,
    useHeatPort=true)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  OnePhase.Lines.TwoPortRL phase3(
    T_ref=T_ref,
    M=M,
    V_nominal=V_nominal,
    R=R/3,
    L=L/3,
    useHeatPort=true)
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
equation

  connect(terminal_n.phase[1], phase1.terminal_n) annotation (Line(
      points={{-100,0},{-20,0},{-20,30},{-10,30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(terminal_n.phase[2], phase2.terminal_n) annotation (Line(
      points={{-100,0},{-10,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(terminal_n.phase[3], phase3.terminal_n) annotation (Line(
      points={{-100,4.44089e-16},{-20,4.44089e-16},{-20,-30},{-10,-30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(phase1.terminal_p, terminal_p.phase[1]) annotation (Line(
      points={{10,30},{20,30},{20,0},{100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(phase2.terminal_p, terminal_p.phase[2]) annotation (Line(
      points={{10,0},{100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(phase3.terminal_p, terminal_p.phase[3]) annotation (Line(
      points={{10,-30},{20,-30},{20,0},{100,0}},
      color={0,120,120},
      smooth=Smooth.None));

  connect(phase1.heatPort, heatPort) annotation (Line(
      points={{0,20},{0,14},{-32,14},{-32,-72},{0,-72},{0,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(phase3.heatPort, heatPort) annotation (Line(
      points={{4.44089e-16,-40},{0,-40},{0,-100},{4.44089e-16,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(phase2.heatPort, heatPort) annotation (Line(
      points={{4.44089e-16,-10},{4.44089e-16,-16},{-32,-16},{-32,-72},{
          4.44089e-16,-72},{4.44089e-16,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                               graphics={
          Text(
            extent={{-150,-28},{136,-60}},
            lineColor={0,0,0},
          textString="R=%R, L=%L"),
          Line(points={{-92,0},{-72,0}}, color={0,0,0}),
          Line(points={{68,0},{88,0}}, color={0,0,0}),
        Rectangle(
          extent={{-72,32},{68,-28}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
          Line(
          points={{-6.85214e-44,-8.39117e-60},{96,1.22003e-14}},
          color={0,0,0},
          origin={62,16},
          rotation=180),
          Line(
          points={{-6.85214e-44,-8.39117e-60},{-4.17982e-15,16}},
          color={0,0,0},
          origin={20,16},
          rotation=180),
          Line(
          points={{-6.85214e-44,-8.39117e-60},{16,1.95937e-15}},
          color={0,0,0},
          origin={28,0},
          rotation=180),
          Line(
          points={{-6.85214e-44,-8.39117e-60},{16,1.95937e-15}},
          color={0,0,0},
          origin={28,-4},
          rotation=180),
          Line(
          points={{-6.85214e-44,-8.39117e-60},{-2.40346e-15,16}},
          color={0,0,0},
          origin={20,-4},
          rotation=180),
        Line(
          points={{-68,16},{-62,16},{-60,20},{-56,12},{-52,20},{-48,12},{-44,20},
              {-40,12},{-38,16},{-34,16}},
          color={0,0,0},
          smooth=Smooth.None),
        Ellipse(
          extent={{-26,22},{-14,10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-14,22},{-2,10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-2,22},{10,10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-26,16},{10,4}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
            extent={{-144,-56},{142,-88}},
            lineColor={0,0,0},
          textString="C=%C"),
          Text(
            extent={{-142,80},{138,40}},
            lineColor={0,120,120},
          textString="%name")}));
end TwoPortRL;
