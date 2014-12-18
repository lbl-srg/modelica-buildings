within Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses;
model PipeToSlabConductance
  "Convective heat transfer in pipes and fictitious resistance to average slab temperature"
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching = true);

  parameter Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.HeatTransfer
    heatTransfer=
    Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.HeatTransfer.EpsilonNTU
    "Model for heat transfer between fluid and slab";
  parameter Modelica.SIunits.Area APip "Pipe inside surface area";

  parameter
    Modelica.Fluid.Dissipation.HeatTransfer.StraightPipe.kc_overall_IN_con
    kc_IN_con "Parameters for convective heat transfer calculation"
    annotation (Placement(transformation(extent={{-90,84},{-78,96}})));

  Modelica.Fluid.Dissipation.HeatTransfer.StraightPipe.kc_overall_IN_var
    kc_IN_var(
    cp=Medium.specificHeatCapacityCp(fluSta),
    eta=Medium.dynamicViscosity(fluSta),
    lambda=Medium.thermalConductivity(fluSta),
    rho=Medium.density(fluSta),
    m_flow=m_flow) "Variables for convective heat transfer calculation"
    annotation (Placement(transformation(extent={{-90,68},{-78,80}})));

  parameter Modelica.SIunits.ThermalResistance RFic
    "Average fictitious thermal resistance between pipe surface and plane that contains pipe";
  parameter Modelica.SIunits.ThermalResistance RWal
    "Thermal resistance through the pipe wall";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";

  Modelica.Blocks.Interfaces.RealInput m_flow(unit="kg/s")
    "Fluid mass flow rate from port_a to port_b"
    annotation (Placement(transformation(extent={{-118,32},{-100,50}}),
        iconTransformation(extent={{-120,30},{-100,50}})));
  Modelica.Blocks.Interfaces.RealInput T_a(unit="K")
    "Temperature at fluid port_a"
    annotation (Placement(transformation(extent={{-118,92},{-100,110}}),
        iconTransformation(extent={{-120,90},{-100,110}})));
  Modelica.Blocks.Interfaces.RealInput T_b(unit="K")
    "Temperature at fluid port_b"
    annotation (Placement(transformation(extent={{-118,62},{-100,80}}),
        iconTransformation(extent={{-120,60},{-100,80}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a solid
    "Heat port at solid interface"
   annotation (
      Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-114,-10},{-94,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b fluid
    "Heat port at fluid interface"
   annotation (
      Placement(transformation(extent={{90,-10},{110,10}}),
        iconTransformation(extent={{86,-10},{106,10}})));

  Modelica.SIunits.TemperatureDifference dT "= solid.T - fluid.T";

  Modelica.SIunits.CoefficientOfHeatTransfer hCon
    "Convective heat transfer coefficient";
  Modelica.SIunits.ThermalResistance RTot
    "Thermal resistance between the fluid and the fictious plane of heat transfer";

  Modelica.SIunits.HeatFlowRate Q_flow "Heat flow rate from solid -> fluid";

protected
  Medium.ThermodynamicState fluSta = Medium.setState_pTX(p=Medium.p_default, T=fluid.T, X=Medium.X_default)
    "State of the medium";
  Modelica.SIunits.SpecificHeatCapacity c_p = Medium.specificHeatCapacityCp(fluSta)
    "Specific heat capacity of the fluid";
equation
  hCon = Modelica.Fluid.Dissipation.HeatTransfer.StraightPipe.kc_overall_KC(
     IN_con=kc_IN_con, IN_var=kc_IN_var);
  RTot = 1/hCon/APip + RFic + RWal;

  if heatTransfer == Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.HeatTransfer.EpsilonNTU then
    Q_flow = Functions.heatFlowRate(T_a=T_a,
                          T_b=T_b,
                          T_s=solid.T,
                          T_f=fluid.T,
                          c_p=c_p,
                          UA=1/RTot,
                          m_flow=m_flow,
                          m_flow_nominal=m_flow_nominal);
  else
    Q_flow = dT/RTot;
  end if;

  dT = solid.T - fluid.T;
  solid.Q_flow = Q_flow;
  fluid.Q_flow = -Q_flow;

  annotation (Icon(graphics={
        Rectangle(
          extent={{-66,80},{94,-80}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-88,80},{2,-82}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Line(points={{96,0},{96,0}}, color={0,127,255}),
        Line(points={{-64,20},{72,20}}, color={191,0,0}),
        Line(points={{-64,-20},{72,-20}}, color={191,0,0}),
        Line(points={{36,80},{36,-80}}, color={0,127,255}),
        Line(points={{72,80},{72,-80}}, color={0,127,255}),
        Line(points={{52,-30},{72,-20}}, color={191,0,0}),
        Line(points={{52,-10},{72,-20}}, color={191,0,0}),
        Line(points={{52,10},{72,20}}, color={191,0,0}),
        Line(points={{52,30},{72,20}}, color={191,0,0}),
        Text(
          extent={{-145,140},{155,100}},
          lineColor={0,0,255},
          textString="%name")}),
    Documentation(info="<html>
<p>
Model to compute the convective heat transfer inside a straight pipe.
The convective heat transfer coefficient is computed as a function of the mass flow rate
using the function
<a href=\"modelica://Modelica.Fluid.Dissipation.HeatTransfer.StraightPipe.kc_overall_KC\">
Modelica.Fluid.Dissipation.HeatTransfer.StraightPipe.kc_overall_KC</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 5, 2012, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
April 3, 2012, by Xiufeng Pang:<br/>
First implementation.
</li>
</ul>
</html>"));
end PipeToSlabConductance;
