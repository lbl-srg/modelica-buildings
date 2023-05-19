within Buildings.Templates.ZoneEquipment.Components.Controls.Interfaces;
partial block PartialController "Interface class for terminal unit controller"

  parameter Buildings.Templates.ZoneEquipment.Types.Controller typ
    "Type of controller"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  replaceable parameter
    Buildings.Templates.ZoneEquipment.Components.Data.PartialController dat(
      final typ=typ)
      "Design and operating parameters"
      annotation (Placement(transformation(extent={{190,170},{210,190}})));

  outer parameter Buildings.Templates.Data.AllSystems datAll
    "Top-level (whole building) system parameters";

  Buildings.Templates.ZoneEquipment.Interfaces.Bus bus
    "Terminal unit control bus"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-200,0}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-100,0})));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-151,-114},{149,-154}},
          textColor={0,0,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-200},{220,
            200}})),
    Documentation(info="<html>
<p>
This partial class provides a standard interface for terminal unit controllers.
</p>
</html>"));
end PartialController;
