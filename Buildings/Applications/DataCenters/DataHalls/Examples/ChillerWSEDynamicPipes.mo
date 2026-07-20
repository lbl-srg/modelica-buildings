within Buildings.Applications.DataCenters.DataHalls.Examples;
model ChillerWSEDynamicPipes
  "Example model of a simple liquid cooled data center with chiller and water-side economizer"
  extends ChillerWSE(
    break uti,
    redeclare model Pipe = MyPlugFlowPipe,
    datCDU(strokeTime=5),
    cdu(
      kVal=1,
      TiVal=30,
      kPum=0.5,
      TiPum=30));
  Controls.OBC.CDL.Reals.Sources.TimeTable utiLiq(
    table=[
      0,  0.5;
      120,0.5;
      120,0.7;
      240,0.7], extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.Periodic)
    "Utilization of liquid-cooled hardware"
    annotation (Placement(transformation(extent={{-72,-80},{-52,-60}})));
  model MyPlugFlowPipe
    extends Buildings.Fluid.FixedResistances.PlugFlowPipe(
      show_T=true,
      have_pipCap=true,
      v_nominal=5,
      dIns=0.01,
      kIns=0.04,
      cPip=500,
      rhoPip=800);
    // Introduce dp_nominal as this is used in the base class to size the pumps,
    // but the model Buildings.Fluid.FixedResistances.PlugFlowPipe
    // has no such top-level parameter
    final parameter Modelica.Units.SI.PressureDifference dp_nominal = res.dp_nominal
      "Design pressure drop";
    final parameter Modelica.Units.SI.MassFlowRate m_flow_turbulent = res.m_flow_turbulent
      "Mass flow rate where transition to turbulent flow occurs";
    final parameter Real deltaM = res.deltaM
      "Normmalized mass flow rate where transition to turbulent flow occurs";
    final parameter Real k = res.k
      "Flow coefficient, k=m_flow/dp^(1/n)";
    final parameter Modelica.Units.SI.PressureDifference dpStraightPipe_nominal = res.dpStraightPipe_nominal
      "Pressure loss of a round cross section pipe at m_flow_nominal";
  end MyPlugFlowPipe;
equation

  connect(utiLiq.y[1], PITIn.u)
    annotation (Line(points={{-50,-70},{-42,-70}}, color={0,0,127}));
  annotation (experiment(
      StopTime=1800,
    Tolerance=1e-06),
__Dymola_Commands(
   file="modelica://Buildings/Resources/Scripts/Dymola/Applications/DataCenters/DataHalls/Examples/ChillerWSEDynamicPipes.mos" "Simulate and plot"),
    Documentation(info="<html>
<p>
This model is identical to
<a href=\\\"modelica://Buildings.Applications.DataCenters.DataHalls.Examples.ChillerWSE\\\">
Buildings.Applications.DataCenters.DataHalls.Examples.ChillerWSE</a>
except that the supply and return pipes in each of the three fluid loops are
modeled using a pipe model that has transport delay.
Moreover, the IT power consumed is here modelled using a time table that alternates the load
every <i>2</i> minutes between <i>50%</i> and <i>70%</i> of the design thermal power.
</p>
</html>", revisions="<html>
<ul>
<li>
July 20, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ChillerWSEDynamicPipes;
