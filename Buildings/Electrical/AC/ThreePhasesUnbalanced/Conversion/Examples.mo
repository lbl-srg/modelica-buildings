within Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion;
package Examples "Package with example models"
  extends Modelica.Icons.ExamplesPackage;
  model WyeDeltaTransformer

    Sources.FixedVoltage source(
      f=60,
      Phi=0,
      V=12470) annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
    ACACTransformerStepDownDY transformer(
      VHigh=12470,
      VLow=4160,
      XoverR=6,
      Zperc=sqrt(0.01^2 + 0.06^2),
      VABase=6000000)
      annotation (Placement(transformation(extent={{-20,20},{0,40}})));
    Loads.Inductive load(
      loadConn=Buildings.Electrical.Types.LoadConnection.wye_to_wyeg,
      pf=0.9,
      P_nominal=-1800e3,
      V_nominal=4160)
      annotation (Placement(transformation(extent={{40,20},{60,40}})));
    Sensors.ProbeWye probe_Y_1(perUnit=false, V_nominal=12470)
      annotation (Placement(transformation(extent={{-50,60},{-30,80}})));
    Sensors.ProbeDelta probe_D_1(perUnit=false, V_nominal=12470)
      annotation (Placement(transformation(extent={{-50,0},{-30,-20}})));
    Sensors.ProbeDelta probe_D_2(perUnit=false, V_nominal=4160)
      annotation (Placement(transformation(extent={{10,0},{30,-20}})));
    Sensors.ProbeWye probe_Y_2(perUnit=false, V_nominal=4160)
      annotation (Placement(transformation(extent={{10,60},{30,80}})));
  equation
    connect(source.terminal, transformer.terminal_n) annotation (Line(
        points={{-60,30},{-20,30}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(transformer.terminal_p, load.terminal_p) annotation (Line(
        points={{0,30},{40,30}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(probe_Y_1.term, transformer.terminal_n) annotation (Line(
        points={{-40,61},{-40,30},{-20,30}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(probe_D_1.term, transformer.terminal_n) annotation (Line(
        points={{-40,-1},{-40,30},{-20,30}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(probe_D_2.term, transformer.terminal_p) annotation (Line(
        points={{20,-1},{20,30},{4.44089e-16,30}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(probe_Y_2.term, load.terminal_p) annotation (Line(
        points={{20,61},{20,30},{40,30}},
        color={0,120,120},
        smooth=Smooth.None));
    annotation (Documentation(revisions="<html>
<ul>
<li>
June 6, 2014, by Marco Bonvini:<br/>
First implementation.
</li>
</ul>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics));
  end WyeDeltaTransformer;

  model DeltaWyeTransformer

    Sources.FixedVoltage source(
      f=60,
      Phi=0,
      V=12470) annotation (Placement(transformation(extent={{-96,20},{-76,40}})));
    ACACTransformerStepDownDY transformer(
      VHigh=12470,
      VLow=4160,
      XoverR=6,
      Zperc=sqrt(0.01^2 + 0.06^2),
      VABase=6000000)
      annotation (Placement(transformation(extent={{-20,20},{0,40}})));
    Loads.Inductive load(
      loadConn=Buildings.Electrical.Types.LoadConnection.wye_to_wyeg,
      pf=0.9,
      P_nominal=-1800e3,
      V_nominal=4160)
      annotation (Placement(transformation(extent={{60,20},{80,40}})));
    Sensors.ProbeWye probe_Y_1(perUnit=false, V_nominal=12470)
      annotation (Placement(transformation(extent={{-50,60},{-30,80}})));
    Sensors.ProbeDelta probe_D_1(perUnit=false, V_nominal=12470)
      annotation (Placement(transformation(extent={{-50,0},{-30,-20}})));
    Sensors.ProbeDelta probe_D_2(perUnit=false, V_nominal=4160)
      annotation (Placement(transformation(extent={{10,0},{30,-20}})));
    Sensors.ProbeWye probe_Y_2(perUnit=false, V_nominal=4160)
      annotation (Placement(transformation(extent={{10,60},{30,80}})));
    Lines.TwoPortMatrixRL line1(
      Z11={0,0},
      Z12={0,0},
      Z13={0,0},
      Z22={0,0},
      Z23={0,0},
      Z33={0,0})
      annotation (Placement(transformation(extent={{-66,20},{-46,40}})));
    Lines.TwoPortMatrixRL line2(
      Z11={0,0},
      Z12={0,0},
      Z13={0,0},
      Z22={0,0},
      Z23={0,0},
      Z33={0,0}) annotation (Placement(transformation(extent={{30,20},{50,40}})));
  equation
    connect(probe_Y_1.term, transformer.terminal_n) annotation (Line(
        points={{-40,61},{-40,30},{-20,30}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(probe_D_1.term, transformer.terminal_n) annotation (Line(
        points={{-40,-1},{-40,30},{-20,30}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(probe_D_2.term, transformer.terminal_p) annotation (Line(
        points={{20,-1},{20,30},{4.44089e-16,30}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(source.terminal, line1.terminal_n) annotation (Line(
        points={{-76,30},{-66,30}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(line1.terminal_p, transformer.terminal_n) annotation (Line(
        points={{-46,30},{-20,30}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(transformer.terminal_p, line2.terminal_n) annotation (Line(
        points={{4.44089e-16,30},{30,30}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(line2.terminal_n, probe_Y_2.term) annotation (Line(
        points={{30,30},{20,30},{20,61}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(line2.terminal_p, load.terminal_p) annotation (Line(
        points={{50,30},{60,30}},
        color={0,120,120},
        smooth=Smooth.None));
    annotation (Documentation(revisions="<html>
<ul>
<li>
June 6, 2014, by Marco Bonvini:<br/>
First implementation.
</li>
</ul>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics));
  end DeltaWyeTransformer;

  model DeltaWyeTransformerStepUp

    Sources.FixedVoltage source(
      f=60,
      Phi=0,
      V=12470) annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
    ACACTransformerStepUpDY transformer(
      VHigh=12470,
      XoverR=6,
      Zperc=sqrt(0.01^2 + 0.06^2),
      VABase=6000000,
      VLow=24900)
      annotation (Placement(transformation(extent={{-20,20},{0,40}})));
    Loads.Inductive load(
      loadConn=Buildings.Electrical.Types.LoadConnection.wye_to_wyeg,
      pf=0.9,
      P_nominal=-1800e3,
      V_nominal=24900)
      annotation (Placement(transformation(extent={{40,20},{60,40}})));
    Sensors.ProbeWye probe_Y_1(perUnit=false, V_nominal=12470)
      annotation (Placement(transformation(extent={{-50,60},{-30,80}})));
    Sensors.ProbeDelta probe_D_1(perUnit=false, V_nominal=12470)
      annotation (Placement(transformation(extent={{-50,0},{-30,-20}})));
    Sensors.ProbeDelta probe_D_2(perUnit=false, V_nominal=24900)
      annotation (Placement(transformation(extent={{10,0},{30,-20}})));
    Sensors.ProbeWye probe_Y_2(perUnit=false, V_nominal=24900)
      annotation (Placement(transformation(extent={{10,60},{30,80}})));
  equation
    connect(source.terminal, transformer.terminal_n) annotation (Line(
        points={{-60,30},{-20,30}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(transformer.terminal_p, load.terminal_p) annotation (Line(
        points={{0,30},{40,30}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(probe_Y_1.term, transformer.terminal_n) annotation (Line(
        points={{-40,61},{-40,30},{-20,30}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(probe_D_1.term, transformer.terminal_n) annotation (Line(
        points={{-40,-1},{-40,30},{-20,30}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(probe_D_2.term, transformer.terminal_p) annotation (Line(
        points={{20,-1},{20,30},{4.44089e-16,30}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(probe_Y_2.term, load.terminal_p) annotation (Line(
        points={{20,61},{20,30},{40,30}},
        color={0,120,120},
        smooth=Smooth.None));
    annotation (Documentation(revisions="<html>
<ul>
<li>
June 6, 2014, by Marco Bonvini:<br/>
First implementation.
</li>
</ul>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics));
  end DeltaWyeTransformerStepUp;

  model DeltaWyeTransformerStepUp_2

    Sources.FixedVoltage source(
      f=60,
      Phi=0,
      V=12470)
      annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
    ACACTransformerStepUpDY transformer(
      VHigh=12470,
      XoverR=6,
      Zperc=sqrt(0.01^2 + 0.06^2),
      VABase=6000000,
      VLow=24900)
      annotation (Placement(transformation(extent={{-20,20},{0,40}})));
    Loads.Inductive load(
      loadConn=Buildings.Electrical.Types.LoadConnection.wye_to_wyeg,
      pf=0.9,
      P_nominal=-1800e3,
      V_nominal=24900)
      annotation (Placement(transformation(extent={{60,20},{80,40}})));
    Sensors.ProbeWye probe_Y_1(perUnit=false, V_nominal=12470)
      annotation (Placement(transformation(extent={{-50,60},{-30,80}})));
    Sensors.ProbeDelta probe_D_1(perUnit=false, V_nominal=12470)
      annotation (Placement(transformation(extent={{-50,0},{-30,-20}})));
    Sensors.ProbeDelta probe_D_2(perUnit=false, V_nominal=24900)
      annotation (Placement(transformation(extent={{10,0},{30,-20}})));
    Sensors.ProbeWye probe_Y_2(perUnit=false, V_nominal=24900)
      annotation (Placement(transformation(extent={{10,60},{30,80}})));
    Lines.TwoPortMatrixRL line1(
      Z11={0.1,0.01},
      Z12={0.1,0.01},
      Z13={0.1,0.01},
      Z22={0.1,0.01},
      Z23={0.1,0.01},
      Z33={0.1,0.01})
      annotation (Placement(transformation(extent={{-72,20},{-52,40}})));
    Lines.TwoPortMatrixRL line2(
      Z11={0.1,0.01},
      Z12={0.1,0.01},
      Z13={0.1,0.01},
      Z22={0.1,0.01},
      Z23={0.1,0.01},
      Z33={0.1,0.01})
      annotation (Placement(transformation(extent={{30,20},{50,40}})));
  equation
    connect(probe_Y_1.term, transformer.terminal_n) annotation (Line(
        points={{-40,61},{-40,30},{-20,30}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(probe_D_1.term, transformer.terminal_n) annotation (Line(
        points={{-40,-1},{-40,30},{-20,30}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(probe_D_2.term, transformer.terminal_p) annotation (Line(
        points={{20,-1},{20,30},{4.44089e-16,30}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(source.terminal, line1.terminal_n) annotation (Line(
        points={{-80,30},{-72,30}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(line1.terminal_p, transformer.terminal_n) annotation (Line(
        points={{-52,30},{-20,30}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(load.terminal_p, line2.terminal_p) annotation (Line(
        points={{60,30},{50,30}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(line2.terminal_n, probe_Y_2.term) annotation (Line(
        points={{30,30},{20,30},{20,61}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(transformer.terminal_p, line2.terminal_n) annotation (Line(
        points={{0,30},{30,30}},
        color={0,120,120},
        smooth=Smooth.None));
    annotation (Documentation(revisions="<html>
<ul>
<li>
June 6, 2014, by Marco Bonvini:<br/>
First implementation.
</li>
</ul>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics));
  end DeltaWyeTransformerStepUp_2;
  annotation (Documentation(info="<html>
<p>
This package contains examples for the use of models that can be found in
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion\">
Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 25, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>"));
end Examples;
