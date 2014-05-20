within Buildings.Controls.DemandResponse.Examples;
model ConstantInput
  "Demand response client with constant input for actual power consumption"
  extends SineInput(redeclare Modelica.Blocks.Sources.Constant PCon(k=1));
  annotation (
  experiment(StopTime=172800),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/DemandResponse/Examples/ConstantInput.mos"
        "Simulate and plot"));
end ConstantInput;
