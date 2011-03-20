within Buildings.Fluid.MassExchangers;
model HumidifierPrescribed
  "Ideal humidifier or dehumidifier with prescribed water mass flow rate addition or subtraction"
  extends Fluid.Interfaces.PartialStaticTwoPortHeatMassTransfer(
     sensibleOnly = false);

  parameter Boolean use_T_in= false
    "Get the temperature from the input connector"
    annotation(Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true));

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
  constant Modelica.SIunits.MassFraction[Medium.nXi] Xi_w = {1}
    "Mass fraction of water";
  Modelica.SIunits.MassFlowRate mWat_flow "Water flow rate";
  Modelica.Blocks.Interfaces.RealInput T_in_internal
    "Needed to connect to conditional connector";
equation
  connect(T_in, T_in_internal);
  if not use_T_in then
    T_in_internal = T;
  end if;

  mWat_flow = u * mWat_flow_nominal;
  Q_flow = Medium.enthalpyOfLiquid(T_in_internal) * mWat_flow;
  for i in 1:Medium.nXi loop
     mXi_flow[i] = if ( i == Medium.Water) then  mWat_flow else 0;
  end for;
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
The amount of exchanged moisture is equal to <code>m_flow = u * m_flow_nominal</code>.
The input signal <code>u</code> and the nominal moisture flow rate added to the air stream <code>m_flow_nominal</code> can be positive or negative.
If the product <code>u * m_flow_nominal</code> is positive, then moisture is added
to the air stream, otherwise it is removed.
</p>
<p>
<p>If the connector <code>T_in</code> is left unconnected, the value
set by the parameter <code>T</code> is used for temperature of the water that is 
added to the air stream.
</p>
<p>
Note that for non-zero <code>m_flow</code>, 
if the mass flow rate tends to zero, then the moisture difference over this 
component tends to infinity.
Hence, using a proper control for <code>u</code> is essential when using this component.
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
April 14, 2010, by Michael Wetter:<br>
Converted temperature input to a conditional connector.
</li>
<li>
April 17, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end HumidifierPrescribed;
