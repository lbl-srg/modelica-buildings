within Districts.Electrical.AC.OnePhase.Conversion.Examples;
model ACACConverter "Test model AC to AC converter"
  import Districts;
  extends Modelica.Icons.Example;
  Districts.Electrical.AC.OnePhase.Conversion.ACACConverter
    conACAC(                      eta=0.9, conversionFactor=220/220)
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  Districts.Electrical.AC.OnePhase.Sources.FixedVoltage                 sou(
    f=60,
    definiteReference=true,
    V=220,
    Phi=0)                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-60,10})));
  Districts.Electrical.AC.OnePhase.Loads.InductiveLoadP
                                             load(
      P_nominal=1000, mode=Districts.Electrical.Types.Assumption.VariableZ_P_input)
    annotation (Placement(transformation(extent={{24,0},{44,20}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=0.5,
    startTime=0.3,
    height=2000,
    offset=-1000)
    annotation (Placement(transformation(extent={{80,0},{60,20}})));
equation
  connect(sou.terminal, conACAC.terminal_n) annotation (Line(
      points={{-50,10},{-10,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(conACAC.terminal_p, load.terminal)     annotation (Line(
      points={{10,10},{24,10}},
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
          "modelica://Districts/Resources/Scripts/Dymola/Electrical/AC/Conversion/Examples/ACACConverter.mos"
        "Simulate and plot"));
end ACACConverter;
