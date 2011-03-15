within Buildings.Fluid.Sensors;
model LatentEnthalpyFlowRate
  "Ideal enthalphy flow rate sensor that outputs the latent enthalpy flow rate only"
  extends Buildings.Fluid.Sensors.BaseClasses.PartialFlowSensor;
  extends Modelica.Icons.RotationalSensor;

  // redeclare Medium with a more restricting base class. This improves the error
  // message if a user selects a medium that does not contain the function
  // enthalpyOfLiquid(.)
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialCondensingGases
      annotation (choicesAllMatching = true);

  Modelica.Blocks.Interfaces.RealOutput H_flow(unit="W")
    "Latent enthalpy flow rate, positive if from port_a to port_b"
    annotation (Placement(transformation(
        origin={0,110},
        extent={{-10,-10},{10,10}},
        rotation=90)));

protected
  Medium.MassFraction XiActual[Medium.nXi] "Medium mass fraction in port_a";
  Medium.SpecificEnthalpy hActual "Medium enthalpy in port_a";
  Medium.ThermodynamicState sta "Medium properties in port_a";
  parameter Integer i_w(fixed=false) "Index for water substance";
initial algorithm
  i_w :=-1;
    for i in 1:Medium.nXi loop
      if Modelica.Utilities.Strings.isEqual(string1=Medium.substanceNames[i],
                                            string2="Water",
                                            caseSensitive=false) then
        i_w :=i;
      end if;
    end for;
  assert(i_w > 0, "Substance 'water' is not present in medium '"
                  + Medium.mediumName + "'.\n"
                  + "Change medium model to one that has 'water' as a substance.");
equation
  if allowFlowReversal then
     XiActual = Modelica.Fluid.Utilities.regStep(port_a.m_flow,
                 port_b.Xi_outflow,
                 port_a.Xi_outflow, m_flow_small);
     hActual = Modelica.Fluid.Utilities.regStep(port_a.m_flow,
                 port_b.h_outflow,
                 port_a.h_outflow, m_flow_small);
  else
     XiActual = port_b.Xi_outflow;
     hActual = port_b.h_outflow;
  end if;
  sta = Medium.setState_phX(port_a.p, hActual, XiActual);
  // Compute H_flow as difference between total enthalpy and enthalpy on non-condensing gas.
  // This is needed to compute the liquid vs. gas fraction of water, using the equations
  // provided by the medium model
  H_flow = port_a.m_flow * (hActual -
     (1-XiActual[i_w]) * Medium.enthalpyOfNonCondensingGas(Medium.temperature(sta)));
annotation (defaultComponentName="senLatEnt",
  Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}), graphics),
  Icon(graphics={
        Line(points={{-100,0},{-70,0}}, color={0,128,255}),
        Line(points={{70,0},{100,0}}, color={0,128,255}),
        Line(points={{0,100},{0,70}}, color={0,0,127}),
        Text(
          extent={{180,151},{20,99}},
          lineColor={0,0,0},
          textString="HL_flow")}),
  Documentation(info="<html>
<p>
This component monitors the <i>latent</i> enthalphy flow rate of the medium in the flow
between fluid ports. In particular, if the enthalpy flow rate is
<pre>
  HTotal_flow = HSensible_flow + HLatent_flow,
</pre>
where <code>HSensible_flow = m_flow * (1-X[water]) * cp_air</code>, then
this sensor outputs <code>H_flow = HLatent_flow</code>.
This sensor can only be used with medium models that implement the function
<code>enthalpyOfCondensingGas(state)</code>. 
</p>
<p>
For a sensor that measures 
<code>HTotal_flow</code>, use
<a href=\"modelica://Buildings.Fluid.Sensors.EnthalpyFlowRate\">
Buildings.Fluid.Sensors.EnthalpyFlowRate</a>.<br>
For a sensor that measures 
<code>HSensible_flow</code>, use
<a href=\"modelica://Buildings.Fluid.Sensors.SensibleEnthalpyFlowRate\">
Buildings.Fluid.Sensors.SensibleEnthalpyFlowRate</a>.
<p>
The sensor is ideal, i.e., it does not influence the fluid.
</p>
</html>
", revisions="<html>
<ul>
<li>
February 22, by Michael Wetter:<br>
Improved code that searches for index of 'water' in medium model.
</li>
<li>
September 9, 2009 by Michael Wetter:<br>
First implementation.
Implementation is based on enthalpy sensor of <code>Modelica.Fluid</code>.
</li>
</ul>
</html>"));
end LatentEnthalpyFlowRate;
