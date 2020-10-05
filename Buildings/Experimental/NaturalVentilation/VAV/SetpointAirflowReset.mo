within Buildings.Experimental.NaturalVentilation.VAV;
block SetpointAirflowReset
  "Sets airflow for VAV based on natural ventilation mode and room population"
parameter Real AreaMinFlo(min=0,
    final unit="m3/s",
    final displayUnit="m3/s",
    final quantity="VolumeFlowRate")=0.1  "Area driven minimum airflow";
 parameter Real VentMinFlo(min=0,
    final unit="m3/s",
    final displayUnit="m3/s",
    final quantity="VolumeFlowRate")=0.3  "Ventilation minimum airflow";
  Controls.OBC.CDL.Interfaces.RealInput floVAV
    "Current airflow setpoint from VAV"
    annotation (Placement(transformation(extent={{-140,-72},{-100,-32}}),
        iconTransformation(extent={{-140,-10},{-100,30}})));
  Controls.OBC.CDL.Continuous.Sources.Constant AreaMinimum(k=AreaMinFlo)
    "Area minimum ventilation airflow"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Controls.OBC.CDL.Continuous.Sources.Constant VentilationMinimum(k=VentMinFlo)
    "Ventilation minimum airflow"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Controls.OBC.CDL.Interfaces.BooleanInput natVenSig
    "True if natural ventilation is active; false if not" annotation (Placement(
        transformation(extent={{-140,-10},{-100,30}}), iconTransformation(
          extent={{-140,30},{-100,70}})));
  Controls.OBC.CDL.Interfaces.BooleanInput rooPop
    "True if room is populated, false if room is not populated" annotation (
      Placement(transformation(extent={{-140,30},{-100,70}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Controls.OBC.CDL.Logical.Switch swi
    "Select airflow setpont based on population (either area minimum or ventilation minimum)"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Controls.OBC.CDL.Logical.Switch swi1
    "Select airflow setpont based on population (either area minimum or ventilation minimum) if natural ventilation mode is on. Otherwise, keep current airflow rate as setpoint"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Controls.OBC.CDL.Interfaces.RealOutput yfloStp
    "New airflow setpoint, adjusted for natural ventilation mode, if nat vent is active"
                                                                    annotation (
     Placement(transformation(extent={{100,-10},{140,30}}), iconTransformation(
          extent={{100,-20},{140,20}})));
equation
  connect(VentilationMinimum.y, swi.u1) annotation (Line(points={{-38,70},{-20,
          70},{-20,58},{-2,58}}, color={0,0,127}));
  connect(AreaMinimum.y, swi.u3) annotation (Line(points={{-38,30},{-20,30},{-20,
          42},{-2,42}}, color={0,0,127}));
  connect(rooPop, swi.u2)
    annotation (Line(points={{-120,50},{-2,50}}, color={255,0,255}));
  connect(natVenSig, swi1.u2)
    annotation (Line(points={{-120,10},{38,10}}, color={255,0,255}));
  connect(swi.y, swi1.u1) annotation (Line(points={{22,50},{32,50},{32,18},{38,18}},
        color={0,0,127}));
  connect(floVAV, swi1.u3) annotation (Line(points={{-120,-52},{0,-52},{0,2},{38,
          2}}, color={0,0,127}));
  connect(swi1.y,yfloStp)
    annotation (Line(points={{62,10},{120,10}}, color={0,0,127}));
  annotation (defaultComponentName = "setAirRes", Documentation(info="<html>
  This block determines the airflow setpoint.
  <p>If the building is in natural ventilation mode and people are present,
  VAV airflow setpoint is set to the ventilation minimum (VentMinFlo).
  <p> If the building is in natural ventilation mode and no people are present,
  the VAV airflow setpoint is set to the area minimum (AreaMinFlo).
  <p> If the building is not in natural ventilation mode, the VAV airflow setpoint is left as-is. 
<p>
</p>
</html>"),Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,140,72},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
          Polygon(
          points={{-80,60},{-80,-60},{34,-60},{94,60},{-52,60},{-80,60}},
          lineColor={0,140,72},
          lineThickness=1), Text(
          extent={{20,-52},{-36,58}},
          lineColor={0,140,72},
          lineThickness=1,
          textString="C"),
        Text(
          lineColor={0,0,255},
          extent={{-152,100},{148,140}},
          textString="%name")}),
                             Diagram(coordinateSystem(preserveAspectRatio=false),
        graphics={
        Text(
          extent={{-94,106},{306,74}},
          lineColor={0,0,0},
          lineThickness=1,
          fontSize=9,
          horizontalAlignment=TextAlignment.Left,
          textStyle={TextStyle.Bold},
          textString="VAV Airflow Setpoint Reset:
Selects VAV airflow setpoint
based on natural ventilation status and other room conditions. 
"),     Text(
          extent={{20,72},{66,66}},
          lineColor={28,108,200},
          lineThickness=1,
          textString="If natural ventilation is active,
set flow setpoint to 
ventilation minimum
if room is occupied and 
area minimum
if room is unoccupied."),
        Text(
          extent={{22,-8},{68,-14}},
          lineColor={28,108,200},
          lineThickness=1,
          textString="If natural ventilation is not active,
pass current flow setpoint through unchanged.")}));
end SetpointAirflowReset;
