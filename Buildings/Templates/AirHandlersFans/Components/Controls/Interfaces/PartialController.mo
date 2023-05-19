within Buildings.Templates.AirHandlersFans.Components.Controls.Interfaces;
partial block PartialController "Interface class for AHU controller"

  parameter Buildings.Templates.AirHandlersFans.Types.Controller typ
    "Type of controller"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Integer nZon
    "Number of served zones";

  outer parameter Buildings.Templates.Data.AllSystems datAll
    "Top-level (whole building) system parameters";
  outer parameter Buildings.Templates.Components.Types.Fan typFanSup
    "Type of supply fan";
  outer parameter Buildings.Templates.Components.Types.Fan typFanRet
    "Type of relief/return fan";

  replaceable parameter
    Buildings.Templates.AirHandlersFans.Components.Data.PartialController dat(
    final typ=typ,
    final typFanSup=typFanSup,
    final typFanRet=typFanRet)
    "Design and operating parameters"
    annotation (Placement(transformation(extent={{190,170},{210,190}})));

  Buildings.Templates.AirHandlersFans.Interfaces.Bus bus
    "AHU control bus"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-200,0}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-100,0})));
  Buildings.Templates.ZoneEquipment.Interfaces.Bus busTer[nZon]
    "Terminal unit control bus"
    annotation (Placement(transformation(
        extent={{-20,20},{20,-20}},
        rotation=90,
        origin={220,0}), iconTransformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={100,0})));

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
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
This partial class provides a standard interface for air handler controllers.
</p>
</html>"));
end PartialController;
