within Buildings.Utilities.IO.Files.Examples;
model JSONWriter "Example use of the JSON writer"
  extends Modelica.Icons.Example;
  Buildings.Utilities.IO.Files.JSONWriter jsonWriterInitial(
    nin=3,
    fileName="InitialOutputs.json",
    outputTime=Buildings.Utilities.IO.Files.BaseClasses.OutputTime.Initial)
    "Outputs at initial time"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Utilities.IO.Files.JSONWriter jsonWriterCustom(
    nin=3,
    outputTime=Buildings.Utilities.IO.Files.BaseClasses.OutputTime.Custom,
    customTime=0.5,
    fileName="CustomOutputs.json",
    varKeys={"Output1","Key2","Name3"}) "Outputs at custom time"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Utilities.IO.Files.JSONWriter jsonWriterTerminal(
    nin=3,
    outputTime=Buildings.Utilities.IO.Files.BaseClasses.OutputTime.Terminal,
    fileName="TerminalOutputs.json") "Outputs at terminal time"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=1,
    duration=1,
    offset=1) "Ramp signal" annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.Constant const(k=2) "Constant signal"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Sources.Cosine cosine(amplitude=1, f=12) "Cosine signal"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Utilities.IO.Files.JSONWriter jsonWriterOneVar(nin=1, fileName="TerminalOutput.json")
    "Single variable output"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
equation
  connect(ramp.y, jsonWriterInitial.u[1]) annotation (Line(points={{-59,30},{
          -30,30},{-30,31.3333},{0,31.3333}},
                                          color={0,0,127}));
  connect(const.y, jsonWriterInitial.u[2]) annotation (Line(points={{-59,0},{-28,
          0},{-28,30},{0,30}}, color={0,0,127}));
  connect(cosine.y, jsonWriterInitial.u[3]) annotation (Line(points={{-59,-30},
          {-26,-30},{-26,28.6667},{0,28.6667}},color={0,0,127}));
  connect(ramp.y, jsonWriterCustom.u[1]) annotation (Line(points={{-59,30},{-30,
          30},{-30,1.33333},{0,1.33333}}, color={0,0,127}));
  connect(ramp.y, jsonWriterTerminal.u[1]) annotation (Line(points={{-59,30},{
          -30,30},{-30,-28.6667},{0,-28.6667}},
                                            color={0,0,127}));
  connect(const.y, jsonWriterCustom.u[2])
    annotation (Line(points={{-59,0},{0,0}}, color={0,0,127}));
  connect(const.y, jsonWriterTerminal.u[2]) annotation (Line(points={{-59,0},{-28,
          0},{-28,-30},{0,-30}}, color={0,0,127}));
  connect(cosine.y, jsonWriterCustom.u[3]) annotation (Line(points={{-59,-30},{-26,
          -30},{-26,-2},{0,-2},{0,-1.33333}}, color={0,0,127}));
  connect(cosine.y, jsonWriterTerminal.u[3]) annotation (Line(points={{-59,-30},
          {-30,-30},{-30,-31.3333},{0,-31.3333}}, color={0,0,127}));
  connect(const.y, jsonWriterOneVar.u[1]) annotation (Line(points={{-59,0},{-40,
          0},{-40,-70},{0,-70}}, color={0,0,127}));
  annotation (
    Documentation(info="<html>
<p>
This model generates four json files,
using a single or multiple inputs and at different points in time.
</p>
</html>", revisions="<html>
<ul>
<li>
April 9, 2019 by Filip Jorissen:<br/>
First implementation.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1114\">#1114</a>.
</li>
</ul>
</html>"),
    experiment(
      StopTime=2,
      Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/IO/Files/Examples/JSONWriter.mos"
        "Simulate and plot"));
end JSONWriter;
