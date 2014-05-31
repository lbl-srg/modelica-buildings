within Buildings.Electrical.AC.OnePhase.Loads.Examples;
model VariableImpedance "Test with a variable impedance"
  extends Modelica.Icons.Example;
  Buildings.Electrical.AC.OnePhase.Sources.FixedVoltage V(f=60, V=110)
           annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Electrical.AC.OnePhase.Loads.Impedance Z_L(
    R=0,
    inductive=true,
    L=1/(2*Modelica.Constants.pi*50),
    useVariableL=true,
    Lmin=1/(2*Modelica.Constants.pi*50),
    Lmax=2/(2*Modelica.Constants.pi*50))
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Buildings.Electrical.AC.OnePhase.Loads.Impedance Z_C(
    R=0,
    inductive=false,
    C=1/(2*Modelica.Constants.pi*50),
    useVariableC=true,
    Cmin=1/(2*Modelica.Constants.pi*50),
    Cmax=2/(2*Modelica.Constants.pi*50))
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Electrical.AC.OnePhase.Loads.Impedance Z_R(
    R=1,
    Rmin=1,
    Rmax=2,
    useVariableR=true,
    L=0)
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Modelica.Blocks.Sources.Ramp load(duration=0.5, startTime=0.2,
    height=1,
    offset=0)
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));
equation
  connect(V.terminal, Z_L.terminal) annotation (Line(
      points={{-60,6.66134e-16},{-40,6.66134e-16},{-40,-50},{-20,-50}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(V.terminal, Z_C.terminal)
                                   annotation (Line(
      points={{-60,6.66134e-16},{-20,6.66134e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(V.terminal, Z_R.terminal)
                                   annotation (Line(
      points={{-60,6.66134e-16},{-40,6.66134e-16},{-40,50},{-20,50}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(load.y, Z_R.y_R) annotation (Line(
      points={{39,0},{30,0},{30,80},{-14,80},{-14,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(load.y, Z_C.y_C) annotation (Line(
      points={{39,4.44089e-16},{30,4.44089e-16},{30,20},{-10,20},{-10,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(load.y, Z_L.y_L) annotation (Line(
      points={{39,6.66134e-16},{34,6.66134e-16},{34,0},{30,0},{30,-20},{-6,-20},
          {-6,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (experiment(StopTime=1.0, Tolerance=1e-06),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),            graphics),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/OnePhase/Loads/Examples/TestImpedance.mos"
        "Simulate and plot"));
end VariableImpedance;
