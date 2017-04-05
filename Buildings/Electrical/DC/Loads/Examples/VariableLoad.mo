within Buildings.Electrical.DC.Loads.Examples;
model VariableLoad "Example using variable loads models"
  extends Modelica.Icons.Example;
  Conductor loa1(
    V_nominal=12,
    linearized=false,
    P_nominal=-50) "Load"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Sources.ConstantVoltage sou(V=12) "Voltage source"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Electrical.Analog.Basic.Ground gro "Ground"
    annotation (Placement(transformation(extent={{-90,-2},{-70,18}})));
  Conductor loa2(              mode=Types.Load.VariableZ_y_input,
    V_nominal=12,
    P_nominal=-50) "Load"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Modelica.Blocks.Sources.Ramp varLoad_y(
    height=0.8,
    duration=0.5,
    startTime=0.3,
    offset=0) "Power signal"
    annotation (Placement(transformation(extent={{60,0},{40,20}})));
  Conductor loa3(
    V_nominal=12,
    P_nominal=0,
    mode=Buildings.Electrical.Types.Load.VariableZ_P_input) "Load"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Modelica.Blocks.Sources.Ramp varLoad_P(
    duration=0.5,
    startTime=0.3,
    height=120,
    offset=-20) "Power signal"
    annotation (Placement(transformation(extent={{60,-40},{40,-20}})));
  Lines.TwoPortResistance res(R=0.1) "Line resistance"
    annotation (Placement(transformation(extent={{-32,40},{-12,60}})));
  Sensors.GeneralizedSensor sen "Sensor"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
equation
  connect(sou.terminal, loa2.terminal)
                                      annotation (Line(
      points={{-60,30},{-40,30},{-40,10},{-4.44089e-16,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(varLoad_y.y, loa2.y)  annotation (Line(
      points={{39,10},{20,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.terminal, loa3.terminal)
                                      annotation (Line(
      points={{-60,30},{-40,30},{-40,-30},{-4.44089e-16,-30}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(varLoad_P.y, loa3.Pow)  annotation (Line(
      points={{39,-30},{20,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.terminal, res.terminal_n)
                                      annotation (Line(
      points={{-60,30},{-40,30},{-40,50},{-32,50}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(res.terminal_p, sen.terminal_n) annotation (Line(
      points={{-12,50},{0,50}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sen.terminal_p, loa1.terminal) annotation (Line(
      points={{20,50},{40,50}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sou.n, gro.p) annotation (Line(
      points={{-80,30},{-80,18}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (            experiment(StopTime=1.0, Tolerance=1e-06),
            __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/DC/Loads/Examples/VariableLoad.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example shows how to use three different types of load models.
Each load is of type <a href=\"modelica://Buildings.Electrical.DC.Loads.Conductor\">
Buildings.Electrical.DC.Loads.Conductor</a>.
</p>
<p>
The first load <code>loa1</code>consumes a constant amount of power.
The second and the third loads (<code>loa2</code> and <code>loa3</code>) consume a variable amount of power.
The load <code>loa2</code> has a variable input <code>y</code> between 0 and 1 that specifies the portion of
nominal power that is consumed.
The load <code>loa3</code> has a variable input <code>Pow</code> that represents the actual power consumed
(or produced) by the load.
</p>
</html>", revisions="<html>
<ul>
<li>
June 2, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>"));
end VariableLoad;
