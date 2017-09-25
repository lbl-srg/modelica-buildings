within Buildings.Fluid.Movers.BaseClasses;
model PowerInterface
  "Partial model to compute power draw and heat dissipation of fans and pumps"
  extends Modelica.Blocks.Interfaces.BlockIcon;

  parameter Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  parameter Boolean motorCooledByFluid
    "Flag, true if the motor is cooled by the fluid stream";

  parameter Modelica.SIunits.VolumeFlowRate delta_V_flow
    "Factor used for setting heat input into medium to zero at very small flows";

  Modelica.Blocks.Interfaces.RealInput etaHyd(
    final quantity="Efficiency",
    final unit="1") "Hydraulic efficiency"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}}),
        iconTransformation(extent={{-140,80},{-100,120}})));

  Modelica.Blocks.Interfaces.RealInput V_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") "Volume flow rate"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));

  Modelica.Blocks.Interfaces.RealInput WFlo(
    final quantity="Power",
    final unit="W") "Flow work"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));

  Modelica.Blocks.Interfaces.RealInput PEle(
    final quantity="Power",
    final unit="W") "Electrical power consumed"
    annotation (Placement(transformation(extent={{-140,-120},{-100,-80}})));

  Modelica.Blocks.Interfaces.RealOutput Q_flow(
    quantity="Power",
    final unit="W") "Heat input from fan or pump to medium"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Modelica.SIunits.Power WHyd
    "Hydraulic power input (converted to flow work and heat)";

protected
  Modelica.SIunits.HeatFlowRate QThe_flow
    "Heat input from fan or pump to medium";

equation
  // Hydraulic power (transmitted by shaft), etaHyd = WFlo/WHyd
  etaHyd * WHyd   = WFlo;
  // Heat input into medium
  QThe_flow +  WFlo = if motorCooledByFluid then PEle else WHyd;
  // At m_flow = 0, the solver may still obtain positive values for QThe_flow.
  // The next statement sets the heat input into the medium to zero for very small flow rates.
  Q_flow = if homotopyInitialization then
    homotopy(actual=Buildings.Utilities.Math.Functions.regStep(
                      y1=QThe_flow,
                      y2=0,
                      x=noEvent(abs(V_flow))-2*delta_V_flow,
                      x_small=delta_V_flow),
            simplified=0)
    else
      Buildings.Utilities.Math.Functions.regStep(
                      y1=QThe_flow,
                      y2=0,
                      x=noEvent(abs(V_flow))-2*delta_V_flow,
                      x_small=delta_V_flow);

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}), graphics={
    Line( origin={-49.5,7.6667},
          points={{-2.5,-91.6667},{17.5,-71.6667},{-22.5,-51.6667},{17.5,-31.6667},
              {-22.5,-11.667},{17.5,8.3333},{-2.5,28.3333},{-2.5,48.3333}},
          smooth=Smooth.Bezier,
          color={255,0,0}),
    Line( origin={0.5,7.6667},
          points={{-2.5,-91.6667},{17.5,-71.6667},{-22.5,-51.6667},{17.5,-31.6667},
              {-22.5,-11.667},{17.5,8.3333},{-2.5,28.3333},{-2.5,48.3333}},
          smooth=Smooth.Bezier,
          color={255,0,0}),
    Line( origin={50.5,7.6667},
          points={{-2.5,-91.6667},{17.5,-71.6667},{-22.5,-51.6667},{17.5,-31.6667},
              {-22.5,-11.667},{17.5,8.3333},{-2.5,28.3333},{-2.5,48.3333}},
          smooth=Smooth.Bezier,
          color={255,0,0}),
    Polygon(
    origin={48,64.333},
    pattern=LinePattern.None,
    fillPattern=FillPattern.Solid,
      points={{0.0,21.667},{-10.0,-8.333},{10.0,-8.333}},
          lineColor={0,0,0},
          fillColor={255,0,0}),
    Polygon(
    origin={-2,64.333},
    pattern=LinePattern.None,
    fillPattern=FillPattern.Solid,
      points={{0.0,21.667},{-10.0,-8.333},{10.0,-8.333}},
          lineColor={0,0,0},
          fillColor={255,0,0}),
    Polygon(
    origin={-52,64.333},
    pattern=LinePattern.None,
    fillPattern=FillPattern.Solid,
      points={{0.0,21.667},{-10.0,-8.333},{10.0,-8.333}},
          lineColor={0,0,0},
          fillColor={255,0,0})}),
    Documentation(info="<html>
<p>Block that implements the functions to compute the
heat dissipation of fans and pumps. It is used by the model
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine\">
Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
December 2, 2016, by Michael Wetter:<br/>
Removed <code>min</code> attribute as otherwise numerical noise can cause
the assertion on the limit to fail.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/606\">#606</a>.
</li>
<li>
March 15, 2016, by Michael Wetter:<br/>
Replaced <code>spliceFunction</code> with <code>regStep</code>.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/300\">issue 300</a>.
</li>
<li>
February 19, 2016, by Michael Wetter:<br/>
First implementation during refactoring of mover models to make implementation clearer.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/417\">#417</a>.
</li>
</ul>
</html>"));
end PowerInterface;
