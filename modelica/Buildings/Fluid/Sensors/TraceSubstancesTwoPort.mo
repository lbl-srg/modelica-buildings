within Buildings.Fluid.Sensors;
model TraceSubstancesTwoPort "Ideal two port sensor for trace substance"
  extends Buildings.Fluid.Sensors.BaseClasses.PartialFlowSensor;
  extends Modelica.Icons.RotationalSensor;

  Modelica.Blocks.Interfaces.RealOutput C
    "Trace substance of the passing fluid"
    annotation (Placement(transformation(
        origin={0,110},
        extent={{10,-10},{-10,10}},
        rotation=270)));
  parameter String substanceName = "CO2" "Name of trace substance";
protected
  parameter Real s[Medium.nC](fixed=false)
    "Vector with zero everywhere except where species is";

initial algorithm
  for i in 1:Medium.nC loop
    if ( Modelica.Utilities.Strings.isEqual(string1=Medium.extraPropertiesNames[i], 
                                            string2=substanceName,
                                            caseSensitive=false)) then
      s[i] :=1;
    else
      s[i] :=0;
    end if;
  end for;
  assert(abs(1-sum(s))<1E-4, "Trace substance '" + substanceName + "' is not present in medium '"
         + Medium.mediumName + "'.\n"
         + "Check sensor parameter and medium model.");
equation
  if allowFlowReversal then
     C = Modelica.Fluid.Utilities.regStep(port_a.m_flow, s*port_b.C_outflow, s*port_a.C_outflow, m_flow_small);
  else
     C = s*inStream(port_b.C_outflow);
  end if;
annotation (defaultComponentName="senTraSub",
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
", revisions="<html>
<ul>
<li>
February 22, by Michael Wetter:<br>
Improved code that searches for index of trace substance in medium model.
</li>
</ul>
</html>"));
end TraceSubstancesTwoPort;
