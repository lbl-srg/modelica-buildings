within Buildings.Fluid.MassExchangers;
model HumidifierPrescribed
  "Ideal humidifier or dehumidifier with prescribed water mass flow rate addition or subtraction"
  extends Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger(
    redeclare replaceable package Medium =
        Modelica.Media.Interfaces.PartialCondensingGases,
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir vol);

  parameter Boolean use_T_in= false
    "Get the temperature from the input connector"
    annotation(Evaluate=true, HideResult=true);

  parameter Modelica.SIunits.Temperature T = 293.15
    "Temperature of water that is added to the fluid stream (used if use_T_in=false)"
    annotation (Evaluate = true,
                Dialog(enable = not use_T_in));

  parameter Modelica.SIunits.MassFlowRate mWat_flow_nominal
    "Water mass flow rate at u=1, positive for humidification";

  Modelica.Blocks.Interfaces.RealInput T_in if use_T_in
    "Temperature of water added to the fluid stream"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}},
          rotation=0)));
  Modelica.Blocks.Interfaces.RealInput u "Control input"
    annotation (Placement(transformation(
          extent={{-140,40},{-100,80}}, rotation=0)));
protected
  Modelica.Blocks.Interfaces.RealInput T_in_internal
    "Needed to connect to conditional connector";
  Modelica.Blocks.Math.Gain gai(k=mWat_flow_nominal) "Gain"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{36,68},{56,88}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=
        Medium.enthalpyOfLiquid(T_in_internal))
    annotation (Placement(transformation(extent={{-96,70},{-20,94}})));
  Modelica.Blocks.Math.Product pro
    "Product to compute latent heat added to volume"
    annotation (Placement(transformation(extent={{0,66},{20,86}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=T_in_internal)
    annotation (Placement(transformation(extent={{-80,-48},{-52,-24}})));
equation
  // Conditional connect statement
  connect(T_in, T_in_internal);
  if not use_T_in then
    T_in_internal = T;
  end if;

  connect(u, gai.u) annotation (Line(
      points={{-120,60},{-82,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gai.y, vol.mWat_flow) annotation (Line(
      points={{-59,60},{-34,60},{-34,-18},{-11,-18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression.y, pro.u1)     annotation (Line(
      points={{-16.2,82},{-2,82}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gai.y, pro.u2)     annotation (Line(
      points={{-59,60},{-34,60},{-34,70},{-2,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pro.y, preHea.Q_flow)     annotation (Line(
      points={{21,76},{28,76},{28,78},{36,78}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preHea.port, vol.heatPort) annotation (Line(
      points={{56,78},{80,78},{80,60},{-20,60},{-20,-10},{-9,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vol.TWat, realExpression1.y) annotation (Line(
      points={{-11,-14.8},{-30,-14.8},{-30,-36},{-50.6,-36}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={85,170,255},
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
          textString="m=%m_flow_nominal"),
        Rectangle(
          extent={{-100,61},{-70,58}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-144,114},{-100,86}},
          lineColor={0,0,255},
          textString="u"),
        Text(
          visible=use_T_in,
          extent={{-140,-20},{-96,-48}},
          lineColor={0,0,255},
          textString="T"),
        Rectangle(
          visible=use_T_in,
          extent={{-100,-59},{-70,-62}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid)}),
defaultComponentName="hum",
Documentation(info="<html>
<p>
Model for an air humidifier or dehumidifier.
</p>
<p>
This model adds (or removes) moisture from the air stream.
The amount of exchanged moisture is equal to
</p>
<p align=\"center\" style=\"font-style:italic;\">
m&#775;<sub>wat</sub> = u  m&#775;<sub>wat,nom</sub>,
</p>
<p>
where <i>u</i> is the control input signal and
<i>m&#775;<sub>wat,nom</sub></i> is equal to the parameter <code>mWat_flow_nominal</code>.
The parameter <code>mWat_flow_nominal</code> can be positive or negative.
If <i>m&#775;<sub>wat</sub></i> is positive, then moisture is added
to the air stream, otherwise it is removed.
</p>
<p>If the connector <code>T_in</code> is left unconnected, the value
set by the parameter <code>T</code> is used for the temperature of the water that is 
added to the air stream.
</p>
<p>
This model can only be used with medium models that define the integer constant
<code>Water</code> which needs to be equal to the index of the water mass fraction 
in the species vector.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 14, 2013 by Michael Wetter:<br/>
Constrained medium to be a subclass of 
<code>Modelica.Media.Interfaces.PartialCondensingGases</code>,
as this base class declares the function
<code>enthalpyOfCondensingGas</code>.
</li>
<li>
July 30, 2013 by Michael Wetter:<br/>
Updated model to use new variable <code>mWat_flow</code>
in the base class.
</li>
<li>
May 24, 2011, by Michael Wetter:<br/>
Changed base class to allow using the model as a dynamic or a steady-state model.
</li>
<li>
April 14, 2010, by Michael Wetter:<br/>
Converted temperature input to a conditional connector.
</li>
<li>
April 17, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(graphics));
end HumidifierPrescribed;
