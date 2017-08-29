within Buildings.ChillerWSE.Examples.BaseClasses.Controls.Examples;
model ChillerStageControl
  "Test the model ChillerWSE.Examples.BaseClasses.ChillerStageControl"
  extends Modelica.Icons.Example;

  Buildings.ChillerWSE.Examples.BaseClasses.Controls.ChillerStageControl chiStaCon(
    tWai=30)
    "Staging controller for chillers"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Pulse QTot(
    amplitude=0.4*chiStaCon.QEva_nominal,
    period=180,
    offset=0.5*chiStaCon.QEva_nominal)
    "Total cooling load in chillers"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Sources.CombiTimeTable cooMod(table=[0,0; 360,0; 360,1; 720,1;
        720,2])
    "Cooling mode"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
equation
  connect(QTot.y, chiStaCon.QTot)
    annotation (Line(points={{-39,-30},{-26,-30},
          {-26,4},{-12,4}}, color={0,0,127}));
  connect(cooMod.y[1], chiStaCon.cooMod)
    annotation (Line(points={{-39,50},{-26,
          50},{-26,8},{-12,8}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/ChillerWSE/Examples/BaseClasses/Controls/Examples/ChillerStageControl.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>
This example test the chiller staging controller implemented in 
<a href=\"modelica://Buildings.ChillerWSE.Examples.BaseClasses.Controls.ChillerStageControl\">
Buildings.ChillerWSE.Examples.BaseClasses.Controls.ChillerStageControl</a>.
</p>
<p>
The number of running chillers is determined by cooling mode signal and total cooling load. In Free Cooling
(FC) mode, no chillers are required; in Partial Mechanic Cooling (PMC) mode and Fully Mechanic Cooling (FMC) mode,
chillers are required to run and the running number is based on cooling load. Details can be found in 
<a href=\"modelica://Buildings.ChillerWSE.Examples.BaseClasses.Controls.ChillerStageControl\">
Buildings.ChillerWSE.Examples.BaseClasses.Controls.ChillerStageControl</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 25, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ChillerStageControl;
