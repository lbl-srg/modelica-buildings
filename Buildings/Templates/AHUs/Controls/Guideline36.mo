within Buildings.Experimental.Templates.AHUs.Controls;
block Guideline36 "Guideline 36 VAV single duct controller"
  extends Interfaces.Controller;
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller conAHU
    annotation (Placement(transformation(extent={{-40,-64},{40,80}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
WARNING: Do not use. Not configured and connected yet!
</p>
</html>"));
end Guideline36;
