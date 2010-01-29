within Buildings.Fluid.Sources;
model PrescribedExtraPropertyFlowRate
  "Source with mass flow that does not take part in medium mass balance (such as CO2)"
  extends Modelica.Fluid.Sources.BaseClasses.PartialSource(nPorts=1);

  annotation (Documentation(info="<html>
This model adds a mass flow rate to the port for an auxiliary
medium that does not take part in the mass balance of the medium
model. Instead, this mass transfer is tracked separately. A typical
use of this source is to add carbon dioxide to a room, since the 
carbon dioxide concentration is typically so small that it need not be added to the
room mass balance.
</html>", revisions="<html>
<ul>
<li>
September 18, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics),
                       Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{20,60},{100,-60}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{38,40},{100,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Ellipse(
          extent={{-100,80},{60,-80}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-60,70},{60,0},{-60,-68},{-60,70}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-54,32},{16,-30}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          textString="m"),
        Ellipse(
          extent={{-26,30},{-18,22}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-210,102},{-70,70}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="m_flow"),
        Text(
          extent={{-100,14},{-60,-20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="C")}));
  parameter String substanceName = "CO2" "Name of trace substance";
  parameter Boolean use_m_flow_in = false
    "Get the trace substance mass flow rate from the input connector" 
    annotation(Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true));

  parameter Medium.MassFlowRate m_flow = 0
    "Fixed mass flow rate going out of the fluid port" 
    annotation (Evaluate = true,
                Dialog(enable = not use_m_flow_in));
  Modelica.Blocks.Interfaces.RealInput m_flow_in if 
       use_m_flow_in "Prescribed mass flow rate for extra property" 
    annotation (Placement(transformation(extent={{-141,-20},{-101,20}},
          rotation=0)));

protected
  Modelica.Blocks.Interfaces.RealInput m_flow_in_internal
    "Needed to connect to conditional connector";
  parameter Medium.ExtraProperty C_in_internal[Medium.nC](
       fixed=false,
       quantity=Medium.extraPropertiesNames)=fill(0, Medium.nC)
    "Boundary trace substances" 
    annotation (Evaluate=true,
                Dialog(enable = Medium.nC > 0));
initial algorithm
  for i in 1:Medium.nC loop
    if ( Modelica.Utilities.Strings.isEqual(Medium.extraPropertiesNames[i], substanceName)) then
      C_in_internal[i] := 1;
    else
      C_in_internal[i] := 0;
    end if;
  end for;
  assert(sum(C_in_internal) > 0, "Trace substance '" + substanceName + "' is not present in medium '"
         + Medium.mediumName + "'.\n"
         + "Check source parameter and medium model.");
equation
  connect(m_flow_in, m_flow_in_internal);
  if not use_m_flow_in then
    m_flow_in_internal = m_flow;
  end if;

  assert(sum(m_flow_in_internal) >= 0, "Reverse flow for species source is not yet implemented.");
  sum(ports.m_flow) = -m_flow_in_internal;
  medium.T = Medium.T_default;
  medium.Xi = Medium.X_default[1:Medium.nXi];
  ports.C_outflow = fill(C_in_internal, nPorts);
end PrescribedExtraPropertyFlowRate;
