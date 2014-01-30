within Buildings.Electrical.AC.OnePhase.Conversion.Examples;
model ACACTransformer "Test model AC to AC trasformer"
  import Buildings;
  extends Modelica.Icons.Example;
  Buildings.Electrical.AC.OnePhase.Conversion.ACACTransformer trasformer(
    Vhigh=220,
    XoverR=8,
    Zperc=0.03,
    VAbase=4000,
    Vlow=110)
    annotation (Placement(transformation(extent={{-8,0},{12,20}})));
  Buildings.Electrical.AC.OnePhase.Sources.FixedVoltage                 sou(
    f=60,
    definiteReference=true,
    V=220,
    Phi=0)                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-60,10})));
  Buildings.Electrical.AC.OnePhase.Loads.InductiveLoadP
                                             load(
                      mode=Buildings.Electrical.Types.Assumption.VariableZ_P_input, pf=1)
    annotation (Placement(transformation(extent={{24,0},{44,20}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=0.5,
    startTime=0.3,
    offset=0,
    height=-2000)
    annotation (Placement(transformation(extent={{80,0},{60,20}})));
equation
  connect(sou.terminal, trasformer.terminal_n)
                                            annotation (Line(
      points={{-50,10},{-8,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(trasformer.terminal_p, load.terminal)  annotation (Line(
      points={{12,10},{24,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(ramp.y, load.Pow) annotation (Line(
      points={{59,10},{44,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), experiment(Tolerance=1e-05),
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
    Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/Conversion/Examples/ACACConverter.mos"
        "Simulate and plot"));
end ACACTransformer;
