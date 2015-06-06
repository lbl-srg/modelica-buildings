within Buildings.Rooms.BaseClasses.Examples;
model CFDHeatGain "Test model for the CFDHeatGain model"
  extends Modelica.Icons.Example;

  package MediumA = Buildings.Media.Air "Medium model";

  parameter Modelica.SIunits.Area AFlo=50 "Floor area";

  Buildings.Rooms.BaseClasses.CFDHeatGain heatGain(
    AFlo=AFlo)
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Sources.Constant qConGai_flow(k=10) "Convective heat gain"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Sources.Constant qRadGai_flow1(k=5) "Radiative heat gain"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Sources.Constant qLatGai_flow(k=12) "Latent heat gain"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
equation
  connect(qRadGai_flow1.y,multiplex3_1. u1[1]) annotation (Line(
      points={{-59,30},{-52,30},{-52,7},{-42,7}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(qConGai_flow.y,multiplex3_1. u2[1]) annotation (Line(
      points={{-59,6.10623e-16},{-54,6.10623e-16},{-54,0},{-50,0},{-50,
          6.66134e-16},{-42,6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(qLatGai_flow.y, multiplex3_1.u3[1])  annotation (Line(
      points={{-59,-30},{-52,-30},{-52,-7},{-42,-7}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiplex3_1.y, heatGain.qGai_flow) annotation (Line(
      points={{-19,6.10623e-16},{-14,6.10623e-16},{-14,0},{-10,0},{-10,
          6.66134e-16},{-2,6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (experiment(StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Rooms/BaseClasses/Examples/CFDHeatGain.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example tests the model for the internal heat gain that is used in the CFD model.
</p>
</html>", revisions="<html>
<ul>
<li>
March 17, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end CFDHeatGain;
