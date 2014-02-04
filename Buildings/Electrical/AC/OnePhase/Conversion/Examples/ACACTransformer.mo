within Buildings.Electrical.AC.OnePhase.Conversion.Examples;
model ACACTransformer "Test model AC to AC trasformer"
  import Buildings;
  extends Modelica.Icons.Example;
  Buildings.Electrical.AC.OnePhase.Conversion.ACACTransformer tra_load(
    Vhigh=220,
    Zperc=0.03,
    VAbase=4000,
    Vlow=110,
    XoverR=8)
    annotation (Placement(transformation(extent={{-18,40},{2,60}})));
  Buildings.Electrical.AC.OnePhase.Sources.FixedVoltage                 sou(
    f=60,
    definiteReference=true,
    V=220,
    Phi=0)                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,50})));
  Buildings.Electrical.AC.OnePhase.Loads.InductiveLoadP
                                             load(
                      mode=Buildings.Electrical.Types.Assumption.VariableZ_P_input,
    P_nominal=-2000,
    V_nominal=110,
    pf=0.8)
    annotation (Placement(transformation(extent={{10,40},{30,60}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=0.5,
    startTime=0.3,
    offset=0,
    height=-2000)
    annotation (Placement(transformation(extent={{70,40},{50,60}})));
  Buildings.Electrical.AC.OnePhase.Conversion.ACACTransformer tra_cc(
    Vhigh=220,
    XoverR=8,
    Zperc=0.03,
    VAbase=4000,
    Vlow=110)
    annotation (Placement(transformation(extent={{-16,0},{4,20}})));
  Buildings.Electrical.AC.OnePhase.Loads.Impedance shortCircuit(R=1e-8)
    annotation (Placement(transformation(extent={{10,0},{30,20}})));
  Buildings.Electrical.AC.OnePhase.Conversion.ACACTransformer tra_void(
    Vhigh=220,
    XoverR=8,
    Zperc=0.03,
    VAbase=4000,
    Vlow=110)
    annotation (Placement(transformation(extent={{-16,-30},{4,-10}})));
equation
  connect(sou.terminal, tra_load.terminal_n)
                                            annotation (Line(
      points={{-60,50},{-18,50}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(tra_load.terminal_p, load.terminal)    annotation (Line(
      points={{2,50},{10,50}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(ramp.y, load.Pow) annotation (Line(
      points={{49,50},{30,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.terminal, tra_cc.terminal_n) annotation (Line(
      points={{-60,50},{-38,50},{-38,10},{-16,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(tra_cc.terminal_p, shortCircuit.terminal) annotation (Line(
      points={{4,10},{10,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(sou.terminal, tra_void.terminal_n) annotation (Line(
      points={{-60,50},{-38,50},{-38,-20},{-16,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), experiment(StopTime=1.0, Tolerance=1e-05),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>
This model illustrates the use of a model that converts AC voltage to AC voltage.
</p>
</html>",
      revisions="<html>
<ul>
<li>
January 29, 2013, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/OnePhase/Conversion/Examples/ACACTrasformer.mos"
        "Simulate and plot"));
end ACACTransformer;
