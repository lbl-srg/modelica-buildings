within Buildings.Fluid.BaseClasses.Validation;
model ActuatorFilter "Validation model for the actuator filter"
  extends Modelica.Icons.Example;

  parameter Modelica.Units.SI.Time riseTime=10 "Cut-off frequency of filter";
  final parameter Modelica.Units.SI.Frequency fCut=5/(2*Modelica.Constants.pi*
      riseTime) "Cut-off frequency of filter";

  Buildings.Fluid.BaseClasses.ActuatorFilter act_1(f=fCut, initType=Modelica.Blocks.Types.Init.InitialState)
    "Filter with u_nominal not set"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.Fluid.BaseClasses.ActuatorFilter act_2(f=fCut, initType=Modelica.Blocks.Types.Init.InitialState)
    "Filter with u_nominal set to 100"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Modelica.Blocks.Math.Gain gain(k=100) "Gain for input signal"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Modelica.Blocks.Sources.Step step(startTime=0)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Fluid.BaseClasses.ActuatorFilter act_y_start05(
    f=fCut,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=0.5) "Filter with initial start value for output"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Buildings.Fluid.BaseClasses.ActuatorFilter act_y_start1(
    f=fCut,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=1) "Filter with initial start value for output"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
equation
  connect(act_2.u, gain.y)
    annotation (Line(points={{18,-50},{1,-50}}, color={0,0,127}));
  connect(step.y, act_1.u)
    annotation (Line(points={{-59,30},{-28,30},{-28,-10},{18,-10}},
                                                color={0,0,127}));
  connect(step.y, gain.u) annotation (Line(points={{-59,30},{-28,30},{-28,-50},{
          -22,-50}}, color={0,0,127}));
  connect(act_y_start05.u, step.y) annotation (Line(points={{18,70},{-28,70},{-28,
          30},{-59,30}}, color={0,0,127}));
  connect(act_y_start1.u, step.y)
    annotation (Line(points={{18,30},{-59,30}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/BaseClasses/Validation/ActuatorFilter.mos"
        "Simulate and plot"),
    experiment(
      StopTime=20,
      Tolerance=1e-06),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Fluid.BaseClasses.ActuatorFilter\">
Buildings.Fluid.BaseClasses.ActuatorFilter</a>.
The validation is done for different settings of <code>u_nominal</code> and for
different start values of the filter output.
</p>
</html>", revisions="<html>
<ul>
<li>
July 22, 2021, by Michael Wetter:<br/>
First implementation for
<a href=\"https://https://github.com/ibpsa/modelica-ibpsa/issues/1498\">IBPSA, #1498</a>
</li>
</ul>
</html>"));
end ActuatorFilter;
