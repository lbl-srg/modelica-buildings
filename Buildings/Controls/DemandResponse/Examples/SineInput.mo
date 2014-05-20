within Buildings.Controls.DemandResponse.Examples;
model SineInput
  "Demand response client with sinusoidal input for actual power consumption"
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.Time tCycle = 24*3600 "Cycle time";
  parameter Modelica.SIunits.Time tSample = 3600 "Sampling period";
  Client client(tSample=tSample) "Demand response client"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  replaceable Modelica.Blocks.Sources.Cosine PCon(
    freqHz=1/3600/24,
    amplitude=0.5,
    offset=0.5,
    phase=3.1415926535898) constrainedby Modelica.Blocks.Interfaces.SO
    "Measured power consumption"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Modelica.Blocks.Sources.BooleanPulse  tri(
    period=tCycle,
    startTime=0.5*tCycle,
    width=4/24*100) "Sample trigger"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Sources.DayType dayType "Outputs the type of the day"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
equation
  connect(PCon.y, client.PCon) annotation (Line(
      points={{-19,-30},{0,-30},{0,6.66134e-16},{18,6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tri.y, client.shed) annotation (Line(
      points={{-19,50},{0,50},{0,-6},{18,-6}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(client.isEventDay, client.shed) annotation (Line(
      points={{19,4},{0,4},{0,-6},{18,-6}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(dayType.y, client.typeOfDay) annotation (Line(
      points={{-19,10},{0,10},{0,8},{19,8}},
      color={0,127,0},
      smooth=Smooth.None));
  annotation (
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),                                                                    graphics),
          __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/DemandResponse/Examples/SineInput.mos"
        "Simulate and plot"),
            experiment(StopTime=172800));
end SineInput;
