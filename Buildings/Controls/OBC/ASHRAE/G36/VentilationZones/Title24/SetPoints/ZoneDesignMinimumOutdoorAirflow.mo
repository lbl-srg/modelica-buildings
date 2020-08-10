within Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.SetPoints;
block ZoneDesignMinimumOutdoorAirflow
  "Zone design outdoor airflow setpoint"

  parameter Boolean have_winSwi "The zone has a window switch";

  parameter Boolean have_occSen  "The zone has occupancy sensor";

  parameter Real VAreMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Zone minimum outdoor airflow for building area, per California Title 24 prescribed airflow-per-area requirements"
    annotation(Dialog(enable=have_occSen));

  parameter Real VOccMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Zone minimum outdoor airflow for occupants, per California Title 24 prescribed airflow-per-occupant requirements"
    annotation(Dialog(enable=have_occSen));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWin if have_winSwi
    "Window status, true if open, false if closed"
    annotation (Placement(transformation(extent={{-140,10},{-100,50}}),
        iconTransformation(extent={{-240,-120},{-200,-80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOcc if have_occSen
    "True if the zone is populated, that is the occupancy sensor senses the presence of people"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
        iconTransformation(extent={{-240,80},{-200,120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VOutMinZonDes_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Outdoor air volume flow setpoint used in AHU sequeces"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

equation

annotation (
  defaultComponentName = "VOutMinZonDes",
  Icon(graphics={Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          lineColor={0,0,255},
          textString="%name")}),
   Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
 Documentation(info="<html>
<p>
fixme
</p>

</html>", revisions="<html>
<ul>
<li>
Jun 20, 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end ZoneDesignMinimumOutdoorAirflow;
