within Buildings.Electrical.AC.OnePhase.Conversion.Examples;
model ACACTransformer
  "This example illustrates how to use the AC/AC simplified transformer model"
  extends Modelica.Icons.Example;
  Buildings.Electrical.AC.OnePhase.Conversion.ACACTransformer tra_load(
    Zperc=0.03,
    VABase=4000,
    XoverR=8,
    VHigh=120,
    VLow=60) "Transformer with load"
    annotation (Placement(transformation(extent={{-18,40},{2,60}})));
  Buildings.Electrical.AC.OnePhase.Sources.FixedVoltage sou(
    definiteReference=true,
    f=60,
    V=120) "Voltage source"
      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={-70,50})));
  Buildings.Electrical.AC.OnePhase.Loads.Inductive load(
    mode=Buildings.Electrical.Types.Load.VariableZ_P_input,
    P_nominal=-2000,
    pf=0.8,
    V_nominal=60) "Load model"
    annotation (Placement(transformation(extent={{10,40},{30,60}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=0.5,
    startTime=0.3,
    offset=0,
    height=-4000*0.8) "Load power consumption profile"
    annotation (Placement(transformation(extent={{70,40},{50,60}})));
  Buildings.Electrical.AC.OnePhase.Conversion.ACACTransformer tra_cc(
    XoverR=8,
    Zperc=0.03,
    VABase=4000,
    VHigh=120,
    VLow=60) "Transformer with short circuit"
    annotation (Placement(transformation(extent={{-16,0},{4,20}})));
  Buildings.Electrical.AC.OnePhase.Loads.Impedance shortCircuit(R=1e-8)
    "Short circuit"
    annotation (Placement(transformation(extent={{10,0},{30,20}})));
  Buildings.Electrical.AC.OnePhase.Conversion.ACACTransformer tra_void(
    XoverR=8,
    Zperc=0.03,
    VABase=4000,
    VHigh=120,
    VLow=60) "Transformer with secondary not connected"
    annotation (Placement(transformation(extent={{-16,-30},{4,-10}})));
  Buildings.Electrical.AC.OnePhase.Sources.FixedVoltage sou1(
    definiteReference=true,
    f=60,
    V=120) "Voltage source for open and short circuit tests"
                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={-70,10})));
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
  connect(tra_cc.terminal_p, shortCircuit.terminal) annotation (Line(
      points={{4,10},{10,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(sou1.terminal, tra_cc.terminal_n) annotation (Line(
      points={{-60,10},{-16,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(sou1.terminal, tra_void.terminal_n) annotation (Line(
      points={{-60,10},{-38,10},{-38,-20},{-16,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation ( experiment(StopTime=1.0, Tolerance=1e-05),
Documentation(info="<html>
<p>
This example illustrates the use of a the AC/AC transformer model.
The example shows three different configurations:
</p>
<ul>
<li>With a load connected,</li>
<li>without a load connected, and</li>
<li>with a short circuit connection.</li>
</ul>
</html>",
      revisions="<html>
<ul>
<li>
August 5, 2014, by Marco Bonvini:<br/>
Revised model and documentation.
</li>
<li>
January 29, 2013, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/OnePhase/Conversion/Examples/ACACTransformer.mos"
        "Simulate and plot"));
end ACACTransformer;
