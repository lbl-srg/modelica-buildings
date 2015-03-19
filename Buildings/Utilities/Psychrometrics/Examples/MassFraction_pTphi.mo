within Buildings.Utilities.Psychrometrics.Examples;
model MassFraction_pTphi "Unit test for dew point temperature calculation"
  extends Modelica.Icons.Example;

   package Medium1 = Buildings.Media.Air "Medium model";
   package Medium2 = Buildings.Media.Air "Medium model";
    Modelica.Blocks.Sources.Ramp Phi(
    offset=0,
    duration=0.5,
    height=1) "Relative humidity"
                 annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Utilities.Psychrometrics.X_pTphi masFra1
    "Mass fraction computation"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
    Modelica.Blocks.Sources.Ramp T(
    height=10,
    offset=283.15,
    duration=0.5,
    startTime=0.5) "Temperature"
                 annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
    Modelica.Blocks.Sources.Constant P(k=101325) "Pressure"
                 annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Utilities.Psychrometrics.X_pTphi masFra2(use_p_in=false)
    "Mass fraction computation"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
equation
  connect(T.y, masFra1.T)
                         annotation (Line(
      points={{-59,-10},{-34,-10},{-34,10},{-22,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Phi.y, masFra1.phi)
                             annotation (Line(
      points={{-59,-50},{-44,-50},{-44,4},{-22,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T.y, masFra2.T)
                         annotation (Line(
      points={{-59,-10},{-34,-10},{-34,-30},{-22,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Phi.y, masFra2.phi)
                             annotation (Line(
      points={{-59,-50},{-44,-50},{-44,-36},{-22,-36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(P.y, masFra1.p_in) annotation (Line(
      points={{-59,30},{-42,30},{-42,16},{-22,16}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Psychrometrics/Examples/MassFraction_pTphi.mos"
        "Simulate and plot"));
end MassFraction_pTphi;
