within Buildings.Fluid.AirFilters.BaseClasses;
model MassTransfer
  "Component that sets the trace substance at the filter outlet"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;
  parameter String namCon[:]
    "Name of contaminant substance";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput eps[nConSub](
    each final unit = "1",
    each final min = 0,
    each final max= 1)
    "Filtration efficiency of each contaminant"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mCon_flow[nConSub](
    each final unit = "kg/s")
    "Contaminant mass flow rate"
    annotation (Placement(transformation(extent={{100,40},{140,80}})));

protected
  parameter Integer nConSub=size(namCon,1)
    "Total types of contaminant substances";
  parameter Real s[:,:]={
    {if (Modelica.Utilities.Strings.isEqual(string1=Medium.extraPropertiesNames[i],
                                            string2=namCon[j],
                                            caseSensitive=false))
    then 1 else 0 for i in 1:nConSub}
    for j in 1:Medium.nC}
    "Vector to check if the trace substances in the medium are included in the performance dataset"
    annotation(Evaluate=true);
initial equation
  assert(abs(sum(s) - nConSub) < 0.1,
         "In " + getInstanceName() + ": Some specified trace substances are
         not present in medium '" + Medium.mediumName + "'.\n"
         + "Check filter parameter and medium model.",
         level = AssertionLevel.warning)
         "Check if all the specified substances are included in the medium";

equation
  // Modify the substances individually.
  for i in 1:Medium.nC loop
      if max(s[i]) > 0.9 then
        for j in 1:nConSub loop
           if s[i,j]>0.9 then
              port_b.C_outflow[i]=inStream(port_a.C_outflow[i])*(1 - eps[j] * s[i,j]);
              port_a.C_outflow[i]=inStream(port_a.C_outflow[i]);
              mCon_flow[j]=inStream(port_a.C_outflow[j])* eps[j];
           end if;
        end for;
      else
        port_b.C_outflow[i]=inStream(port_a.C_outflow[i]);
        port_a.C_outflow[i]=inStream(port_b.C_outflow[i]);
      end if;
  end for;
  // Mass balance (no storage).
  port_a.Xi_outflow=inStream(port_b.Xi_outflow);
  port_b.Xi_outflow=inStream(port_a.Xi_outflow);
  port_a.m_flow =-port_b.m_flow;
  // Pressure balance (no pressure drop).
  port_a.p=port_b.p;
  // Energy balance (no heat exchange).
  port_a.h_outflow=inStream(port_b.h_outflow);
  port_b.h_outflow=inStream(port_a.h_outflow);

  if not allowFlowReversal then
    assert(m_flow>-m_flow_small,
      "In " + getInstanceName() + ": Reverting flow occurs even though allowFlowReversal is false.",
      level=AssertionLevel.error);
  end if;

annotation (defaultComponentName="masTra",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
    Rectangle(extent={{-100,100},{100,-100}}, fillColor={255,255,255},
              fillPattern=FillPattern.Solid, pattern=LinePattern.None),
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
Documentation(info="<html>
<p>
This model sets the trace substance
of the medium that leaves <code>port_b</code> by
</p>
<pre>
port_b.C_outflow = inStream(port_a.C_outflow) - eps * C_inflow;
</pre>
<p>
where <code>eps</code> is an input mass transfer efficiency and
<code>C_inflow</code> is an input trace substance rate.
</p>
<p>
This model has no pressure drop.
</p>
</html>", revisions="<html>
<ul>
<li>
December 22, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end MassTransfer;
