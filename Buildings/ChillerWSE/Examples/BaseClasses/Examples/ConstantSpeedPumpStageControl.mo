within Buildings.ChillerWSE.Examples.BaseClasses.Examples;
model ConstantSpeedPumpStageControl
  "Test the model ChillerWSE.Examples.BaseClasses.ConstatnSpeedPumpStageControl"

  extends Modelica.Icons.Example;

  .Buildings.ChillerWSE.Examples.BaseClasses.ConstantSpeedPumpStageControl conSpePumSta(tWai=30)
    "Staging controller for constant speed pumps"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.CombiTimeTable cooMod(table=[0,0; 360,0; 360,1; 720,1;
        720,2]) "Cooling mode"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Sources.CombiTimeTable chiNumOn(table=[0,0; 360,0; 360,1; 540,
        1; 540,2; 720,2; 720,1; 900,1; 900,2]) "The number of running chillers"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
equation
  connect(cooMod.y[1], conSpePumSta.cooMod) annotation (Line(points={{-39,50},{
          -26,50},{-26,8},{-12,8}}, color={0,0,127}));
  connect(chiNumOn.y[1], conSpePumSta.chiNumOn) annotation (Line(points={{-39,
          -30},{-26,-30},{-26,4},{-12,4}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/ChillerWSE/Examples/BaseClasses/Examples/ConstantSpeedPumpStageControl.mos"
        "Simulate and Plot"));
end ConstantSpeedPumpStageControl;
