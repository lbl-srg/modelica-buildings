within Buildings.Fluid.Movers.BaseClasses;
model EfficiencyInterface
  "Block for efficiency calculations for fans and pumps"
  extends Modelica.Blocks.Interfaces.BlockIcon;

  import cha = Buildings.Fluid.Movers.BaseClasses.Characteristics;

  replaceable parameter Data.FlowControlled per "Record with performance data"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{60,-80},{80,-60}})));

  Modelica.Blocks.Interfaces.RealInput m_flow(
    final quantity="MassFlowRate",
    final unit="kg/s") "Mass flow rate"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));

  Modelica.Blocks.Interfaces.RealInput dp(
    final quantity="PressureDifference",
    final unit="Pa")
    "Pressure difference (positive if mover is operating as usual)"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));

  Modelica.Blocks.Interfaces.RealInput rho(
    final quantity="Density",
    final unit="kg/m3",
    min=0.0) "Medium density"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Modelica.Blocks.Interfaces.RealOutput V_flow(
    quantity="VolumeFlowRate",
    final unit="m3/s") "Volume flow rate"
    annotation (Placement(transformation(extent={{100,80},{120,100}}),
        iconTransformation(extent={{100,80},{120,100}})));

  Modelica.Blocks.Interfaces.RealOutput WFlo(
    quantity="Power",
    final unit="W") "Flow work"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));

  Modelica.Blocks.Interfaces.RealOutput PEle(
    quantity="Power",
    final unit="W") "Electrical power consumed"
    annotation (Placement(transformation(extent={{100,20},{120,40}})));

  Modelica.Blocks.Interfaces.RealOutput eta(
    final quantity="Efficiency",
    final unit="1",
    min=0,
    max=1) "Overall efficiency"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Modelica.Blocks.Interfaces.RealOutput etaHyd(
    final quantity="Efficiency",
    final unit="1",
    min=0,
    max=1) "Hydraulic efficiency"
    annotation (Placement(transformation(extent={{100,-52},{120,-32}})));

  Modelica.Blocks.Interfaces.RealOutput etaMot(
    final quantity="Efficiency",
    final unit="1",
    min=0,
    max=1) "Motor efficiency"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));

 // Derivatives for cubic spline
protected
  final parameter Real motDer[size(per.motorEfficiency.V_flow, 1)](each fixed=false)
    "Coefficients for polynomial of motor efficiency vs. volume flow rate";
  final parameter Real hydDer[size(per.hydraulicEfficiency.V_flow,1)](each fixed=false)
    "Coefficients for polynomial of hydraulic efficiency vs. volume flow rate";

initial equation
   // Compute derivatives for cubic spline
 motDer = if (size(per.motorEfficiency.V_flow, 1) == 1)
          then
            {0}
          else
            Buildings.Utilities.Math.Functions.splineDerivatives(
              x=per.motorEfficiency.V_flow,
              y=per.motorEfficiency.eta,
              ensureMonotonicity=Buildings.Utilities.Math.Functions.isMonotonic(
                x=per.motorEfficiency.eta,
                strict=false));

  hydDer = if (size(per.hydraulicEfficiency.V_flow, 1) == 1)
           then
             {0}
           else
             Buildings.Utilities.Math.Functions.splineDerivatives(
               x=per.hydraulicEfficiency.V_flow,
               y=per.hydraulicEfficiency.eta);
equation
  V_flow = m_flow/rho;

  etaHyd = cha.efficiency(
    per=per.hydraulicEfficiency,
    V_flow=V_flow,
    d=hydDer,
    r_N=1,
    delta=1E-4);

  etaMot = cha.efficiency(
    per=per.motorEfficiency,
    V_flow=V_flow,
    d=motDer,
    r_N=1,
    delta=1E-4);

  eta = etaHyd * etaMot;

  // Flow work
  WFlo = -dp*V_flow;

  PEle = WFlo / Buildings.Utilities.Math.Functions.smoothMax(x1=eta, x2=1E-5, deltaX=1E-6);

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Ellipse(
          extent={{-72,64},{50,-58}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-56,48},{34,-42}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(extent={{48,96},{98,82}},
          lineColor={0,0,127},
          textString="V_flow"),
        Text(extent={{52,32},{102,18}},
          lineColor={0,0,127},
          textString="PEle"),
        Text(extent={{52,2},{102,-12}},
          lineColor={0,0,127},
          textString="eta"),
        Text(extent={{44,-40},{94,-54}},
          lineColor={0,0,127},
          textString="etaHyd"),
        Text(extent={{44,-76},{94,-90}},
          lineColor={0,0,127},
          textString="etaMot"),
        Text(extent={{50,62},{100,48}},
          lineColor={0,0,127},
          textString="WFlo"),
        Polygon(
          points={{-20,8},{-26,22},{-24,40},{-2,50},{0,44},{-18,36},{-18,22},{-12,
              10},{-20,8}},
          lineColor={0,0,0},
          fillColor={100,100,100},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Polygon(
          points={{-7,-21},{-13,-7},{-11,11},{11,21},{13,15},{-5,7},{-5,-7},{1,-19},
              {-7,-21}},
          lineColor={0,0,0},
          fillColor={100,100,100},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier,
          origin={-37,-1},
          rotation=90),
        Ellipse(
          extent={{-20,12},{-2,-6}},
          lineColor={0,0,0},
          fillColor={100,100,100},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-2,-2},{4,-16},{2,-34},{-20,-44},{-22,-38},{-4,-30},{-4,-16},
              {-10,-4},{-2,-2}},
          lineColor={0,0,0},
          fillColor={100,100,100},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Polygon(
          points={{7,21},{13,7},{11,-11},{-11,-21},{-13,-15},{5,-7},{5,7},{-1,19},
              {7,21}},
          lineColor={0,0,0},
          fillColor={100,100,100},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier,
          origin={15,7},
          rotation=90)}),
    Documentation(info="<html>
<p>
Blcok that computes the mover efficiency and power consumption.
It is used by the model
<a href=\"modelica://Buildings.Fluids.Movers.BaseClasses.FlowControlled\">FlowControlled</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 19, 2016, by Michael Wetter:<br/>
First implementation during refactoring of mover models to make implementation clearer.
This is for
<a href=\"https://github.com/iea-annex60/modelica-annex60/issues/417\">#417</a>.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end EfficiencyInterface;
