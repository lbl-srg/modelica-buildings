within Districts.Electrical.AC.OnePhase.Conversion.Examples;
model ACDCConverter "Test model AC to DC converter"
  import Districts;
  extends Modelica.Icons.Example;

  Districts.Electrical.DC.Loads.Resistor    res(R=1)      annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={50,10})));
  Districts.Electrical.AC.OnePhase.Conversion.ACDCConverter
                                                         conversion(
    eta=0.9,
    conversionFactor=0.5,
    ground_AC=false)
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  Districts.Electrical.AC.OnePhase.Sources.FixedVoltage                 sou(
    f=60,
    V=120,
    phi=0)                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-62,10})));
  Districts.Electrical.DC.Loads.Conductor   load(P_nominal=200, mode=Districts.Electrical.Types.Assumption.VariableZ_P_input)
                                                          annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={50,-10})));
  Modelica.Blocks.Sources.Ramp pow(
    duration=0.5,
    startTime=0.2,
    offset=-200,
    height=5200)
    annotation (Placement(transformation(extent={{90,-20},{70,0}})));
equation
  connect(sou.terminal, conversion.terminal_n) annotation (Line(
      points={{-52,10},{-10,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(conversion.terminal_p, res.terminal) annotation (Line(
      points={{10,10},{40,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(conversion.terminal_p, load.terminal) annotation (Line(
      points={{10,10},{30,10},{30,-10},{40,-10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pow.y, load.Pow) annotation (Line(
      points={{69,-10},{60,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), experiment(Tolerance=1e-05),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>
This model illustrates the use of a model that converts AC voltage to DC voltage.
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
          "modelica://Districts/Resources/Scripts/Dymola/Electrical/AC/Conversion/Examples/ACDCConverter.mos"
        "Simulate and plot"));
end ACDCConverter;
