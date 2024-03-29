within Buildings.AirCleaning;
model PAC "In-room portable air cleaner"
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component";

  parameter Real eff[Medium.nC](min=0, max=1) = 0.9997
    "trace species removal efficiency";

  parameter Modelica.Units.SI.MassFlowRate flow_PAC(min=0) = 0.094
    "PAC flow rate";

  parameter Modelica.Units.SI.Power kpow(min=0) = 50
    "Rated power";

  Modelica.Blocks.Interfaces.RealInput C[Medium.nC] "Zone concentration(s)"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealOutput yC_flow[Medium.nC] "Concentration outflow"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.BooleanInput uPACEna "True when PAC is on"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a diss "Heat dissipation"
    annotation (Placement(transformation(extent={{94,-90},{114,-70}})));

protected
  Modelica.Blocks.Math.Gain pow(final k=kpow)       "power of PAC"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prePow(final alpha=0)
    "Prescribed power of the PAC dissipated as heat"
    annotation (Placement(transformation(extent={{38,-30},{58,-10}})));

equation
  connect(uPACEna, booleanToReal.u)
    annotation (Line(points={{-120,-20},{-82,-20}}, color={255,0,255}));
  connect(booleanToReal.y, pow.u)
    annotation (Line(points={{-59,-20},{-22,-20}}, color={0,0,127}));
  connect(pow.y, prePow.Q_flow) annotation (Line(points={{1,-20},{38,-20}},
                                     color={0,0,127}));
  connect(prePow.port, diss) annotation (Line(points={{58,-20},{90,-20},{90,-80},
          {104,-80}}, color={191,0,0}));

  // calculate trace species mass flow exiting PAC
  for i in 1:Medium.nC loop
    yC_flow[i]  = booleanToReal.y*(-flow_PAC)*eff[i]*C[i];
  end for;
    annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"),
                Dialog(group = "Integer"),
              Icon(graphics={
        Ellipse(
          extent={{-30,68},{32,50}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.None),
        Ellipse(
          extent={{-30,-42},{32,-60}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.None),
        Line(points={{-30,60},{-30,-50}}, color={28,108,200}),
        Line(points={{32,60},{32,-50}}, color={28,108,200})}), Documentation(
        info="<html>
<p>This model is designed to simulate the removal of trace species using a portable air cleaner (PAC). The PAC model calculates the mass removal rate of trace species by the PAC (<span style=\"font-family: Courier New;\">yC_flow[]</span>) based on the equation described below when the PAC is on (<span style=\"font-family: Courier New;\">uPACEna</span>). The PACs are modeled to consume energy using a constant power rating (<span style=\"font-family: Courier New;\">kpow</span>) and heat is dissipated into the zone based on the consumed power. </p>
<h4>Main Equations </h4>
<p align=\"center\"><span style=\"font-family: Courier New;\">Ċ</span><sub>PAC</sub> = eff<sub>PAC</sub>* <span style=\"font-family: Courier New;\">flow</span><sub>PAC</sub>*c<sub>zone</sub> </p>
<p>where <span style=\"font-family: Courier New;\">Ċ</span><sub>PAC</sub> is the rate of trace species removal by the PAC, eff<sub>PAC</sub> is the trace species removal efficency, <span style=\"font-family: Courier New;\">flow</span><sub>PAC</sub> is the mass airflow rate of the PAC, and c<sub>zone</sub> is the trace species concentration in the zone where the PAC is located.</p>
<h4>Assumptions</h4>
<p>The model assumes well-mixed zones with uniform concentrations. </p>
</html>", revisions="<html>
<ul>
<li>
March 29, 2024 by Cary Faulkner:<br/>
First implementation.
</li>
</ul>
</html>"));
end PAC;
