within Buildings.Experimental.ScalableModels.Controls;
expandable connector ControlBus_withSub
  extends Modelica.Icons.SignalBus;
  parameter Integer nSubBus "Sub-bus used for sub-system control";

  Buildings.Experimental.ScalableModels.Controls.SubControlBus subBus[nSubBus]
    "Combined signal"
    annotation (HideResult=false);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ControlBus_withSub;
