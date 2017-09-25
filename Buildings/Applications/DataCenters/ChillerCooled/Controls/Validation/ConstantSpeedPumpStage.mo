within Buildings.Applications.DataCenters.ChillerCooled.Controls.Validation;
model ConstantSpeedPumpStage
  "Test the model ChillerWSE.Examples.BaseClasses.ConstatnSpeedPumpStageControl"
  extends Modelica.Icons.Example;

  Buildings.Applications.DataCenters.ChillerCooled.Controls.ConstantSpeedPumpStage
  conSpePumSta(
    tWai=30)
    "Staging controller for constant speed pumps"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.IntegerTable cooMod(
    table=[0,0; 360,1;
           720,2; 1080,3])
    "Cooling mode"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Sources.IntegerTable chiNumOn(
    table=[0,0; 360,1; 540,2; 720,1;
           900,2; 1080,1; 1260,2; 1440,1])
    "The number of running chillers"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
equation
  connect(cooMod.y, conSpePumSta.cooMod)
    annotation (Line(points={{-39,50},{-20,50},{-20,5},{-12,5}},
                        color={255,127,0}));
  connect(chiNumOn.y,conSpePumSta.numOnChi)
    annotation (Line(points={{-39,-30},{-20,-30},{-20,-5},{-12,-5}},
                        color={255,127,0}));
  annotation (    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Applications/DataCenters/ChillerCooled/Controls/Validation/ConstantSpeedPumpStage.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example test how the number of required constant-speed pumps varies
based on cooling mode signals and the number of running chillers. Detailed
control logic can be found in
<a href=\"modelica://Buildings.Applications.DataCenters.ChillerCooled.Controls.ConstantSpeedPumpStage\">
Buildings.Applications.DataCenters.ChillerCooled.Controls.ConstantSpeedPumpStage</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 25, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(
      StartTime=0,
      StopTime=1440,
      Tolerance=1e-06));
end ConstantSpeedPumpStage;
