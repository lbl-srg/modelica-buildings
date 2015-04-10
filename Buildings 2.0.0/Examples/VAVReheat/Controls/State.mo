within Buildings.Examples.VAVReheat.Controls;
model State
  "Block that outputs the mode if the state is active, or zero otherwise"
  extends Modelica.StateGraph.StepWithSignal;
 parameter OperationModes mode "Enter enumeration of mode";
  Modelica.Blocks.Interfaces.IntegerOutput y "Mode signal (=0 if not active)"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
equation
   y = if localActive then Integer(mode) else 0;
  annotation (Icon(graphics={Text(
          extent={{-82,96},{82,-84}},
          lineColor={0,0,255},
          textString="state")}));
end State;
