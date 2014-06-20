within Buildings.Fluid.HeatExchangers;
model HeaterCoolerPrescribed "Heater or cooler with prescribed heat flow rate"
  extends Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger(
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolume vol,
    final showDesignFlowDirection=false);

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal
    "Heat flow rate at u=1, positive for heating";
  Modelica.Blocks.Interfaces.RealInput u "Control input"
    annotation (Placement(transformation(
          extent={{-140,40},{-100,80}}, rotation=0)));
protected
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHea
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Modelica.Blocks.Math.Gain gai(k=Q_flow_nominal) "Gain"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
equation
  connect(u, gai.u) annotation (Line(
      points={{-120,60},{-82,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gai.y, preHea.Q_flow) annotation (Line(
      points={{-59,60},{-40,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preHea.port, vol.heatPort) annotation (Line(
      points={{-20,60},{-9,60},{-9,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-102,5},{99,-5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-56,-12},{54,-72}},
          lineColor={0,0,255},
          textString="Q=%Q_flow_nominal"),
        Rectangle(
          extent={{-100,61},{-70,58}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-122,106},{-78,78}},
          lineColor={0,0,255},
          textString="u")}),
defaultComponentName="hea",
Documentation(info="<html>
<p>
Model for an ideal heater or cooler with prescribed heat flow rate to the medium.
</p>
<p>
This model adds heat in the amount of <code>Q_flow = u Q_flow_nominal</code> to the medium.
The input signal <code>u</code> and the nominal heat flow rate <code>Q_flow_nominal</code> 
can be positive or negative.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 15, 2013, by Michael Wetter:<br/>
Redeclared the control volume to be final so that it does not show
anymore in the parameter window.
</li>
<li>
July 11, 2011, by Michael Wetter:<br/>
Redeclared fluid volume as final. This prevents the fluid volume model
to appear in the dialog window.
</li>
<li>
May 24, 2011, by Michael Wetter:<br/>
Changed base class to allow using the model as a dynamic or a steady-state model.
</li>
<li>
April 17, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(graphics));
end HeaterCoolerPrescribed;
