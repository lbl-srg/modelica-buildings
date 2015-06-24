within Buildings.HeatTransfer.Convection.Examples;
model Interior "Test model for convective heat transfer coefficients"
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Ramp step(
    duration=1,
    startTime=0,
    height=10,
    offset=293.15 - 5)
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TB(T=293.15)
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.HeatTransfer.Convection.Interior conCon(
                                           A=1,
  til=Buildings.Types.Tilt.Wall)    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-30,10})));
  Buildings.HeatTransfer.Convection.Interior conVer(
                                           A=1,
  til=Buildings.Types.Tilt.Wall,
  conMod=Buildings.HeatTransfer.Types.InteriorConvection.Temperature)
                                                               annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={10,10})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TA1
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TA2
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TA3
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TA4
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Buildings.HeatTransfer.Convection.Interior conHorFluTop(
    A=1,
    til=Buildings.Types.Tilt.Floor,
    conMod=Buildings.HeatTransfer.Types.InteriorConvection.Temperature)
    "Convection model with fluid on top"        annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={50,10})));
  Buildings.HeatTransfer.Convection.Interior conHorSolTop(
    A=1,
    til=Buildings.Types.Tilt.Ceiling,
    conMod=Buildings.HeatTransfer.Types.InteriorConvection.Temperature)
    "Convection model with solid on top"        annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={90,10})));
  Buildings.HeatTransfer.Sources.FixedTemperature TB1(T=293.15)
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TB2(T=293.15)
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TB3(T=293.15)
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
equation
  connect(conCon.solid, TB.port) annotation (Line(
      points={{-30,-5.55112e-16},{-30,-30},{-40,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(step.y, TA4.T) annotation (Line(
      points={{-79,80},{54,80},{54,50},{58,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(step.y, TA3.T) annotation (Line(
      points={{-79,80},{14,80},{14,50},{18,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(step.y, TA2.T) annotation (Line(
      points={{-79,80},{-26,80},{-26,50},{-22,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(step.y, TA1.T) annotation (Line(
      points={{-79,80},{-72,80},{-72,50},{-62,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TA1.port, conCon.fluid) annotation (Line(
      points={{-40,50},{-30,50},{-30,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TA2.port, conVer.fluid) annotation (Line(
      points={{5.55112e-16,50},{10,50},{10,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TA3.port, conHorFluTop.fluid) annotation (Line(
      points={{40,50},{50,50},{50,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TA4.port, conHorSolTop.fluid) annotation (Line(
      points={{80,50},{90,50},{90,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TB1.port, conVer.solid) annotation (Line(
      points={{5.55112e-16,-30},{10,-30},{10,-5.55112e-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TB2.port, conHorFluTop.solid) annotation (Line(
      points={{40,-30},{50,-30},{50,-5.55112e-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TB3.port, conHorSolTop.solid) annotation (Line(
      points={{80,-30},{90,-30},{90,-5.55112e-16}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/HeatTransfer/Convection/Examples/Interior.mos" "Simulate and plot"),
    Documentation(info="<html>
This example tests the convective heat transfer models.
</html>", revisions="<html>
<ul>
<li>
March 9 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Interior;
