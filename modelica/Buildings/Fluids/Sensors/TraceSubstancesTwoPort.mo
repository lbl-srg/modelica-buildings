within Buildings.Fluids.Sensors;
model TraceSubstancesTwoPort "Ideal two port sensor for trace substance"
  extends Modelica.Fluid.Sensors.BaseClasses.PartialFlowSensor;
  extends Modelica.Icons.RotationalSensor;
  Modelica.Blocks.Interfaces.RealOutput C
    "Trace substance of the passing fluid" 
    annotation (Placement(transformation(
        origin={0,110},
        extent={{10,-10},{-10,10}},
        rotation=270)));
  parameter String substanceName = "CO2" "Name of trace substance";
  parameter Medium.MassFlowRate m_flow_small(min=0) = system.m_flow_small
    "For bi-directional flow, trace substance is regularized in the region |m_flow| < m_flow_small (m_flow_small > 0 required)"
    annotation(Dialog(tab="Advanced"));

annotation (defaultComponentName="traceSubstance",
  Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
            100,100}}), graphics),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), 
        graphics={
        Text(
          extent={{82,122},{0,92}},
          lineColor={0,0,0},
          textString="C"),
        Line(points={{0,100},{0,70}}, color={0,0,127}),
        Line(points={{-100,0},{-70,0}}, color={0,128,255}),
        Line(points={{70,0},{100,0}}, color={0,128,255})}),
  Documentation(info="<HTML>
<p>
This component monitors the trace substance of the passing fluid. 
The sensor is ideal, i.e. it does not influence the fluid.
</p>
</HTML>
"));
protected
  parameter Integer ind(fixed=false)
    "Index of species in vector of auxiliary substances";
initial algorithm
  ind:= -1;
  for i in 1:Medium.nC loop
    if ( Modelica.Utilities.Strings.isEqual(Medium.extraPropertiesNames[i], substanceName)) then
      ind := i;
    end if;
  end for;
  assert(ind > 0, "Trace substance '" + substanceName + "' is not present in medium '"
         + Medium.mediumName + "'.\n"
         + "Check sensor parameter and medium model.");
equation
  if allowFlowReversal then
     C = Modelica.Fluid.Utilities.regStep(port_a.m_flow, port_b.C_outflow[ind], port_a.C_outflow[ind], m_flow_small);
  else
     C = port_b.C_outflow[ind];
  end if;
end TraceSubstancesTwoPort;
