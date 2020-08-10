within Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.SetPoints;
block ZoneDesignMinimumOutdoorAirflow
  "Zone design outdoor airflow setpoint"

  parameter Boolean have_winSwi = false "The zone has a window switch";

  parameter Boolean have_occSen = true "The zone has occupancy sensor";

  parameter Real FraVAreMin = 0.25
    "Fraction of zone minimum oudoor airflow"
    annotation(Dialog(enable=have_occSen));

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

  CDL.Interfaces.BooleanInput uWin if have_winSwi
    "Window status, true if open, false if closed"
    annotation (Placement(transformation(extent={{-140,10},{-100,50}}),
        iconTransformation(extent={{-240,-120},{-200,-80}})));

  CDL.Interfaces.BooleanInput uOcc if have_occSen
    "True if the zone is populated, that is the occupancy sensor senses the presence of people"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
        iconTransformation(extent={{-240,80},{-200,120}})));

  CDL.Interfaces.RealOutput VOutMinZonDes_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Outdoor air volume flow setpoint used in AHU sequeces"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  CDL.Continuous.Sources.Constant zero(
    final k=0) if have_winSwi "Zero flow"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));

  CDL.Continuous.Sources.Constant VAreMin(
    final k=VAreMin_flow) if not
                                (have_winSwi or have_occSen)
    "Zone minimum outdoor airflow for building area, per California Title 24 prescribed airflow-per-area requirements"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));

  CDL.Continuous.Sources.Constant VOccMin(
    final k=VOccMin_flow) if not
                                (have_winSwi or have_occSen)
    "Zone minimum outdoor airflow for occupants, per California Title 24 prescribed airflow-per-occupant requirements"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));

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
Per section 5.2.1.4.b.2. zone design minimum outdoor airflow <code>VOutMinZonDes_flow</code> equals the following:  
</p>
<ul>
<li>
Zero, if the zone has a window switch as indicated by <code>have_winSwi</code> parameter and the window is open, 
that is the <code>uWin</code> input is <code>true</code>
</li>
<li>
<code>FraVAreMin</code> fraction of zone minimum outdoor airflow for building area <code>VAreMin_flow</code> if the zone has an 
occupancy sensor as indicated by <code>have_occSen</code> parameter and is unpopulated, 
that is the <code>uOcc</code> input is <code>false</code>
</li>
<li>
The larger of <code>VAreMin_flow</code> and <code>VOccMin_flow</code> otherwise. 
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
August 10, 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end ZoneDesignMinimumOutdoorAirflow;
